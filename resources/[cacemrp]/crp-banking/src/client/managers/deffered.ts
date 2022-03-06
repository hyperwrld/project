export class Deferred<T> {
    readonly promise: Promise<T>;
    readonly resolve: (value?: T | PromiseLike<T>) => void;
    readonly reject: (reason?: any) => void;

    constructor() {
        this.promise = new Promise<T>(
            (resolve, reject) => (
                ((this as any).resolve = resolve), ((this as any).reject = reject)
            ),
        );
    }
}
