# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::ImportJob do
  describe '#perform' do
    let!(:application) { create(:application) }

    before do
      allow(Application).to receive(:find_by).with(id: application.id).and_return(application)
      allow(application).to receive(:import)
    end

    it 'calls Application.find_by' do
      described_class.perform_now(application.id)
      expect(Application).to have_received(:find_by).with(id: application.id)
    end

    it 'calls Application#import' do
      described_class.perform_now(application.id)
      expect(application).to have_received(:import)
    end

    context "when application doesn't exist" do
      before do
        allow(Application).to receive(:find_by).and_return(nil)
      end

      it 'does not call Application#import' do
        described_class.perform_now(application.id)
        expect(application).not_to have_received(:import)
      end
    end
  end
end
