class TweetsController < ApplicationController

  get '/tweets' do
    if  logged_in?
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if  logged_in?
      erb :'tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if params[:content] == ""
      redirect to "/tweets/new"
    else
      @tweet = current_user.tweets.create(content: params[:content])
      redirect to "/tweets/#{@tweet.id}"
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = current_tweet
      if current_user.id
       erb :'tweets/edit_tweet'
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end
  end

  patch '/tweets/:id' do
    if params[:content] == ""
      redirect to "/tweets/#{params[:id]}/edit"
    else
      @tweet = current_tweet
      @tweet.content = params[:content]
      @tweet.update(content: params[:content])
      if @tweet.save
        redirect to "/tweets/#{@tweet.id}"
      else
        redirect to "/tweets/#{@tweet.id}/edit"
      end
    end
  end

  delete '/tweets/:id/delete' do
    if logged_in?
      @tweet = current_tweet
      if @tweet.user_id == current_user.id
        @tweet.delete
        redirect to '/tweets'
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end
  end

end
