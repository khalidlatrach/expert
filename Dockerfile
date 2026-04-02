# ---- Build stage ----
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# IMPORTANT: ensure SvelteKit is synced
RUN npx svelte-kit sync

# Build the app
RUN npm run build

# ---- Run stage ----
FROM node:20-alpine
WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000

# FIX: correct entry file
CMD ["node", "build/index.js"]