require 'mailread'
require 'fileutils'
class ArchiveController < ApplicationController
    include FileUtils

  def index
      @mail_pages, @mails = paginate :list_mails, :order=>'stamp desc', :per_page=>50, :conditions=>"parent_id is null"
  end

  def message
      @message = ListMail.find(params[:id])
  end

  def show
    @message = ListMail.find(params[:id])
  end

end
