require 'mailread'
require 'fileutils'

class ArchiveController < ApplicationController
  before_filter :login_required
    include FileUtils


    def search
      @page=params[:page]
      session[:last_search]=params[:search] if params[:search]
      @results = ListMail.find_with_sphinx(session[:last_search], :sphinx=>{:limit=>PER_PAGE, :page=>@page})
      @lm_pages = pages_for(@results.total, :page=>@page)
    end




  def message
      @message = ListMail.find(params[:id])
  end

  def show
  end

end
