require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      search = build(:search)
      expect(search).to be_valid
    end

    it 'is not valid without a query' do
      search = build(:search, query: nil)
      expect(search).not_to be_valid
    end

    it 'is not valid without a user_ip' do
      search = build(:search, user_ip: nil)
      expect(search).not_to be_valid
    end
  end

  describe 'normalization' do
    it 'normalizes the query by stripping spaces and downcasing' do
      search = create(:search, query: '   Test Query   ')
      expect(search.query).to eq('test query')
    end
  end

  describe 'search creation logic' do
    let(:query) { 'test query' }
    let(:user_ip) { '127.0.0.1' }
    let(:time_of_request) { Time.current }

    it 'creates a new search entry' do
      expect {
        Search.create(query: query, user_ip: user_ip, created_at: time_of_request)
      }.to change(Search, :count).by(1)
    end

    it 'creates a new entry if the query is different' do
      Search.create(query: query, user_ip: user_ip, created_at: time_of_request)
      expect {
        Search.create(query: 'another query', user_ip: user_ip, created_at: time_of_request + 3.seconds)
      }.to change(Search, :count).by(1)
    end
  end
end
