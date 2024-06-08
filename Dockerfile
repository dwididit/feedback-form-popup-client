# Use the official Node.js 14 image as the base image
FROM node:14

# Set the working directory inside the container to /app
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install the dependencies specified in package.json
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Define a build argument for the backend URL
ARG VUE_APP_BACKEND_URL

# Set the environment variable for the backend URL using the build argument
ENV VUE_APP_BACKEND_URL=${VUE_APP_BACKEND_URL}

# Build the application for production
RUN npm run build

# Expose port 8080 to be accessible from outside the container
EXPOSE 8080

# Use npx to serve the production build from the dist directory
CMD ["npx", "serve", "-s", "dist"]
