require 'time'

module Heirloom

  class MetadataAdder

    def initialize(args)
      @config = args[:config]
      @id     = args[:id]
      @name   = args[:name]
      @domain = "heirloom_#{@name}"
      @logger = @config.logger
    end

    def add_metadata(args)
      @base      = args[:base]
      @encrypted = args[:encrypted]
      @regions   = args[:regions]

      attributes = { 'base'       => @base,
                     'created_at' => current_time,
                     'encrypted'  => @encrypted,
                     'id'         => @id,
                     'name'       => @name }

      @regions.each do |region|

        @logger.debug "Adding metadata for #{@id} in #{region}."

        sdb = AWS::SimpleDB.new :config => @config,
                                :region => region

        sdb.put_attributes @domain, @id, attributes

      end

      @logger.info "Setting metadata complete."
    end

    private 

    def current_time
      Time.now.utc.iso8601
    end

  end
end
