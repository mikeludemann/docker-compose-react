FROM node:alpine AS development

ENV NODE_ENV development

# Add a work directory
WORKDIR /app

# Cache dependencies
COPY package*.json .
COPY yarn.lock .

# Install dependencies
RUN yarn install

# Copy app files
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD [ "yarn", "start" ]

FROM node:alpine AS production

ENV NODE_ENV production

# Add a work directory
WORKDIR /app

# Cache dependencies
COPY package*.json .
COPY yarn.lock .

# Install dependencies
RUN yarn install

# Copy app files
COPY . .

# Build the application
RUN yarn build

# ------------------------------------------------

FROM httpd:alpine as server

# Server path
WORKDIR /usr/local/apache2/htdocs

# Copy
COPY --from=production /app/build .

# Start the app
CMD [ "sudo", "service", "apache2", "restart" ]
