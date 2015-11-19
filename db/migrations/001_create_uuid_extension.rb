Sequel.migration do
  up do
    run %(CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;)
  end

  down do
    run %(DROP EXTENSION "uuid-ossp";)
  end
end
