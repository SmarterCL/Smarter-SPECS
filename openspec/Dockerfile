FROM node:24-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 4321

ENV NODE_ENV=production
ENV PORT=4321
ENV ASTRO_TELEMETRY_DISABLED=1

CMD ["node", "dist/server/entry.mjs"]
