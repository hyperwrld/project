const crpUi = (<any>global).exports['crp-ui'];

export class UIManager {
    protected static instance: UIManager;

    static getInstance(): UIManager {
        if (!UIManager.instance) {
            UIManager.instance = new UIManager();
        }

        return UIManager.instance;
    }

    protected _registeredCallbacks: string[] = [];

    constructor() {
        on('crp-ui:uiStarted', () => {
            for (const eventName of this._registeredCallbacks) {
                crpUi.RegisterUIEvent(eventName);
            }
        });
    }

    RegisterUICallback(eventName: string, cb): void {
        const interceptCb = (data, innerCb) => {
            cb(data, result => {
                innerCb(result);
            });
        };

        on(`crp-ui:${eventName}`, interceptCb);
        this._registeredCallbacks.push(eventName);
    }

    SendUIMessage(data: []): void {
        return crpUi.SendUIMessage(data);
    }

    SetUIFocus(hasFocus: boolean, hasCursor: boolean, keepInput: boolean): void {
        return crpUi.SetUIFocus(hasFocus, hasCursor, keepInput);
    }
}
