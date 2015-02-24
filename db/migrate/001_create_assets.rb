Sequel.migration do
  change do
    create_table(:assets) do
      primary_key :id
      column :strategy, String, null: false
      column :uid, String, null: false, unique: true
      column :acl, String, null: false
      column :status_id, Integer, null: false
      column :meta, :json, null: false, default: '{}'
    end
  end
end
