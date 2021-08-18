# frozen_string_literal: true
# encoding: utf-8

class Comment
  include Mongoid::Document

  field :title, type: String
  field :text, type: String

  belongs_to_one :account
  belongs_to_one :movie
  belongs_to_one :rating
  belongs_to_one :wiki_page

  belongs_to_one :commentable, polymorphic: true

  validates :title, presence: true
  validates :movie, :rating, associated: true
end
