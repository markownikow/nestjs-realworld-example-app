# ---- Base Node ----
FROM node:16.8-slim as base
ARG NODE_ENV=dev
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app
# install no

# copy project file
COPY package.json .
COPY yarn.lock .

RUN yarn install


FROM node:16.8-slim
ARG NODE_ENV=dev
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY . .
COPY --from=base --chown=node:node  /app/node_modules /app/node_modules


USER node

WORKDIR /app

EXPOSE 3000

CMD ["yarn", "start:watch"]
