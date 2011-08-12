require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "My App" do

  before(:each) do
    DB[:items].delete
    DB[:items].insert(topic:'test', author:'test', title:'example', content:'please ignore',
                      link:'http://example.com/',created:Time.now)
  end

  describe "items" do
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

    it "delete all items" do
      get '/', 'clear' => APASS
      DB[:items].all.to_a.should == []
    end
  end

  describe "administration" do
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

  describe "topics" do
    it "respond to /t/:topic" do
      get '/t/test'
      last_response.should be_ok, last_response.body
      doc = Nokogiri::HTML(last_response.body)
      title = doc.xpath('//title').text
      title.should == "Topic: test"
    end

    it "delete all topic items" do
      DB[:items].insert(topic:'test2', author:'test', title:'example', content:'please ignore',
                      link:'http://example2.com/',created:Time.now)
      DB[:items].all.size.should == 2
      get '/t/test', 'clear' => APASS
      DB[:items].all.size.should == 1
      DB[:items].all[0][:topic].should == "test2"
    end
  end

  describe "subscriber" do
    it "return challenge token on GET" do
      get '/sub/test', 'hub.challenge' => 'abc'
      last_response.should be_ok, last_response.body
      last_response.body.should == 'abc'
    end
  end

end
