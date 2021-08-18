# frozen_string_literal: true
# encoding: utf-8

class ShippingPack < Pack
  belongs_to_one :subscription, counter_cache: true
end
