require 'active_model'
require 'forwardable'
require 'yaml'
require 'pry'

PROOF_SYSTEM_ROOT = File.expand_path('../', File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join PROOF_SYSTEM_ROOT, 'app')

%w(app/**).each do |load_dir|
  Dir.glob(File.join(PROOF_SYSTEM_ROOT, load_dir, '*.rb')).sort.each do |f|
    load f
  end
end

class ProofSystem
  class << self
    def root(path = '')
      File.join(PROOF_SYSTEM_ROOT, path)
    end

    def file_base
      File.join PROOF_SYSTEM_ROOT, config['file_base']
    end

    def config
      @config ||= load_config
    end

    private

    def load_config
      YAML.load_file File.join PROOF_SYSTEM_ROOT, 'config/proof_system.yml'
    end
  end
end
