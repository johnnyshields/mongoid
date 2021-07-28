# frozen_string_literal: true
# encoding: utf-8

require 'spec_helper'

describe 'scoped associations' do

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

    it 'should lazy load documents' do
      expect(plumber.company).to eq company1
      expect(plumber.active_company).to eq company1
      expect(plumber.inactive_company).to eq nil
    end

    it 'should eager load documents' do
      loaded = Plumber.includes(:company, :active_company, :inactive_company).first
      expect(loaded.instance_variable_get(:@_company)).to eq company1
      expect(loaded.instance_variable_get(:@_active_company)).to eq company1
      expect(loaded.instance_variable_get(:@_inactive_company)).to eq nil
    end

    it 'should not define setters for scoped associations' do
      plumber.company = company1
      plumber.company_id = company1._id
      expect { plumber.active_company = company1 }.to raise_error(NoMethodError)
      expect { plumber.active_company_id = company1._id }.to raise_error(NoMethodError)
      expect { plumber.inactive_company = company1 }.to raise_error(NoMethodError)
      expect { plumber.inactive_company_id = company1._id }.to raise_error(NoMethodError)
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

      it 'should lazy load documents' do
        expect(plumber.account).to eq account
        expect(plumber.rich_account).to eq account
        expect(plumber.unbalanced_account).to eq nil
      end

      it 'should eager load documents' do
        loaded = Plumber.includes(:account, :rich_account, :unbalanced_account).first
        expect(loaded.instance_variable_get(:@_account)).to eq account
        expect(loaded.instance_variable_get(:@_rich_account)).to eq account
        expect(loaded.instance_variable_get(:@_unbalanced_account)).to eq nil
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

      it 'should lazy load documents' do
        expect(plumber.account).to eq account3
        expect(plumber.rich_account).to eq account
        expect(plumber.unbalanced_account).to eq account2
      end

      it 'should eager load documents' do
        loaded = Plumber.includes(:account, :rich_account, :unbalanced_account).first
        expect(loaded.instance_variable_get(:@_account)).to eq account3
        expect(loaded.instance_variable_get(:@_rich_account)).to eq account
        expect(loaded.instance_variable_get(:@_unbalanced_account)).to eq account2
      end
    end

    it 'should not define setters for scoped associations' do
      plumber.account = account
      expect { plumber.account_id = account._id }.to raise_error(NoMethodError)
      expect { plumber.rich_account = account }.to raise_error(NoMethodError)
      expect { plumber.rich_account_id = account._id }.to raise_error(NoMethodError)
      expect { plumber.unbalanced_account = account }.to raise_error(NoMethodError)
      expect { plumber.unbalanced_account_id = account._id }.to raise_error(NoMethodError)
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

    it 'should lazy load documents' do
      expect(plumber.powerups.sort).to eq [powerup1, powerup2, powerup3].sort
      expect(plumber.fire_powerups).to eq [powerup2]
      expect(plumber.invincible_powerups).to eq [powerup3]
    end

    it 'should eager load documents' do
      plumber.save!
      loaded = Plumber.includes(:powerups, :fire_powerups, :invincible_powerups).first
      expect(loaded.instance_variable_get(:@_powerups).sort).to eq [powerup1, powerup2, powerup3].sort
      expect(loaded.instance_variable_get(:@_fire_powerups)).to eq [powerup2]
      expect(loaded.instance_variable_get(:@_invincible_powerups)).to eq [powerup3]
    end

    it 'should not define setters for scoped associations' do
      plumber.powerups = [powerup1]
      plumber.powerup_ids = [powerup1._id]
      expect { plumber.fire_powerups = [powerup1] }.to raise_error(NoMethodError)
      expect { plumber.fire_powerup_ids = [powerup1._id] }.to raise_error(NoMethodError)
      expect { plumber.invincible_powerups = [powerup1] }.to raise_error(NoMethodError)
      expect { plumber.invincible_powerup_ids = [powerup1._id] }.to raise_error(NoMethodError)
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

    it 'should lazy load documents' do
      expect(plumber.houses.sort).to eq [house1, house2, house3].sort
      expect(plumber.prefab_houses).to eq [house2]
      expect(plumber.tiny_houses).to eq [house3]
    end

    it 'should eager load documents' do
      plumber.save!
      loaded = Plumber.includes(:houses, :prefab_houses, :tiny_houses).first
      expect(loaded.instance_variable_get(:@_houses).sort).to eq [house1, house2, house3].sort
      expect(loaded.instance_variable_get(:@_prefab_houses)).to eq [house2]
      expect(loaded.instance_variable_get(:@_tiny_houses)).to eq [house3]
    end

    it 'should not define setters for scoped associations' do
      plumber.houses = [house1]
      plumber.house_ids = [house1._id]
      expect { plumber.prefab_houses = [house1] }.to raise_error(NoMethodError)
      expect { plumber.prefab_house_ids = [house1._id] }.to raise_error(NoMethodError)
      expect { plumber.tiny_houses = [house1] }.to raise_error(NoMethodError)
      expect { plumber.tiny_house_ids = [house1._id] }.to raise_error(NoMethodError)
    end
  end

  context 'invalid relation' do
    # TODO: name conflict
    # TODO: invalid relation types

    let(:bad_scope) do
      Plumber.association_scope :bad, :foobars, -> { where(foo: :bar) }
    end

    it do
      expect { bad_scope }.to raise_error(Mongoid::Errors::InvalidAssociationScope)
    end
  end
end
