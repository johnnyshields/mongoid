# frozen_string_literal: true

class Edit
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  field :archived_at, type: Time
  embedded_in :wiki_page, touch: true
end
