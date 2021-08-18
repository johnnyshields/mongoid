# frozen_string_literal: true
# encoding: utf-8

class Tag
  include Mongoid::Document
  field :text, type: String
  belongs_to_many :actors
  belongs_to_many :articles
  belongs_to_many :posts
  belongs_to_many :related, class_name: "Tag", inverse_of: :related
end
