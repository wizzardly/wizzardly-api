# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationPolicy, type: :policy do
  subject(:policy) { described_class.new(user, record) }

  let(:user) { instance_double(User) }
  let(:record_id) { rand(0..100) }
  let(:record) { instance_double(User, id: record_id, class: Faker::Lorem.word) }
  let(:scope) { instance_double(ActiveRecord::Relation) }

  before { allow(Pundit).to receive(:policy_scope!).with(user, record.class).and_return(scope) }

  describe ".new" do
    it "initializes with a user and the record" do
      expect(policy.user).to eq user
      expect(policy.record).to eq record
    end
  end

  it { is_expected.to forbid_action(:index) }
  it { is_expected.to forbid_action(:create) }
  it { is_expected.to forbid_action(:update) }
  it { is_expected.to forbid_action(:destroy) }

  context "when the record is within the scope" do
    before { allow(scope).to receive(:exists?).with(id: record_id).and_return(true) }
    it { is_expected.to permit_action(:show) }
  end

  context "when the record is not in scope" do
    before { allow(scope).to receive(:exists?).with(id: record_id).and_return(false) }
    it { is_expected.to forbid_action(:show) }
  end

  context "when create? is true" do
    subject { example_class.new(user, record) }

    let(:example_class) do
      Class.new(ApplicationPolicy) do
        def create?
          true
        end
      end
    end

    it { is_expected.to permit_action(:new) }
  end

  context "when create? is false" do
    subject { example_class.new(user, record) }

    let(:example_class) do
      Class.new(ApplicationPolicy) do
        def create?
          false
        end
      end
    end

    it { is_expected.to forbid_action(:new) }
  end

  context "when update? is true" do
    subject { example_class.new(user, record) }

    let(:example_class) do
      Class.new(ApplicationPolicy) do
        def update?
          true
        end
      end
    end

    it { is_expected.to permit_action(:edit) }
  end

  context "when update? is false" do
    subject { example_class.new(user, record) }

    let(:example_class) do
      Class.new(ApplicationPolicy) do
        def update?
          false
        end
      end
    end

    it { is_expected.to forbid_action(:edit) }
  end

  describe "#scope" do
    it "returns the scope" do
      expect(policy.scope).to eq scope
    end
  end
end
