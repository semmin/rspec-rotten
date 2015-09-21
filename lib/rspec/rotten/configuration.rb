require 'singleton'

module Rspec
  module Rotten
    class Configuration
      include ::Singleton

      class << self
        attr_accessor :results_file, :time_to_rotten

        def configure
          yield self
        end

        def register_formatter
          RSpec.configure do |config|
            config.add_formatter(Rspec::Rotten::Formatters::RottenReportFormatter)
          end
        end
      end
    end
  end
end
