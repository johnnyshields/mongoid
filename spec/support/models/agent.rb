# frozen_string_literal: true
# encoding: utf-8

class Agent
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  field :title, type: String
  field :number, type: String
  field :dob, type: Time
  embeds_many :names, as: :namable
  embeds_one :address
  belongs_to_one :game
  belongs_to_one :agency, touch: true, autobuild: true

  belongs_to_one :same_name, class_name: 'Band', inverse_of: :same_name

  belongs_to_many :accounts
  belongs_to_many :basics
end
