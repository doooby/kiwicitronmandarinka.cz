module BuildHelper

    def self.hello
        puts "hello"
    end

    def self.exec_system command
        puts command.blue
        output = `#{command} 2>&1`.strip
        puts output
        output
    end

end
