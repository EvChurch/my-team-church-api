# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::ImportAllJob do
  subject(:import_all_job) { described_class.new }

  describe '#perform' do
    let!(:application) { create(:application) }

    before do
      allow(Application::ImportJob).to receive(:perform_async)
    end

    it 'calls Application::ImportJob.perform_async' do
      import_all_job.perform
      expect(Application::ImportJob).to have_received(:perform_async).with(application.id)
    end
  end
end
