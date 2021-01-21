require 'pry'
class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end 

  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'/figures/new'
  end 

  post '/figures' do
    #binding.pry
    @figure = Figure.create(name: params[:figure][:name])

    #if there's a new title, add the new title
    if !params[:title][:name].empty?
      @title = Title.create(name: params[:title][:name])
      @figure.titles << @title
    end 

    #If there's a new landmark, add the new landmark
    if !params[:landmark][:name].empty?
      @landmark = Landmark.create(name: params[:landmark][:name])
      @landmark.figure = @figure
      @landmark.save
    end 

    #Return the title ids thing to a damn integer, find the title, and add it to the figure's titles.
    @title_ids = params[:figure][:title_ids]
    @title_ids.each do |id|
      n = id.gsub("title_", "").to_i
      @figure.titles << Title.find(n)
    end

    #Return the landmark ids to a damn integer, find the landmark, and set the landmark's figure to the current figure object
    @landmark_ids = params[:figure][:landmark_ids]
    #Assign the array of landmark IDs to a variable
    @landmark_ids.each do |id|
        #To each item in the array...
        n = id.gsub("landmark_", "").to_i
        #Strip all the decoratext and turn it back to an integer
        @landmark = Landmark.find(n)
        #Find the landmark by that integer
        @landmark.figure = @figure
        #Assign the landmark to the figure object currently in question
        @landmark.save 
        #Save it?
    end

    redirect to "/figures/#{@figure.id}" 
  end 

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'/figures/show'
  end 

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'/figures/edit'
  end 

  patch '/figures/:id' do
    @figure = Figure.find(params[:id])
    @figure.update(name: params[:figure][:name])
    @title_ids = params[:figure][:title_ids]
    @title_ids.each do |id|
      n = id.gsub("title_", "").to_i
      @figure.titles << Title.find(n)
    end
    @figure.save
    erb :'/figures/show'
  end 
end
