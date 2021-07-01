import { Vector3 } from 'fivem-js';

export const npcs = [
    {
        id: 'PoliceReceptionist',
        name: 'Receptionist',
        model: 's_f_y_cop_01',
        distance: 50.0,
        position: { coords: new Vector3(442.69, -981.88, 29.68), heading: 91.74 },
        appearance: {
            head: {
                params: [0, 1, 0, 0],
                mode: 'component',
            },
            hair: {
                params: [2, 1, 0, 0],
                mode: 'component',
            },
            torso: {
                params: [3, 1, 0, 0],
                mode: 'component',
            },
            undershirt: {
                params: [8, 1, 0, 0],
                mode: 'component',
            },
            kevlar: {
                params: [9, 1, 0, 0],
                mode: 'component',
            },
            hat: {
                params: [0, 0, 0, true],
                mode: 'prop',
            },
            glasses: {
                params: [1, 0, 0, true],
                mode: 'prop',
            },
        },
        settings: [
            { mode: 'invincible', active: true },
            { mode: 'ignore', active: true },
            { mode: 'freeze', active: true },
        ],
        decors: {
            isNpc: true,
        },
        animation: 'Cop3',
    },
    {
        id: 'HeadStripper',
        name: 'Stripper',
        model: 'csb_tonya',
        networked: false,
        distance: 25.0,
        position: { coords: new Vector3(110.98, -1297.22, 28.39), heading: 204.3 },
        appearance: {},
        settings: [
            { mode: 'invincible', active: true },
            { mode: 'ignore', active: true },
            { mode: 'freeze', active: true },
        ],
        decors: {
            isNpc: true,
            isCommonJobProvider: true,
        },
        scenario: 'WORLD_HUMAN_SMOKING',
    },
    {
        id: 'NewsReporter',
        name: 'News Reporter',
        model: 'a_m_m_paparazzi_01',
        networked: false,
        distance: 75.0,
        position: { coords: new Vector3(-598.85, -929.87, 22.87), heading: 83.47 },
        appearance: {},
        settings: [
            { mode: 'invincible', active: true },
            { mode: 'ignore', active: true },
            { mode: 'freeze', active: true },
        ],
        decors: {
            isNpc: true,
            isCommonJobProvider: true,
        },
    },
];
