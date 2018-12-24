# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  status     :integer          default(0)
#  updated_at :datetime         not null
#

class Match < ApplicationRecord
  MAX_USERS_PER_MATCH = 2

  has_and_belongs_to_many :users, -> { distinct }, before_add: :validate_users

  scope :unfinished, -> { where(status: unfinished_statuses) }

  enum status: %i[pending active paused finished] do
    event :activate do
      transition pending: :active
    end

    event :pause do
      transition active: :paused
    end

    event :unpause do
      transition paused: :active
    end

    event :finish do
      before { self.finished_at = Time.current }

      transition all - %i[finished] => :finished
    end
  end

  class << self
    def unfinished_statuses
      statuses.except(:finished).keys
    end
  end

  def validate_users(user)
    raise ActiveRecord::Rollback if users.count >= MAX_USERS_PER_MATCH || user.matches.unfinished.any?
  end
end