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
  table = YAML.safe_load(File.read(path), permitted_classes: [BigDecimal]).deep_symbolize_keys[:sets]
  table.each do |name, spec|
    context name do
      let(:documents) do
        spec[:values].map do |value|
          Band.create!({ name: 'Foobar', mojo: value })
        end
      end

      %i[sum avg min max].each do |method|
        context method do
          let(:result) do
            context.send(method, :mojo)
          end

          it 'produces the expected result' do
            if result.is_a?(Integer)
              expect(result).to eq spec[method]
            else
              expect(result).to be_within(0.001).of(spec[method])
            end
          end

          it 'produces the expected type' do
            expect(result).to be_a spec[method].class
          end
        end
      end
    end
  end
end
