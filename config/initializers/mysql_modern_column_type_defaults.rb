require 'active_record/connection_adapters/abstract_mysql_adapter'

ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES.tap do |defaults|
  # Decrease default string length from 255 -> 191 chars so *_type columns
  # can be indexed with utf8mb4 without blowing 767 byte max key length.
  defaults[:string][:limit] = 191

  # Use microsecond precision for all timestamps. High-precision times are
  # first available in MySQL 5.6, but default to second precision for
  # backward compatibility.
  defaults[:datetime][:limit] = 6
  defaults[:time][:limit] = 6
end


# thanks @jeremy
# https://github.com/rails/rails/pull/23009#issuecomment-171406595