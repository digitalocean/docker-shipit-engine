# docker-shipit-engine

Docker image for https://github.com/Shopify/shipit-engine

## Running locally
* Create `config/secrets.yml` based off of `config/secrets.example.yml` and fill in your GitHub App's info
* Run `make start-local` to start a local instance. To stop it, run: `make stop-local`. Occassionally, the app and/or worker processeses may fail to start due to Postgres not being ready. To resolve, `ctrl-c` and re-run `make start-local`.

## Running on Kubernetes
* TBD
