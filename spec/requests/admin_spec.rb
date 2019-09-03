require 'rails_helper'

describe "Admin API", :type => :request do
  before(:each) do
    Admin.delete_all
  end

  after(:each) do
    Admin.delete_all
  end
  
  # TEST ADMIN SIGN UP
  it "creates a an admin if admin provides valid parameters" do

    entry = get_entries("valid_new_user")
    post "/api/v1/admins", params: get_entries("valid_new_user")

    token = json["accessToken"].split(' ').last if json["accessToken"]
    key = ENV['JWT_SECRET'] || 'secret'
    decoded = JWT.decode(token, key) if token

    expect(response).to be_successful
    expect(status).to eq(201)
    expect(json["accessToken"]).to be_truthy
    expect(request.headers["ADMIN-KEY"]).to be_truthy
    expect(json["accessToken"]).to eq(request.headers["ADMIN-KEY"])
  end

  it "doesn't create an admin user if name, email or password are not provided" do

    post "/api/v1/admins", params: {}

    expect(response).not_to be_successful
    expect(status).to eq(422)
  end

  it "doesn't create an admin if admin name is not provided" do

    post "/api/v1/admins", params: get_entries("missing_name")

    expect(response).not_to be_successful
    expect(status).to eq(422)
  end

  it "doesn't create an admin if admin email is not provided" do

    post "/api/v1/admins", params: get_entries("missing_email")

    expect(response).not_to be_successful
    expect(status).to eq(422)
  end

  it "doesn't create an admin if admin password is not provided" do

    post "/api/v1/admins", params: get_entries("missing_password")

    expect(response).not_to be_successful
    expect(status).to eq(422)
  end

  it "doesn't create an admin if admin email already exists on the system" do

    new_admin = Admin.create(get_entries("valid_new_user"))
    post "/api/v1/admins", params: get_entries("valid_new_user")

    expect(new_admin).to be_truthy
    expect(response).not_to be_successful
    expect(status).to eq(422)
  end

  it "doesn't create an admin if admin email is not valid" do

    post "/api/v1/admins", params: get_entries("invalid_email_new_user")
  

    expect(response).not_to be_successful
    expect(status).to eq(422)
  end

  it "doesn't create an admin if admin password is not valid" do

    post "/api/v1/admins", params: get_entries("invalid_password")

    expect(response).not_to be_successful
    expect(status).to eq(422)
  end

  # TEST ADMIN SIGN IN
  it "login admin if admin provides valid credentials" do
    entry = get_entries("valid_new_user")
    new_admin = Admin.create(get_entries("valid_new_user"))
    post "/api/v1/admins/login", params: get_entries("sign_in_user")
    
    token = json["accessToken"].split(' ').last if json["accessToken"]
    key = ENV['JWT_SECRET'] || 'secret'
    decoded = JWT.decode(token, key) if token
   
    expect(new_admin).to be_truthy
    expect(response).to be_successful
    expect(status).to eq(201)
    expect(json["accessToken"]).to be_truthy
    expect(request.headers["ADMIN-KEY"]).to be_truthy
    expect(json["accessToken"]).to eq(request.headers["ADMIN-KEY"])
    expect(json["expires_in"]).to eq("24h")
  end

  it "doesn't login admin if admin email and password is not provided" do
    
    new_admin = Admin.create(get_entries("valid_new_user"))
    post "/api/v1/admins/login", params: {}
    error = json["error"]

    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
  end

  it "doesn't login admin if admin email is not provided" do
    
    new_admin = Admin.create(get_entries("valid_new_user"))
    post "//api/v1/admins/login", params: get_entries("no_email_sign_in")
    error = json["error"]

    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
  end

  it "doesn't login a admin if admin password is not provided" do
    
    new_admin = Admin.create(get_entries("valid_new_user"))
    post "/api/v1/admins/login", params: get_entries("no_password_sign_in")
    error = json["error"]

    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
  end

  it "doesn't login a admin if admin email is doesn't exist in the system" do
    
    new_admin = Admin.create(get_entries("valid_new_user"))
    post "/api/v1/admins/login", params: get_entries("wrong_email")

    expect(response).not_to be_successful
    expect(status).to eq(401)
  end

  it "doesn't login an admin if admin password is invalid" do
    
    new_admin = Admin.create(get_entries("valid_new_user"))
    post "/api/v1/admins/login", params: get_entries("wrong_password")
    error = json["error"]

    expect(response).not_to be_successful
    expect(status).to eq(401)
    expect(error).to be_truthy
  end


end