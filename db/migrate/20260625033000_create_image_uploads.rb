class CreateImageUploads < ActiveRecord::Migration[8.0]
  def change
    create_table :image_uploads do |t|
      t.string :title

      t.timestamps
    end
  end
end
