import { DBManager } from './managers/db-manager';
import { RPCManager } from './managers/rpc-manager';

const RPC = new RPCManager(),
    DB = new DBManager();
const exp = (<any>global).exports;

enum Permissions {
    fire,
    manage,
    stash,
    craft,
    locks,
    deposit,
    withdraw,
    owner,
}

on('crp-base:characterLoaded', async (source: number) => {
    emitNet('crp-business:updateBusinesses', source, await fetchBusinesses(source));
});

async function fetchBusinesses(source: number): Promise<[]> {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId();

    const query = `
        SELECT
            businesses.id,
            businesses.name,
            type,
            positions.name AS role
        FROM businesses
            INNER JOIN business_employees AS employees
                ON employees.character = ?
            JOIN business_positions AS positions
                ON role = positions.id
        GROUP BY businesses.id DESC;
    `;
    const result = await DB.Execute(query, characterId);

    if (!result || result.length == 0) {
        return [];
    }

    return result;
}

RPC.Register('fetchBusiness', (source: number, businessId: number) => {
    return fetchBusiness(source, businessId);
});

async function fetchBusiness(source: number, businessId: number): Promise<[boolean, []?, []?]> {
    const query = `
        SELECT
            characters.id,
            CONCAT(characters.firstname, ' ', characters.lastname) AS name,
            name AS role,
            positions.hire,
            positions.fire,
            positions.manage,
            positions.stash,
            positions.craft,
            positions.locks,
            positions.deposit,
            positions.withdraw,
            positions.owner
        FROM business_employees AS employees
            JOIN business_positions AS positions
                ON role = positions.id
            JOIN characters
                ON employees.character = characters.id
        WHERE positions.business = ?
        ORDER BY positions.hire DESC,
            positions.fire DESC,
            positions.manage DESC,
            positions.stash DESC,
            positions.craft DESC,
            positions.locks DESC,
            positions.deposit DESC,
            positions.withdraw DESC,
            positions.owner DESC;
    `;
    const result = await DB.Execute(query, businessId);

    if (!result || result.length == 0) {
        return [false];
    }

    return [true, result, await fetchPermissions(source, businessId)];
}

async function fetchPermissions(source: number, businessId: number): Promise<[] | any> {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId();

    const query = `
        SELECT
            positions.hire,
            positions.fire,
            positions.manage,
            positions.stash,
            positions.craft,
            positions.locks,
            positions.deposit,
            positions.withdraw,
            positions.owner
        FROM business_positions AS positions
            JOIN business_employees AS employees
                ON employees.character = ?
                AND employees.role = positions.id
        WHERE positions.business = ? LIMIT 1;
    `;

    const result = await DB.Execute(query, characterId, businessId);

    if (!result || result.length == 0) {
        return [];
    }

    return result[0];
}

RPC.Register('fetchPositions', (source: number, businessId: number) => {
    return fetchPositions(source, businessId);
});

async function fetchPositions(source: number, businessId: number): Promise<[boolean, []?]> {
    const query = `
        SELECT
            id AS value,
            name AS label
        FROM business_positions
        WHERE business = ?
        GROUP BY hire DESC,
            fire DESC,
            manage DESC,
            stash DESC,
            craft DESC,
            locks DESC,
            deposit DESC,
            withdraw DESC,
            owner DESC;
    `;
    const result = await DB.Execute(query, businessId);

    if (!result || result.length == 0) {
        return [false];
    }

    return [true, result];
}

RPC.Register('changeRole', (source: number, businessId: number, employeeId: number, role: any) => {
    return changeRole(source, businessId, employeeId, role);
});

async function changeRole(
    source: number,
    businessId: number,
    employeeId: number,
    role: any,
): Promise<[boolean, string?]> {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId();

    const [success, message] = await canChangeRole(characterId, employeeId, businessId, role);

    if (!success) return [false, message];

    const query = `
        UPDATE business_employees SET role = ? WHERE business_employees.character = ?;
    `;
    const result = await DB.Execute(query, role, employeeId);

    if (!result || result.affectedRows == 0) {
        return [false, 'Oops, aconteceu alguma coisa.'];
    }

    return [true, 'Cargo mudado com sucesso.'];
}

