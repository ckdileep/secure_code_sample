require "rails_helper"
describe "Page content API" do
  describe "POST /api/pages/index_page_content" do
    it "indexes page content and saves" do
      # page 1 - https://s3-us-west-2.amazonaws.com/tmp9779/page1.html
      # page 2 - https://s3-us-west-2.amazonaws.com/tmp9779/page2.html
      page_params = { "url" => "https://s3-us-west-2.amazonaws.com/tmp9779/page1.html" }.to_json

      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/api/pages/index_page_content", page_params, request_headers
      expect(response.status).to eq 201
    end
    it "returns status code 400 when invalid url is provided" do
      page_params = { "url" => "https://dd" }.to_json

      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/api/pages/index_page_content", page_params, request_headers
      expect(response.status).to eq 400
    end
  end

  describe "GET /api/pages" do
    it "returns all saved pages as json" do
      get "/api/pages", {}, { "Accept" => "application/json" }
      
      pages = JSON.parse(response.body)
      h1_data = JSON.parse pages[0]["h1_data"]
      links = JSON.parse pages[0]["links"]
      
      expect(response.status).to eq 200
      expect(pages[0]["url"]).to eq "https://s3-us-west-2.amazonaws.com/tmp9779/page1.html"
      expect(h1_data[0]).to eq "Page1 H1 tag first"
      expect(links[0]["href"]).to eq "https://www.google.com"
      expect(links[0]["link_text"]).to eq "Page1 link 1 google"
    end
  end
end
