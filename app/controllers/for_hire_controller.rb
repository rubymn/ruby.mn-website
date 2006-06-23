class ForHireController < ApplicationController
  before_filter :login_required

  def index
    @for_hires = ForHire.find :all, :order=>'title'
  end

  def create
    if @request.post? and @params['for_hire']['id'].nil?
      if (fh = ForHire.new @params['for_hire'])
        fh.user = session[:user]
        fh.save
        redirect_to :action=>'index'
      else
        render_text 'Error saving.'
      end
    elsif @request.post? and !params['for_hire'][:id].nil?
      update 
    else
      render :action=>'for_hire_form'
    end
  end

  def destroy
    fh = ForHire.find(@params[:id])
    if fh.user == session[:user]
      fh.destroy
      redirect_to :action=>'index'
    else
      session[:user] = nil;
      redirect_to :controller=>'welcome', :action=>'index'
    end
  end


  def edit
    if !@params[:id].nil?
      @for_hire=ForHire.find(@params[:id])
      if !(@for_hire.user == session[:user])
        session[:user] = nil
        redirect_to :controller=>'welcome', :action=>'index'
      else
        render :action=>'for_hire_form'
      end

    else
        render :action=>'for_hire_form'
    end

  end

  protected
  def update 
    fh = ForHire.find @params['for_hire'][:id]
    if fh.user == session[:user]
      if fh.update_attributes @params['for_hire']
        redirect_to :action=>'index'
      else
        render_text 'Error Saving'
      end
    else
      session[:user] = nil
      redirect_to :controller=>'welcome', :action=>'index'
    end

  end
end
