# frozen_string_literal: true
# encoding: utf-8

class Eye
  include Mongoid::Document

  field :pupil_dilation, type: Integer

  belongs_to_one :eyeable, polymorphic: true

  belongs_to_one :suspended_in, polymorphic: true
end
