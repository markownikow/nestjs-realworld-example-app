import {UserEntity} from "../user/user.entity";
import * as faker from 'faker';
import {connectionFactory} from "./connection";
import {ArticleEntity} from "../article/article.entity";


export class ArticleFactory {

    public async create(count: number): Promise<void> {

        connectionFactory().then(async connection => {

            let usersCount = await connection.createQueryBuilder().select("count(*)").from("user").execute()
            if (usersCount[0]["count"] === undefined) {
                return
            }
            let maxUsers = usersCount[0]["count"]

            for (let i = 0; i < count; i++) {

                let user = await connection.createQueryBuilder()
                    .select()
                    .from("user")
                    .where('id = :uid', { uid: Math.floor(Math.random() * maxUsers) })
                    .execute()

                let data = this.randArticle(user[0]["id"])

                connection.createQueryBuilder().insert().into("article")
                    .values(data)
                    .execute()
                    .catch(e => {
                        console.log(e)
                    })
            }
            console.log("data updated");

        }).catch(error => console.log(error));
    }

    private randArticle(userId) {
      return {
            title: faker.lorem.paragraph(),
            body: faker.lorem.text(),
            authorId: userId,
            slug: faker.lorem.slug(),
            tagList: []
        }
    }
}
