import { UuidTool } from 'uuid-tool';

import { DBManager } from './managers/db-manager';
import { RPCManager } from './managers/rpc-manager';

const RPC = new RPCManager(),
    DB = new DBManager();
const exp = (<any>global).exports;

onNet('crp-base:createdCharacter', (characterId: number) => {
    createAccount(1, characterId, 'Conta Default', 5000);
});

async function createAccount(
    accountType: number,
    characterId: number,
    accountName: string,
    startingMoney: number,
): Promise<boolean> {
    const query = 'INSERT INTO accounts (type, owner, name, money) VALUES (?, ?, ?, ?);';
    const result = await DB.Execute(query, accountType, characterId, accountName, startingMoney);

    if (!result.changedRows) {
        return false;
    }

    return true;
}

RPC.Register('fetchBank', function (source: number) {
    return fetchBank(source);
});

async function fetchBank(source: number) {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId();

    const query = `
        SELECT DISTINCT
            accounts.id,
            accounts.owner,
            type.name AS type,
            CONCAT(characters.firstname, ' ', characters.lastname) AS owner_name,
            accounts.name,
            accounts.money,
            holders.permissions,
            positions.withdraw
        FROM accounts
            JOIN accounts_type type
                ON accounts.type = type.id
            JOIN characters
                ON accounts.owner = characters.id
            LEFT JOIN accounts_holders holders
                ON accounts.id = holders.account
            LEFT JOIN businesses
                ON accounts.id = businesses.bank_account
            LEFT JOIN business_positions positions
                ON businesses.id = positions.business
            LEFT JOIN business_employees employees
                ON positions.id = employees.role
                AND employees.business = businesses.id
        WHERE holders.holder = ?
            OR accounts.owner = ?
            OR (employees.employee = ?
            AND (positions.deposit = TRUE
            OR positions.withdraw = TRUE))
        GROUP BY accounts.id
        ORDER BY FIELD(accounts.owner, ?) DESC;
    `;

    const result = await DB.Execute(query, characterId, characterId, characterId, characterId);

    if (!result || result.length == 0) {
        return [false];
    }

    return [
        true,
        characterId,
        character.firstname,
        character.lastname,
        await exp['crp-inventory'].getMoney(source),
        result,
        await fetchTransactions(result[0].id),
    ];
}

RPC.Register('fetchTransactions', function (_source: number, accountId: number) {
    return fetchTransactions(accountId);
});

async function fetchTransactions(accountId: number) {
    const query = `
        SELECT
            UuidFromBin(transactions.id) AS id,
			transactions.account AS sender_id,
			accounts.name AS sender_name,
			transactions.receiver AS receiver_id,
			receiver.name AS receiver_name,
			CONCAT(characters.firstname, ' ', characters.lastname) AS sender_fullname,
			type.id AS type,
			type.name AS type_name,
			transactions.time,
			transactions.money,
			transactions.description
		FROM transactions
			LEFT JOIN accounts
				ON transactions.account = accounts.id
            LEFT JOIN accounts receiver
				ON transactions.receiver = receiver.id
			INNER JOIN characters
				ON transactions.sender = characters.id
			INNER JOIN transactions_type type
				ON transactions.type = type.id
		WHERE transactions.account = ?
		OR transactions.receiver = ? ORDER BY transactions.time ASC;
    `;
    const result = await DB.Execute(query, accountId, accountId);

    if (!result || result.length == 0) {
        return [];
    }

    return result;
}

RPC.Register('depositMoney', function (
    source: number,
    accountId: number,
    money: number,
    description: string,
) {
    return depositMoney(source, accountId, Number(money), description);
});

async function depositMoney(source: number, accountId: number, money: number, description: string) {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId(),
        hasMoney = exp['crp-inventory'].useItem(source, 'CRP_DINHEIRO', money);

    if (!hasMoney) return [false, 'Não tens dinheiro suficiente!'];

    if (!hasPermission(accountId, characterId))
        return [false, 'Não tem permissão para realizar esta operação.'];

    const uuid = UuidTool.newUuid();
    const query = [
        'INSERT INTO transactions (id, account, sender, receiver, money, type, time, description) VALUES (UuidToBin(@uuid), NULL, @characterId, @accountId, @money, 2, UNIX_TIMESTAMP(), @description);',
        'UPDATE accounts SET money = money + @money WHERE id = @accountId;',
    ];
    const result = await DB.Transaction(query, {
        uuid: uuid,
        accountId: accountId,
        characterId: characterId,
        money: money,
        description: description,
    });

    if (!result) return [false];

    return [true, 'Depósito efetuado com sucesso.', await fetchTransaction(uuid)];
}

RPC.Register('withdrawMoney', function (
    source: number,
    accountId: number,
    money: number,
    description: string,
) {
    return withdrawMoney(source, accountId, Number(money), description);
});

