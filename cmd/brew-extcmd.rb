# -*- coding: UTF-8 -*-

require "pathname"
require "extend/string"

require "descriptions"

module External_Command

  class ExtCmd

    private
      def initialize( package_yaml )
        @pkg = package_yaml
      end

    public
    def self.factory( cmd )
      if data = Package_Cache.fetch(cmd)
        ExtCmd.new data
      end
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


    def search( args )
      res = args.uniq!.map{ |a|
        Package_Cache.search_name( /#{a}/ )
      }
      Descriptions.new(res).print
    end

    def search_desc( args )
      args.uniq!.map! { |a| Package_Cache.search_desc( /#{a}/ ) }
    end

    def install( args )
      args.uniq.map{ |name|
        ExtCmd.factory(name).install.each { |cmd|
          system "brew", cmd
        }
      }
    end

    def uninstall( args )
      args.uniq.map{ |name|
        ExtCmd.factory(name).uninstall.each { |cmd|
          system "brew", cmd
        }
      }
    end

    def desc( args )
      args.uniq.map{ |name|
        puts name, ":", ExtCmd.factory(name).desc
      }
    end

    def home( args )
      args.uniq.map{ |name|
        system "open", ExtCmd.factory(name).home
      }
    end

    def help( args )

    end


    def Usage
      <<-EOS.undent
        Usage:
          brew alias foo=bar     # set 'brew foo' as an alias for 'brew bar'
          brew alias foo --edit  # open up alias 'foo'in EDITOR
          brew alias foo         # print the alias 'foo'
          brew alias             # print all aliases
          brew unalias foo       # remove the 'foo' alias
      EOS
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
