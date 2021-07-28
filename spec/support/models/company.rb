# frozen_string_literal: true
# encoding: utf-8

class Company
  include Mongoid::Document

  field :active, type: Boolean, default: true

  embeds_many :staffs

  has_many :plumbers
end
