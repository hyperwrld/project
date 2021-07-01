export const npcs = [
    {
        type: 'decor',
        group: ['isRecycleExchange'],
        data: [
            {
                id: 'recycle_exchange',
                label: 'Exchange recyclables',
                icon: 'circle',
                event: '',
                parameters: {},
            },
        ],
        options: {
            distance: { radius: 2.5 },
        },
    },
    {
        type: 'decor',
        group: ['isCommonJobProvider'],
        data: [
            {
                id: 'common_job_signIn',
                label: 'Sign in/out',
                icon: 'circle',
                event: '',
                parameters: {},
            },
        ],
        options: {
            distance: { radius: 2.5 },
        },
    },
];
