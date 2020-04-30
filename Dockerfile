FROM node:12-alpine AS dev
EXPOSE 3000

WORKDIR /opt/outline
COPY . .

RUN yarn install 
RUN cp -r /opt/outline/node_modules /opt/node_modules
CMD yarn dev

FROM dev AS build
RUN yarn build 

FROM node:12-alpine AS prod
ENV NODE_ENV production
COPY . .
COPY --from=build /opt/outline/dist .
RUN yarn install --frozen-lockfile

CMD ["node", "index.js"]