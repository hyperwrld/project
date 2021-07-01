export const vehicles = [
    {
        type: 'entity',
        group: [2],
        data: [
            {
                id: 'vehicle_flip',
                label: 'Flip Vehicle',
                icon: 'car-crash',
                event: '',
                parameters: {},
            },
        ],
        options: {
            distance: { radius: 3.0 },
            isEnabled: function (entity: number): number {
                return IsVehicleOnAllWheels(entity);
            },
        },
    },
];
