class LinkController < ApplicationController
    before_filter :login_required

    def index
        @links = Link.find(:all, :order=>'score desc')
    end

    def delete
        link = Link.destroy(params[:id])
        redirect_to :action=>'index'
    end

    def create
        link = Link.new(params[:link])
        link.user=session[:user]
        if link.save
            render :partial=>'links', :locals=>{:links=>link}, :layout=>false
        else
            throw link.errors
        end
    end

    def bump
        link = Link.find(params[:id])
        link.score+=1
        link.save
        render_text link.score

    end

    def redirect
        link = Link.find(params[:id])
        link.clicked+=1
        link.save
        redirect_to params[:url]

    end
end
