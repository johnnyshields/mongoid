# frozen_string_literal: true
# encoding: utf-8

class Dragon
  include Mongoid::Document
  belongs_to_many :dungeons
end
