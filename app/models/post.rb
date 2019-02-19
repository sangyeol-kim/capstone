class Post < ApplicationRecord
    # 이미지 업로드
    mount_uploader :post_img, ImageUploader
    
    belongs_to :bulletin
    belongs_to :user
    # 조회수
    has_many :impressions, :as=>:impressionable
    
    # 게시글이 삭제되도 DB에는 원본 기록이 남아있음.
    acts_as_paranoid
    
    # 투표 환경 설정
    acts_as_votable
    
    # 대댓글
    acts_as_commentable
 
    def impression_count
        impressions.size
    end
    
    def unique_impression_count
        # impressions.group(:ip_address).size gives => {'127.0.0.1'=>9, '0.0.0.0'=>1}
        # so getting keys from the hash and calculating the number of keys
        impressions.group(:ip_address).size.keys.length #TESTED
    end
end
