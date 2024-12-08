require 'bundler/setup'
require 'zeitwerk'

ROOT_PATH = Pathname.new File.expand_path '..', __FILE__
Dir.chdir ROOT_PATH

def app_bundle! *groups
    groups.unshift :default
    Bundler.require(*groups)
end

def app_load! reload: false
    loader = Zeitwerk::Loader.new
    loader.push_dir ROOT_PATH.join('lib')
    loader.enable_reloading if reload
    loader.setup

    if reload
        listener = Listen.to ROOT_PATH.join 'lib' do
            loader.reload
            reload.call if reload.is_a? Proc
        end
        listener.start
    end
end

def app_sys_exec command
    puts command.blue
    output = `#{command} 2>&1`.strip
    puts output
    output
end
