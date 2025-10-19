# 1. Base image
FROM node:20-alpine

# 2. Set working directory
WORKDIR /app

# 3. Copy files
COPY package*.json ./
RUN npm install

COPY . .

# 4. Build Prisma client
RUN npx prisma generate

# 5. Expose port
EXPOSE 3001

# 6. Start the app
CMD ["npm", "run", "dev"]
