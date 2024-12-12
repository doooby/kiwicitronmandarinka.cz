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
        "#{Storage::S3_BASE_URL}#{file.get_th_key}",
        "#{Storage::S3_BASE_URL}#{file.get_og_key}"
      ]
    else
      [
        "/storage/#{path}",
        "/storage/#{path}"
      ]
    end
  end

end
