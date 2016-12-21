# -*- coding: UTF-8 -*-

require "pathname"
require "extend/string"


module External_Command

  class ExtCmd

    def initialize( cmd )
      @pkg = Package_Cache.fetch(cmd)
    end

    def name
      @pkg['name']
    end

    def desc
      @pkg['desc']
    end

    def homepage
      @pkg['home']
    end

    def install
      @pkg['install']
    end

    def uninstall
      @pkg['uninstall']
    end

    def test
      @pkg['test']
    end

  end

  class Package_Cache

    def self.search_name( pattern )
      query "name" , lambda { |v| v =~ pattern }
    end

    def self.search_desc( pattern )
      query "desc" , lambda { |v| v =~ pattern }
      # sample = { "1" => "one", "2" => "two" }
      # Descriptions.new(sample).print
    end

    def self.fetch( cmd )
      cache[cmd]
    end

    def self.cache
      @cache || load_cache

    end

    def self.load_cache
      @cache = Hash.new do |hash, key|
        if pname = Pathname.glob("../Package/brew-#{key}.yaml").first
          hash[key] = YAML.load_file pname
        end
      end
    end

    def self.query( key, block )
      matches = {}
      for pkg in list do
        matches[pkg] = cache[pkg][key] if block.call cache[pkg][key]
      end
    end

    def self.list
      Dir.glob("../Package/*.yaml").map do |path|
        File.basename(path, ".yaml").match(/^brew-(.*)$/)[1]
      end
    end

  end



  class << self

    def search( *args )

    end

    def search_desc( *args )

    end

    def install( *args )

    end

    def uninstall( *args )

    end

    def desc( *args )

    end

    def home( *args )

    end

    def help( *args )

    end

    def cli

      case ARGV.shift
      when 'search'
        case ARGV.first
        when '--desc'
          search_desc ARGV.drop(1)
        else
          search ARGV
        end
      when 'install'
        install ARGV
      when uninstall
        uninstall ARGV
      when desc
        desc ARGV
      when 'home'
        home ARGV
      when 'help','--help','-help','-h'
        help ARGV
      else
        help
      end

    end

  end

end

External_Command.cli