async function withdrawMoney(
    source: number,
    accountId: number,
    money: number,
    description: string,
) {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId(),
        uuid = UuidTool.newUuid();

    if (!hasPermission(accountId, characterId))
        return [false, 'Não tem permissão para realizar esta operação.'];

    let query = `UPDATE accounts SET money = money - ? WHERE id = ? AND money >= ?;`;
    let result = await DB.Execute(query, money, accountId, money);

    if (!result || result.changedRows <= 0) return [false, 'Não tens dinheiro suficiente!'];

    query = `
		INSERT INTO transactions (id, account, sender, receiver, money, type, time, description)
		VALUES (UuidToBin(?), ?, ?, NULL, ?, 1, UNIX_TIMESTAMP(), ?);
	`;
    result = await DB.Execute(query, uuid, accountId, characterId, money, description);

    if (!result || result.affectedRows <= 0) return [false];

    return [true, 'Levantamento efetuado com sucesso.', await fetchTransaction(uuid)];
}

RPC.Register('transferMoney', function (
    source: number,
    accountId: number,
    money: number,
    iban: number,
    description: string,
) {
    return transferMoney(source, accountId, Number(money), Number(iban), description);
});

async function transferMoney(
    source: number,
    accountId: number,
    money: number,
    iban: number,
    description: string,
) {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId();

    if (!hasPermission(accountId, characterId))
        return [false, 'Não tem permissão para realizar esta operação.'];

    const [success, receiverId] = await isAccountValid(iban);

    if (!success) return [false, receiverId];

    if (receiverId == accountId)
        return [false, 'Não podes transferir dinheiro para a mesma conta bancária.'];

    const query = `UPDATE accounts SET money = money - ? WHERE id = ? AND money > ?`;
    let result = await DB.Execute(query, money, accountId, money);

    if (!result || result.changedRows <= 0)
        return [false, 'A conta atual não tem dinheiro suficiente!'];

    const uuid = UuidTool.newUuid();
    const querys = [
        `INSERT INTO transactions (id, account, sender, receiver, money, type, time, description) VALUES (UuidToBin(@uuid), @accountId, @characterId, @receiverId, @money, 3, UNIX_TIMESTAMP(), @description);`,
        `UPDATE accounts SET money = money + @money WHERE id = @receiverId;`,
    ];
    result = await DB.Transaction(querys, {
        uuid: uuid,
        accountId: accountId,
        receiverId: receiverId,
        characterId: characterId,
        money: money,
        description: description,
    });

    if (!result) return [false];

    return [true, 'Transferência efetuada com sucesso.', await fetchTransaction(uuid)];
}

async function fetchTransaction(uuid: string) {
    const query = `
        SELECT
			UuidFromBin(transactions.id) AS id,
			transactions.account AS sender_id,
			accounts.name AS sender_name,
			transactions.receiver AS receiver_id,
			receiver.name AS receiver_name,
			CONCAT(characters.firstname, ' ', characters.lastname) AS sender_fullname,
			type.id AS type,
			type.name AS type_name,
			transactions.time,
			transactions.money,
			transactions.description
		FROM transactions
			LEFT JOIN accounts
				ON transactions.account = accounts.id
            LEFT JOIN accounts receiver
				ON transactions.receiver = receiver.id
			INNER JOIN characters
				ON transactions.sender = characters.id
			INNER JOIN transactions_type type
				ON transactions.type = type.id
		WHERE transactions.id = UuidToBin(?);
    `;
    const result = await DB.Execute(query, uuid);

    return result[0];
}

async function hasPermission(accountId: number, characterId: number) {
    const query = `
		SELECT EXISTS(SELECT * FROM accounts WHERE accounts.owner = ? AND accounts.id = ? GROUP BY accounts.id LIMIT 1) AS hasPermission;
	`;
    const result = await DB.Execute(query, characterId, accountId);

    return result[0].hasPermission;
}

async function isAccountValid(iban: number) {
    const isPersonal = iban < 6371708 ? true : false;
    let data = iban;

    if (isPersonal) {
        const character = exp['crp-base'].getCharacter(iban);

        if (!character) return [false, 'A conta que você inseriu não existe.'];

        data = character.getCharacterId();
    }

    const query = isPersonal
        ? `SELECT id FROM accounts WHERE accounts.owner = ? AND accounts.type = 1`
        : `SELECT EXISTS (SELECT * FROM accounts WHERE accounts.id = ? LIMIT 1) AS isAccountValid;`;
    const result = await DB.Execute(query, data);

    if (!result || (isPersonal && result.length == 0) || (!isPersonal && !result[0].isAccountValid))
        return [false, 'A conta que você inseriu não existe.'];

    return [true, isPersonal ? result[0].id : iban];
}
