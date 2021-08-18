# frozen_string_literal: true
# encoding: utf-8

class Dungeon
  include Mongoid::Document
  belongs_to_many :dragons
end
