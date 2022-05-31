const exp = (<any>global).exports;

export class DBManager {
    protected static instance: DBManager;

    static getInstance(): DBManager {
        if (!DBManager.instance) {
            DBManager.instance = new DBManager();
        }

        return DBManager.instance;
    }

    Execute(query: string, ...params: any[]): Promise<[] | any> {
        return new Promise(resolve => {
            exp.oxmysql.query(query, params, result => {
                return resolve(result);
            });
        });
    }

    Scalar(query: string, ...params: any[]): Promise<[] | any> {
        return new Promise(resolve => {
            exp.oxmysql.scalar(query, params, result => {
                return resolve(result);
            });
        });
    }

    Transaction(query: string[], ...params: any[]): Promise<[] | any> {
        return new Promise(resolve => {
            exp.oxmysql.transaction(query, ...params, result => {
                return resolve(result);
            });
        });
    }
}
