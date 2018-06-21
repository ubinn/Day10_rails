class BoardController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
 #  before_action :set_post, except: [:index, :create, :new, ..]
  
  # 로그인이 안된 상태에서만 접속할수있는 페이지는 ? => index랑 show만 가능하도록!
  # 나머지는 반드시 로그인이 필요하게
before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @boards =Post.all
    puts current_user.user_id if !current_user.nil?
  end

  def show
    @post.user_id = current_user.id
  end


  def new
  end

  def create
    p1 = Post.new
    p1.title = params[:title]
    p1.contents = params[:content]
     # post를 등록할 때 이 글을 작성한 사람은 현재 로그인 유저이다.
    p1.user_id = current_user.id
    p1.save
    redirect_to "/board/#{p1.id}"
 
    
    
    
    
  end
  
  def edit
  end

  def update
    @post.contents=params[:content]
    @post.title =params[:title]
    @post.save
    redirect_to "/board/#{@post.id}"
  end

  def destroy
    @post.destroy
    redirect_to "/boards"
  end

  def set_post
    @post = Post.find(params[:id])
  end
  # set_post 라는 액션(메소드)가 다른곳에서 불리면 @post 변수는 계속 유지
end
