class UserController < ApplicationController
  def index
    @users = User.all
    @current_user=User.find(session[:current_user]) if session[:current_user]
    
  end

  def show
    @user = User.find(params[:id])
  end

  def new

  end
  
  def create
    user = User.new
    user.user_id = params[:user_id]
    user.password = params[:password]
    user.ip_address =request.ip
    user.save
    redirect_to "/user/#{user.id}"
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    user = User.find(params[:id])
    # user.user_id = params[:user_id]
    user.password=params[:password]
    # user.ip_address=request.ip
    user.save
    redirect_to "/user/#{user.id}"
  end
  
  def sign_in
    # 로그인이 되어있는지 확인하고,
    # 로그인이 되어있으면 원래 페이지로 돌아가기
  end
  
  def login
    # 유저가 입력한 ID, PW를 바탕으로
    # 실제로 로그인이 이루어 지는곳
    id = params[:user_id]
    pw = params[:password]
    user = User.find_by_user_id(id) # 숫자가 아닌 사용자가 입력한 아이디로 찾는고야. 
    
    if !user.nil? and user.password.eql?(pw)  # 해당 user_id 로 가입한 유저가 있고, 패스워드도 일치하는 경우
  # if user.present? 도 가능 ! 
      session[:current_user]=user.id
      flash[:success]="로그인 되었습니다."
      redirect_to "/users"
    
    else # 가입한 user_id가 없거나, password가 틀린경우
      flash[:error] ="가입된 유저가 아니거나 비밀번호가 틀립니다. "
      redirect_to '/sign_in'
    end
  end
  def logout
    session.delete(:current_user)
    flash[:success]="로그아웃에 성공하셨습니다."
    redirect_to "/users"
  end
end
