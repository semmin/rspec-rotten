module Rspec
  module Rotten
    class Configuration
      include Singleton

      class << self
        attr_accessor :results_file, :time_to_rotten

        def configure
          yield self
        end
      end
    end
  end
end
