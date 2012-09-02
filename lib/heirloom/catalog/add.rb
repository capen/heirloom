module Heirloom
  class Catalog
    class Add

      def initialize(args)
        @config  = args[:config]
        @name    = args[:name]
        @logger  = @config.logger
      end

      def add_to_catalog(args)
        regions = args[:regions]
        base    = args[:base]

        if verify.entry_exists_in_catalog? @name
          return false
        end

        @logger.info "Adding #{@name} to catalog."
        sdb.put_attributes 'heirloom', 
                           "heirloom_#{@name}", 
                           { "regions" => regions, "base" => base }

      end

      private

      def sdb
        @sdb ||= AWS::SimpleDB.new :config => @config
      end

      def verify
        @verify ||= Catalog::Verify.new :config => @config
      end

    end
  end
end