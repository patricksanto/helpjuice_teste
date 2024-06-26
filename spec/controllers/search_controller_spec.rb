require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:article1) { create(:article, title: 'First Article', content: 'Content of first article') }
  let!(:article2) { create(:article, title: 'Second Article', content: 'Content of second article') }
  let!(:article3) { create(:article, title: 'Third Article', content: 'Content of third article') }
  let!(:article4) { create(:article, title: 'Fourth Article', content: 'Content of fourth article with special keywords') }

  describe "GET #index" do
    context "when searching with a query" do
      it "returns the correct search results for a single keyword" do
        get :index, params: { q: { title_or_content_i_cont_any: 'First' } }
        expect(assigns(:articles)).to include(article1)
        expect(assigns(:articles)).not_to include(article2, article3, article4)
      end

      it "returns no results for a query that matches nothing" do
        get :index, params: { q: { title_or_content_i_cont_any: 'Nonexistent' } }
        expect(assigns(:articles)).to be_empty
      end

      it "returns correct results for a query with special characters" do
        get :index, params: { q: { title_or_content_i_cont_any: 'special keywords' } }
        expect(assigns(:articles)).to include(article4)
        expect(assigns(:articles)).not_to include(article1, article2, article3)
      end

      it "returns correct results for case-insensitive search" do
        get :index, params: { q: { title_or_content_i_cont_any: 'first' } }
        expect(assigns(:articles)).to include(article1)
        expect(assigns(:articles)).not_to include(article2, article3, article4)
      end

      it "returns correct results for partial matches" do
        get :index, params: { q: { title_or_content_i_cont_any: 'Article' } }
        expect(assigns(:articles)).to include(article1, article2, article3, article4)
      end
    end

    context "when no search query is provided" do
      it "returns all articles" do
        get :index
        expect(assigns(:articles)).to include(article1, article2, article3, article4)
      end
    end
  end

  describe "GET #perform_search" do
    before do
      ActiveJob::Base.queue_adapter = :test
    end

    context "when searching with a query" do
      it "enqueues the SaveSearchJob" do
        query = "test query"
        expect {
          get :perform_search, params: { query: query }, format: :turbo_stream
        }.to have_enqueued_job(SaveSearchJob)
      end

      it "normalizes the search query" do
        query = "   Test Query   "
        get :perform_search, params: { query: query }, format: :turbo_stream
        perform_enqueued_jobs { SaveSearchJob.perform_later(query, request.remote_ip, Time.current) }
        expect(Search.last.query).to eq("test query")
      end

      it "does not create a new entry for the same query within 4 seconds" do
        query = "test query"
        get :perform_search, params: { query: query }, format: :turbo_stream
        perform_enqueued_jobs

        expect {
          get :perform_search, params: { query: query }, format: :turbo_stream
          perform_enqueued_jobs
        }.not_to change(Search, :count)
      end
    end
  end
end
