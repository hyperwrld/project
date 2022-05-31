import { npcs } from './data';
import { RPCManager } from './managers/rpc-manager';

const RPC = new RPCManager();

RPC.Register('fetchNpcs', () => {
    return npcs;
});
