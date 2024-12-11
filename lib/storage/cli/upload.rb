module Storage::Cli::Upload

  def self.call args
    path = validate_path! args.shift
    if path[-1] == '/'
      raise 'niy'
    else
      file = upload_file path
      puts({
        file: file.file,
        mime: file.mime,
        size: file.size,
        hash: file.hash,
        og_key: file.og_key,
        th_key: file.th_key,
      }.to_s)
    end
  end

  def self.validate_path! path
    match = path&.match /^storage\/(.+)/
    raise 'pass valid path to the resource' if match.nil?
    match[1]
  end

  def self.upload_file path
    file = Storage::File.new
    file.file = path
    file.upload!
    file
  end

end
