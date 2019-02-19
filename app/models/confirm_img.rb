class ConfirmImg < ApplicationRecord
    #이미지 업로드
    mount_uploader :image_analyst, ImageUploader
end
