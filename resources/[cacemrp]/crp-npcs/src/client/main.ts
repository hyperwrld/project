import { Vector3 } from 'fivem-js';
import { RPCManager } from './managers/rpc-manager';
import { NPC } from './classes/npc';
import Utils from './utils';

const npcs = {},
    resourceNpcs = {};

const exp = (<any>global).exports,
    resourceName = GetCurrentResourceName();

function createNpc(data: any, resourceName?: string) {
    if (resourceName) {
        if (!resourceNpcs[resourceName]) resourceNpcs[resourceName] = {};

        resourceNpcs[resourceName][data.id] = true;
    }

    if (doesNpcExist(data.id)) {
        npcs[data.id].npc.position = data.position;
        return;
    }

    const npc = new NPC(
        data.id,
        data.model,
        data.position,
        data.appearance,
        data.animation,
        data.networked,
        data.settings,
        data.decors,
        data.scenario,
        data.blip,
    );

    npc.spawnNpc();

    npcs[data.id] = { npc: npc, distance: data.distance };
}

function removeNpc(id: string | number) {
    if (!doesNpcExist(id)) return;

    npcs[id].npc.deleteNpc();

    if (npcs[id].npc.blipHandler) npcs[id].npc.blipHandler.deleteBlip();

    npcs[id] = undefined;
}

function doesNpcExist(id: number | string) {
    return npcs[id] != undefined;
}

setTick(async () => {
    await Utils.Wait(500);

    const [x, y, z] = GetEntityCoords(PlayerPedId(), false);

    for (const npcId in npcs) {
        const npc = npcs[npcId].npc,
            spawnRange = npcs[npcId].distance;
        const distance = new Vector3(x, y, z).distance(npc.position.coords);

        if (distance <= spawnRange && !npc.isSpawned && !npc.isDisabled) {
            npc.spawnNpc();
        } else if ((distance > spawnRange && npc.isSpawned) || (npc.isDisabled && npc.isSpawned)) {
            npc.deleteNpc();
        }
    }
});

on('onClientResourceStart', async (resource: string) => {
    if (resource == resourceName) {
        const npcsList = await new RPCManager().Trigger('fetchNpcs');

        for (const data of npcsList) createNpc(data);
    }
});

on('onResourceStop', (resource: string) => {
    if (resource == resourceName) {
        for (const npcId in npcs) npcs[npcId].npc.deleteNpc();
        return;
    } else if (resourceNpcs[resource]) {
        for (const npcId in resourceNpcs[resource]) {
            if (resourceNpcs[resource][npcId]) removeNpc(npcId);
        }
    }
});
