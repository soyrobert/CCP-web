# Etapa 1: Build Angular app
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build -- --configuration=production

# Etapa 2: Servir con Nginx
FROM nginx:stable-alpine

# Copiar configuración personalizada para SPA (manejo de rutas)
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar archivos de Angular compilados
COPY --from=builder /app/dist/ccp-web/browser /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
