class User < ApplicationRecord
  #중복검사 체크
  validates_uniqueness_of :email, :std_number
  
  has_many :posts
  has_many :bulletins
  
  #유저의 기본 권한 설정
  after_create :assign_default_role
  
  #투표 환경 설정
  acts_as_voter
  
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  def assign_default_role
    add_role(:student)
  end
  
  # admin 권한 검사 추가
  def admin?
    has_role?(:admin)
  end
  
end
