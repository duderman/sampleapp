Sequel.migration do
  change do
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end

    create_table(:users, :ignore_index_errors=>true) do
      String :id, :null=>false
      String :email, :text=>true, :null=>false
      String :name, :text=>true, :null=>false
      String :password_digest, :text=>true, :null=>false
      TrueClass :is_admin, :default=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false

      primary_key [:id]

      index [:email], :unique=>true
    end

    create_table(:posts) do
      String :id, :null=>false
      foreign_key :user_id, :users, :type=>String, :null=>false, :key=>[:id]
      String :body, :text=>true, :null=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false

      primary_key [:id]
    end

    create_table(:comments) do
      String :id, :null=>false
      foreign_key :user_id, :users, :type=>String, :null=>false, :key=>[:id]
      foreign_key :post_id, :posts, :type=>String, :null=>false, :key=>[:id]
      String :text, :text=>true, :null=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false

      primary_key [:id]
    end
  end
end
