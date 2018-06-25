class BoardController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
 #  before_action :set_post, except: [:index, :create, :new, ..]
  
  # 로그인이 안된 상태에서만 접속할수있는 페이지는 ? => index랑 show만 가능하도록!
  # 나머지는 반드시 로그인이 필요하게
before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @title = "타이틀이지롱"
    @boards =Post.all
    puts current_user.user_id if !current_user.nil?
  end

  def show
    @post.user_id = current_user.id
  end


  def new
  end

  def create
    p1 = Post.create(post_params)
    # p1.title = params[:title]
    # p1.contents = params[:content]
    # p1.user_id = current_user.id
    #  p1.save
   flash[:success]="글이 작성되었습니다."
    redirect_to "/board/#{p1.id}"
  end
  
  def edit
  end

  def update
    p post_params
    @post.update(post_params) 
    flash[:success]="글이 수정되었습니다."
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
  
  def post_params
    # 스캐폴드때 한대. params.fetch(:post, {}).permit(:title, :content)
    {title: params[:title], contents: params[:content], user_id: current_user.id}
  end
end
