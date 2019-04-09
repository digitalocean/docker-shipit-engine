# docker-shipit-engine

Docker image for https://github.com/Shopify/shipit-engine

## Running on Docker Compose

* Create `config/secrets.yml` based off of `config/secrets.example.yml` and fill in your GitHub App's info
* Run `make start` to start an instance. To stop it, run: `make stop`.

## Running on Kubernetes

* TBD

## Database Management

On first run, you'll need to create the database. Do so by running `make setup`.

After upgrades, you may need to run database migrations. Do so by running `make upgrade`.
