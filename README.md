# Learning by Doing 

![Ubuntu version](https://img.shields.io/badge/Ubuntu-16.04%20LTS-orange.svg)
![Rails version](https://img.shields.io/badge/Rails-v5.0.0-blue.svg)
![Ruby version](https://img.shields.io/badge/Ruby-v2.3.1p112-red.svg)

Mackenzie Child's video really inspired me. So I decided to follow all of his rails video tutorial to learn how to build a web app. Through the video, I would try to build the web app by my self and record the courses step by step in text to facilitate the review.


# Project 10: How To Build A Forum With Rails          
This time we built a simple forum application. We have the ability to sign up and sign in / out… Add, Edit, Destroy forum posts, and users can reply to each others forum posts through comments. In this project, we use custom styling instead of bootstrap.


https://mackenziechild.me/12-in-12/10/      


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
	%h2= post.title
	%p
		Published at
		= time_ago_in_words(post.created_at)

= link_to "New Post", new_post_path
```





To be continued...