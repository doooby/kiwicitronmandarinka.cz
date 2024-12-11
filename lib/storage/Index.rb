class Storage::Index

  def initialize map
    @map = map
  end

  def get_file path
    row = @map[path]
    return nil unless row
    file = Storage::File.new path
    file.set_from_index! row
    file
  end

  def set_file file
    @map[file.file] = file.to_index_data
  end

  def save!
    rows = @map.values.sort_by(&:first)
    CSV.open Storage::INDEX_PATH, 'w' do |csv|
      rows.each{ csv << _1 }
    end
  end

  def self.read!
    map = {}
    CSV.foreach Storage::INDEX_PATH do |row|
      map[row.first] = row
    end
    new map
  end

end