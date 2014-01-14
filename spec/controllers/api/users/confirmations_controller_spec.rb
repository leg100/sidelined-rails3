require 'spec_helper'

#describe Api::Users::ConfirmationsController do
#  before :each do 
#    @request.env["devise.mapping"] = Devise.mappings[:user]
#    @user = create(:user, confirmed_at: nil)
#  end
#
#  it "confirms a user with a correct token" do
#    expect(@user.confirmed?).to eq false
#    get :show, confirmation_token: @user.confirmation_token
#
#    expect(@user.confirmed?).to eq true
#    expect(response).to redirect_to '/confirmed?status=success'
#  end
#end
