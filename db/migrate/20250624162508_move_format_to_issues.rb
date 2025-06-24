class MoveFormatToIssues < ActiveRecord::Migration[7.2]
  def change
    remove_column :podcasts, :is_audio, :boolean
    add_column :issues, :format, :string, default: "video"  # по умолчанию пусть будут аудио-выпуски
  end
end