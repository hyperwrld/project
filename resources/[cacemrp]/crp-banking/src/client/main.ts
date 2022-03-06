import { RPCManager } from './managers/rpc-manager';
import { UIManager } from './managers/ui-manager';

import { Vector3 } from 'fivem-js';

const exp = (<any>global).exports,
    banks = [];

const UI = new UIManager();
const RPC = new RPCManager();

let isInsideZone = false;

exp['crp-lib'].createBoxZones(
    [
        {
            coords: new Vector3(149.23, -1040.42, 29.37),
            heading: 340,
            length: 0.7,
            width: 2.8,
            minZ: 25.57,
            maxZ: 29.57,
            data: 1,
        },
        {
            coords: new Vector3(313.57, -278.88, 54.16),
            heading: 340,
            length: 0.7,
            width: 2.8,
            minZ: 50.36,
            maxZ: 54.36,
            data: 2,
        },
        {
            coords: new Vector3(-351.57, -49.64, 49.04),
            heading: 340,
            length: 0.7,
            width: 2.8,
            minZ: 45.24,
            maxZ: 49.24,
            data: 3,
        },
        {
            coords: new Vector3(-1213.28, -331.08, 37.79),
            heading: 297,
            length: 2.8,
            width: 0.7,
            minZ: 33.99,
            maxZ: 37.99,
            data: 4,
        },
        {
            coords: new Vector3(247.48, 223.16, 106.29),
            heading: 340,
            length: 0.65,
            width: 3.2,
            minZ: 102.29,
            maxZ: 106.29,
            data: 5,
        },
        {
            coords: new Vector3(-2962.59, 482.29, 15.7),
            heading: 358,
            length: 2.8,
            width: 0.7,
            minZ: 11.9,
            maxZ: 15.9,
            data: 6,
        },
        {
            coords: new Vector3(1175.77, 2706.79, 38.09),
            heading: 0,
            length: 0.7,
            width: 2.8,
            minZ: 34.29,
            maxZ: 38.29,
            data: 7,
        },
        {
            coords: new Vector3(-112.05, 6469.08, 31.63),
            heading: 315,
            length: 0.65,
            width: 4.4,
            minZ: 27.83,
            maxZ: 31.83,
            data: 8,
        },
    ],
    'bankZones',
    GetCurrentResourceName(),
    false,
);

on('crp-banking:onPlayerInOut', (isPointInside: boolean, zone: any) => {
    if (isPointInside) {
        if (!banks[zone.data]) {
            ListenForInput(1);
        }

        exp['crp-ui'].toggleInteraction(
            true,
            !banks[zone.data] ? '[E] para usar o banco' : 'Este banco está fechado',
        );
    } else {
        exp['crp-ui'].toggleInteraction(false);
    }

    isInsideZone = isPointInside;
});

function ListenForInput(bankId: number) {
    const thread = setTick(() => {
        if (IsControlJustReleased(0, 38)) {
            console.log('saasasas');
            emit('crp-banking:openBank', 1);
        }

        if (!isInsideZone) clearTick(thread);
    });
}

on('crp-banking:openBank', async (type: number) => {
    const [
        success,
        characterId,
        firstName,
        lastName,
        money,
        accounts,
        transactions,
    ] = await RPC.Trigger('fetchBank');

    if (success) {
        exp['crp-ui'].openApp('banking', {
            type: type,
            characterId: characterId,
            firstName: firstName,
            lastName: lastName,
            money: money,
            accounts: accounts,
            transactions: transactions,
        });
    }
});

UI.RegisterUICallback('fetchTransactions', async function (accountId: any, cb: any) {
    const transactions = await RPC.Trigger('fetchTransactions', accountId);

    cb({ state: true, transactions: transactions });
});

UI.RegisterUICallback('depositMoney', async function (data: any, cb: any) {
    const [success, message, transaction] = await RPC.Trigger(
        'depositMoney',
        data.accountId,
        data.money,
        data.description,
    );

    cb({ state: success, message: message, transaction: transaction });
});

UI.RegisterUICallback('withdrawMoney', async function (data: any, cb: any) {
    const [success, message, transaction] = await RPC.Trigger(
        'withdrawMoney',
        data.accountId,
        data.money,
        data.description,
    );

    cb({ state: success, message: message, transaction: transaction });
});

UI.RegisterUICallback('transferMoney', async function (data: any, cb: any) {
    const [success, message, transaction] = await RPC.Trigger(
        'transferMoney',
        data.accountId,
        data.money,
        data.iban,
        data.description,
    );

    cb({ state: success, message: message, transaction: transaction });
});
