require 'rails_helper'

RSpec.describe SaveSearchJob, type: :job do
  let(:query) { "test query" }
  let(:user_ip) { "127.0.0.1" }
  let(:time_of_request) { Time.current }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  it "creates a new search entry" do
    expect {
      SaveSearchJob.perform_now(query, user_ip, time_of_request)
    }.to change(Search, :count).by(1)
  end

  it "normalizes the search query" do
    SaveSearchJob.perform_now("   Test Query   ", user_ip, time_of_request)
    expect(Search.last.query).to eq("test query")
  end

  it "does not create a new entry for the same query within 10 seconds" do
    SaveSearchJob.perform_now(query, user_ip, time_of_request)
    expect {
      SaveSearchJob.perform_now(query, user_ip, time_of_request + 3.seconds, Search.last.id)
    }.not_to change(Search, :count)
  end

  it "creates a new entry if the query is different" do
    SaveSearchJob.perform_now(query, user_ip, time_of_request)
    expect {
      SaveSearchJob.perform_now("another query", user_ip, time_of_request + 3.seconds)
    }.to change(Search, :count).by(1)
  end

  it "creates a new entry if the time difference is greater than 4 seconds" do
    SaveSearchJob.perform_now(query, user_ip, time_of_request)
    expect {
      SaveSearchJob.perform_now(query, user_ip, time_of_request + 5.seconds)
    }.to change(Search, :count).by(1)
  end
  it "creates a new entry if two different people search for the same thing at the same time" do
    SaveSearchJob.perform_now(query, "127.0.0.1", time_of_request)
    expect {
      SaveSearchJob.perform_now(query, "192.168.0.1", time_of_request)
    }.to change(Search, :count).by(1)
  end
end
