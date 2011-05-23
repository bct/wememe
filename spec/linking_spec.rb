require_relative 'spec_helper'

describe "linkings" do
  def sign_in
    app.class_eval do
      helpers do
        def current_user
          @current_user ||= User.create(:username => 'test-user', :password => '')
        end
      end
    end
  end

  before do
    sign_in
  end

  describe 'new linking creation' do
    let(:url)     { 'http://example.org/' }
    let(:summary) { 'An example posting' }

    it 'should create a Linking in the database' do
      expect do
        post '/linkings', :url => url, :summary => summary
      end.to change { Linking.count }.by(1)

      last_response.should be_redirect
      last_response['Location'].should == "http://example.org/users/test-user"
    end
  end
end
