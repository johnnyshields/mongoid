# frozen_string_literal: true
# encoding: utf-8

require 'spec_helper'

describe 'scoped associations eager loading' do

  let(:plumber) do
    Plumber.new(name: 'Luigi')
  end

  context 'scoped belongs_to' do
    let(:company1) do
      Company.create!(active: true)
    end

    let(:company2) do
      Company.create!(active: false)
    end

    before do
      plumber.company = company1
      plumber.save!
    end
  end

  context 'scoped has_one' do

    let!(:account) do
      Account.create!(name: 'Coins', balance: 200, plumber: plumber)
    end

    context 'when object is not persisted' do

      it 'scoped assocations do not work (known limitation)' do
        expect(plumber.account).to eq account
        expect(plumber.rich_account).to eq nil # should be account
        expect(plumber.unbalanced_account).to eq nil
      end
    end

    context 'when object is persisted' do
      before do
        plumber.save!
      end

      it 'scoped associations behave correctly' do
        expect(plumber.account).to eq account
        expect(plumber.rich_account).to eq account
        expect(plumber.unbalanced_account).to eq nil
      end
    end

    context 'with multiple foreign objects persisted' do
      before do
        plumber.save!
      end

      let!(:account2) do
        Account.create!(name: 'Score', balance: nil, plumber: plumber)
      end

      let!(:account3) do
        Account.create!(name: 'Lives', balance: 3, plumber: plumber)
      end

      it 'scoped associations behave correctly' do
        expect(plumber.account).to eq account3
        expect(plumber.rich_account).to eq account
        expect(plumber.unbalanced_account).to eq account2
      end
    end
  end

  context 'scoped has_many' do

    let!(:powerup1) do
      Powerup.create!(name: 'Mushroom', plumber: plumber)
    end

    let!(:powerup2) do
      Powerup.create!(name: 'Flower', plumber: plumber)
    end

    let!(:powerup3) do
      Powerup.create!(name: 'Star', plumber: plumber)
    end

    it 'scoped associations behave correctly' do
      expect(plumber.powerups.sort).to eq [powerup1, powerup2, powerup3].sort
      expect(plumber.fire_powerups).to eq [powerup2]
      expect(plumber.invincible_powerups).to eq [powerup3]
    end
  end

  context 'scoped has_and_belongs_to_many' do

    let!(:house1) do
      House.create!(model: 'Foo', plumber: [plumber])
    end

    let!(:house2) do
      House.create!(model: 'Prefab', plumber: [plumber])
    end

    let!(:house3) do
      House.create!(model: 'Tiny', plumber: [plumber])
    end

    it 'scoped associations behave correctly' do
      expect(plumber.houses.sort).to eq [house1, house2, house3].sort
      expect(plumber.prefab_houses).to eq [house2]
      expect(plumber.tiny_houses).to eq [house3]
    end
  end

  context 'invalid relation' do
    # TODO: name conflict

    let(:bad_scope) do
      Plumber.association_scope :bad, :foobars, -> { where(foo: :bar) }
    end

    it do
      expect { bad_scope }.to raise_error(Mongoid::Errors::InvalidAssociationScope)
    end
  end
end
