require 'spec_helper'

describe Api::Users::RegistrationsController do
  before :each do 
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "signs up a user" do
    post :create, user: attributes_for(:user), format: :json

    expect(response.body).to eq ({
      info: 'Signed up',
      data: {
        _id: assigns(:user)._id,
        email: assigns(:user).email,
        username: assigns(:user).username
      }
    }).to_json
  end

  it "sends an email" do
    post :create, user: attributes_for(:user), format: :json
    expect(ActionMailer::Base.deliveries.last.to)
      .to eq [assigns(:user).email]
  end
end
