module Heirloom

  class Verifier

    def initialize(args)
      @config = args[:config]
      @name = args[:name]
      @logger = @config.logger
    end

    def buckets_exist?(args)
      bucket_prefix = args[:bucket_prefix]
      regions = args[:regions]
      result = true

      regions.each do |region|
        unless bucket_exists? :region        => region,
                              :bucket_prefix => bucket_prefix
          result = false
        end
      end

      result
    end

    def domains_exist?(args)
      regions = args[:regions]
      result = true

      regions.each do |region|
        result = false unless domain_exists? region
      end

      result
    end

    def bucket_exists?(args)
      bucket_prefix = args[:bucket_prefix]
      region = args[:region]

      bucket = "#{bucket_prefix}-#{region}"
      
      s3 ||= AWS::S3.new :config => @config,
                         :region => region

      if s3.get_bucket bucket
        @logger.debug "Bucket #{bucket} exists in #{region}"
        true
      else
        @logger.debug "Bucket #{bucket} in #{region} does not exist"
        false
      end
    end


    def domain_exists?(region)
      domain = "heirloom_#{@name}"
      sdb    = AWS::SimpleDB.new :config => @config,
                                 :region => region
      if sdb.domain_exists? domain
        @logger.debug "SimpleDB domain for #{@name} exists in #{region}"
        true
      else
        @logger.debug "SimpleDB domain for #{@name} does not exist in #{region}"
        false
      end
    end

  end
end
