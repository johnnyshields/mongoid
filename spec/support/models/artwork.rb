# frozen_string_literal: true
# encoding: utf-8

class Artwork
  include Mongoid::Document
  belongs_to_many :exhibitors
end
