class RoommatesController < ApplicationController

get '/signup' do
  if session[:user_id]
    redirect to '/chores'
  else
    erb :'roommates/create_roommate'
  end
end

post '/signup' do
  # also check if params[:household][:id] AND params[:household][:name] are both not blank
  if params[:name] == "" || params[:password] == "" || (params[:household][:id] == "" && params[:household][:name] == "")
    redirect to '/signup'
  else
    @roommate = Roommate.new(:name => params[:name], :password => params[:password])
      if params[:household][:name] != ""
        @household = Household.create(:name => params[:household][:name])
      else
        @household = Household.find(params[:household][:id])
      end
    @roommate.household = @household
    @household.roommates << @roommate
    # conditionally set a roomate to a household (create houshold if params[:household][:name])
    # conditionally set a roomate to a household (find by params[:household][:id] if selected)
    @roommate.save
    @household.save
    session[:roommate_id] = @roommate.id

    redirect to '/chores'
  end
end

get '/login' do
  if session[:roommate_id]
    redirect to '/chores'
  else
    erb :'roommates/login'
  end
end

post '/login' do
  user = Roommate.find_by(:name => params[:name])
  if user && user.authenticate(params[:password])
    session[:roommate_id] = user.id
    redirect to '/chores'
  else
    redirect to '/signup'
  end
end

get '/logout' do
  if logged_in?
    session.clear
    redirect to '/login'
  else
    redirect to '/login'
  end
end

end
