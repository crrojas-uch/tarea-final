FROM node:24-alpine AS construccion

WORKDIR /usr/app

COPY package*.json .
COPY pnpm-lock.yaml .
COPY . .
RUN corepack enable && corepack prepare pnpm@latest --activate

RUN pnpm install --frozen-lockfile

RUN pnpm build

FROM node:24-alpine AS ejecucion

WORKDIR /usr/app

COPY package*.json .
COPY pnpm-lock.yaml .
COPY pnpm-workspace.yaml .

RUN corepack enable && corepack prepare pnpm@latest --activate

RUN pnpm install --prod --frozen-lockfile

COPY --from=construccion /usr/app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main.js"]
