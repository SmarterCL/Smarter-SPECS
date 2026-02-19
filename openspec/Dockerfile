FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

# Fix host binding in generated entry point
RUN sed -i 's/"host": false/"host": "0.0.0.0"/g' dist/server/entry.mjs

EXPOSE 4321

ENV NODE_ENV=production
ENV PORT=4321
ENV ASTRO_TELEMETRY_DISABLED=1

CMD ["node", "dist/server/entry.mjs"]
