# frozen_string_literal: true
# encoding: utf-8

class FireHydrant
  include Mongoid::Document
  field :location, type: String
  belongs_to_many :dogs, primary_key: :name
  belongs_to_many :cats, primary_key: :name
end
