require 'sinatra/base'
require 'sinatra/assetpack'
require 'json'
module Bootstrap
  class Application < Sinatra::Base
    set :static, true
    set :sessions, true
    set :root, File.dirname(__FILE__)
    register Sinatra::AssetPack

    assets {
      serve '/js', from: 'js'
      serve '/css', from: 'css'

      js :application, '/js/application.js', [
        '/js/vendor/*.js',
        '/js/app/app*.js',
        '/js/app/models/*.js',
        '/js/app/collections/*.js',
        '/js/app/views/*.js',
        '/js/**/*.js'
      ]

      css :application, '/css/main.css', [
        '/css/bootstrap/css/bootstrap.css',
        '/css/bootstrap/css/bootstrap-responsive.css',
        '/css/*.css',
        '/css/*.scss'
      ]

      js_compression  :uglify
      css_compression :sass
    }

    get '/' do
      @content = Content.find(:first)
      @text = @content.text
      @templates = []
      template_path = "#{File.dirname(__FILE__)}/../public/javascripts/templates"
        Dir.foreach(template_path) do |f| 
          if f[0] != "."
            @templates << {name:f.split('.').first,template:IO.readlines(File.join(template_path,f)).join()}
          end
      end

      erb :index
    end

    post '/notes' do
      content_type :json
      n = Note.new(JSON.parse(request.body.read))
      n.save()
      n.to_json()
    end

    put '/note/:id' do
      content_type :json
      n = Note.find(params[:id])
      n.update_attributes(JSON.parse(request.body.read))
      n.to_json()
    end

    delete '/note/:id' do
      content_type :json
      Note.find(params[:id]).destroy().to_json()
    end

    get '/notes' do
      content_type :json
      Note.find(:all).to_json()
    end

#authorities
    post '/authorities' do
      content_type :json
      a = Authority.new(JSON.parse(request.body.read))
      a.save()
      a.to_json()
    end

    post '/authority/bulksave' do
      models = JSON.parse(request.body.read)
      models.each do |m|
        Authority.find(m["_id"]).update_attributes(m)
      end
      models.to_json()
    end

    put '/authority/:id' do
      content_type :json
      a = Authority.find(params[:id])
      a.update_attributes(JSON.parse(request.body.read))
      a.to_json()
    end

    delete '/authority/:id' do
      content_type :json
      Authority.find(params[:id]).destroy().to_json()
    end

    get '/authorities' do
      content_type :json
      Authority.find(:all).to_json()
    end


  end
end

