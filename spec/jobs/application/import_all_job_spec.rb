# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::ImportAllJob do
  describe '#perform' do
    let!(:application) { create(:application) }

    before do
      allow(Application::ImportJob).to receive(:perform_later)
    end

    it 'calls Application::ImportJob.perform_later' do
      described_class.perform_now
      expect(Application::ImportJob).to have_received(:perform_later).with(application.id)
    end
  end
end
