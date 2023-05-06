# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account::ImportAllJob do
  subject(:import_all_job) { described_class.new }

  describe '#perform' do
    before do
      allow(Account).to receive(:import_all)
    end

    it 'calls Account.import_all' do
      import_all_job.perform('api_key')
      expect(Account).to have_received(:import_all).with('api_key')
    end
  end
end
