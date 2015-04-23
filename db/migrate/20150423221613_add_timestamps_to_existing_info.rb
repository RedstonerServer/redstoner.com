class AddTimestampsToExistingInfo < ActiveRecord::Migration
  def change
    Info.all.each do |i|
      i.update_attributes(created_at: Time.now)
    end
  end
end
