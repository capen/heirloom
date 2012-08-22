require 'socket'
require 'time'

module Heirloom

  class Builder

    attr_writer :local_build

    def initialize(args)
      @config = args[:config]
      @name = args[:name]
      @domain = "heirloom_#{@name}"
      @id = args[:id]
      @logger = @config.logger
    end

    def build(args)
      @base    = args[:base]
      @secret  = args[:secret]
      @source  = args[:directory]
      @exclude = args[:exclude]

      directory = Directory.new :path      => @source,
                                :exclude   => @exclude,
                                :config    => @config

      unless directory.build_artifact_from_directory :secret => @secret
        return false
      end

      @logger.info "Build complete."

      @local_build = directory.local_build
    end

  end
end
