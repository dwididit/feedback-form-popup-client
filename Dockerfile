# Stage 1: Build the Vue.js app
FROM node:14.20.1-alpine as build-stage

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the Vue.js app
RUN npm run build

# Stage 2: Serve the Vue.js app with Nginx
FROM nginx:stable-alpine as production-stage

# Copy the built files from the previous stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 8080

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
