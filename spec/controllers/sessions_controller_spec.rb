require 'spec_helper'

describe SessionsController do
  describe "GET #new" do
    it "renders new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    before do
      @user = create(:user)
    end

    it "creates a cookie with the content of auth_token filed of user" do
      post :create, session: attributes_for(:user).slice(:email, :password)
      expect(response.cookies[:auth_token]).to eql(@user.auth_token)
    end

    it "redirects the user to its profile page" do
      expect(response).to redirect_to(@user)
    end

    it "sets the current_user to @user" do
      expect(controller.current_user).to eql(@user)
    end
  end
end