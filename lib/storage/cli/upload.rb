module Storage::Cli::Upload

  def self.call args
    path = validate_path! args.shift
    uploader = Uploader.new
    uploader.push_path path
    uploader.await!
    fails, success = uploader.files.partition{ _1.processing_error }

    puts "successfuly uploaded #{success.length}".green

    unless success.empty?
      puts "updating index".blue
    end

    puts "failed to upload #{fails.length}".red unless fails.empty?
    fails.each{ puts _1.file }
  end

  def push_dir path, uploader

  end

  def self.validate_path! path
    match = path&.match /^storage\/(.+)/
    raise 'pass valid path to the resource' if match.nil?
    match[1]
  end

  class Uploader

    attr_reader :files

    def initialize pool_size = 8
      @pool = Concurrent::FixedThreadPool.new pool_size
      @files = Concurrent::Array.new
    end

    def push_path path
      # TODO optimize this bro
      is_file, listing = Dir.chdir 'storage' do
        next [ true ] if File.file? path
        if File.directory? path
          glob_path = path.end_with?('/') ? "#{path}*" : "#{path}/*"
          next [ false, Dir.glob(glob_path) ]
        end
      end

      if is_file
        push_file path
      else
        listing&.each{ push_path _1 }
      end
    end

    def push_file path
      @pool.post do
        puts "processing #{path}"
        file = Storage::File.new path
        begin
          file.upload!
        rescue => error
          file.processing_error = error
        end
        @files.push file
      rescue => worker_error
        puts "worker fail: #{worker_error.message.red}"
      end
    end

    def await!
      @pool.shutdown
      @pool.wait_for_termination
    end
  end

end
