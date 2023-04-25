# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:user) { create(:user) }

  let(:account) { create(:account) }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:slug).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:avatar).of_type(:string) }
  it { is_expected.to have_db_column(:remote_id).of_type(:string) }
  it { is_expected.to have_db_column(:first_name).of_type(:string) }
  it { is_expected.to have_db_column(:last_name).of_type(:string) }
  it { is_expected.to have_db_column(:email).of_type(:string) }
  it { is_expected.to have_db_column(:phone_number).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_many(:contact_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).through(:contact_connections) }
  it { is_expected.to have_many(:objectives).through(:contacts) }
  it { is_expected.to have_many(:results).through(:objectives) }
  it { is_expected.to have_many(:activities).through(:objectives) }
  it { is_expected.to have_many(:teams).through(:contacts) }
  it { is_expected.to have_many(:team_contacts).through(:teams) }
  it { is_expected.to have_many(:team_objectives).through(:teams) }
  it { is_expected.to have_many(:team_results).through(:team_objectives) }
  it { is_expected.to have_many(:team_activities).through(:team_objectives) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(:account_id).allow_nil }

  describe '.login' do
    before { travel_to Time.zone.local(1994) }

    let!(:contact) { create(:contact, remote_id: '5c0d9d497ef61e100ae45153') }
    let(:remote_attributes) do
      {
        '_id' => 'remote_id',
        'name' => 'Bob Jones',
        'firstName' => 'Bob',
        'lastName' => 'Jones',
        'email' => 'bob.jones@example.com',
        'phoneNumber' => '021987654',
        'created' => '2023-02-26 21:55:30.864000000 +0000',
        'contacts' => [contact.remote_id]
      }
    end
    let(:local_attributes) do
      {
        'account_id' => account.id,
        'remote_id' => 'remote_id',
        'avatar' => nil,
        'title' => 'Bob Jones',
        'first_name' => 'Bob',
        'last_name' => 'Jones',
        'email' => 'bob.jones@example.com',
        'phone_number' => '021987654',
        'slug' => 'bob-jones',
        'created_at' => '2023-02-26 21:55:30.864000000 +0000'.to_time
      }
    end

    let(:client) { instance_double(Fluro::ClientService, avatar: nil) }

    it 'creates new user' do
      expect { described_class.login(client, remote_attributes) }.to change(described_class, :count).by(1)
    end

    it 'sets attributes of user' do
      login = described_class.login(client, remote_attributes)
      expect(login[:user].attributes).to include(local_attributes)
    end

    it 'connects user to contacts' do
      login = described_class.login(client, remote_attributes)
      expect(login[:user].contacts).to eq [contact]
    end

    it 'sets token' do
      login = described_class.login(client, remote_attributes)
      expect(JsonWebTokenService.decode(login[:token])).to eq(
        'user_id' => login[:user].id, 'account_id' => login[:user].account_id, 'exp' => 30.days.from_now.to_i
      )
    end

    it 'sets expires_at' do
      login = described_class.login(client, remote_attributes)
      expect(login[:expires_at]).to eq(30.days.from_now.iso8601)
    end

    context 'when avatar' do
      let(:client) { instance_double(Fluro::ClientService, avatar: 'base64encodedstring') }

      it 'sets avatar' do
        login = described_class.login(client, remote_attributes)
        expect(login[:user].attributes).to include('avatar' => 'base64encodedstring')
      end
    end

    context 'when user already exists' do
      subject!(:user) { create(:user, remote_id: 'remote_id') }

      it 'does not create new user' do
        expect { described_class.login(client, remote_attributes) }.not_to change(described_class, :count)
      end

      it 'updates existing user' do
        described_class.login(client, remote_attributes)
        expect(user.reload.attributes).to include(local_attributes)
      end
    end
  end
end
