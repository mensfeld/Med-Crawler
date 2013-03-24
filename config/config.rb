require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
require 'active_record'
require 'yaml'
require 'debugger'
require 'require_all'
require 'logger'

module MedParser

  ENV  = ::ENV['MED_ENV'] || 'development'
  ROOT = File.join(File.dirname(__FILE__).split('/')[0..-2].join('/')+'/')

  def self.root
    ROOT
  end

  def self.logger
    Logger.new(File.join(ROOT, 'log', "#{ENV}.log"))
  end

  def self.env
    ENV
  end

end

require_all File.join(MedParser.root, 'lib')

db_file = File.join(MedParser.root, 'config', 'database.yml')
db_config = YAML::load(File.open(db_file))
ActiveRecord::Base.establish_connection(db_config)
