# frozen_string_literal: true
# encoding: utf-8

class Vertex
  include Mongoid::Document

  belongs_to_many :parents, inverse_of: :children, class_name: 'Vertex'
  belongs_to_many :children, inverse_of: :parents, class_name: 'Vertex'
end
