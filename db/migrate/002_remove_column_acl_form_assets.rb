Sequel.migration do
  change do
    drop_column :assets, :acl
  end
end
