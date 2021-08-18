# frozen_string_literal: true
# encoding: utf-8

class Meat
  include Mongoid::Document
  belongs_to_many :sandwiches
end
