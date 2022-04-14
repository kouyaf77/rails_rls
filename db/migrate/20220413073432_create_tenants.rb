class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants do |t|
      t.string :name

      t.timestamps
    end

    # Grant application user permissions on the table (this migration should run as the admin user)
    reversible do |dir|
      dir.up do
        execute 'GRANT SELECT, INSERT, UPDATE, DELETE ON tenants TO rails'
      end
      dir.down do
        execute 'REVOKE SELECT, INSERT, UPDATE, DELETE ON tenants FROM rails'
      end
    end
  end
end
