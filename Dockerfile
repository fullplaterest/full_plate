FROM elixir:1.16-alpine

WORKDIR /app

RUN apk update && \
    apk add --no-cache build-base git nodejs npm inotify-tools

RUN mix local.hex --force && \
    mix local.rebar --force

COPY . .

RUN mix deps.get

RUN mix compile

EXPOSE 4000

CMD ["mix", "phx.server"]