# Use the official Node.js image as the base image for building the app
FROM node:14 AS build

# Set the working directory
WORKDIR /movie-app-frontend

# Copy package.json and package-lock.json (or yarn.lock) to the working directory
COPY package.json ./
COPY package-lock.json ./
# If you use yarn, uncomment the following line and comment out the package-lock.json line above
# COPY yarn.lock ./

# Install dependencies
RUN npm install
# If you use yarn, uncomment the following line and comment out the npm install line above
# RUN yarn install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React app
RUN npm run build
# If you use yarn, uncomment the following line and comment out the npm run build line above
# RUN yarn build

# Use the official Nginx image as the base image for serving the app
FROM nginx:alpine

# Copy the build output to the Nginx HTML directory
COPY --from=build /movie-app-frontend/build /usr/share/nginx/html

# Copy a custom Nginx configuration file, if needed
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
