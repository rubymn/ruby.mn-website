class OpeningController < ApplicationController
  before_filter :login_required
  def index
    @openings = Opening.find(:all)
  end

  def create
    if request.get?
      render :action=>'opening_form'
    end
    if request.post? and params['opening']['id'].nil? 
      evt = Opening.new params["opening"]
      evt.user=current_user
      evt.save
      redirect_to :action=>"index"
      Notifier.deliver_notify_opening(evt)


    elsif request.post? and !params['opening']['id'].nil?
      evt = Opening.find(params['opening']['id'])
      evt.update_attributes params["opening"]
      redirect_to :action=>'index'
    end
  end
  def edit
    id = params[:id]
    if request.get? and @opening=Opening.find(id)
      @id=id
      if @opening.user == current_user
        render :action=> 'opening_form'
      else
        session[:uid] = nil
        redirect_to :controller=>'welcome'
      end
    end
  end
  def destroy
    u = current_user
    id=params[:id]
    evt = Opening.find(id)
    if u.openings.include? evt
      evt.destroy
      redirect_to :action=>'index'
    else
      session[:uid]=nil
      redirect_to :controller=>"welcome", :action=>'index'
    end

  end

end
