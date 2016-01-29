require 'active_record/connection_adapters/abstract_mysql_adapter'

ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES.tap do |defaults|
  # Decrease default string length from 255 -> 191 chars so *_type columns
  # can be indexed with utf8mb4 without blowing 767 byte max key length.
  defaults[:string][:limit] = 191
end


# thanks @jeremy
# https://github.com/rails/rails/pull/23009#issuecomment-171406595