class CreateConfirmImgs < ActiveRecord::Migration[5.1]
  def change
    create_table :confirm_imgs do |t|
      t.string :image_analyst #이미지 text 분석
      t.string :test
      t.timestamps
    end
  end
end
