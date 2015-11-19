FactoryGirl.definition_file_paths = %w(./spec/factories)
FactoryGirl.find_definitions
FactoryGirl.define { to_create(&:save) }
