require File.dirname(__FILE__) + '/spec_helper'

describe "My App" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should return the correct content-type when viewing root" do
    get '/'
    last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
  end

  it "should return 404 when page cannot be found" do
    get '/404'
    last_response.status.should == 404
  end

  it "should protect the admin page" do
    get '/admin'
    last_response.status.should == 401
  end

  it "should require right username and password" do
    authorize 'bad', 'boy'
    get '/admin'
    last_response.status.should == 401
  end

  it "should login with proper credentials" do
    authorize 'admin', 'secret'
    get '/admin'
    last_response.should be_ok
  end

end
