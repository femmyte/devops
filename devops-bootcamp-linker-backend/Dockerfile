FROM node:lts-bookworm-slim AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

# build the image
RUN npm run build

# STAGE 2
FROM node:lts-bookworm-slim as runner
WORKDIR /app


# Set build variable

# re-install Only production dependencies to keep the image small
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# copy only neccessary files
COPY --from=build /app/dist ./dist

USER node

EXPOSE 3001

CMD [ "node", "src/index.js"]
