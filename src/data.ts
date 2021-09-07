import "reflect-metadata";
import {UsersFactory} from "./fixtures/users";
import * as dotenv from "dotenv"
import {ArticleFactory} from "./fixtures/article";

dotenv.config()

let userFactory = new UsersFactory()

userFactory.create(100).catch(resp => {
    console.log(resp)
})

let article = new ArticleFactory()
article.create(100)