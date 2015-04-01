Sequel.migration do
  change do
    add_column :assets, :username, String
  end
end
