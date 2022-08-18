# frozen_string_literal: true

require 'spec_helper'

describe 'Queries with Mongoid::RawValue criteria' do
  before { Time.zone = 'UTC'}
  let(:now_utc) { Time.utc(2020, 1, 1, 16, 0, 0, 0) }
  let(:today) { Date.new(2020, 1, 1) }

  let(:labels) do
    [ Label.new(age: 12), Label.new(age: 16) ]
  end

  let!(:band1) { Band.create!(name: '1', likes: 0, rating: 0.9, decibels: 20..80, founded: today, updated_at: now_utc) }
  let!(:band2) { Band.create!(name: '2', likes: 1, rating: 1.0, decibels: 30..90, founded: today, updated_at: now_utc + 1.days) }
  let!(:band3) { Band.create!(name: '3', likes: 1, rating: 2.2, decibels: 40..100, founded: today + 1.days, updated_at: now_utc + 2.days) }
  let!(:band4) { Band.create!(name: '3', likes: 2, rating: 3.1, decibels: 50..120, founded: today + 1.days, updated_at: now_utc + 3.days) }
  let!(:band5) { Band.create!(name: '4', likes: 3, rating: 3.1, decibels: 60..150, founded: today + 2.days, updated_at: now_utc + 3.days, labels: labels) }

  context 'Mongoid::RawValue<String> criteria' do

    context 'Integer field' do
      it 'does not match objects' do
        expect(Band.where(likes: Mongoid::RawValue('1')).to_a).to eq []
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(likes: '1').to_a).to eq [band2, band3]
      end
    end
  
    context 'Float field' do
      it 'does not match objects' do
        expect(Band.where(rating: Mongoid::RawValue('3.1')).to_a).to eq []
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(rating: '3.1').to_a).to eq [band4, band5]
      end
    end
  
    context 'String field' do
      it 'matches objects' do
        expect(Band.where(name: Mongoid::RawValue('3')).to_a).to eq [band3, band4]
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(name: '3').to_a).to eq [band3, band4]
      end
    end
  
    context 'Range field' do
      it 'does not match objects' do
        expect(Band.where(decibels: Mongoid::RawValue('90')).to_a).to eq []
      end
  
      it 'does not match objects without raw value' do
        expect(Band.where(name: '90').to_a).to eq []
      end
    end
  
    context 'Date field' do
      it 'does not match objects' do
        expect(Band.where(founded: Mongoid::RawValue('2020-01-02')).to_a).to eq []
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(founded: '2020-01-02').to_a).to eq [band3, band4]
      end
    end
  
    context 'Time field' do
      it 'does not match objects' do
        expect(Band.where(updated_at: Mongoid::RawValue('2020-01-04 16:00:00 UTC')).to_a).to eq []
      end
  
      # TODO: this isn't working for some reason
      xit 'matches objects without raw value' do
        expect(Band.where(updated_at: '2020-01-04 16:00:00 UTC').to_a).to eq [band4, band5]
      end
    end
  end

  context 'Mongoid::RawValue<Integer>' do

    context 'Integer field' do
      it 'does not match objects' do
        expect(Band.where(likes: Mongoid::RawValue(1)).to_a).to eq [band2, band3]
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(likes: 1).to_a).to eq [band2, band3]
      end
    end
  
    context 'Float field' do
      it 'does not match objects' do
        expect(Band.where(rating: Mongoid::RawValue(1)).to_a).to eq [band2]
        expect(Band.where(rating: Mongoid::RawValue(3)).to_a).to eq []
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(rating: 1).to_a).to eq [band2]
        expect(Band.where(rating: 3).to_a).to eq []
      end
    end
  
    context 'String field' do
      it 'matches objects' do
        expect(Band.where(name: Mongoid::RawValue(3)).to_a).to eq []
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(name: 3).to_a).to eq [band3, band4]
      end
    end
  
    context 'Range field' do
      it 'does not match objects' do
        expect(Band.where(decibels: Mongoid::RawValue(90)).to_a).to eq []
      end
  
      it 'does not match objects without raw value' do
        expect(Band.where(name: 90).to_a).to eq []
      end
    end
  
    context 'Date field' do
      it 'does not match objects' do
        expect(Band.where(founded: Mongoid::RawValue(1577923200)).to_a).to eq []
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(founded: 1577923200).to_a).to eq [band3, band4]
      end
    end
  
    context 'Time field' do
      it 'does not match objects' do
        expect(Band.where(updated_at: Mongoid::RawValue(1578153600)).to_a).to eq []
      end
  
      # TODO: this isn't working for some reason
      xit 'matches objects without raw value' do
        expect(Band.where(updated_at: 1578153600).to_a).to eq [band4, band5]
      end
    end
  end

  context 'Mongoid::RawValue<Float>' do

    context 'Integer field' do
      it 'does not match objects' do
        expect(Band.where(likes: Mongoid::RawValue(1.0)).to_a).to eq [band2, band3]
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(likes: 1.0).to_a).to eq [band2, band3]
      end
    end
  
    context 'Float field' do
      it 'does not match objects' do
        expect(Band.where(rating: Mongoid::RawValue(3.1)).to_a).to eq [band4, band5]
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(rating: 3.1).to_a).to eq [band4, band5]
      end
    end
  
    context 'String field' do
      it 'matches objects' do
        expect(Band.where(name: Mongoid::RawValue(3.0)).to_a).to eq []
      end
  
      it 'matches objects without raw value' do
        expect(Band.where(name: 3.0).to_a).to eq []
      end
    end
  
    context 'Range field' do
      it 'does not match objects' do
        expect(Band.where(decibels: Mongoid::RawValue(90.0)).to_a).to eq []
      end

      it 'does not match objects without raw value' do
        expect(Band.where(name: 90.0).to_a).to eq []
      end
    end

    context 'Date field' do
      it 'does not match objects' do
        expect(Band.where(founded: Mongoid::RawValue(1577923200.0)).to_a).to eq []
      end

      it 'matches objects without raw value' do
        expect(Band.where(founded: 1577923200.0).to_a).to eq [band3, band4]
      end
    end

    context 'Time field' do
      it 'does not match objects' do
        expect(Band.where(updated_at: Mongoid::RawValue(1578153600.0)).to_a).to eq []
      end

      # TODO: this isn't working for some reason
      xit 'matches objects without raw value' do
        expect(Band.where(updated_at: 1578153600.0).to_a).to eq [band4, band5]
      end
    end
  end
end
