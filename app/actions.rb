# Homepage (Root path)
helpers do

  def password_auth(user)
    input_user = User.find_by(username: user.username)
    if input_user
      input_user.password == user.password
    end
  end

  def current_user
    User.find_by(id: session[:user_id]) || User.new(username: 'stranger')
  end

end

get '/' do
  @message = session[:message]
  @message = session.delete(:message)
  erb :index
end

get '/music' do
  @musics = Music.includes(:upvotes).order('count(upvotes.id) desc').references(:upvotes).group('musics.id')
  erb :'music/index'
end

get '/music/new' do
  @music = Music.new
  erb :'music/new'
end

get '/song/:id/upvote' do
  @song = Music.find(params[:id])
  @upvote = Upvote.new(
    music: @song,
    user: current_user
  ).save
  redirect '/music'
end

get '/songs/:id' do
  @song = Music.find(params[:id])
  @song_reviews = Review.where(music: @song)
  @review = Review.new
  erb :'songs/show'
end

post '/songs/review' do
  # binding.pry
  @song = Music.find(params[:id])
  @review = Review.new(
    subject: params[:subject],
    comment: params[:comment],
    user: current_user,
    music_id: params[:id],
    rating: params[:rating]
    )
  if @review.save
    redirect '/songs/'+params[:id]
  end
end

get '/song/:id/delete' do
  Review.where(music_id: params[:id], user: current_user).destroy_all
  redirect '/songs/' + params[:id]
end

get '/signup' do
  @user = User.new
  erb :signup
end

get '/login' do
  @user = User.new
  erb :login
end

get '/logout' do
  session.clear
  redirect '/'
end

post '/login' do
  @user = User.new(
    username: params[:username],
    password: params[:password]
  )
  if password_auth(@user)
    session[:message] = "WELCOME BACK SENPAI #{@user.username}, DON'T YOU EVER LEAVE ME AGAIN!"
    session[:user_id] = User.find_by(username: @user.username).id
    redirect '/'
  else
    @login_fail_message = "YOU ARE NOT TRUE SENPAI, DON'T LIE TO ME! (login information is wrong)"
    erb :login
  end
end

post '/signup' do
  @user = User.new(
    username: params[:username],
    password: params[:password]
  )
  if @user.save
    redirect '/'
  else
    erb :signup
  end
end

post '/music' do
  @music = Music.new(
    song_title: params[:song_title],
    artist: params[:artist],
    author: current_user.username,
    url: params[:url]
  )
  if @music.save
    redirect '/music'
  else
    erb :'music/new'
  end
end