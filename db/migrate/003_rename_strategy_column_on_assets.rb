Sequel.migration do
  change do
    rename_column :assets, :strategy, :strategy_name
  end
end
