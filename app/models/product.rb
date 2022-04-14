class Product < ApplicationRecord
  multi_tenant :tenant
end
