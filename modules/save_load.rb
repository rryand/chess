require "yaml"

module SaveLoad

  public

  def save(data)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    write_to_save_file(data)
    exit
  end

  private

  def write_to_save_file(data)
    file_name = "rchess_#{Time.now.strftime("%m%d%y_%H%M%S")}.yaml"
    File.open("saves/#{file_name}", 'w') do |file|
      file.write(data)
    end
  end
end