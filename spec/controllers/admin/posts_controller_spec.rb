require 'spec_helper'

describe Admin::PostsController do
  include SessionsHelper
  describe "GET #index" do
    context 'admin user' do
      before do
        user = create(:admin)
        sign_in user
        current_user.posts.create(attributes_for(:post))
        get :index
      end

      it "assigns current user posts to @posts" do
        assigns(:posts).should == current_user.posts
      end

      it "renders index template" do
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET #new" do
    context 'signed in' do
      context 'is admin' do
        before do
          user = create(:admin)
          sign_in user
          get :new
        end

        it "renders new template" do
          expect(response).to render_template(:new)
        end

        it "assings a new post" do
          expect(assigns(:post)).to be_a_new(Post)
        end
      end

      context 'not admin' do
        before do
          user = create(:user)
          sign_in user
          get :new
        end

        it "should be redirected to user profile" do
          expect(response).to redirect_to(current_user)
        end

        it "renders authorization flash message" do
          expect(flash[:warning]).to eql I18n.translate('authorization.errors.post.new')
        end
      end
    end

    context 'not signed in' do
      before do
        get :new
      end

      it "redirects the user to login path" do
        expect(response).to redirect_to login_path(redirect_url: request.original_url)
      end

      it "renders not signed in flash message" do
        expect(flash[:warning]).to eql I18n.translate('authorization.errors.signin')
      end
    end
  end

  describe "POST #create" do
    context 'with valid data' do
      before do
        sign_in create(:admin)
        post :create, post: attributes_for(:post, tags: build(:post).tags.join(','))
      end

      it "increase current user posts by 1" do
        expect{
          post :create, post: attributes_for(:post)
        }.to change {
          current_user.posts.count
        }.by 1
      end

      it "redirects user to its dashboard" do
        expect(response).to redirect_to admin_user_path(current_user)
      end

      it "renders successful created flash" do
        expect(flash[:success]).to eql I18n.translate('post.create.success')
      end

      it "saves tags value as array in the database" do
        expect(Post.last.tags).to eql build(:post).tags 
      end
    end

    context 'with invalid data' do
      before do
        sign_in create(:admin)
      end

      context 'without title' do
        before do
          post :create, post: attributes_for(:post, title: nil)
        end

        it "renders new template without title" do
          expect(response).to render_template(:new)
        end

        it "renders post not valid flash message" do
          expect(flash[:danger]).to eql I18n.translate('post.create.failure')
        end
      end

      context 'without digest' do
        before do
          post :create, post: attributes_for(:post, digest: nil)
        end

        it "renders new template without digest" do
          expect(response).to render_template(:new)
        end

        it "renders post not valid flash message" do
          expect(flash[:danger]).to eql I18n.translate('post.create.failure')
        end
      end
    end
  end

  describe "GET #edit" do
    context 'admin user' do
      before do
        sign_in create(:admin)
        @post = create(:post)
        get :edit, id: @post.id
      end

      it "renders edit template" do
        expect(response).to render_template(:edit)
      end

      it "assigns @post variable with id param" do
        expect(assigns(:post)).to eql @post
      end
    end

    context 'normal user' do
      before do
        sign_in create(:user)
        @post = create(:post)
        get :edit, id: @post.id
      end

      it "redirects to it's profile page" do
        expect(response).to redirect_to current_user
      end

      it "renders authorization post edit flash message" do
        expect(flash[:warning]).to eql I18n.translate('authorization.errors.post.edit')
      end
    end

    context 'guest user' do
      before do
        @post = create(:post)
        get :edit, id: @post.id
      end

      it "redirects to root path" do
        expect(response).to redirect_to login_path(redirect_url: request.original_url)
      end

      it "renders signin authorization flash message" do
        expect(flash[:warning]).to eql I18n.translate('authorization.errors.signin')
      end
    end
  end

  describe "PUT #update" do
    before do
      sign_in create(:user)
      @post = create(:post)
      put :update, id: @post.id, post: attributes_for(:post, title: 'test2', tags: build(:post).tags.join(','))
    end

    it "assigns post variable from params" do
      expect(assigns(:post)).to eql @post
    end

    it "updates the post in the database" do
      expect(Post.first.title).not_to eql @post.title
    end

    it "redirects to admin dashboard" do
      expect(response).to redirect_to admin_user_path(current_user)
    end

    it "renders post edit success flash message" do
      expect(flash[:success]).to eql I18n.translate('post.edit.success')
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in create(:admin)
      @post = create(:post)
      delete :destroy, id: @post.id
    end

    it "removes a post from database" do
      @post = create(:post)
      expect { delete :destroy, id: @post.id }.to change(Post, :count).by -1
    end

    it "redirects to admin dashboard" do
      expect(response).to redirect_to admin_user_path(current_user)
    end

    it "renders post delete success message" do
      expect(flash[:success]).to eql I18n.translate('post.delete.success')
    end
  end
end
