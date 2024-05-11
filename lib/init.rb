require 'bundler/setup'


ROOT_PATH = Pathname.new(
    File.expand_path '../..', __FILE__
)
Dir.chdir ROOT_PATH

def my_bundle_require additional_group= nil
    groups = [ :default, additional_group ].compact
    Bundler.require *groups
end

def my_exec_system command
    puts command.blue
    output = `#{command} 2>&1`.strip
    puts output
    output
end
