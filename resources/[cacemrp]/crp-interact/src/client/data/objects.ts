export const objects = [
    {
        type: 'decor',
        group: ['isTrash'],
        data: [
            {
                id: 'trash',
                label: 'Pickup trash',
                icon: 'circle',
                event: '',
                parameters: {},
            },
        ],
        options: {
            distance: { radius: 1.7 },
            job: ['sanitation_worker'],
        },
    },
    {
        type: 'decor',
        group: ['isChair'],
        data: [
            {
                id: 'sit_on_chair',
                label: 'Sentar',
                icon: 'fas fa-chair-office',
                event: '',
                parameters: {},
            },
        ],
        options: {
            distance: { radius: 1.5 },
        },
    },
];
