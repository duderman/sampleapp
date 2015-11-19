Sequel.migration do
  change do
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
    
    create_table(:users) do
      String :id, :null=>false
      String :email, :text=>true, :null=>false
      String :name, :text=>true, :null=>false
      String :password_digest, :text=>true, :null=>false
      TrueClass :is_admin, :default=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      primary_key [:id]
    end
  end
end
