require 'rails_helper'

# describe ApplicationController do
#   let!(:user) { create(:user) }

#   controller do
#     def test_404
#       raise ActiveRecord::RecordNotFound
#     end

#     def test_no_permission
#     end
#   end

#   before do
#     @routes.draw do
#       get '/anonymous/test_404'
#       get '/anonymous/test_no_permission'
#     end
#   end

#   describe 'when accessing a nonexistant record' do
#     it 'shows the 404 page' do
#       get :test_404
#       expect(response).to render_template('errors/404.html.erb')
#     end
#   end

#   describe 'when the user does not have permission' do
#     it 'flashes a warning' do
#       get :test_no_permission
#       expect(flash[:warning]).to be_present
#     end
#     it 'redirects to back if it can'
#     it 'redirects to home if it cannot'
#   end
# end

describe ApplicationController do
  let!(:user) { create(:user) }
  let!(:rentaluser2) { create(:user) }

  before(:each) { current_user }

  context 'in production' do
    before :each do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
    end

    context 'checking permissions & 404 behavior' do
      controller do
        def test_404
          raise ActiveRecord::RecordNotFound
        end

        def test_no_permission
        end
      end

      before do
        @routes.draw do
          get '/anonymous/test_404'
          get '/anonymous/test_no_permission'
        end
      end

      describe 'when accessing a nonexistant record' do
        it 'shows the 404 page' do
          group = create(:group)
          permission = create(:permission, controller: 'anonymous', action: 'test_404')

          group.permissions << permission
          current_user.groups << group

          get :test_404
          expect(response).to render_template('errors/404.html.erb')
        end
      end

      describe 'when the user does not have permission' do
        it 'flashes a warning' do
          get :test_no_permission
          expect(flash[:warning]).to be_present
        end

        it 'redirects to back if it can' do
          request.env['HTTP_REFERER'] = 'old_page'
          get :test_no_permission
          expect(response).to redirect_to('old_page')
        end

        it 'redirects to home if it cannot' do
          get :test_no_permission
          expect(response).to redirect_to(home_index_path)
        end
      end
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
          create(:user)
          create(:user)
          user = create(:user)
          request.env['fcIdNumber'] = user.spire_id.to_s
          subject.current_user
          expect(assigns[:current_user]).to eq(user)
        end

        it 'gets a user from their stored session' do
          create(:user)
          create(:user)
          user = create(:user)
          request.env['fcIdNumber'] = ''
          session[:user_id] = user.id.to_s
          subject.current_user
          expect(assigns[:current_user]).to eq(user)
        end
      end

      it 'raises an error if no user with shibboleth id exists' do
        user = create(:user)
        request.env['fcIdNumber'] = (user.spire_id + 1).to_s
        expect { subject.current_user }.to raise_error MissingUserError
      end

      it 'raises an error if no user with user id exists' do
        user = create(:user)
        request.env['fcIdNumber'] = ''
        session[:user_id] = (user.id + 1).to_s
        expect { subject.current_user }.to raise_error MissingUserError
      end
    end
  end

  describe 'when an error occurs' do
    before :each do
      allow_any_instance_of(ApplicationController).to receive(:root).and_raise('test root error')
      # allow_any_instance_of(ApplicationController).to receive(:send_error_email).and_return('send_error_email called')
      # allow_any_instance_of(ActionMailer).to receive(:build_email).and_return(true)
    end

    it 'calls the render_500 method' do
      get :root
      expect(response).to render_template('errors/500.html.erb')
    end

    it 'sends an error email' do
      expect(subject).to receive(:send_error_email)
      get :root
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
    it 'assigns the first user to @current_user in development' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
      subject.current_user
      expect(assigns[:current_user]).to eq(User.first)
    end
  end

  describe '#has_permission?' do
    it 'returns true in test' do
      expect(subject.has_permission?).to be true
    end
  end

  describe '#render_404' do
    it 'renders the 404 page' do
      get(:render_404)
      expect(response).to render_template('errors/404.html.erb')
    end
  end
end
