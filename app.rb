require 'bundler/setup'
require 'zeitwerk'

ROOT_PATH = Pathname.new(
    File.expand_path '..', __FILE__
)
Dir.chdir ROOT_PATH

def app_bundle! additional_group= nil
    groups = [ :default, additional_group ].compact
    Bundler.require *groups
end

def app_load! reloading: false
    loader = Zeitwerk::Loader.new
    loader.push_dir ROOT_PATH.join('lib')
    loader.enable_reloading if reloading
    loader.setup
    loader
end

def app_sys_exec! command
    puts command.blue
    output = `#{command} 2>&1`.strip
    puts output
    output
end
