class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  SET_TENANT_ID_SQL = 'SET rls.tenant_id = %s'.freeze
  def self.switch!(tenant_id)
    connection.execute format(SET_TENANT_ID_SQL, connection.quote(tenant_id))
  end
end
