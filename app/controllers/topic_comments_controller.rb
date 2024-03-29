class TopicCommentsController < ApplicationController
  

  before_action :set_topic

  def new
    @comment= Comment.new
    
  end

  def create

  	@comment= @topic.comments.new(topic_comments_params)
  	@comment.user=current_user
  	if @comment.save
      @topic.comments_count += 1
      @topic.save
  	redirect_to topic_path(@topic)
    flash[:notice]="回復成功"
  	else 
  	redirect_to topic_path(@topic)
    flash[:alert]="回覆不可留白"
  	end
  end	

  def update
    @comment=Comment.find(params[:id])
    if @comment.user!=current_user
      redirect_to topic_path(@topic)
      flash[:alert]="你僅能修改自己的回覆"
    elsif @comment.update(topic_comments_params)
      flash[:notice]="修改成功" 
      redirect_to topic_path(@topic)
    else
      redirect_to topic_path(@topic)
      flash[:alert]="回覆不可留白"
    end  
       
  end  

  def destroy
    @comment=Comment.find(params[:id])
    @comment.destroy
    flash[:alert]="刪除回覆"
    @topic.comments_count -= 1
    @topic.save

     redirect_to topic_path(@topic)
  end


  def set_topic
  	@topic=Topic.find(params[:topic_id])
    
  end	



  def topic_comments_params
	params.require(:comment).permit(:content,:topic_id,:user_id) 
	end

end
