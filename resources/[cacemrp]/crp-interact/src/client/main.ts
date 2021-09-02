import { Vector3 } from 'fivem-js';
import { UIManager } from './managers/ui-manager';
import { npcs } from './data/npcs';
import { objects } from './data/objects';
import { vehicles } from './data/vehicles';
import { zones } from './data/zones';

import Utils from './utils';

const exp = (<any>global).exports,
    UI = new UIManager();

const peekEntries: any = { model: {}, decor: {}, entity: {}, zone: {} };
const currentZones = {};

let currentTarget = undefined;
let isPeeking = false;
let isPeakActive = false;
let isRefreshingList = false;
let isUpdateRequired = false;
const currentJob = undefined;

let peekTick;
let entryCount = 0;
let listCount = 0;

function convertNpcIds(npcIds: any): any {
    if (npcIds == undefined) return undefined;

    const idHashes = [];

    for (const npcHash of npcIds) idHashes.push(GetHashKey(npcHash));

    return idHashes;
}

function hasNpcId(entity: number, npcIds: any): boolean {
    if (!npcIds) return true;

    for (const npcId of npcIds) {
        if (DecorGetInt(entity, 'NpcId') == npcId) return true;
    }

    return false;
}

function addPeekEntry(type: string, group: any, data: any, options: any): void {
    const entries = peekEntries[type];

    if (!entries) return;

    const addEntry = function (entryGroup: string, entryData: any, entryOptions: any): void {
        entryOptions.npcIds = convertNpcIds(entryOptions.npcIds);

        if (!entries[entryGroup]) entries[entryGroup] = {};

        for (const entry of entryData) {
            if (!entry.id) continue;

            entry.index = entryCount += 1;
            entries[entryGroup][entry.id] = { data: entry, options: entryOptions };
        }
    };

    for (const entryGroup of group) {
        addEntry(entryGroup, data, options);
    }

    refreshPeekList();
}

function RegisterEntries(entries: any): void {
    for (const entry of entries) {
        addPeekEntry(entry.type, entry.group, entry.data, entry.options);
    }
}

function refreshPeekList(): void {
    if (isRefreshingList) return;

    isRefreshingList = true;

    setTimeout(() => {
        const entries = {};

        for (const group in peekEntries) {
            for (const groupEntries in peekEntries[group]) {
                for (const entryId in peekEntries[group][groupEntries]) {
                    entries[entryId] = peekEntries[group][groupEntries][entryId].data;
                }
            }
        }

        isRefreshingList = false;

        exp['crp-ui'].setAppData('interact', {
            entries: entries,
        });
    }, 250);
}

function startPeeking(): void {
    if (isPeeking) return;
    if (IsPedArmed(PlayerPedId(), 6)) return;

    let context;

    (isPeeking = true), (isUpdateRequired = true), (isPeakActive = true);

    peekTick = setTick(async () => {
        await Utils.Wait(0);

        DisablePlayerFiring(PlayerPedId(), true);

        if (isUpdateRequired) {
            isUpdateRequired = false;

            context = getCurrentPeekEntries();
        }

        if (
            isPeakActive &&
            (IsControlJustReleased(0, 24) || IsDisabledControlJustReleased(0, 24))
        ) {
            SetCursorLocation(0.5, 0.5);

            exp['crp-ui'].setUiFocus(true, true, false);
            exp['crp-ui'].setAppData('interact', {
                hideState: true,
                activeState: true,
                context: context,
                entity: currentTarget,
            });
        }
    });

    exp['crp-ui'].openApp(
        'interact',
        {
            hideState: true,
            activeState: false,
        },
        false,
        false,
    );
}

function stopPeeking(): void {
    if (!isPeeking) return;

    clearTick(peekTick);

    isPeeking = false;

    exp['crp-ui'].closeApp('interact');
}

function getCurrentPeekEntries(): [] {
    const context = Utils.GetEntityContext(currentTarget);

    const listId = (listCount += 1);
    const entries = {},
        tracked = {};

    const addEntry = function (entryId: string, entry: any, data: any, related: string | number) {
        const options = entry.options;

        if (options.job) {
            let hasJob = false;

            for (const jobName of options.job) {
                if (jobName == currentJob) hasJob = true;
            }

            if (!hasJob) return;
        }

        if (options.npcIds) if (!hasNpcId(currentTarget, options.npcIds)) return;

        const hasChecks = options.isEnabled || options.distance;

        entries[entryId] = !hasChecks;

        if (!hasChecks) return;
        if (options.distance && data.zones[related]) options.distance.zone = related;

        tracked[entryId] = options;
    };

    if (currentTarget) {
        const modelEntries = peekEntries.model[context.model];

        if (modelEntries) {
            for (const entryId in modelEntries)
                addEntry(entryId, modelEntries[entryId], context, currentTarget);
        }

        for (const decorName in context.decors) {
            const decorEntries = peekEntries.decor[decorName];

            if (context.decors[decorName] && decorEntries) {
                for (const entryId in decorEntries) {
                    addEntry(entryId, decorEntries[entryId], context, currentTarget);
                }
            }
        }

        const entityEntries = peekEntries.entity[context.type];

        if (entityEntries) {
            for (const entryId in entityEntries)
                addEntry(entryId, entityEntries[entryId], context, currentTarget);
        }
    }

    for (const zoneName in currentZones) {
        const zone = currentZones[zoneName];

        if (zone) {
            const zoneEntries = peekEntries.zone[zoneName];

            context.zones[zoneName] = zone.data;

            if (zoneEntries) {
                for (const entryId in zoneEntries)
                    addEntry(entryId, zoneEntries[entryId], context, currentTarget);
            }
        }
    }

    startTrackerThread(listId, entries, tracked, context);

    return context;
}

