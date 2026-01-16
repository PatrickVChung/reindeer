source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

########################################
# Core
########################################
gem "rails", "~> 7.1"
gem "bundler"
gem "pg"
gem "bcrypt"
gem "rdoc"
gem "psych", "< 4"

########################################
# Sprockets (Rails 7.1 still supports it)
########################################
gem "sprockets-rails"     # REQUIRED for your asset pipeline gems
gem "sassc-rails"         # Rails 7.1 supports SassC
gem "coffee-rails"        # Works only with Sprockets

########################################
# Admin / Auth / Config
########################################
gem "rails_admin", "~> 3.3"
gem "rails_admin_import", "~> 3.0"
gem "settingslogic"
gem "cancancan"
gem "devise", "~> 4.7"
gem "devise_ldap_authenticatable"
gem "lograge"

########################################
# JavaScript / CSS (Sprockets-based)
########################################
gem "jquery-rails"
gem "jquery-ui-rails", "~> 8.0.0"
gem "jquery_context_menu-rails"
gem "momentjs-rails"
gem "fullcalendar-rails"
gem "select2-rails"
gem "font-awesome-rails"
gem "highcharts-rails"
gem "lazy_high_charts"
gem "jquery-datatables"
gem "datejs-rails", "~> 2.0.1"
gem "twitter-bootstrap-rails"   # Bootstrap 3/4 via Sprockets
gem "bootstrap", "~> 5.3.2"     # If you want Bootstrap 5 via CSS bundling or CDN
gem "flatpickr"
gem "popper_js", ">= 2.11.8", "< 3"

########################################
# Asset Pipeline Enhancements
########################################
gem "autoprefixer-rails"
gem "dartsass-rails"            # Optional: Dart Sass compiler

########################################
# Forms / UI
########################################
gem "simple_form"
gem "cocoon"
gem "nested_form_fields"

########################################
# Pagination
########################################
gem "kaminari"
gem "will_paginate", "~> 3.1"

########################################
# File Uploads / Active Storage
########################################
gem "image_processing"
gem "activestorage-validator", "~> 0.1.0"
gem "active_storage_drag_and_drop"

########################################
# Utilities
########################################
gem "gon"
gem "prawn"
gem "csv"
gem "csv_hasher"
gem "xsv"
gem "fast_page"
gem "aes"
gem "httparty"
gem "timeout"
gem "nokogiri"
gem "net-imap", ">= 0.4.20"
gem "rails-html-sanitizer", ">= 1.6.1"
gem "icalendar"
gem "rufus-scheduler"
gem "statistics2"
gem "descriptive-statistics"
gem "php-serialize"
gem "paper_trail"

########################################
# Importmap (Rails 7.1 supports it)
########################################
gem "importmap-rails", "~> 2.0"

########################################
# Development & Test
########################################
group :development, :test do
  gem "rspec-rails"
  gem "capybara"
  gem "rails-perftest"
  gem "factory_bot_rails"
  gem "faker"
  gem "rails-controller-testing"
  gem "letter_opener"
end

group :development do
  gem "better_errors"
  gem "byebug"
  gem "rack-mini-profiler", require: false
  gem "rack", ">= 2.2.12"
  gem "webrick", ">= 1.8.2"
  gem "puma", "~> 6.4.2"
  gem "rails_layout"
  gem "awesome_print"
  gem "binding_of_caller"
  gem "redcarpet"
  gem "guard"
  gem "guard-rspec"
  gem "bullet"
end

group :production do
  gem "exception_notification"
end

gem "mini_racer"
gem "whenever", require: false
