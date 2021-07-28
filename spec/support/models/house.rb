# frozen_string_literal: true
# encoding: utf-8

class House
  include Mongoid::Document
  field :name, type: String
  field :model, type: String
  default_scope ->{ asc(:name) }

  has_and_belongs_to_many :people, class_name: 'Person'
  has_and_belongs_to_many :plumber, class_name: 'Plumber'
end
