# Rails Boilerplate

A modern Rails API boilerplate with best practices, ready for production and testing.

## Features

- Rails 7.x API-only application
- PostgreSQL database
- Namespaced API versioning (`/api/v1/...`)
- RSpec for testing
- FactoryBot and Faker for test data
- RuboCop for linting and code style
- Preconfigured for Docker (optional)
- CI/CD ready (GitHub Actions or your choice)

---

## Getting Started

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd rails-boilerplate
````

### 2. Install dependencies

```bash
bundle install
```

### 3. Setup database

```bash
cd infra/
docker compose up -d
rails db:create db:migrate
```

### 4. Run the server

```bash
rails server
```

By default, the server runs at [http://localhost:3000](http://localhost:3000)

---

## API Structure

* Namespaced controllers: `app/controllers/api/v1/..._controller.rb`
* Example route:

```ruby
namespace :api do
  namespace :v1 do
    resources :articles
  end
end
```

* URL example: `GET /api/v1/articles`

---

## Testing

### Run RSpec

```bash
bundle exec rspec
```

### Using FactoryBot & Faker

Factories are located in `spec/factories/`. Example:

```ruby
article = create(:article) # automatically uses Faker for random data
```

---

## Linting

RuboCop is preconfigured for Rails, RSpec, and FactoryBot.

```bash
bundle exec rubocop        # check code style
bundle exec rubocop -A     # auto-fix offenses
```

Excluded paths (not linted):

* `bin/*`, `db/schema.rb`, `db/migrate/*`
* `node_modules/*`, `vendor/*`, `tmp/*`, `log/*`, `storage/*`
* `spec/rails_helper.rb`, `spec/spec_helper.rb`
* `config/environments/*`, `config/puma.rb`

---

## Recommended Gems

* `rubocop`, `rubocop-rails`, `rubocop-rspec`, `rubocop-factory_bot`
* `rspec-rails`, `factory_bot_rails`, `faker`

---

## Project Structure

```
app/
  controllers/api/v1/...
  models/
  services/
lib/
spec/
  factories/
  services/
  models/
  requests/
config/
db/
```

---

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m "Add my feature"`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request

---

## License

This project is open source and available under the MIT License.

