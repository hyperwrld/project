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
        exp['crp-decors'].setDecors(entity, type, decors);
    }

    public static GetRandomNumber(min: number, max: number): number {
        return Math.floor(Math.random() * (max - min + 1) + min);
    }
}
