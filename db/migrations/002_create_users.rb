Sequel.migration do
  change do
    create_table(:users) do
      column :id, 'uuid',
        default: Sequel::LiteralString.new('uuid_generate_v4()'),
        null: false
      column :email, 'text', null: false
      column :name, 'text', null: false
      column :password_digest, 'text', null: false
      column :is_admin, 'boolean', default: false
      column :created_at, 'timestamp without time zone', null: false
      column :updated_at, 'timestamp without time zone', null: false

      primary_key [:id]
      index :email, unique: true
    end
  end
end
