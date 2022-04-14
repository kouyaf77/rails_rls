class ApplicationController < ActionController::Base
  set_current_tenant_through_filter # Required to opt into this behavior
  before_action :set_tenant

  def set_tenant
    tenant = Tenant.first
    set_current_tenant(tenant)
    ApplicationRecord.switch!(MultiTenant.current_tenant_id)
  end
end
