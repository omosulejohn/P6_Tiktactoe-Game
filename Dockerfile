# Use Alpine as the base image
#FROM alpine:latest
# Update package index and upgrade all packages
#RUN apk update && apk upgrade && apk add --no-cache libxml2

# Build stage
FROM node:20-alpine AS build
WORKDIR /app
RUN apk update && apk upgrade && apk add --no-cache libxml2
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
RUN apk update && apk upgrade && apk add --no-cache libxml2
COPY --from=build /app/dist .
COPY --from=build /app/dist /usr/share/nginx/html
# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]