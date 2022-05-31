const RPC: any = {},
    functions = {};

RPC.Register = function (name, func) {
    functions[name] = func;
};

RPC.Remove = function (name) {
    functions[name] = undefined;
};

onNet('crp-lib:request', (name: string, callId: number, params: any) => {
    const _source = (global as any).source;
    let response;

    if (!functions[name]) return;

    response = [functions[name](_source, ...params)];

    if (!response) response = {};

    emitNet('crp-lib:response', _source, callId, response);
});

exports('Register', RPC.Register);
exports('Remove', RPC.Remove);
