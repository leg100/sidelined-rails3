require 'spec_helper'

describe Api::Users::SessionsController do
  before :each do 
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = create(:user)
  end

  it "sign in a user" do
    post :create, user: {
      login: @user.email,
      password: @user.password
    }, format: :json
    expect(response.body).to eq ({
      success: true,
      info: 'Logged in',
      data: {
        _id: @user._id,
        email: @user.email,
        username: @user.username
      }
    }).to_json
    expect(subject.current_user).to eq @user
  end

  it "sign out a user" do
    delete :destroy, user: @user, format: :json
    expect(subject.current_user).to eq nil
  end
end
