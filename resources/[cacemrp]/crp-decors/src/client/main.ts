import { ObjectDecors, PedDecors, VehicleDecors } from './data/decors';

const exp = (<any>global).exports;

const flagTypes = {
    PedDecors: PedDecors,
    VehicleDecors: VehicleDecors,
    ObjectDecors: ObjectDecors,
};

DecorRegister('PedDecors', 3);
DecorRegister('VehicleDecors', 3);
DecorRegister('ObjectDecors', 3);

exp('setDecor', (entity: number, type: string, decorName: string, enabled: boolean) => {
    const decor = flagTypes[type][decorName];

    if (decor && DoesEntityExist(entity)) {
        const currentDecor = DecorGetInt(entity, type);

        DecorSetInt(entity, type, (enabled && currentDecor | decor) || currentDecor & ~decor);
    }
});

exp('hasDecor', (entity: number, type: string, decorName: string) => {
    const decor = flagTypes[type][decorName];

    if (decor && DoesEntityExist(entity)) {
        const currentDecor = DecorGetInt(entity, type);

        return (currentDecor & decor) > 0;
    }
});

exp('setDecors', (entity: number, type: string, decors: any) => {
    let decorValue = DecorGetInt(entity, type);

    if (decorValue && DoesEntityExist(entity)) {
        for (const name in decors) {
            const currentDecor = flagTypes[type][decors[name]];

            if (currentDecor)
                decorValue =
                    (decors[name] && decorValue | currentDecor) || decorValue & ~currentDecor;
        }

        DecorSetInt(entity, type, decorValue);
    }
});

exp('getDecors', (entity: number, type: string) => {
    const decor = DecorGetInt(entity, type),
        decors = {};

    if (decor && decor >= 0) {
        for (const name in flagTypes[type]) {
            if (isNaN(Number(name))) decors[name] = (decor & flagTypes[type][name]) > 0;
        }
    }

    return decors;
});
