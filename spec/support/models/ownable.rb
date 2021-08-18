# frozen_string_literal: true
# encoding: utf-8

module Ownable
  extend ActiveSupport::Concern
  included do
    belongs_to_one :user
  end
end
