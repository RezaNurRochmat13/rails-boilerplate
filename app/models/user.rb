# frozen_string_literal: true

class User < ApplicationRecord # rubocop:disable Style/Documentation
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
