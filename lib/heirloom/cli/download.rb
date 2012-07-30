module Heirloom
  module CLI
    class Download

      def initialize
        @opts = read_options
        @logger = HeirloomLogger.new :log_level => @opts[:level]
        exit 1 unless CLI::Shared.valid_options? :provided => @opts,
                                                 :required => [:name, :id, :output],
                                                 :logger   => @logger

        @archive = Archive.new :name   => @opts[:name],
                               :id     => @opts[:id],
                               :logger => @logger
      end
      
      def download
        @archive.download :output => @opts[:output],
                          :region => @opts[:region]
      end

      private

      def read_options
        Trollop::options do
          version Heirloom::VERSION
          banner <<-EOS

Download an archive.

Usage:

heirloom download -n NAME -i ID -r REGION -o OUTPUT_FILE

EOS
          opt :help, "Display Help"
          opt :id, "id of the archive to download.", :type => :string
          opt :name, "Name of archive.", :type => :string
          opt :level, "Log level [debug|info|warn|error].", :type    => :string,
                                                            :default => 'info'
          opt :output, "Location to download archive.", :type => :string
          opt :region, "Region to download archive.", :type    => :string,
                                                      :default => 'us-west-1'
        end
      end
    end
  end
end
