import { modelDecors } from './data/models';

const exp = (<any>global).exports;

export default class Utils {
    public static Wait(ms: number): Promise<void> {
        return new Promise(res => setTimeout(res, ms));
    }

    public static LoadModel(modelHash: number | string): Promise<void> {
        RequestModel(modelHash);

        return new Promise(resolve => {
            const interval = setInterval(() => {
                if (HasModelLoaded(modelHash)) {
                    clearInterval(interval);
                    resolve();
                }
            }, 0);
        });
    }

    public static LoadDictionary(dictionary: string): Promise<void> {
        if (HasAnimDictLoaded(dictionary)) return;

        RequestAnimDict(dictionary);

        return new Promise(resolve => {
            const interval = setInterval(() => {
                if (HasAnimDictLoaded(dictionary)) {
                    clearInterval(interval);
                    resolve();
                }
            }, 0);
        });
    }

    public static SetDecor(
        entity: number,
        type: string,
        decorName: string,
        enabled: boolean,
    ): void {
        exp['crp-decors'].setDecor(entity, type, decorName, enabled);
    }

    public static SetDecors(entity: number, type: string, decors: unknown): void {
        exp['crp-decors'].setDecor(entity, type, decors);
    }

    public static GetRandomNumber(min: number, max: number): number {
        return Math.floor(Math.random() * (max - min + 1) + min);
    }

    public static GetEntityContext(
        entity: number,
        entityType?: number,
        pEntityModel?: number,
    ): any {
        const context = {
            decors: {},
            model: null,
            type: null,
            zones: {},
        };

        if (!entity) return context;

        context.type = entityType || GetEntityType(entity);
        context.model = pEntityModel || GetEntityModel(entity);

        switch (context.type) {
            case 1:
                context.decors = exp['crp-decors'].getDecors(entity, 'PedDecors');
                context.decors['isPlayer'] = IsPedAPlayer(entity);

                if (context.decors['isNpc']) Utils.GetPedContext(entity, context);
                break;
            case 2:
                context.decors = exp['crp-decors'].getDecors(entity, 'VehicleDecors');
                break;
            case 3:
                context.decors = exp['crp-decors'].getDecors(entity, 'ObjectDecors');
                break;
            default:
                break;
        }

        if (modelDecors[context.model]) {
            for (const decorName in modelDecors[context.model]) {
                context.decors[decorName] = true;
            }
        }

        return context;
    }

    private static GetPedContext(entity: number, context: any): void {
        const npcId = DecorGetInt(entity, 'NpcId');

        if (context.decors['isJobEmployer']) context.job = exp['crp-jobs'].GetNpcJobData(npcId);
    }
}
