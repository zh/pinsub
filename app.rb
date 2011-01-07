#!/usr/bin/env ruby

$KCODE = 'u'
%w{jcode cgi open-uri logger rubygems sinatra sequel global}.each {|lib| require lib}
require 'simple-rss'

configure do
  enable :logging
  disable :sessions
  set :environment, ENV['RACK_ENV']

  Sequel.extension(:pagination)
  Sequel.extension(:blank)
  DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://pincat.db')
  unless DB.table_exists? "items"
    DB.create_table :items do
      primary_key :id
      String :title, :null=>false 
      String :content
      String :link, :null=>false, :unique => true
      String :topic, :null=>false
      String :tags
      String :author
      DateTime :created
      index :created
      index :link
    end
  end

  AUSER = ENV['AUSER'] || 'admin'
  APASS = ENV['APASS'] || 'secret'
end

helpers do
  def protected!
    response['WWW-Authenticate'] = %(Basic realm="Protected Area") and \
    throw(:halt, [401, "Not authorized\n"]) and \
    return unless authorized?
  end

  def authorized?
    user = ENV['AUSER'] || 'admin'
    pass = ENV['APASS'] || 'secret'
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [AUSER, APASS]
  end
end  

get '/' do
  page = (params[:page] || 1).to_i
  if params['clear'] && params['clear'] == APASS
    DB[:items].delete
    @items = []
    redirect('/admin') if params['admin']
  else
    @items = DB[:items].order(:created.desc).paginate(page,20)
  end  
  erb :index
end  

get '/t/:topic/?' do |topic|
  throw :halt, [404, "Missing data"] unless topic and not topic.empty?
  @topic = topic
  page = (params[:page] || 1).to_i
  if params['clear'] && params['clear'] == APASS
    DB[:items].filter(:topic=>topic).delete
    @items = []
    redirect('/admin') if params['admin']
  else
    @items = DB[:items].filter(:topic=>topic).order(:created.desc).paginate(page, 20)
  end  
  erb :topic
end

get '/admin/?' do
  protected!
  @secret = APASS
  hsh = DB[:items].group_and_count(:topic).all
  @topics_count = hsh.sort {|a,b| b[:count]<=>a[:count]}
  erb :admin
end

# PuSH subscriber
get '/sub/:topic/?' do |topic|
  content_type 'text/plain', :charset => 'utf-8'
  throw :halt, [404, "Missing data"] unless params['hub.challenge']
  return params['hub.challenge']
end

post '/sub/:topic/?' do |topic|
  throw :halt, [404, "Missing data"] unless topic
  request.body.rewind
  begin
    feed = SimpleRSS.parse(request.body.read)
  rescue Exception => ex
    puts ex.to_s
  end
  throw :halt, [500, "Invalid feed"] unless feed
  feed.entries.each do |e|
    title = e.title.empty? ? e.links.first : e.title.strip_tags.strip.truncate(250)
    content = nil
    if e.content
      content = e.content.strip_tags.truncate(400)
    else
      if e.description
        content = e.description.strip_tags.truncate(400)
      else
        content = e.summary.strip_tags.truncate(400) if e.summary
      end  
    end
    author = e.author.strip
    begin  
      DB[:items].insert(:topic=>topic,:author=>author,
                        :title=>title,:content=>content,:link=>e.link,
                        :created=>Time.now)
    rescue Exception => ex
      puts ex.to_s
      next
    end  
  end
  throw :halt, [200, "OK"]
end
