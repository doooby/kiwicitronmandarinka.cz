module Storage

  INDEX_PATH = 'storage/index.csv'

  S3_BASE_URL = 'https://s3.eu-central-1.amazonaws.com/kiwicitronmandarinka.cz/'

  def self.bucket
    @bucket ||= begin
      secrets = ::File.readlines '.secrets'
      resource = Aws::S3::Resource.new(
        region: 'eu-central-1',
        access_key_id: secrets[0].strip,
        secret_access_key: secrets[1].strip
      )
      resource.bucket 'kiwicitronmandarinka.cz'
    end
  end

  def self.index
    @index ||= Storage::Index.read!
  end

  def self.asset_urls path
    file = index.get_file path
    if file
      [
        File.mime_to_asset_type(file.mime),
        "#{S3_BASE_URL}#{file.get_th_key}",
        "#{S3_BASE_URL}#{file.get_og_key}"
      ]
    else
      file_path = "storage/#{path}"
      mime = File.identify_mime file_path, ::File.extname(file_path)
      url = "/#{file_path}"
      [
        File.mime_to_asset_type(mime),
        "#{url}?th=1",
        url
      ]
    end
  end

end
