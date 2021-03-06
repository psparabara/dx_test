require 'spec_helper'

describe SessionsController do
  include SessionsHelper

  describe "GET #new" do
    context 'not signed in' do
      before do
        get :new
      end

      it "renders new template" do
        expect(response).to render_template(:new)
      end
    end

    context 'signed in' do
      context 'admin user' do
        before do
          @user = create(:admin)
          sign_in @user
          get :new
        end

        it "redirects user to his profile page" do
          expect(response).to redirect_to(admin_user_path(@user))
        end

        it "renders already signed in flash message" do
          expect(flash[:warning]).to eql I18n.translate('user.login.already_loged_in')
        end
      end

      context 'normal user' do
        before do
          @user = create(:user)
          sign_in @user
          get :new
        end

        it "redirects user to his profile page" do
          expect(response).to redirect_to(user_path(@user))
        end

        it "renders already signed in flash message" do
          expect(flash[:warning]).to eql I18n.translate('user.login.already_loged_in')
        end
      end
    end
  end

  describe "POST #create" do
    before do
      @user = create(:user)
      post :create, session: attributes_for(:user).slice(:email, :password)
    end

    it "redirects the user to its profile page" do
      expect(response).to redirect_to(@user)
    end

    it "sets the current_user to @user" do
      expect(controller.current_user).to eql(@user)
    end

    it "sets auth_token cookie" do
      expect(response.cookies['auth_token']).to eql @user.auth_token
    end

    context 'admin user' do
      it "redirect the user to it's admin dashboard" do
        @user = create(:admin)
        post :create, session: attributes_for(:admin).slice(:email, :password)
        expect(response).to redirect_to [:admin, @user]
      end
    end
  end

  describe "POST #destroy" do
    before do
      @user = create(:user)
      post :create, session: attributes_for(:user).slice(:email, :password)
      get :destroy
    end

    it "removes the auth_token cookie" do
      expect(response.cookies['auth_token']).to eql nil
    end

    it "redirects user to root path" do
      expect(response).to redirect_to root_path
    end
  end
end