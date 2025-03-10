# Use Alpine as the base image
#FROM alpine:latest
# Update package index and upgrade all packages
#RUN apk update && apk upgrade && apk add --no-cache libxml2

# Build stage
FROM node:3.21.3-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]