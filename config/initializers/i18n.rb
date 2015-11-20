I18n.enforce_available_locales = false
I18n.default_locale = :en
I18n.available_locales = [:en, :ru]
I18n.load_path = Dir[
  File.expand_path('../../translations/**/*.yml', __FILE__)
]
I18n.backend.load_translations
