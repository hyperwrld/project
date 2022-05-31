export const vehicles = [
    {
        type: 'entity',
        group: [2],
        data: [
            {
                id: 'vehicle_flip',
                label: 'Virar o veículo',
                icon: 'fas fa-car-crash',
                event: '',
                parameters: {},
            },
        ],
        options: {
            distance: { radius: 3.0 },
            isEnabled: function (entity: number): boolean {
                return IsVehicleOnAllWheels(entity) == 0;
            },
        },
    },
    {
        type: 'entity',
        group: [2],
        data: [
            {
                id: 'vehicle_refuel',
                label: 'Abastecer Veículo',
                icon: 'fas fa-gas-pump',
                event: '',
                parameters: {},
            },
        ],
        options: {
            distance: { radius: 1.5, boneId: 'wheel_lr' },
            isEnabled: function (entity: number): boolean {
                return true;
            },
        },
    },
];
