# Free Stock Photo (Rails Architect Masterclass)

[![app](https://github.com/davebream/free-stock-photo-ram/actions/workflows/app.yml/badge.svg)](https://github.com/davebream/free-stock-photo-ram/actions/workflows/app.yml)
[![reviewing](https://github.com/davebream/free-stock-photo-ram/actions/workflows/reviewing.yml/badge.svg)](https://github.com/davebream/free-stock-photo-ram/actions/workflows/reviewing.yml)
[![tagging](https://github.com/davebream/free-stock-photo-ram/actions/workflows/tagging.yml/badge.svg)](https://github.com/davebream/free-stock-photo-ram/actions/workflows/tagging.yml)

## Requirements

- Ruby 3.0.3 (with bundler)
- PostgreSQL 12.5
- Redis 6.2+
- Node 14+
- Yarn 1.22+

## Setup

### Repository

    git clone https://github.com/davebream/free-stock-photo-ram.git && cd free-stock-photo-ram

### Gems

    gem install foreman
    bundle install --jobs 4

### Database

    bundle exec rails db:prepare

### Frontend setup

    yarn install

### 🌎 Start all servers

    foreman start -f Procfile.dev

  Go to [http://localhost:5000](http://localhost:5000)

### Tests

- **Run all tests**

      bundle exec rspec .

- **Run tests for the rails app**

      bundle exec rspec

- **Run tests for bounded contexts**

      bundle exec rspec contexts
