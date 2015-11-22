Sequel.migration do
  change do
    create_table(:comments) do
      column :id, 'uuid',
        default: Sequel::LiteralString.new('uuid_generate_v4()'),
        null: false
      foreign_key :user_id, :users, type: 'uuid', key: [:id], null: false
      foreign_key :post_id, :posts, type: 'uuid', key: [:id], null: false
      column :text, 'text', null: false
      column :created_at, 'timestamp without time zone', null: false
      column :updated_at, 'timestamp without time zone', null: false

      primary_key [:id]
    end
  end
end
