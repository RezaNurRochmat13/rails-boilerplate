# frozen_string_literal: true

class UserMailer < ApplicationMailer # rubocop:disable Style/Documentation
  def welcome(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "Selamat datang, #{@user.name}!")
  end
end
