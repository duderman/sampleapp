module Sequel
  module Plugins
    module Localization
      module ClassMethods
        def attribute_name(attribute)
          check_attribute_existens!(attribute)
          attribute_i18n_translation(attribute)
        end

        def attribute_description(attribute)
          check_attribute_existens!(attribute)
          attribute_i18n_translation(attribute, 'description')
        end

        private

        def check_attribute_existens!(attribute)
          return true if columns.include?(attribute.to_sym)

          message = "Attribute #{attribute} not found" \
                    " for model #{to_s.demodulize}"
          fail ArgumentError, message
        end

        def attribute_i18n_translation(attribute, path = 'name')
          I18n.t!("models.#{table_name}.attributes.#{attribute}.#{path}")
        rescue I18n::MissingTranslationData
          I18n.t(
            "models.attributes.#{attribute}.#{path}",
            default: attribute.to_s
          )
        end
      end
    end
  end
end
