require_relative 'spec_helper'

describe "user account management" do
  let(:username) { 'bct' }
  let(:password) { 'arkady' }

  describe 'account creation' do
    it 'should create a User in the database' do
      expect do
        post '/accounts', :username => username, :password => password, :'password-again' => password
      end.to change { User.count }.by(1)

      User.first(:username => username).should_not be_nil
    end

    it 'should verify password confirmation' do
      expect do
        post '/accounts', :username => username, :password => password, :'password-again' => 'different'
      end.to_not change { User.count }

      User.first(:username => username).should be_nil
    end
  end
end
