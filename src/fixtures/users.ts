import "reflect-metadata";
import {UserEntity} from "../user/user.entity";
import * as faker from 'faker';
import {connectionFactory} from "./connection";


export class UsersFactory {

    public async create(count: number): Promise<void> {

        connectionFactory().then(async connection => {

            for (let i = 0; i < count; i++) {
                let userData = this.randUser()

                connection.createQueryBuilder().insert().into("user")
                    .values(userData)
                    .execute()
                    .catch(e => {
                        console.log(e)
                    })
            }
            console.log("data updated");

        }).catch(error => console.log(error));
    }

    private randUser(): UserEntity {
        let user = new UserEntity()
        user.username =  faker.internet.userName()
        user.password = faker.internet.password()
        user.email = faker.internet.email()

        return user;
    }
}
