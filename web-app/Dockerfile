FROM node:20-alpine

WORKDIR /app

# Copiamos primero las dependencias para aprovechar el caché de Docker
COPY package*.json ./

# Instalamos dependencias
RUN npm ci

# Copiamos el código fuente
COPY . .

# Build de Next.js
# Nota: Next.js necesita saber que es prod, pero NO necesita la DB URL aquí
ENV NODE_ENV=production
RUN npm run build

EXPOSE 3000

# Iniciamos
CMD ["npm", "start"]