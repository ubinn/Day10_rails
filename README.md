## Day10_180621

```ruby
# CRUD 복습
```

### 검색

- 무언가 사용자 혹은 개발자가 원하는 데이터를 찾고자 할때

- 검색방법

  - 일치
  - 포함
  - 범위
  - ...

- 우리가 그동안 검색했던 방법은 **'일치' ** table에 있는 id와 일치하는 것을 찾아왔었다. 

  예를들면 id 같은 것. 이 컬럼은 인덱싱이 되어있기 때문에 속도가 매우 빠르며 항상 고유한 값을 가진다. 

  - Table에 있는 id로 검색을 할때는 `Model.find`메소드를 사용한다.

- Table에 있는 id값으로 해결하지 못하는 경우

  - 사용자가 입력했던 값으로 검색해야 하는 경우. (`user_id`)
  - 게시글을 검색하는데, 작성자로 혹은 제목으로 검색하는 경우
  - Table에 있는 다른 컬럼으로 검색할 경우에는 `Model.find_by_컬럼명(value)`,`Model.find_by(컬럼명: value)`
  - `find_by`의 특징 : 1개만 검색됨. (일치하는 값이 최초 나온뒤 검색종료, 일치하는 값이 없는 경우 nil값으로 리턴. ) 

- 추가적인 검색방법 : `Model.where(특정col명: 검색어값(value))` 

  - `User.where(user_id: "hello")  `

  - `where`의 특징 :  검색결과가 여러개. col에서 일치하는 row를 모두 리턴 -> 결과값이 배열형태. 일치하는 값이 없는 경우에도 빈배열 형태로 나온다(length가 0인 배열). 

    - 배열은 아니지만 배열형태로 나와서, 배열에 사용가능한 모든 method 사용가능 

      : 덕타이핑

  - 결과값이 비어있는 경우에도 `.nil?` 메소드의 결과값이 `false`로 나옴

  - 결과값이 비어있는지 어떻게 알까 ? `.length = 0` 혹은 `.empty?` 로 질의한다.

- 포함?

  - 텍스트가 특정 단어/문장을 포함하고 있는가?
  - `Model.where("컬럼명 LIKE ?", "%#{value}%")`
  - `Model.where("컬럼명 LIKE '%#{value}%'")` 해도 동작은 되지만, 쓰면 안됨
    - SQL Injection(해킹)이 발생할 수 있다.
    - 사용자가 SQL문을 보낼수있어서 해킹의 위험이 높다.
  - 사실, 좋은 Query 방법은 아니다. -> **Full text search** 라는 방식 존재

- ### [8 Filters](http://guides.rubyonrails.org/action_controller_overview.html#filters)

  - `  before_action :set_post, only: [:show, :edit, :update, :destroy]` : 모든 액션 실행전 set_post액션을 실행해라 :show, :edit, :update, :destroy 에서만!
  - ` #  before_action :set_post, except: [:index, :create, :new, ..]` : 얘는 ~제외하고.
  - 컨트롤러 액션을 시작되기전, 시작된 후 혹은 그 즈음에 method가 자동으로 실행되도록 하는것이다. 만약` ApplicationController` filter를 놓았다면, 이것은 상속되어 모든 controller에서 작동할수있다.
  - `BoardController < ApplicationController` ApplicationController를 BoardController가 상속받는다. 
  - `ApplicationController` 에서는 세션과 같이 모든페이지에서 확인해줘야하는것. 사용

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception <- CSRF공격을 막는 것.
    # 현재 로그인 된 상태니?
  def user_signed_in? # 리턴값은 T/F
    if session[:current_user].present?  
    else
      redirect_to "/sign_in"
    # 로그인 되어있지 않으면 로그인 페이지로 이동시켜줘
    end    
    session[:current_user].present?
  end
  
  # 현재 로그인 된 사람은 누구니?

  def current_user
    # 현재 로그인 됬니?
    if user_signed_in?
        @current_user = User.find(session[:current_user])

    end
  end
