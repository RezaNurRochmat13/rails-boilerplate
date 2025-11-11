# frozen_string_literal: true

# app/workers/user_mailer_worker.rb
class UserMailerWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'mailers', retry: 5

  def perform(user_id)
    user = User.find(user_id)
    # pastikan mailer tersedia
    UserMailer.welcome(user.id).deliver_now
  end
end
