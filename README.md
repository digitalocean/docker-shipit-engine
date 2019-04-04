# docker-shipit-engine

Docker image for https://github.com/Shopify/shipit-engine

## Running locally
* Create `config/secrets.yml` based off of `config/secrets.example.yml` and fill in your GitHub App's info
* Run `make start-local` to start a local instance. To stop it, run: `make stop-local`.

## Running on Kubernetes
* TBD

## Database Management
Locally, on first run, you'll need to create the database. Do so by running the following:
```
make shell
bundle exec rake railties:install:migrations db:create db:migrate
```
