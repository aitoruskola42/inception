FROM alpine:3.20.2

# Install Node.js and npm
RUN apk add --no-cache nodejs npm

WORKDIR /public

COPY conf/package*.json ./

COPY src ./public

RUN npm install

COPY . .

RUN npm run build

RUN npm install -g serve

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]