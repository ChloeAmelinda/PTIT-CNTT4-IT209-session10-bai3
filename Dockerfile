# STAGE 1: BUILDER
FROM node:18-alpine AS builder

WORKDIR /app

# Copy khai bao thu vien truoc de tan dung cache
COPY package*.json ./

# Cai dat dependencies
RUN npm install --omit=dev

# Copy ma nguon
COPY server.js ./

# STAGE 2: RUNTIME
FROM node:18-alpine

WORKDIR /app

# Chi copy nhung gi can de chay ung dung
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./

ENV PORT=3000
EXPOSE 3000

CMD ["node", "server.js"]