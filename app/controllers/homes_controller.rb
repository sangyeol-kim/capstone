class HomesController < ApplicationController

  def index
    @vote_mention_list = VoteComment.order("created_at DESC")
  end
  
  def create
    @mention = VoteComment.new
    @mention.mention = params[:mention]
    @mention.save
    
    redirect_to root_path
  end
end
