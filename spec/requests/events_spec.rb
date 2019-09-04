require 'rails_helper'

describe "Event API", :type => :request do
  before(:each) do
    Event.delete_all
  end

  after(:each) do
    Event.delete_all
  end

  it "an admin is able to create a new event" do
    new_admin = Admin.create(get_entries("valid_new_user"))
    payload = { admin_id: new_admin.id, exp: 24.hours.from_now.to_i }
    key = ENV['JWT_SECRET'] || 'secret'
    jwt_encoded = JWT.encode(payload, key)

    event = get_entries("valid_event")
    post "/api/v1/events", params: event, headers: { "ADMIN-KEY": "Bearer " + jwt_encoded }
    event = Event.all.first

    expect(response).to be_successful
    expect(status).to eq(201)
    expect(json["id"]).to eq(event.id)
    expect(json["name"]).to eq(event.name)
  end

  it "non admins should not be able to create an event" do

    event = get_entries("valid_event")
    post "/api/v1/events", params: event

    error = json["error"]

    expect(response).not_to be_successful
    expect(status).to eq(401)
    expect(error).to be_truthy
  end


end