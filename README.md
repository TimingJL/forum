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