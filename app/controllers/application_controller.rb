class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :user_signed_in?
  
  # 현재 로그인 된 상태니?
  def user_signed_in? # 리턴값은 T/F
    session[:current_user].present?
  end
  
  # 로그인이 되어있지 않으면 로그인하는 페이지로 이동시켜줘
  def authenticate_user!  # 내가 의도하지 않는 액션이 올수있는 경우 !(뱅)을 붙여준다. =! 원형을 변경시킬수있는 메소드에도 쓴다 .delete! 처럼
    #메소드 명에다가 리턴값을 유추할수있는 무언가를 넣어주면 좋아
    unless user_signed_in?
      redirect_to '/sign_in'
    end
  end
  
  
  # 현재 로그인 된 사람은 누구니?
  def current_user
    # 현재 로그인 됬니?
    if user_signed_in?
      @current_user = User.find(session[:current_user])
    end
  end
  
end
