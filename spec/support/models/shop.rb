# frozen_string_literal: true
# encoding: utf-8

class Shop
  include Mongoid::Document
  field :title, type: String
  belongs_to_many :followers, inverse_of: :followed_shops, class_name: "User"
  belongs_to_one :user
end
