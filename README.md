# Shopping Cart API Challenge

This challenge consists of an API for managing a shopping cart for an e-commerce system.

The goal is to allow the creation, manipulation, and cleanup of shopping carts efficiently, including support for asynchronous processing and abandoned cart handling.

------------------------------------------------------------------------

## Stack

- Ruby 3.3.1
- Rails 7.2.3.1
- PostgreSQL 16
- Redis 7
- Sidekiq
- Docker / Docker Compose

------------------------------------------------------------------------

## Install Docker and Docker Compose

- https://docs.docker.com/engine/install/
- https://docs.docker.com/compose/install/

------------------------------------------------------------------------

## How to run the project

```bash
docker compose -f docker-compose.dev.yml up --build
```

------------------------------------------------------------------------

## Run migrations

```bash
docker compose -f docker-compose.dev.yml exec web rails db:create db:migrate
```

------------------------------------------------------------------------

## Run seeds

```bash
docker compose -f docker-compose.dev.yml exec web rails db:seed
```

------------------------------------------------------------------------

## Access the application shell

```bash
docker exec -it myapp_api_dev bash
```

------------------------------------------------------------------------

# API Endpoints

------------------------------------------------------------------------

## List available products

```bash
curl -X GET http://localhost:3000/products
```

------------------------------------------------------------------------

## Add product to cart

```bash
curl -X POST http://localhost:3000/cart \
  -H "Content-Type: application/json" \
  -d '{
    "product_id": 1,
    "quantity": 2
  }'
```

------------------------------------------------------------------------

## Get current cart

```bash
curl -X GET http://localhost:3000/cart
```

------------------------------------------------------------------------

## Update product quantity in cart

```bash
curl -X POST http://localhost:3000/cart/add_item \
  -H "Content-Type: application/json" \
  -d '{
    "product_id": 1230,
    "quantity": 1
  }'
```

------------------------------------------------------------------------

## Remove product from cart

```bash
curl -X DELETE http://localhost:3000/cart/:product_id
```

------------------------------------------------------------------------

# Business Rules

- A cart is automatically created if it does not exist
- Products are incremented if they already exist in the cart
- Carts with no interaction for 3 hours are marked as abandoned
- Carts abandoned for more than 7 days are removed
- Asynchronous processing using Sidekiq (jobs)

------------------------------------------------------------------------

# CI/CD Pipeline (GitHub Actions)

- RuboCop (linting)
- bundle-audit (security checks)
- Brakeman (security scanner)
- RSpec (automated tests)
- PostgreSQL service in CI
