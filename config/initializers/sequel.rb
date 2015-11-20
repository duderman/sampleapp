Sequel.extension :seed

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :defaults_setter
Sequel::Model.plugin :timestamps, force: true, update_on_create: true
Sequel::Model.plugin :auto_validations
Sequel::Model.plugin :localization

module Sequel
  class Model
    class Errors < ::Hash
      remove_const(:ATTRIBUTE_JOINER)
      ATTRIBUTE_JOINER = I18n.t('models.errors.joiner').freeze

      def full_messages
        each_with_object([]) do |kv, m|
          att, errors = *kv
          if att.is_a?(Array)
            Array(att).map! { |v| I18n.t("models.attributes.#{v}.name") }
          else
            att = I18n.t("models.attributes.#{att}.name")
          end
          errors.each do |e|
            m << if e.is_a?(LiteralString)
                   e
                 else
                   "#{Array(att).join(ATTRIBUTE_JOINER)} #{e}"
                 end
          end
          m
        end
      end
    end
  end
end

Sequel::Plugins::ValidationHelpers::DEFAULT_OPTIONS.merge!(
  exact_length: {
    message: ->(exact) { I18n.t('models.errors.exact_length', exact: exact) }
  },
  format: {
    message: ->(_with) { I18n.t('models.errors.format') }
  },
  includes: {
    message: ->(set) { I18n.t('models.errors.include', values: set.inspect) }
  },
  integer: {
    message: -> { I18n.t('models.errors.integer') }
  },
  length_range: {
    message: lambda do |range|
      I18n.t('models.errors.length_range', min: range.min, max: range.max)
    end
  },
  max_length: {
    message: ->(max) { I18n.t('models.errors.max_length', max: max) },
    nil_message: -> { I18n.t('models.errors.presence') }
  },
  min_length: {
    message: ->(min) { I18n.t('models.errors.min_length', min: min) }
  },
  not_string: {
    message: lambda do |type|
      type ? I18n.t('', type: type) : I18n.t('models.errors.string')
    end
  },
  numeric: {
    message: -> { I18n.t('models.errors.numeric') }
  },
  type: {
    message: ->(type) { I18n.t('models.errors.type', type: type) }
  },
  presence: {
    message: -> { I18n.t('models.errors.presence') }
  },
  unique: {
    message: -> { I18n.t('models.errors.unique') }
  }
)
