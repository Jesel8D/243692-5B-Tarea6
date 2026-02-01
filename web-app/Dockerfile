FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Cambiamos la URL de la DB para que Next.js busque el contenedor 'db' en la red de Docker
ENV DATABASE_URL=postgresql://webapp_user:rollito_password@db:5432/rollito_db
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]