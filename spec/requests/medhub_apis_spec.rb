require 'rails_helper'

RSpec.describe "MedhubApis", type: :request do
  describe "GET /final_evals" do
    it "returns http success" do
      get "/medhub_apis/final_evals"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /all_courses" do
    it "returns http success" do
      get "/medhub_apis/all_courses"
      expect(response).to have_http_status(:success)
    end
  end

end
