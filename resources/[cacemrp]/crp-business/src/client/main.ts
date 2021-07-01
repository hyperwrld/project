import { RPCManager } from './managers/rpc-manager';
import { UIManager } from './managers/ui-manager';

enum Businesses {
    DPLS = 'police',
}

const exp = (<any>global).exports;

const UI = new UIManager();
const RPC = new RPCManager();

let business = [];
let updatedAt = 0;

onNet('crp-business:updateBusinesses', (businesses: any): void => {
    business = [];
    updatedAt = GetGameTimer();

    for (const data of businesses) business.push(Businesses[data.name]);

    exp['crp-ui'].setAppData('businesses', businesses);
});

async function updateBusinesses() {
    const businesses = await RPC.Trigger('fetchBusinesses');

    business = [];
    updatedAt = GetGameTimer();

    for (const data of businesses) business.push(Businesses[data.name]);
}

async function isEmployedAt(businessName: string) {
    if (GetGameTimer() - updatedAt > 15 * 60000) await updateBusinesses();

    return business.includes(businessName);
}

exp('isEmployedAt', isEmployedAt);

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
