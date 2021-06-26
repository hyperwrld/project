import { Vector3 } from 'fivem-js';

export const npcs = [
    {
        id: 'HeadStripper',
        name: 'Stripper',
        model: 'csb_tonya',
        networked: false,
        distance: 25.0,
        position: { coords: new Vector3(110.98, -1297.22, 28.39), heading: 204.3 },
        appearance: undefined,
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
        appearance: undefined,
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
