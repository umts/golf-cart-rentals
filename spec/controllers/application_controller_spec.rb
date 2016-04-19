require 'rails_helper'

describe ApplicationController do
  before(:each) { current_user }

  describe "in production" do
    before :each do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
    end

    describe 'when an error occurs' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:root).and_raise("test root error")
      end

      it 'renders the 500 page' do
        get :root
        expect(response).to render_template('errors/500.html.erb')
      end

      it 'sends an error email'
    end

    describe '#has_permission?' do
      it 'returns true when accessing the home page' do
        subject.params = {
          controller: 'home',
          action: 'index'
        }
        expect(subject.has_permission?).to be true
      end

      it 'returns true when accessing the root page' do
        subject.params = {
          controller: 'application',
          action: 'root'
        }
        expect(subject.has_permission?).to be true
      end

      it 'returns true when accessing the 404 page' do
        subject.params = {
          controller: 'application',
          action: 'render_404'
        }
        expect(subject.has_permission?).to be true
      end

      it 'returns true if the current user has access to the page' do
        group = create(:group, name: 'test', description: 'testing')
        permission = create(:permission, controller: 'user', action: 'index')

        group.permissions << permission
        current_user.groups << group

        subject.params = {
          controller: 'user',
          action: 'index'
        }
        expect(subject.has_permission?).to be true
      end

      it 'returns false if the current user doesnt have access to the page' do
        subject.params = {
          controller: 'user',
          action: 'index'
        }
        expect(subject.has_permission?).to be false
      end
    end

    describe '#current_user' do
      context 'when the user exists' do
        it 'gets a user from their shibboleth login id' do
          user = create(:user)
          request.env['fcIdNumber'] = user.spire_id.to_s
          subject.current_user
          expect(assigns[:current_user]).to eq(user)
        end

        it 'gets a user from their stored session' do
          user = create(:user)
          request.env['fcIdNumber'] = ""
          session[:user_id] = user.id.to_s
          subject.current_user
          expect(assigns[:current_user]).to eq(user)
        end
      end

      it 'raises an error if no user with shibboleth id exists' do
        user = create(:user)
        request.env['fcIdNumber'] = (user.spire_id + 1).to_s
        expect{subject.current_user}.to raise_error MissingUserError
      end
      
      it 'raises an error if no user with user id exists' do
        user = create(:user)
        request.env['fcIdNumber'] = ""
        session[:user_id] = (user.id + 1).to_s
        expect{subject.current_user}.to raise_error MissingUserError
      end
    end
  end

  describe '#root' do
    it 'redirects to the home index action' do
      get :root
      expect(response).to redirect_to home_index_path
    end
  end

  describe '.get_actions' do
    it 'returns the actions available to a controller' do
      expect(ApplicationController.get_actions(HomeController)).to eq ['index']
    end
  end

  describe '#current_user' do
    it 'assigns the first user in test to @current_user' do
      subject.current_user
      expect(assigns[:current_user]).to eq(User.first)
    end
  end

  describe '#has_permission?' do
    it 'returns true in test' do
      expect(subject.has_permission?).to be true
    end
  end
end