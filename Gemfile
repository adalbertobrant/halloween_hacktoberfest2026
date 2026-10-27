source "https://rubygems.org"

ruby "3.3.0"

# Rails
gem "rails", "~> 8.0.0"
gem "puma", "~> 6.4"
gem "bootsnap", require: false

# MongoDB
gem "mongoid", "~> 9.0"

# Temporal
gem "temporalio", "~> 0.3"

# Redis
gem "redis", "~> 5.0"

# HTTP
gem "httparty", "~> 0.22"

# Segurança
gem "rack-attack", "~> 6.7"
gem "pundit", "~> 2.3"
gem "devise", "~> 4.9"

# Utilitários
gem "dotenv-rails", "~> 3.1"
gem "jbuilder", "~> 2.12"

# Observabilidade
gem "opentelemetry-sdk", "~> 1.4"
gem "opentelemetry-exporter-otlp", "~> 0.28"
gem "opentelemetry-instrumentation-all", "~> 0.62"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end
