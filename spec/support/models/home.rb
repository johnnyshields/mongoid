# frozen_string_literal: true
# encoding: utf-8

class Home
  include Mongoid::Document
  belongs_to_one :person
end
