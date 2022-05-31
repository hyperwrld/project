const webpack = require('webpack');
const path = require('path');
const RemovePlugin = require('remove-files-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const buildPath = path.resolve(__dirname, 'dist');

const server = {
    entry: './src/server/main.ts',
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: ['ts-loader', 'eslint-loader'],
                exclude: /node_modules/,
            },
        ],
    },
    plugins: [
        new webpack.DefinePlugin({ 'global.GENTLY': false }),
        new RemovePlugin({
            before: {
                include: [path.resolve(buildPath, 'server')],
            },
            watch: {
                include: [path.resolve(buildPath, 'server')],
            },
        }),
        new CopyWebpackPlugin({
            patterns: [{ from: 'src/static/server', to: '' }],
        }),
    ],
    optimization: {
        minimize: true,
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js'],
    },
    output: {
        filename: 'main.js',
        path: path.resolve(buildPath, 'server'),
    },
    target: 'node',
};

const client = {
    entry: './src/client/main.ts',
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: ['ts-loader', 'eslint-loader'],
                exclude: /node_modules/,
            },
        ],
    },
    plugins: [
        new RemovePlugin({
            before: {
                include: [path.resolve(buildPath, 'client')],
            },
            watch: {
                include: [path.resolve(buildPath, 'client')],
            },
        }),
        new CopyWebpackPlugin({
            patterns: [
                { from: 'src/static/client', to: '' },
                { from: 'src/static/shared', to: '../shared' },
            ],
        }),
    ],
    optimization: {
        minimize: true,
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js'],
    },
    output: {
        filename: 'main.js',
        path: path.resolve(buildPath, 'client'),
    },
};

module.exports = [server, client];
