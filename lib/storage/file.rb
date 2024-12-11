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

    puts "uploading #{file}".blue
    og_object = Storage.bucket.object get_og_key
    og_object.put body: File.read(path)

    puts "uploading th #{file}".blue
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

  def is_img?
    case mime
    when 'image/jpeg', 'image/png' then true
    else false
    end
  end

  def self.identify_mime path, extension
    case extension
    when '.jpg', '.png' then
      simple = `identify -format "%m" "#{path}"`.strip
      case simple
      when 'JPEG' then 'image/jpeg'
      when 'PNG' then 'image/png'
      else raise "unknown sipmple mime - #{simple}"
      end
    else raise "unknown file extension - #{path}"
    end
  end

  def self.mime_to_extension mime
    case mime
    when 'image/jpeg' then 'jpeg'
    when 'image/png' then 'png'
    else raise "unknown mime - #{mime}"
    end
  end

  def self.generate_thumb mime, path
    file = Tempfile.new
    case mime
    when 'image/jpeg', 'image/png'
      `magick "#{path}" -resize 300x -format png "#{file.path}"`
    else raise "unknown mime - #{mime}"
    end
    file.rewind
    yield file
    file.close
    file.unlink
  end

end
