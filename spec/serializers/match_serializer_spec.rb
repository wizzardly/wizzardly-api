# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  status     :integer          default(0)
#  updated_at :datetime         not null
#


require "rails_helper"

RSpec.describe MatchSerializer, type: :serializer do
  let(:record) { create :match }
  let(:example_serializer) { described_class.new(record) }

  it { expect(described_class <= ApplicationSerializer).to be_truthy }

  describe ".serializable_hash" do
    subject { example_serializer.serializable_hash }

    let(:expected_hash) do
      { id: record.id, finished: record.finished }
    end

    it { is_expected.to eq expected_hash }
  end
end