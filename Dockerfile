FROM node:18-alpine AS builder

WORKDIR /build

COPY package*.json .

RUN npm i

COPY . .

# Second stage

FROM node:18-alpine AS prod

RUN apk --no-cache add curl doas

WORKDIR /app

COPY --from=builder /build .

RUN adduser -D run-user
RUN chown run-user:run-user -R /app
USER run-user

EXPOSE 8000

HEALTHCHECK CMD curl --fail http://localhost:8000/api/users || exit 1

CMD ["npm", "start"]
