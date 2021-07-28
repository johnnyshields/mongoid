# frozen_string_literal: true
# encoding: utf-8

class Plumber
  include Mongoid::Document

  field :name

  belongs_to :company, validate: false
  association_scope :active_company, :company, -> { where(active: true) }
  association_scope :inactive_company, :company, -> { where(active: false) }

  has_one :account, validate: false
  association_scope :rich_account, :account, -> { gt(balance: 100) }
  association_scope :unbalanced_account, :account, :unbalanced

  has_many :powerups, validate: false
  association_scope :invincible_powerups, :powerups, -> { where(name: 'Star') }
  association_scope :fire_powerups, :powerups, Powerup.where(name: 'Flower')

  has_and_belongs_to_many :houses, validate: false
  association_scope :prefab_houses, :houses, -> { where(model: 'Prefab') }
  association_scope :tiny_houses, :houses, -> { where(model: 'Tiny') }
end
