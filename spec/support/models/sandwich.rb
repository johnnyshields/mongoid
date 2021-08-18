# frozen_string_literal: true
# encoding: utf-8

class Sandwich
  include Mongoid::Document
  belongs_to_many :meats

  field :name, type: String

  belongs_to_one :posteable, polymorphic: true
  accepts_nested_attributes_for :posteable, autosave: true
end
