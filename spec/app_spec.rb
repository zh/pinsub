require File.expand_path(File.dirname(__FILE__) + '/spec_helper')



describe "My App" do

  describe "GET on /" do
    it "respond to /" do
      get '/'
      last_response.should be_ok, last_response.body
    end
  
    it "return the correct content-type when viewing root" do
      get '/'
      last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
    end

    it "return 404 when page cannot be found" do
      get '/404'
      last_response.status.should == 404
    end
  end

  describe "GET on /admin" do
    it "protect the admin page" do
      get '/admin'
      last_response.status.should == 401
    end

    it "require right username and password" do
      authorize 'bad', 'boy'
      get '/admin'
      last_response.status.should == 401
    end

    it "login with proper credentials" do
      authorize 'admin', 'secret'
      get '/admin'
      last_response.should be_ok, last_response.body
    end
  end

end
