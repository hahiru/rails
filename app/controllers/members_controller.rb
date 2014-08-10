class MembersController < ApplicationController
  require 'scrape'
  include Scrape
  def index
    default_target = 'http://engawa.open2ch.net'
    default_thread = 'proverty'
    default_url = default_target + '/' + default_thread + '/subback.html'
    @scrape = scrape(default_target,default_thread)
    @target = default_url
    render "index"
  end

  def search
    @scrape = scrape(params[:target],params[:thread])
    render "index"
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
