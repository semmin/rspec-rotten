require 'json'
require 'time'
require 'rspec/core/formatters/console_codes'
require 'rspec/rotten/configuration'

module Rspec
  module Rotten
    class ExampleStore
      # 1 year duration when AS is not available
      ROTTEN_DURATION = Time.parse("2016-01-01") - Time.parse("2015-01-01")

      attr_accessor :file_path, :records

      def initialize()
        @file_path = Rspec::Rotten::Configuration.results_file
        @records = File.exists?(@file_path) ? JSON.parse(read_example_data) : []
      end

      def find(example)
        @records.find{ |x| x['id'] == example.id }
      end

      def delete(example)
        @records.delete example
      end

      def save
        f = File.open(@file_path,"w")
        f.truncate(0)
        f.write(@records.to_json)
        f.close
      end

      # use config for date
      def rotten
        rotten_duration = Rspec::Rotten::Configuration.time_to_rotten || ROTTEN_TIME
        @rotten ||= @records.select {|x| !x['date'].nil? && x['date'] < Time.now() - rotten_duration }
      end

      def notify_rotten
        if @rotten.any?
          @message = %Q{
          \n\nYou have #{@rotten.count} specs that haven't failed for extended period of time.\n\t
          \n\nYou may want to consider removing them:\n\t
          #{@records.map {|example| example['description'] + " - " + example['location'] }.join("\n\t")}
          \n
          }
          RSpec::Core::Formatters::ConsoleCodes.wrap(@message, :pending)
        end
      end

      private

      def read_example_data
        if File.exists? @file_path
          f = File.open(@file_path, 'r')
          data = f.read
          f.close
          data
        end
      end
    end
  end
end
