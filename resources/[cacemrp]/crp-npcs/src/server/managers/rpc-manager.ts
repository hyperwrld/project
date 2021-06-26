export class RPCManager {
    protected static instance: RPCManager;

    static getInstance(): RPCManager {
        if (!RPCManager.instance) {
            RPCManager.instance = new RPCManager();
        }

        return RPCManager.instance;
    }

    protected functions: any[] = [];

    constructor() {
        onNet('crp-business:request', async (name: string, callId: number, params: []) => {
            const _source = source;

            if (!this.functions[name]) return;

            let response = await this.functions[name](_source, ...params);

            if (!response) response = [];

            emitNet('crp-business:response', _source, callId, response);
        });
    }

    Register(name: string, func): void {
        this.functions[name] = func;
    }

    Remove(name: string): void {
        this.functions[name] = undefined;
    }
}
