class ForHireController < ApplicationController
  before_filter :login_required, :except=>[:index]

  def index
    @for_hires = ForHire.find :all, :order=>'title'
  end

  def create
    if request.post? and params['for_hire']['id'].nil?
      if (fh = ForHire.new params['for_hire'])
        fh.user = current_user
        fh.save
        redirect_to :action=>'index'
      else
        render_text 'Error saving.'
      end
    elsif request.post? and !params['for_hire'][:id].nil?
      update 
    else
      render :action=>'for_hire_form'
    end
  end

  def destroy
    fh = ForHire.find(params[:id])
    if fh.user == current_user
      fh.destroy
      redirect_to :action=>'index'
    else
      session[:uid] = nil;
      redirect_to :controller=>'welcome', :action=>'index'
    end
  end


  def edit
    if !params[:id].nil?
      @for_hire=ForHire.find(params[:id])
      if  not (@for_hire.user == current_user)
        session[:uid] = nil
        redirect_to :controller=>'welcome', :action=>'index'
      else
        render :action=>'for_hire_form'
      end

    else
        render :action=>'for_hire_form'
    end

  end

  def update 
    fh = ForHire.find params['for_hire'][:id]
    if fh.user == session[:uid]
      if fh.update_attributes params['for_hire']
        redirect_to :action=>'index'
      else
        render_text 'Error Saving'
      end
    else
      session[:uid] = nil
      redirect_to :controller=>'welcome', :action=>'index'
    end

  end
end
