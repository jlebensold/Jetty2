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
        '/css/fontawesome/fontawesome.css',
        '/css/*.css',
        '/css/*.scss'
      ]

      js_compression  :uglify
      css_compression :sass
    }
    
    get '/' do
      @templates = []
      template_path = "#{File.dirname(__FILE__)}/../public/javascripts/templates"
      Dir.foreach(template_path) do |f| 
        next if f[0] == "."
        @templates << {name:f.split('.').first,template:IO.readlines(File.join(template_path,f)).join()}
      end
      erb :index
    end

# contents
    get '/content/:id' do
      content_type :json
      Content.find(params[:id]).to_json()
    end

    put '/content/:id' do
      content_type :json
      c = Content.find(params[:id])
      c.update_attributes(JSON.parse(request.body.read))
      c.to_json()
    end

    get '/contents' do
      content_type :json
      Content.find(:all).only(:id, :title, :version, :created_at, :updated_at).to_json()
    end


# notes
    post '/notes' do
      content_type :json
      n = Note.create(JSON.parse(request.body.read))
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

    get '/notes/:authority_id' do
      content_type :json
      Content.find(params[:authority_id]).notes.to_json()
    end

# authorities
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

    get '/authorities/as_tags' do
      content_type :json
      Authority.where({ :name =>  Regexp.new(/.*#{params[:term]}.*/i)  }).map {|a| {label:a.name,id:a._id,value:a.name} }.to_json()
    end

  end
end

