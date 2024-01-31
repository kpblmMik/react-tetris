# Stage 1: Node.js base image to build the app
 FROM node:lts-alpine as build-stage 

# Set working directory in container
 WORKDIR /app

# Install dependencies 
COPY package*.json .
RUN npm ci 

# Copy source code
 COPY . . 

# Build application
 RUN npm run build 

# Stage 2: Nginx to run the app
 FROM nginx:alpine as production-stage 

# Copy Nginx configuration file
 COPY --from=build-stage /app/dist /usr/share/nginx/html 

# By default uses Nginx port 80
 EXPOSE 80 

# Run Nginx in foreground
 CMD [ "nginx" , "-g" , "daemon off;" ]