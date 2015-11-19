require 'sprockets'

module Sampleapp
  module Extensions
    module Assets
      module_function

      class UnknownAsset < StandardError; end

      module Helpers
        def asset_path(name)
          asset = settings.assets[name]
          fail UnknownAsset, "Unknown asset: #{name}" unless asset
          "#{settings.asset_host}/assets/#{asset.digest_path}"
        end
      end

      def registered(app)
        app.set :assets, assets = Sprockets::Environment.new(app.settings.root)

        assets.append_path('app/assets/javascripts')
        assets.append_path('app/assets/stylesheets')
        assets.append_path('app/assets/images')
        assets.append_path('vendor/assets/javascripts')
        assets.append_path('vendor/assets/stylesheets')

        app.set :asset_host, ''

        configure_assets(app, assets)

        app.helpers Helpers
      end

      private

      def configure_assets(app, assets)
        app.configure :development do
          assets.cache = Sprockets::Cache::FileStore.new('./tmp')
        end

        app.configure :production do
          assets.cache          = Sprockets::Cache::MemcacheStore.new
          assets.js_compressor  = Closure::Compiler.new
          assets.css_compressor = YUI::CssCompressor.new
        end
      end
    end
  end
end
