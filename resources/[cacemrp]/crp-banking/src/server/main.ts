import { UuidTool } from 'uuid-tool';

const exp = (<any>global).exports;

onNet('crp-base:createdCharacter', (characterId: number) => {
    createAccount(1, characterId, 'Conta Pessoal', 5000);
});

// @ts-ignore
RPC.Register('fetchBank', function (source: number) {
    return fetchBank(source);
});

async function createAccount(
    accountType: number,
    characterId: number,
    accountName: string,
    startingMoney: number,
): Promise<boolean> {
    const query = 'INSERT INTO accounts (type, owner, name, money) VALUES (?, ?, ?, ?);'; // @ts-ignore
    const result = await DB.Execute(query, accountType, characterId, accountName, startingMoney);

    if (!result.changedRows) {
        return false;
    }

    return true;
}

async function fetchBank(source: number) {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId();

    const query = `
        SELECT
            accounts.id,
            accounts.owner,
            type.name AS type,
            CONCAT(characters.firstname, ' ', characters.lastname) AS owner_name,
            accounts.name,
            accounts.money
        FROM accounts
            INNER JOIN accounts_type type
                ON accounts.type = type.id
            JOIN characters
                ON accounts.owner = characters.id
                AND accounts.owner = ?
        GROUP BY accounts.id
        ORDER BY FIELD(accounts.owner, ?) DESC;
    `; // @ts-ignore
    const result = await DB.Execute(query, characterId, characterId, characterId);

    if (!result || result.length == 0) {
        return [false];
    }

    return [true, characterId, result, await fetchTransactions(result[0].id)];
}

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
			INNER JOIN accounts
				ON transactions.account = accounts.id
			INNER JOIN accounts receiver
				ON transactions.receiver = receiver.id
			INNER JOIN characters
				ON transactions.sender = characters.id
			INNER JOIN transactions_type type
				ON transactions.type = type.id
		WHERE transactions.account = ?
		OR transactions.receiver = ? ORDER BY transactions.time DESC;
    `; // @ts-ignore
    const result = await DB.Execute(query, accountId, accountId);

    if (!result || result.length == 0) {
        return [];
    }

    return result;
}

// @ts-ignore
RPC.Register('depositMoney', function (
    source: number,
    accountId: number,
    money: number,
    description: string,
    canUpdate: boolean,
) {
    return depositMoney(source, accountId, Number(money), description, canUpdate);
});

async function depositMoney(
    source: number,
    accountId: number,
    money: number,
    description: string,
    canUpdate: boolean,
) {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId(),
        hasMoney = exp['crp-inventory'].useItem(source, 'CRP_DINHEIRO', money);

    if (!hasMoney) return [false, 'Não tens dinheiro suficiente!'];

    if (!hasPermission(accountId, characterId))
        return [false, 'Não tem permissão para realizar esta operação.'];

    const uuid = UuidTool.newUuid();
    const query = [
        `INSERT INTO transactions (id, account, sender, receiver, money, type, time, description) VALUES (UuidToBin(@uuid), @accountId, @characterId, @accountId, @money, 2, UNIX_TIMESTAMP(), @description);`,
        `UPDATE accounts SET money = money + @money WHERE id = @accountId;`,
    ]; // @ts-ignore
    const result = await DB.Transaction(query, {
        uuid: uuid,
        accountId: accountId,
        characterId: characterId,
        money: money,
        description: description,
    });

    if (!result) return [false];

    return [
        result,
        'Depósito efetuado com sucesso.',
        canUpdate ? await fetchTransaction(uuid) : null,
    ];
}

// @ts-ignore
RPC.Register('withdrawMoney', function (
    source: number,
    accountId: number,
    money: number,
    description: string,
    canUpdate: boolean,
) {
    return withdrawMoney(source, accountId, Number(money), description, canUpdate);
});

async function withdrawMoney(
    source: number,
    accountId: number,
    money: number,
    description: string,
    canUpdate: boolean,
) {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId(),
        uuid = UuidTool.newUuid();

    if (!hasPermission(accountId, characterId))
        return [false, 'Não tem permissão para realizar esta operação.'];

    let query = `UPDATE accounts SET money = money - ? WHERE id = ? AND money >= ?;`; // @ts-ignore
    let result = await DB.Execute(query, money, accountId, money);

    if (!result || result.changedRows <= 0) return [false, 'Não tens dinheiro suficiente!'];

    query = `
		INSERT INTO transactions (id, account, sender, receiver, money, type, time, description)
		VALUES (UuidToBin(?), ?, ?, ?, ?, 1, UNIX_TIMESTAMP(), ?);
	`; // @ts-ignore
    result = await DB.Execute(query, uuid, accountId, characterId, accountId, money, description);

    if (!result || result.affectedRows <= 0) return [false];

    return [
        result,
        'Levantamento efetuado com sucesso.',
        canUpdate ? await fetchTransaction(uuid) : null,
    ];
}

// @ts-ignore
RPC.Register('transferMoney', function (
    source: number,
    accountId: number,
    money: number,
    nib: number,
    description: string,
    canUpdate: boolean,
) {
    return transferMoney(source, accountId, Number(money), Number(nib), description, canUpdate);
});

async function transferMoney(
    source: number,
    accountId: number,
    money: number,
    nib: number,
    description: string,
    canUpdate: boolean,
) {
    const character = exp['crp-base'].getCharacter(source);
    const characterId = character.getCharacterId();

    if (!hasPermission(accountId, characterId))
        return [false, 'Não tem permissão para realizar esta operação.'];

    const [success, data] = await isAccountValid(nib);

    if (!success) return [false, data];

    if (data == accountId)
        return [false, 'Não podes transferir dinheiro para a mesma conta bancária.'];

    const query = `UPDATE accounts SET money = money - ? WHERE id = ? AND money > ?`; // @ts-ignore
    let result = await DB.Execute(query, money, accountId, money);

    if (!result || result.changedRows <= 0)
        return [false, 'A conta atual não tem dinheiro suficiente!'];

    const uuid = UuidTool.newUuid();
    const querys = [
        `INSERT INTO transactions (id, account, sender, receiver, money, type, time, description) VALUES (UuidToBin(@uuid), @accountId, @characterId, @receiverId, @money, 3, UNIX_TIMESTAMP(), @description);`,
        `UPDATE accounts SET money = money + @money WHERE id = @receiverId;`,
    ]; // @ts-ignore
    result = await DB.Transaction(querys, {
        uuid: uuid,
        accountId: accountId,
        receiverId: data,
        characterId: characterId,
        money: money,
        description: description,
    });

    if (!result) return [false];

    return [
        result,
        'Transferência efetuada com sucesso.',
        data,
        canUpdate ? await fetchTransaction(uuid) : null,
    ];
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
			INNER JOIN accounts
				ON transactions.account = accounts.id
			INNER JOIN accounts receiver
				ON transactions.receiver = receiver.id
			INNER JOIN characters
				ON transactions.sender = characters.id
			INNER JOIN transactions_type type
				ON transactions.type = type.id
		WHERE transactions.id = UuidToBin(?);
    `; // @ts-ignore
    const result = await DB.Execute(query, uuid);

    return result[0];
}

async function hasPermission(accountId: number, characterId: number) {
    const query = `
		SELECT EXISTS(SELECT * FROM accounts WHERE accounts.owner = ? AND accounts.id = ? GROUP BY accounts.id LIMIT 1) AS hasPermission;
	`; // @ts-ignore
    const result = await DB.Execute(query, characterId, accountId);

    return result[0].hasPermission;
}

async function isAccountValid(nib: number) {
    const isPersonal = nib < 6371708 ? true : false;
    let data = nib;

    if (isPersonal) {
        const character = exp['crp-base'].getCharacter(nib);

        if (!character) return [false, 'A conta que você inseriu não existe.'];

        data = character.getCharacterId();
    }

    const query = isPersonal
        ? `SELECT id FROM accounts WHERE accounts.owner = ? AND accounts.type = 1`
        : `SELECT EXISTS (SELECT * FROM accounts WHERE accounts.id = ? LIMIT 1) AS isAccountValid;`; // @ts-ignore
    const result = await DB.Execute(query, data);

    if (!result || (isPersonal && result.length == 0) || (!isPersonal && !result[0].isAccountValid))
        return [false, 'A conta que você inseriu não existe.'];

    return [true, isPersonal ? result[0].id : nib];
}