end
```

- 뷰에서는 컨트롤러단에 있는 method를 직접호출할수는 없어. 
  - 하지만 이것을 사용할수있게 하는게 `helper_method :user_signed_in?` 로 이름을 지정해줘야 뷰에서도 이런 메소드들을 사용가능!  (예외를 만들어주는 것)
  - 뷰헬퍼 폼헬퍼 는 루비코드로 html 코드를 만들어주는 친구들 (헷갈리지 말기)







- **릴레이션** : 한명의 유저가 여러개의 포스트를 쓸수있다 (1:N 관계)
  - 외래키를 지정한 것.

*~/daum_cafe_app/app/models/user.rb*

```ruby
class User < ApplicationRecord
    has_many :posts # 여러 포스트를 쓴다.
end
```

*~/daum_cafe_app/app/models/post.rb*


```ruby
class Post < ApplicationRecord
    belongs_to :user  # 한명의 유저가
end
```

```ruby
binn02:~/daum_cafe_app (master) $ rails c
Running via Spring preloader in process 9341
Loading development environment (Rails 5.0.7)
2.3.4 :001 > User.new
 => #<User id: nil, user_id: nil, password: nil, ip_address: nil, created_at: nil, updated_at: nil> 
2.3.4 :002 > u = User.new
 => #<User id: nil, user_id: nil, password: nil, ip_address: nil, created_at: nil, updated_at: nil> 
2.3.4 :003 > u.user_id = "haha"
 => "haha" 
2.3.4 :004 > u.password = "1234"
 => "1234" 
2.3.4 :005 > u.save
   (0.1ms)  begin transaction
  SQL (0.5ms)  INSERT INTO "users" ("user_id", "password", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["user_id", "haha"], ["password", "1234"], ["created_at", "2018-06-21 05:12:00.395977"], ["updated_at", "2018-06-21 05:12:00.395977"]]
   (15.2ms)  commit transaction
 => true 
2.3.4 :006 > p = Post.new
 => #<Post id: nil, title: nil, contents: nil, user_id: nil, created_at: nil, updated_at: nil> 
2.3.4 :007 > p.title = "simple"
 => "simple" 
2.3.4 :008 > p.contents = "relation"
 => "relation" 
2.3.4 :009 > p.user_id = u.id // p.user_id = 1 로 해줘도 상관없으.
 => 1 
2.3.4 :010 > p.save
   (0.1ms)  begin transaction
  User Load (0.4ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  SQL (0.4ms)  INSERT INTO "posts" ("title", "contents", "user_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["title", "simple"], ["contents", "relation"], ["user_id", 1], ["created_at", "2018-06-21 05:13:51.172808"], ["updated_at", "2018-06-21 05:13:51.172808"]]
   (15.9ms)  commit transaction
 => true 
2.3.4 :011 > u.posts //user 가 작성한 모든 포스트 보여주는것.
  Post Load (0.3ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = ?  [["user_id", 1]]
 => #<ActiveRecord::Associations::CollectionProxy [#<Post id: 1, title: "simple", contents: "relation", user_id: 1, created_at: "2018-06-21 05:13:51", updated_at: "2018-06-21 05:13:51">]> 
2.3.4 :012 > p
 => #<Post id: 1, title: "simple", contents: "relation", user_id: 1, created_at: "2018-06-21 05:13:51", updated_at: "2018-06-21 05:13:51"> 
2.3.4 :013 > p.user // post에 있는 모든 유저 보여주는것.
 => #<User id: 1, user_id: "haha", password: "1234", ip_address: nil, created_at: "2018-06-21 05:12:00", updated_at: "2018-06-21 05:12:00"> 
2.3.4 :014 > 
```



만약 cafe랑 post를 연결하고 싶으면 post에 cafe_id 라는 col을 만들면 되는거지. 위에 db에다가  `has_many :posts`  `belongs_to :cafe` 를 써주고 나서!

