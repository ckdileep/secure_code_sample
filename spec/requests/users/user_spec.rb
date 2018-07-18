require "rails_helper"


describe "User specs" do
  describe "PATCH users/update_admin", :type => :request do
    it "updates all users as admin on sql injection" do
      user_params = { "name" => "\' OR \'1=1;" }.to_json

      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }
      patch "/users/update_admin", :params => user_params, :headers => request_headers
      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)

      #See db/seeds.rb. Six users are seeded in the db. Checking whether all users are given admin privilege by calling
      # update_admin method above
      expect(json_response["update_count"]).to eql(6)
    end
  end

  describe "PATCH users/update_admin_incorrect_0", :type => :request do
    it "limits the updates of users as admin to 3 on sql injection" do
      user_params = { "name" => "\' OR \'1=1;" }.to_json

      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }
      patch "/users/update_admin_incorrect_0", :params => user_params, :headers => request_headers
      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      #See db/seeds.rb. Six users are seeded in the db. update_admin_incorrect_0 method uses limit function to
      # restrict number of rows updated to 3
      expect(json_response["update_count"]).to eql(3)
    end
  end

  describe "PATCH users/update_admin_incorrect_1", :type => :request do
    it "returns status 400 if special characters found in name" do
      user_params = { "name" => "\' OR \'1=1;" }.to_json

      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }
      patch "/users/update_admin_incorrect_1", :params => user_params, :headers => request_headers
      expect(response.status).to eq 400
      json_response = JSON.parse(response.body)
      # update_admin_incorrect_1 uses regex to check if name param is a valid name. It should not update any
      # record if name param is invalid
      expect(json_response["update_count"]).to eql(0)
    end
  end

  describe "PATCH users/update_admin_incorrect_2", :type => :request do
    it "uses sanitize_sql_like method" do
      user_params = { "name" => "\' OR \'1=1;" }.to_json

      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }
      patch "/users/update_admin_incorrect_2", :params => user_params, :headers => request_headers
      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      # update_admin_incorrect_2 uses sanitize_sql_like. sanitize_sql_like sanitizes only ",", "_" and "%"
      # all records should be updated.
      expect(json_response["update_count"]).to eql(6)
    end
  end

  describe "PATCH users/update_admin_secure", :type => :request do
    it "does not update any row if sql injection is attempted" do
      user_params = { "name" => "\' OR \'1=1;" }.to_json

      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }
      patch "/users/update_admin_secure", :params => user_params, :headers => request_headers
      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      # update_admin_secure uses a placeholder syntax and activerecord sanitizes the parameter.
      # No records should be updated in this case
      expect(json_response["update_count"]).to eql(0)
    end

    it "updates rows if valid param name is provided" do
      user_params = { "name" => "Jac" }.to_json

      request_headers = {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
      }
      patch "/users/update_admin_secure", :params => user_params, :headers => request_headers

      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      # Only one record corresponding to user Jack should be updated.
      expect(json_response["update_count"]).to eql(1)
    end
  end
end
