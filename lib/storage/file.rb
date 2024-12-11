class Storage::File

  attr_accessor :file, :mime, :size, :hash
  attr_accessor :processing_error

  def initialize file
    self.file = file
  end

  def read!
    Storage.index[file]
  end

  def upload!
    path = "storage/#{file}"

    self.mime = Storage::File.identify_mime path, File.extname(path)
    self.size = File.size path
    self.hash = `md5sum "#{path}"`.split(' ').first

    og_object = Storage.bucket.object get_og_key
    og_object.put body: File.read(path)

    th_object = Storage.bucket.object get_th_key
    Storage::File.generate_thumb mime, path do |th_file|
      th_object.put body: th_file.read
    end
  end

  def get_og_key
    extension = Storage::File.mime_to_extension mime
    "#{file}.og.#{extension}"
  end

  def get_th_key
    "#{file}.th.png"
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
