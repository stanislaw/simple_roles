require 'dummy_spec_helper'

describe "Requests" do
  it "truth" do
    Rails.application.should be_kind_of(Dummy::Application)
  end

  describe "Basic pages" do
    before do
      login_as(User.first) 
    end

    it "should get root" do
      get '/carrier'
      response.status.should be(200)
    end

    it "should get /messages" do
      get '/carrier/messages'
      response.status.should be(200)
    end

    it "should get /sent" do
      get '/carrier/messages/sent'
      response.status.should be(200)
    end

    it "should get /archive" do
      get '/carrier/messages/archive'
      response.status.should be(200)
    end

  end
end
