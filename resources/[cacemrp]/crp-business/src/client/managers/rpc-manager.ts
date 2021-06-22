import { Deferred } from './deffered';

export class RPCManager {
    protected static instance: RPCManager;

    static getInstance(): RPCManager {
        if (!RPCManager.instance) {
            RPCManager.instance = new RPCManager();
        }

        return RPCManager.instance;
    }

    protected promises: any[] = [];
    protected callId = 0;

    constructor() {
        onNet('crp-business:response', (identifier: number, response: any) => {
            if (!this.promises[identifier]) return;

            this.promises[identifier].resolve(response);
        });
    }

    async Trigger(name: string, ...data: any[]): Promise<any> {
        const identifier: number = this.callId,
            promises = this.promises;

        let isResolved = false;

        this.callId += 1;

        promises[identifier] = new Deferred();

        emitNet('crp-business:request', name, identifier, data);

        setTimeout(function () {
            if (!isResolved) promises[identifier].resolve([null]);
        }, 5000);

        return await promises[identifier].promise.then(result => {
            (isResolved = true), (promises[identifier] = undefined);

            return result;
        });
    }
}
