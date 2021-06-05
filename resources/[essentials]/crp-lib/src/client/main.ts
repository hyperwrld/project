let callId = 0;

const RPC: any = {},
    promises = [];

class Deferred {
    constructor() {
        this.promise = new Promise((resolve, reject) => {
            this.reject = reject;
            this.resolve = resolve;
        });
    }

    promise;
    reject;
    resolve;
}

RPC.Trigger = function (name: string, ...data: any[]) {
    const identifier = callId;
    let isResolve = false;

    callId += 1;

    promises[identifier] = new Deferred();

    emitNet('crp-lib:request', name, identifier, data);

    setTimeout(function () {
        if (!isResolve) promises[identifier].resolve([null]);
    }, 5000);

    promises[identifier].promise.then(result => {
        (isResolve = true), (promises[identifier] = undefined);

        return result;
    });
};

onNet('crp-lib:response', (identifier, ...response) => {
    if (!promises[identifier]) return;

    console.log(response);

    promises[identifier].resolve(response);
});

exports('Trigger', RPC.Trigger);
