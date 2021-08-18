# frozen_string_literal: true
# encoding: utf-8

module Publication
  class Review
    include Mongoid::Document

    field :summary

    belongs_to_one :reviewable, polymorphic: true
    belongs_to_one :reviewer, polymorphic: true
    belongs_to_one :template
  end
end
