class PostsController < ApplicationController
  # 로그인 된 사용자만 접근 가능
  before_action :authenticate_user!
    
  load_and_authorize_resource
  before_action :set_bulletin
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :log_impression, :only=> [:show]
  
  #조회수
  def log_impression
    @hit_post = Post.find(params[:id])
    # this assumes you have a current_user method in your authentication system
    @hit_post.impressions.create(ip_address: request.remote_ip,user_id:current_user.id)
  end

  def index
    @posts = @bulletin.present? ? @bulletin.posts.all : Post.all
    @posts = Post.where(bulletin_id: @bulletin).order("created_at DESC").page(params[:page]).per(6)
    @post_vote_order = Post.where(bulletin_id: @bulletin).order(:cached_votes_up => :desc).first(3)
  end

  def show
    @post         = Post.find(params[:id])
    @new_comment  = Comment.build_from(@post, current_user.id, "")
  end

  def new
    @post = @bulletin.present? ? @bulletin.posts.new : Post.new
  end

  def edit
  end

  def create
    @post = @bulletin.present? ? @bulletin.posts.new(post_params) : Post.new(post_params)
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to (@bulletin.present? ? [@post.bulletin, @post] : @post), notice: '새 글이 작성되었습니다.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to (@bulletin.present? ? [@post.bulletin, @post] : @post), notice: '글이 수정되었습니다.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to (@bulletin.present? ? bulletin_posts_url : posts_url), notice: '글이 삭제되었습니다.' }
      format.json { head :no_content }
    end
  end
  
  # 투표 관련 Controller 내용 : 찬성
  def upvote
  @post = Post.find(params[:id])
 
    #만약 '찬성' 투표를 이미 한 경우 : '찬성' 투표 취소
    if ((current_user.voted_up_on? @post) == true)
      @post.unliked_by current_user
      redirect_to(request.referrer, :notice => '해당 글의 추천을 취소하셨습니다.')
    else
      @post.upvote_by current_user
      redirect_to(request.referrer, :notice => '해당 글을 추천하셨습니다.')
    end
  end
 
  # 투표 관련 Controller 내용 : 반대
  def downvote
    @post = Post.find(params[:id])
      
    #만약 '반대' 투표를 이미 한 경우 : '반대' 투표 취소
    if ((current_user.voted_down_on? @post) == true)
      @post.undisliked_by current_user
      redirect_to(request.referrer, :notice => '해당 글의 반대를 취소하셨습니다.')
    else
      @post.downvote_from current_user
      redirect_to(request.referrer, :notice => '해당 글을 반대하셨습니다.')
    end
  end

  private
  def set_bulletin
    @bulletin = Bulletin.find(params[:bulletin_id]) if params[:bulletin_id].present?
  end

  def set_post
    if @bulletin.present?
      @post = @bulletin.posts.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end

  def post_params
    params[:post][:user_id] = current_user.id
    params[:post][:nickname] = current_user.nickname
    params.require(:post).permit(:title, :content, :user_id, :nickname, :post_img)
  end
end