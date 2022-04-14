class CreateProdcuts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.references :tenant, null: false, foreign_key: true

      t.timestamps
    end

    # Grant application user permissions on the table (this migration should run as the admin user)
    reversible do |dir|
      dir.up do
        execute 'GRANT SELECT, INSERT, UPDATE, DELETE ON products TO rails'
      end
      dir.down do
        execute 'REVOKE SELECT, INSERT, UPDATE, DELETE ON products FROM rails'
      end
    end

    # Define RLS policy
    reversible do |dir|
      dir.up do
        execute 'ALTER TABLE products ENABLE ROW LEVEL SECURITY'
        execute "CREATE POLICY products_rails ON products TO rails USING (tenant_id = NULLIF(current_setting('rls.tenant_id', TRUE), '')::bigint)"
      end
      dir.down do
        execute 'DROP POLICY products_rails ON products'
        execute 'ALTER TABLE products DISABLE ROW LEVEL SECURITY'
      end
    end
  end
end
