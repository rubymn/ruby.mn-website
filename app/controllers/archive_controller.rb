require 'mailread'
require 'fileutils'
class ArchiveController < ApplicationController
    include FileUtils

  def index
      @mail_pages, @mails = paginate :list_mails, :order=>'stamp desc', :per_page=>50
  end

  def message
      @message = ListMail.find(@params[:id])
      render :action=>'message', :layout=>false
  end

end
