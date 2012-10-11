require "sinatra/base"
require "json"
require "haml"
require "coffee-script"
require "coffee-filter"
require_relative "lib/nodes"

module LeoTamer
  class App < Sinatra::Base
    use Nodes
    use Rack::Session::Cookie,
      :expire_after => 60*60*24*14, # 2 weeks
      :secret => "aria-tools"
  
    before do
      if !session[:user_id] && request.path != "/login"
        redirect "/login"
      end
    end
  
    get "/" do
      haml :index
    end

    get "/login" do
      haml :login
    end
  
    post "/login" do
      session[:user_id] = params[:user_id]
      redirect "/"
    end
  
    get "/logout" do
      session.clear
      redirect "/login"
    end
  
    get "/js/*.js" do |script|
      coffee script.to_sym
    end
  
    get "*/favicon.ico" do
      404
    end
  
    get "/*" do |temp|
      haml temp.to_sym
    end
  end
end
