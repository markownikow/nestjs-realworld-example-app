import {createConnection} from "typeorm";

export function connectionFactory() {
    // @ts-ignore
    return createConnection({
        "type": process.env.DB_TYPE,
        "host": process.env.DB_HOST,
        "port": process.env.DB_PORT,
        "username": process.env.DB_USERNAME,
        "password": process.env.DB_PASSWORD,
        "database": process.env.DB_NAME,
        "entities": ["../**.entity{.ts,.js}"],
        "synchronize": false
    })

}