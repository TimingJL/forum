# Learning by Doing 

![Ubuntu version](https://img.shields.io/badge/Ubuntu-16.04%20LTS-orange.svg)
![Rails version](https://img.shields.io/badge/Rails-v5.0.0-blue.svg)
![Ruby version](https://img.shields.io/badge/Ruby-v2.3.1p112-red.svg)

Mackenzie Child's video really inspired me. So I decided to follow all of his rails video tutorial to learn how to build a web app. Through the video, I would try to build the web app by my self and record the courses step by step in text to facilitate the review.


# Project 10: How To Build A Forum With Rails          
This time we built a simple forum application. We have the ability to sign up and sign in / out… Add, Edit, Destroy forum posts, and users can reply to each others forum posts through comments. In this project, we use custom styling instead of bootstrap.


https://mackenziechild.me/12-in-12/10/        


![image](https://github.com/TimingJL/forum/blob/master/pic/index.jpeg) 
![image](https://github.com/TimingJL/forum/blob/master/pic/comment2.jpeg)
![image](https://github.com/TimingJL/forum/blob/master/pic/new_post.jpeg)
![image](https://github.com/TimingJL/forum/blob/master/pic/edit_post.jpeg)


### Highlights of this course
1. Users
2. Posts
3. Comments
4. Custom Styling
5. HAML


# Create A Forum
```console
$ rails new forum
```


Chage directory to the pin_board. Under `Gemfile`, add `gem 'therubyracer'`, save and run `bundle install`.      

Note: 
Because there is no Javascript interpreter for Rails on Ubuntu Operation System, we have to install `Node.js` or `therubyracer` to get the Javascript interpreter.

```console
$ bundle install
```

Then run the `rails server` and go to `http://localhost:3000` to make sure everything is correct.      


Let's first do the ability to create a post, and then we'll add users, and assign the post to the users. After that we'll add the ability to add comments to the individual post.


Let's start by generating a model.
```console
$ rails g model post title:string content:text
$ rake db:migrate
```


From here, let's generate a controller.
```console
$ rails g controller posts
```

And we create index action to loop through all the various posts.       
In `app/controllers/posts_controller.rb`
```ruby
class PostsController < ApplicationController
	def index
	end
end
```

Then I'm gonna open up the routes file.        
In `config/routes.rb`
```ruby
Rails.application.routes.draw do
  resources :posts
  root 'posts#index'
end
```

Before we create the view file, let's install a few gems for our application.       
In `Gemfile`
```
gem 'devise'
gem 'simple_form', github: 'kesha-antonov/simple_form', branch: 'rails-5-0'
gem 'haml', '~> 4.0.5'
```
Save that, run `bundle install` and restart our server.


Then, under `app/views/posts`, let's create a view file and save it as `index.html.haml`. 
```haml
%h1 This is the index placeholder text
``


# New Post
Next, let's add the ability to create a new post and show.         
In `app/controllers/posts_controller.rb`
```ruby
class PostsController < ApplicationController
	def index
	end

	def show
		@post = Post.find(params[:id])
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)

		if @post.save
			redirect_to @post
		else
			render 'new'
		end
	end

	private

	def post_params
		params.require(:post).permit(:title, :content)
	end
end
```  

Then we create a new file called `new.html.haml` under `app/views/posts`.        
In `app/views/posts/new.html.haml`
```haml
%h1 New Post

= render 'form'
```

Now, let's create our form under `app/views/posts` and save the file as `_form.html.haml`.       
In `app/views/posts/_form.html.haml`
```haml
= simple_form_for @post do |f|
	= f.input :title
	= f.input :content
	= f.submit
``` 

Next, let's create a show page under `app/views/posts` and save it as `show.html.haml`.
```haml
%h1= @post.title
%p= @post.content
```


# Edit & Destroy
Let's add the ability to edit and destory a post.       
In our controller `app/controllers/posts_controller.rb`, the reason we are defining a private action `find_post` is because otherwise you have to copy and paste `@post = Post.find(params[:id])` four different times.
```ruby
class PostsController < ApplicationController
	before_action :find_post, only: [:show, :edit, :update, :destroy]
	
	def index
	end

	def show		
	end	

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)

		if @post.save
			redirect_to @post
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @post.update(post_params)
			redirect_to @post
		else
			render 'edit'
		end
	end

	def destroy
		@post.destroy
		redirect_to root_path
	end


	private

	def find_post
		@post = Post.find(params[:id])
	end

	def post_params
		params.require(:post).permit(:title, :content)
	end
end
```


In our show page `app/views/posts/show.html.haml`
```haml
%h1= @post.title
%p= @post.content

= link_to "Edit", edit_post_path(@post)
= link_to "Delete", post_path(@post), method: :delete, data: { confirm: "Are you sure?" }
= link_to "Home", root_path
```

And then let's create the edit page under `app/views/posts` and save the file as `edit.html.haml`
```haml
%h1 Edit Post

= render 'form'

= link_to "Cancel", post_path
```

# Loops Through All Of The Posts
Now, let's loop through all of the posts inside of our post index action.      
In `app/controllers/posts_controller.rb`
```ruby
def index
	@posts = Post.all.order("created_at DESC")
end
```

In the `app/views/posts/index.html.haml`
```haml
- @posts.each do |post|
	%h2= link_to post.title, post
	%p
		Published at
		= time_ago_in_words(post.created_at)

= link_to "New Post", new_post_path
```

# User
Next thing we need to do is install devise by generator.
```console
$ rails generate devise:install


===============================================================================

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

===============================================================================
```

Let's do the step 1 and step 3.


Next thing we need to do is run the generator to create a model.      
```console
$ rails generate devise user
$ rake db:migrate
```

Then we restart the server and go to `http://localhost:3000/users/sign_up`
![image](https://github.com/TimingJL/forum/blob/master/pic/sign_up.jpeg)




The next thing we want to do is build out the post from the current user.         
In `app/controllers/posts_controller.rb`
```ruby
def new
	@post = current_user.posts.build
end

def create
	@post = current_user.posts.build(post_params)

	if @post.save
		redirect_to @post
	else
		render 'new'
	end
end
```

So next what we want to do is add association between the post model and the user model.        
In `app/models/posts.rb`
```ruby
class Post < ApplicationRecord
	belongs_to :user
end
```

In `app/models/user.rb`
```ruby
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
end
```

```console
$ rails g migration add_user_id_to_posts user_id:integer
$ rake db:migrate
```

After assigning the user_id to all of the post, let's go to `app/views/posts/index.html.haml` to make sure it work.
```haml
- @posts.each do |post|
	%h2= link_to post.title, post
	%p
		Published at
		= time_ago_in_words(post.created_at)
		by
		= post.user.email

= link_to "New Post", new_post_path
```
![image](https://github.com/TimingJL/forum/blob/master/pic/add_user_id.jpeg)


# Structure and Styling

First, let's rename `application.html.erb` to `application.html.haml` under `app/views/layouts` and tweak the html to haml.
```haml
!!!
%html
%head
	%title TimingJL's Rails Forum
	= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true
	%link{ rel: "stylesheet", href: "http://fonts.googleapis.com/css?family=Lato:300,400,700", type: "text/css"}
	%link{:rel => "stylesheet", :href => "http://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.1/normalize.min.css"}/
	= javascript_include_tag 'application', 'data-turbolinks-track' => true
	= csrf_meta_tags
%body
	%header.main_header.clearfix
		.wrapper
			#logo
				%p= link_to "TimingJL's Rails Forum", root_path
			#buttons
				= link_to "New Post", new_post_path

	.wrapper
		%p.notice= notice
		%p.alert= alert

	.wrapper
		= yield
```


And let's define what the `.wrapper` is.       
In `app/assets/stylesheets/application.css`, rename `application.css` to `application.css.scss`.
```scss
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
 * or vendor/assets/stylesheets of plugins, if any, can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any styles
 * defined in the other CSS/SCSS files in this directory. It is generally better to create a new
 * file per style scope.
 *
 *= require_tree .
 *= require_self
 */

 body {
 	font-family: 'Lato', sans-serif;
 	background: #EDEFF0;
 }

.wrapper {
	width: 60%;
	max-width: 1140px;
	margin: 0 auto;
}

.clearfix:before, .clearfix:after {
	content: " ";
	display: table;
}

.clearfix:after {
	clear: both;
}

.main_header {
	width: 100%;
	margin: 0 auto;
	background: white;
	#logo {
		float: left;
		a {
			text-transform: uppercase;
			font-weight: 700;
			letter-spacing: -1px;
			font-size: 1.2rem;
			text-decoration: none;
			color:#397CAC;
		}
	}
	#buttons {
		float: right;
		a {
			line-height: 60px;
			background: #397CAC;
			padding: .5em 1em;
			border-radius: 0.2em;
			color: white;
			text-decoration: none;
			font-weight: 100;
		}
	}
}

#posts {
	background: white;
	padding: 2em 5%;
	border-radius: .5em;
	.post {
		margin: 1em 0;
		padding: 1em 0;
		border-bottom: 1px solid #D1d1d1;
		.title {
			margin: 0;
			a {
				color: #397CAC;
				text-decoration: none;
				font-weight: 100;
				font-size: 1.25rem;
			}
		}
		.date {
			margin-top: .25rem;
			font-size: 0.9rem;
			color: #B2BAC2;
		}
	}
}

.button {
	color: #397CAC;
	border: 1px solid #397CAC;
	padding: .5em 1em;
	border-radius: 0.2em;
	text-decoration: none;
	margin-right: 2%;
}

#post_content {
	background: white;
	padding: 2em 5%;
	border-radius: .5em;
	h1 {
		font-weight: 100;
		font-size: 2em;
		color: #397CAC;
		margin-top: 0;
	}
	p {
		color: #B2BAC2;
		font-size: 0.9rem;
		font-weight: 100;
		line-height: 1.5;
	}
	#comments {
		.comment {
			border-bottom: 1px solid #d1d1d1;
			padding-bottom: 1em;
			margin-bottom: 1em;
			.content {
				width: 75%;
				float: left;
			}
			.buttons {
				width: 25%;
				float: left;
				font-size: .8em;
				text-align: right;
				padding-top: 1.5em;
				a {
					color: #397CAC;
					border: 1px solid #397CAC;
					padding: .5em 1em;
					border-radius: 0.2em;
					text-decoration: none;
					margin-right: 2%;
				}
			}
			.comment_content {
				margin: 0;
				padding: 0;
			}
			.comment_author {
				color: #397CAC;
				margin-top: .5rem;
				font-size: 0.6em;
				font-weight: 700;
			}
		}
		input[type="submit"] {
			background: #397CAC;
			border: none;
			color: white;
			font-weight: 100;
			padding: .5em 1em;
			border-radius: .2em;
		}
		textarea {
			width: 100%;
			min-height: 200px;
			border: 1px solid #d1d1d1;
			border-radius: .2em;
			margin: 1em 0;
		}
	}
}

.form-input {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}
```

In `app/views/posts/index.html.haml`
```haml
#posts
	- @posts.each do |post|
		.post
			%h2.title= link_to post.title, post
			%p.date
				Published at
				= time_ago_in_words(post.created_at)
				by
				= post.user.email
```
![image](https://github.com/TimingJL/forum/blob/master/pic/basic_styling.jpeg)

### Style Show Page
In `app/views/posts/show.html.haml`
```haml
#post_content
	%h1= @post.title
	%p= @post.content

	= link_to "Edit", edit_post_path(@post), class: "button"
	= link_to "Delete", post_path(@post), method: :delete, data: { confirm: "Are you sure you want to do this?" }, class: "button"
```


# SignIn, SignOut and SignUp

Only the sign-in user can new a post.      
In `app/views/layouts/application.html.haml`
```haml
!!!
%html
%head
  %title TimingJL's Rails Forum
  = stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true
  %link{ rel: "stylesheet", href: "http://fonts.googleapis.com/css?family=Lato:300,400,700", type: "text/css"}
  %link{:rel => "stylesheet", :href => "http://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.1/normalize.min.css"}/
  = javascript_include_tag 'application', 'data-turbolinks-track' => true
  = csrf_meta_tags
%body
  %header.main_header.clearfix
    .wrapper
      #logo
        %p= link_to "TimingJL's Rails Forum", root_path
      #buttons
        - if user_signed_in?
          = link_to "New Post", new_post_path
          = link_to "Sign Out", destroy_user_session_path
        - else
          = link_to "Sign Up", new_user_registration_path
          = link_to "Sign In", new_user_session_path

  .wrapper
    %p.notice= notice
    %p.alert= alert

  .wrapper
    = yield
```
The :method => :delete part is required if you use the default HTTP method. To change it, you will need to tell Devise this: Under app/config/initializers/devise.rb change
```
# config/initializers/devise.rb
# The default HTTP method used to sign out a resource. Default is :delete.
config.sign_out_via = :delete
```

to

```
# config/initializers/devise.rb
# The default HTTP method used to sign out a resource. Default is :delete.
config.sign_out_via = :get
```

In `app/controllers/posts_controller.rb`
```ruby
before_action :authenticate_user!, except: [:index, :show]
```
So we have the ability to create a post if you sign-in.


# Comment
The last thing we need to do is add comments for each post.
```console
$ rails g model Comment comment:text post:references user:references
$ rake db:migrate
```

### Association
In `app/models/post.rb`
```ruby
class Post < ApplicationRecord
	belongs_to :user
	has_many :comments
end
```

In `app/models/user.rb`
```ruby
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  has_many :comments
end
```

### Some Routes
Now, we need to create some routes for this.
In `config/routes.rb`
```ruby
Rails.application.routes.draw do
  devise_for :users
  resources :posts do
  	resources :comments
  end
 
  root 'posts#index'
end
```

### Controller
Next, let's create a controller.
```console
$ rails g controller Comments
```


### Add Comments
In `app/controllers/comments_controller.rb`
```ruby
class CommentsController < ApplicationController
	def create
		@post = Post.find(params[:post_id])
		@comment = @post.comments.create(params[:comment].permit(:comment))
		@comment.user_id = current_user.id if current_user	

		if @comment.save
			redirect_to post_path(@post)
		else
			render 'posts/show'
		end
	end
end
```


Next, we need to add some views for our comments.        
In `app/views/comments/`
	1. _form.html.haml
	2. _comment.html.haml

In `app/views/comments/_comment.html.haml`
```haml
.comment
	%p= comment.comment
	%p= comment.user.email
```



In `app/views/comments/_form.html.haml`
```haml
= simple_form_for([@post, @post.comments.build]) do |f|
	= f.input :comment
	= f.submit
```


And in `app/views/posts/show.html.haml`
```haml
#post_content
	%h1= @post.title
	%p= @post.content

	#comments
		%h2
			= @post.comments.count
			Comments
		= render @post.comments

		%h3 Reply to thread
		= render "comments/form"

	%br/
	%hr/
	%br/

	= link_to "Edit", edit_post_path(@post), class: "button"
	= link_to "Delete", post_path(@post), method: :delete, data: { confirm: "Are you sure you want to do this?" }, class: "button"
```


### Edit & Destroy Comments
In `app/controllers/comments_controller.rb`
```ruby
class CommentsController < ApplicationController
	before_action :find_post

	def create
		@comment = @post.comments.create(params[:comment].permit(:comment))
		@comment.user_id = current_user.id if current_user	

		if @comment.save
			redirect_to post_path(@post)
		else
			render 'posts/show'
		end
	end

	def edit
		@comment = @post.comments.find(params[:id])
	end

	def update
		@comment = @post.comments.find(params[:id])

		if @comment.update(params[:comment].permit(:comment))
			redirect_to post_path(@post)
		else
			render 'edit'
		end
	end

	def destroy	
		@comment = @post.comments.find(params[:id])
		@comment.destroy
		redirect_to post_path(@post)
	end	


	private

	def find_post
		@post = Post.find(params[:post_id])
	end

end
```


Let's go to the `app/views/comments/_comment.html.haml`
```haml
.comment.clearfix
	.content
		%p.comment_content= comment.comment
		%p.comment_author= comment.user.email
	.buttons
		= link_to "Edit", edit_post_comment_path(comment.post, comment)
		= link_to "Delete", [comment.post, comment], method: :delete, data: { confirm: "Are you sure?" }
```


Then. let's add a new file named `edit.html.haml` under `app/views/comments`.
```ruby
%h1 Edit Reply

= simple_form_for([@post, @comment]) do |f|
	= f.input :comment
	= f.submit
```
![image](https://github.com/TimingJL/forum/blob/master/pic/comment2.jpeg)


In `app/views/posts/_from.html.haml`
```haml
= simple_form_for @post do |f|
	= f.input :title, input_html: { class: 'form-input' }
	= f.input :content, input_html: { class: 'form-input' }
	= f.button :submit, class: "button"
```

In `app/views/posts/new.html.haml`
```haml
#post_content
	%h1 New Post
	= render 'form'
```
![image](https://github.com/TimingJL/forum/blob/master/pic/new_post.jpeg)

In `app/views/posts/edit.html.haml`
```haml
#post_content
	%h1 Edit Post
	= render 'form'
	%br/
	= link_to "Cancel", post_path, class: "button"
```
![image](https://github.com/TimingJL/forum/blob/master/pic/edit_post.jpeg)



Finished!