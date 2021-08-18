# frozen_string_literal: true
# encoding: utf-8

class Exhibitor
  include Mongoid::Document
  field :status, type: String
  belongs_to_one :exhibition
  belongs_to_many :artworks
end
