# frozen_string_literal: true
# encoding: utf-8

class Breed
  include Mongoid::Document
  belongs_to_many :dogs
end
