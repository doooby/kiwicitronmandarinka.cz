class Storage::File

  attr_accessor :file, :mime, :size, :checksum
  attr_accessor :upload_state

  def initialize file
    self.file = file
  end

  def to_index_data
    [
      file,
      mime,
      size,
      checksum,
    ]
  end

  def set_from_index! row
    self.mime = row[1]
    self.size = row[2]
    self.checksum = row[3]
  end

  def upload!
    path = "storage/#{file}"
    self.checksum = `md5sum "#{path}"`.split(' ').first

    indexed_file = Storage.index.get_file file
    if indexed_file && indexed_file.checksum == checksum
      self.upload_state = :skip
      return
    end

    self.mime = Storage::File.identify_mime path, File.extname(path)
    self.size = File.size path

    og_object = Storage.bucket.object get_og_key
    og_object.put body: File.read(path)

    th_object = Storage.bucket.object get_th_key
    Storage::File.generate_thumb mime, path do |th_file|
      th_object.put body: th_file.read
    end

    self.upload_state = :up

  rescue => error
    puts "upload fail #{file} : #{error.message.red}"
    self.upload_state = :fail

  end

  def get_og_key
    extension = Storage::File.mime_to_extension mime
    "#{file}.og.#{extension}"
  end

  def get_th_key
    "#{file}.th.png"
  end

  def self.mime_to_asset_type mime
    case mime
    when 'image/jpeg', 'image/png' then 'image'
    when 'video/mp4' then 'video'
    end
  end

  def self.identify_mime path, extension
    case extension
    when '.jpg', '.mp4' then
      `file --mime-type -b #{path}`.strip
    else raise "unknown file extension - #{path}"
    end
  end

  def self.mime_to_extension mime
    case mime
    when 'image/jpeg' then 'jpeg'
    when 'image/png' then 'png'
    when 'video/mp4' then 'mp4'
    else raise "unknown mime - #{mime}"
    end
  end

  def self.generate_thumb mime, path
    file = Tempfile.new
    case mime
    when 'image/jpeg', 'image/png'
      `magick "#{path}" -resize 300x -format png "#{file.path}"`
    when 'video/mp4'
      IO.popen "ffmpeg -i #{path} -ss 00:00:01 -vframes 1 -c:v png -f image2pipe -", 'rb' do |io|
        file.write io.read
      end
    else raise "unknown mime - #{mime}"
      #
    end
    file.rewind
    yield file
    file.close
    file.unlink
  end

end
