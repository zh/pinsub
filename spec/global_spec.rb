require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "global functions" do
  it "truncate the string to given length" do
    str = Array.new(10,'abc').join
    str.truncate(10).should == 'abcabcabca'
  end

  it "escape some special characters" do
    str = '&"<>'
    str.html_escape.should == '&amp;&quot;&lt;&gt;'
  end

  it "strip HTML tags" do
    str = '<html>text</html><pre>&amp;&quot;&lt;&gt;</pre>'
    str.strip_tags.should == 'text&"<>'
  end

  it "escape an URL" do
    str = "http://example.com/a/b/c?d=xxx&&e=yyy"
    str.uri_escape.should == "http%3A%2F%2Fexample.com%2Fa%2Fb%2Fc%3Fd%3Dxxx%26%26e%3Dyyy"
  end

  it "unescape an URL" do
    str = "http%3A%2F%2Fexample.com%2Fa%2Fb%2Fc%3Fd%3Dxxx%26%26e%3Dyyy"
    str.uri_unescape.should == "http://example.com/a/b/c?d=xxx&&e=yyy"
  end

  it "format the Time" do
    now = Time.now
    now.to_formatted_s(:rfc822).should == now.rfc822
  end

  it "time since in human friendly form" do
    t = Time.now - 3600
    t.time_since(Time.now).should == "about 1 hour" 
  end
end
