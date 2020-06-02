require "yaml"

module SaveLoad

  public

  def save(data)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    write_to_save_file(data)
    exit
  end

  def load(file_name)
    data = YAML.load(File.read("saves/#{file_name}"))
    @board = data[:board]
    @player = data[:player]
  end

  def delete(file_name)
    File.delete("saves/#{file_name}")
  end

  private

  def save_data
    data_hash = {
      board: @board,
      player: @player
    }
    YAML.dump(data_hash)
  end

  def write_to_save_file(data)
    file_name = "rchess_#{Time.now.strftime("%m%d%y_%H%M%S")}.yaml"
    File.open("saves/#{file_name}", 'w') do |file|
      file.write(data)
    end
  end
end