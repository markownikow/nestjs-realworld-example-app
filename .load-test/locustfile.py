from locust import HttpUser, task, between
from random import randint
import os

ITEMS_TO_VISIT = os.environ.get("ITEMS_TO_VISIT", 100)

class QuickstartUser(HttpUser):
    wait_time = between(0.1, 2)

    articles = {}
    articles_count = 0

    @task
    def view_articles(self):

        for article_id in range(ITEMS_TO_VISIT):
            article = self.rand_article()
            self.client.get("/api/articles/" + article["slug"])

    def on_start(self):
        response = self.client.get("/api/articles/?limit=1000")
        self.articles = response.json()['articles']
        self.articles_count = len(self.articles)


    def rand_article(self):
        return self.articles[randint(0, self.articles_count - 1)]
