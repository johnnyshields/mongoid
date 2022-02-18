# frozen_string_literal: true

require "spec_helper"

describe Mongoid::Contextual::Aggregable::Memory do

  let(:criteria) do
    Band.all.tap do |crit|
      crit.documents = documents
    end
  end

  let(:context) do
    Mongoid::Contextual::Memory.new(criteria)
  end

  path = File.join(File.dirname(__FILE__), 'memory_table.yml')
  table = BSON::Document.new(YAML.load(File.read(path)))

  table.each do |name, spec|
    context name do
      let(:documents) do
        spec.fetch(:documents).map do |doc|
          Band.create!(doc)
        end
      end

      let(:result) do
        context.send(spec.fetch(:method), spec.fetch(:field))
      end

      it 'produces the expected result' do
        result.should == spec.fetch(:result)
      end

      it 'produces the expected type' do
        result.class.should be spec.fetch(:result).class
      end
    end
  end

end
