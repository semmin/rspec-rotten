require 'rspec'
require 'rspec/rotten/formatters/initial_report_formatter'

module Rspec
  module Rotten
    class InitialReportCreator
      def self.create_report
        unless File.exist?(Rspec::Rotten::Configuration.results_file)
          config = RSpec.configuration

          formatter = Rspec::Rotten::Formatters::InitialReportFormatter.new(Rspec::Rotten::Configuration.results_file)

          reporter =  RSpec::Core::Reporter.new(config)
          config.instance_variable_set(:@reporter, reporter)

          # internal hack
          # api may not be stable, make sure lock down Rspec version
          loader = config.send(:formatter_loader)
          notifications = loader.send(:notifications_for, Rspec::Rotten::Formatters::InitialReportFormatter)

          reporter.register_listener(formatter, *notifications)

          RSpec::Core::Runner.run([config.default_path])
        end
      end
    end
  end
end
