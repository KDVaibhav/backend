FROM node:20-alpine AS build

WORKDIR /app


RUN apk add --no-cache curl && \
    curl -fsSL https://get.pnpm.io/install.sh | sh - && \
    export PATH="/root/.local/share/pnpm:$PATH"
COPY package*.json ./

RUN pnpm install

COPY . .

RUN pnpm run build

FROM node:20-alpine AS production

WORKDIR /app

COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

EXPOSE 5000

CMD ["node", "dist/main.js"]



