require 'active_model'
require 'forwardable'
require 'yaml'
require 'pry'

ND_PROVING_ROOT = File.expand_path('../', File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join ND_PROVING_ROOT, 'app')

%w(app/**).each do |load_dir|
  Dir.glob(File.join(ND_PROVING_ROOT, load_dir, '*.rb')).sort.each do |f|
    load f
  end
end

class NdProving
  class << self
    def root(path = '')
      File.join(ND_PROVING_ROOT, path)
    end

    def file_base
      File.join ND_PROVING_ROOT, config['file_base']
    end

    def config
      @config ||= load_config
    end

    private

    def load_config
      YAML.load_file File.join ND_PROVING_ROOT, 'config/nd_proving.yml'
    end
  end
end
