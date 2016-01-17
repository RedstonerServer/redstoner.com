module MailerHelper
  def background_mailer(mails)
    Thread.new do
      begin
        mails.each do |mail|
          begin
            mail.deliver_now
          rescue => e
            Rails.logger.error "---"
            Rails.logger.error "WARNING: '#{mail.try(:subject)}' failed for recipient #{mail.try(:to)}"
            Rails.logger.error e.message
            Rails.logger.error "---"
          end
        end
      rescue => e
        Rails.logger.error "---"
        Rails.logger.error "WARNING: Problem while processing mails:"
        Rails.logger.error e.message
        Rails.logger.error "---"
      ensure
        # threads open their own DB connection
        ActiveRecord::Base.connection.close
        Rails.logger.flush
      end
    end
  end
end