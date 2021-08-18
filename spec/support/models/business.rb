# frozen_string_literal: true
# encoding: utf-8

class Business
  include Mongoid::Document
  field :name, type: String
  belongs_to_many :owners, class_name: "User", validate: false
end