RPC.Register('fireEmployee', (source: number, businessId: number, employeeId: number) => {
    return fireEmployee(source, businessId, employeeId);
});

async function fireEmployee(
    source: number,
    businessId: number,
    employeeId: number,
): Promise<[boolean, string?]> {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId();

    const [success, message] = await hasPermissions(businessId, characterId, employeeId, 'fire');

    if (!success) return [false, message];

    const query = `
        DELETE employees
            FROM business_employees AS employees
                JOIN business_positions AS positions
                    ON employees.role = positions.id
                    AND positions.business = ?
        WHERE employees.character = ?;
    `;
    const result = await DB.Execute(query, businessId, employeeId);

    if (!result || result.affectedRows == 0) {
        return [false, 'Oops, aconteceu alguma coisa.'];
    }

    return [true, 'Empregado despedido com sucesso.'];
}

async function hasPermission(
    businessId: number,
    characterId: number,
    employeeId,
    permission: string,
) {
    const query = `
        SELECT
            positions.${permission} AS hasPermission
        FROM business_employees AS employees
        JOIN business_positions AS positions
            ON employees.role = positions.id
            AND positions.business = ?
        WHERE employees.character = ? LIMIT 1;
	`;
    const result = await DB.Execute(query, businessId, characterId);

    if (!result || !result[0]) return false;

    return result[0].hasPermission;
}

async function canChangeRole(
    characterId: number,
    employeeId: number,
    businessId: number,
    roleId: number,
): Promise<[boolean, string?]> {
    const query = `
        SELECT
            positions.*
        FROM business_positions AS positions
            JOIN business_employees AS employees
            ON employees.role = positions.id
            AND (employees.character = ?
            OR employees.character = ?)
        WHERE positions.business = ?
        ORDER BY FIELD(employees.character, ?, ?);
    `;

    const result = await DB.Execute(
        query,
        characterId,
        employeeId,
        businessId,
        characterId,
        employeeId,
    );

    if (!result || result.length == 0) return [false, 'Oops, aconteceu alguma coisa.'];

    if (!result[0].manage) return [false, 'Não tem permissão para realizar esta operação.'];

    const characterPoints = calculatePoints(result[0]);

    if (characterPoints <= calculatePoints(result[1]))
        return [false, 'Não tem permissão para realizar esta operação.'];

    const roleQuery = `
        SELECT
            hire, fire, manage,
            stash, craft, locks,
            deposit, withdraw, owner
        FROM business_positions
        WHERE id = ?
        AND business = ?;
    `;
    const roleResult = await DB.Execute(roleQuery, roleId, businessId);

    if (!roleResult || roleResult.length == 0) return [false, 'Oops, aconteceu alguma coisa.'];

    if (!result[0].owner && characterPoints <= calculatePoints(roleResult[0]))
        return [false, 'Não tem permissão para realizar esta operação.'];

    return [true];
}

async function hasPermissions(
    businessId: number,
    characterId: number,
    employeeId: number,
    permission: string,
): Promise<[boolean, string?]> {
    const query = `
        SELECT DISTINCT
            positions.*
        FROM business_positions AS positions
            INNER JOIN business_employees AS employees
                ON employees.role = positions.id
                AND (employees.character = ?
                OR employees.character = ?)
                AND positions.business = ?;
    `;
    const result = await DB.Execute(query, characterId, employeeId, businessId);

    if (!result || !result[0] || !result[1]) return [false, 'Oops, aconteceu alguma coisa.'];

    if (!result[0][permission]) return [false, 'Não tem permissão para realizar esta operação.'];

    if (calculatePoints(result[0]) <= calculatePoints(result[1]))
        return [false, 'Não tem permissão para realizar esta operação.'];

    return [true];
}

function calculatePoints(data: any): number {
    let points = 0;

    for (const permission in Permissions) {
        if (data[permission] && data[permission] == 1) points++;
    }

    return points;
}
