module Storage

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


end
