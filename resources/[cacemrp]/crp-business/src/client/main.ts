import { RPCManager } from './managers/rpc-manager';
import { UIManager } from './managers/ui-manager';

const exp = (<any>global).exports,
    UI = new UIManager(),
    RPC = new RPCManager();

onNet('crp-business:updateBusinesses', (businesses: []): void => {
    exp['crp-ui'].setAppData('businesses', businesses);
});

UI.RegisterUICallback('fetchBusiness', async function (businessId: number, cb: any) {
    const [success, employees, permissions] = await RPC.Trigger('fetchBusiness', businessId);

    cb({ state: success, employees: employees, permissions: permissions });
});

UI.RegisterUICallback('fetchPositions', async function (businessId: number, cb: any) {
    const [success, positions] = await RPC.Trigger('fetchPositions', businessId);

    cb({ state: success, positions: positions });
});

UI.RegisterUICallback('changeRole', async function (data: any, cb: any) {
    const [success, message] = await RPC.Trigger(
        'changeRole',
        data.businessId,
        data.employeeId,
        data.role.value,
    );

    cb({ state: success, message: message });
});

UI.RegisterUICallback('fireEmployee', async function (data: any, cb: any) {
    const [success, message] = await RPC.Trigger('fireEmployee', data.businessId, data.employeeId);

    cb({ state: success, message: message });
});
