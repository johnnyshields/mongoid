# frozen_string_literal: true
# encoding: utf-8

class Role
  include Mongoid::Document
  field :name, type: String
  belongs_to_one :user
  belongs_to_one :post
  recursively_embeds_many
end
