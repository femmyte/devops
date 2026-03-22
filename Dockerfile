FROM node:lts-bookworm-slim AS build

WORKDIR /app

COPY package*.json .

RUN npm install

COPY . .

# build the image
RUN npm run build

# STAGE 2
FROM node:lts-bookworm-slim
WORKDIR /app


# Set build variable
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=127.0.0.1:3001


# COPY --from=build /app/public ./public
# COPY --from=build /app/.next/standalone ./
# COPY --from=build /app/.next/static ./.next/static

COPY --from=build /app/public ./public
COPY --from=build /app/.next ./.next
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/next.config.mjs ./next.config.mjs


EXPOSE 3000
ENV PORT=3000

RUN useradd -m myuser
USER myuser

CMD ["npm", "start"]
# CMD [ "node", "server.js"]
