require 'rack/coffee_compiler'
require 'erb'

# based on https://github.com/jbaudanza/rack-asset-compiler/blob/master/examples/jasmine_config.rb
module Jasmine
  class Config
    alias_method :old_js_files, :js_files

    def js_files(spec_filter = nil)
      # Convert all .coffee files into .js files before putting them in a script tag
      old_js_files(spec_filter).map do |filename|
        filename.sub('.coffee', '.js')
      end
    end

    def start_server(port = 8888)
      config = self
      app = Rack::Builder.new do
        use Rack::CoffeeCompiler, :source_dir => File.join(File.dirname(__FILE__), '../../../spec/javascripts'), :url => config.spec_path
        use Rack::CoffeeCompiler, :source_dir => File.join(File.dirname(__FILE__), '../../../app/js/app'), :url => '/app/js/app'

        map '/' do
          run Jasmine.app(config)
        end
      end

      Rack::Server.start(:app => app, :Port => port)
    end
  end
end

# Note - this is necessary for rspec2, which has removed the backtrace
module Jasmine
  class SpecBuilder
    def declare_spec(parent, spec)
      me = self
      example_name = spec["name"]
      @spec_ids << spec["id"]
      backtrace = @example_locations[parent.description + " " + example_name]
      parent.it example_name, {} do
        me.report_spec(spec["id"])
      end
    end
  end
end