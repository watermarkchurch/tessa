Sequel.migration do
  up do
    add_column :assets, :created_at, Time, null: false
    add_column :assets, :updated_at, Time, null: false

    run %{
      ALTER TABLE assets
        ALTER COLUMN created_at
          SET DEFAULT CURRENT_TIMESTAMP AT TIME ZONE 'UTC';

      ALTER TABLE assets
        ALTER COLUMN updated_at
          SET DEFAULT CURRENT_TIMESTAMP AT TIME ZONE 'UTC';
    }

    run %{
      CREATE OR REPLACE FUNCTION set_updated_at_column() RETURNS TRIGGER AS $$
      BEGIN
        NEW.updated_at = CURRENT_TIMESTAMP AT TIME ZONE 'UTC'; 
        RETURN NEW;
      END;
      $$ language 'plpgsql';
    }

    run %{
      DROP TRIGGER IF EXISTS set_updated_at_assets ON assets;

      CREATE TRIGGER set_updated_at_assets
        BEFORE UPDATE ON assets FOR EACH ROW
        EXECUTE PROCEDURE set_updated_at_column();
    }
  end

  down do
    run "DROP TRIGGER IF EXISTS set_updated_at_assets ON assets;"
    run "DROP FUNCTION IF EXISTS set_updated_at_column"
    drop_column :assets, :updated_at
    drop_column :assets, :created_at
  end
end
