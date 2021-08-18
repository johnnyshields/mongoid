# frozen_string_literal: true
# encoding: utf-8

class Dog
  include Mongoid::Document
  field :name, type: String
  belongs_to_many :breeds
  belongs_to_many :fire_hydrants, primary_key: :location
  default_scope ->{ asc(:name) }
end
