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
      @text = IO.readlines(File.join("#{File.dirname(__FILE__)}/../config/sample.txt")).join()
      @templates = []
      template_path = "#{File.dirname(__FILE__)}/../public/javascripts/templates"
        Dir.foreach(template_path) do |f| 
          if f[0] != "."
            @templates << {name:f.split('.').first,template:IO.readlines(File.join(template_path,f)).join()}
          end
         
      end

      erb :index
    end
  end
end