function updatePeekEntries(entries: any): void {
    const active = isActive(entries);

    if (!isPeakActive && active) {
        isPeakActive = true;
    } else if (isPeakActive && !active) {
        isPeakActive = false;
    }

    exp['crp-ui'].setAppData('interact', {
        hideState: true,
        activeState: isPeakActive,
        choices: entries,
    });
}

function isActive(entries: any): boolean {
    if (!entries) return;

    for (const entryId in entries) {
        if (entries[entryId]) return true;
    }

    return false;
}

function startTrackerThread(trackerId: number, entries: any, tracked: any, context: any): void {
    const entity = currentTarget;
    const playerPed = PlayerPedId();

    const normals = {};
    const bones = {};
    const zones = {};

    let updateRequired = true;

    for (const optionId in tracked) {
        const data = tracked[optionId].distance;

        let isVisible = false;

        const checkIfIsEnabled = function (playerDistance: number) {
            const isInRange = !data || playerDistance <= data.radius;
            const isEnabled =
                isInRange &&
                (!tracked[optionId].isEnabled || tracked[optionId].isEnabled(entity, context));

            if (isInRange && isEnabled && !isVisible) {
                (isVisible = true), (updateRequired = true), (entries[optionId] = true);
            } else if (!isInRange || (!isEnabled && isVisible)) {
                (isVisible = false), (updateRequired = true), (entries[optionId] = false);
            }
        };

        if (data && data.boneId) {
            const bone = data.boneId;
            const boneIndex =
                typeof bone == 'string'
                    ? GetEntityBoneIndexByName(entity, bone)
                    : GetPedBoneIndex(entity, bone);

            if (!bones[boneIndex]) bones[boneIndex] = checkIfIsEnabled;
        } else if (data && data.zone) {
            if (!zones[data.zone]) zones[data.zone] = checkIfIsEnabled;
        } else {
            normals[optionId] = checkIfIsEnabled;
        }
    }

    const trackerTick = setTick(async () => {
        await Utils.Wait(150);

        let coords: any = GetEntityCoords(playerPed, false);

        coords = new Vector3(coords[0], coords[1], coords[2]);

        if (entity) {
            for (const boneIndex in bones) {
                let _coords: any = GetWorldPositionOfEntityBone(entity, Number(boneIndex));

                _coords = new Vector3(_coords[0], _coords[1], _coords[2]);

                bones[boneIndex](coords.distance(_coords));
            }

            for (const optionId in normals) {
                let _coords: any = GetEntityCoords(entity, false);

                _coords = new Vector3(_coords[0], _coords[1], _coords[2]);

                normals[optionId](coords.distance(_coords));
            }
        }

        for (const zoneId in zones) {
            const zone = currentZones[zoneId];
            const zoneCoords = new Vector3(zone.vectors.x, zone.vectors.y, zone.vectors.z);
            const distance = !zone ? 1000.0 : coords.distance(zoneCoords);

            zones[zoneId](distance);
        }

        if (updateRequired) {
            updateRequired = false;

            updatePeekEntries(entries);
        }

        if (!isPeeking || listCount != trackerId) clearTick(trackerTick);
    });
}

on('crp-interact:changedEntity', function (target: number) {
    (currentTarget = target), (isUpdateRequired = true);
});

UI.RegisterUICallback('selectedOption', async (data: any, cb: any) => {
    isPeeking = false;

    exp['crp-ui'].closeApp('interact');

    await Utils.Wait(100);

    const parameters = data.parameters || {};
    const entity = data.entity || 0;
    const context = data.context || {};

    TriggerEvent(data.eventName, parameters, entity, context);

    cb({ state: true });
});

RegisterEntries(npcs);
RegisterEntries(objects);
RegisterEntries(vehicles);
RegisterEntries(zones);

RegisterCommand('+interact', startPeeking, false);
RegisterCommand('-interact', stopPeeking, false);

exp['crp-binds'].RegisterKeybind('Target', 'Mostrar/Ocultar', 'LMENU', '+interact', '-interact');
