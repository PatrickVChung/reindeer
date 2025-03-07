
#Rails.application.config.assets.paths << Rails.root.join("node_modules")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap/dist/js")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap/dist/js")
#
# Rails.application.config.assets.paths += [
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap/dist/js")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap/dist/js")
#   Rails.root.join('vendor', 'assets').to_s
# ]
#
# # # Precompile additional assets.
# # # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += [
#   Rails.root.join('vendor/assets/javascripts/*').to_s,
#   Rails.root.join('vendor/assets/stylesheets/*').to_s
# ]

Rails.application.config.assets.precompile += %w(
    bootstrap.min.js
    popper.js
    print.css
    comments.css
    form-utils.js
    sync_triggers.js
    high_voltage_pages.css
    errors.css errors.js
    sessions.css  sessions.js
    dashboard.css dashboard.js
    devise_sessions.css
    users.css users.js
    settings_sync_triggers.css
    settings.css
    rails_admin_iframe.css
    dataTables/*
    action_plan_items.css
    searches.css
    jquery.contextmenu/dist/jquery.contextMenu.css
    jquery.contextmenu/dist/jquery.contextMenu.js
    artifacts.css
   )
Rails.application.config.assets.precompile << "bootstrap.min.js"
