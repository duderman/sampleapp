namespace :db do
  desc 'Run DB migrations'
  task migrate: :environment do
    require 'sequel/extensions/migration'

    Sequel::Migrator.apply(Sampleapp::App.database, 'db/migrations')
  end

  desc 'Rollback migration'
  task rollback: :environment do
    require 'sequel/extensions/migration'
    database = Sampleapp::App.database

    version  = (row = database[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(database, 'db/migrations', version - 1)
  end

  desc 'Dump the database schema'
  task dump: :environment do
    database = Sampleapp::App.database

    `sequel -d #{database.url} > db/schema.rb`
    `pg_dump --schema-only #{database.url} > db/schema.sql`
  end

  desc 'Runs migrations and dumps DB'
  task migrate_and_dump: [:migrate, :dump]

  desc 'Seeds database'
  task seed: :environment do
    Sequel::Seeder.apply(Sampleapp::App.database, 'db/seeds')
  end
end
