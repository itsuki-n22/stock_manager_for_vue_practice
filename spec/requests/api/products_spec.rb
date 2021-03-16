require 'rails_helper'

RSpec.describe "Api::Products", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/products/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/products/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/products/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/products/update"
      expect(response).to have_http_status(:success)
    end
  end

end
