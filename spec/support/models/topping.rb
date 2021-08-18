# frozen_string_literal: true
# encoding: utf-8

class Topping
  include Mongoid::Document
  field :name, type: String
  belongs_to_one :pizza
end
