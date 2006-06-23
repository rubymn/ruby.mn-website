module LinkHelper
    def link_to_redirect link
        link_to link.title, url_for(:action=>'redirect', 
                                          :controller=>'link', :url=>link.url,:id=>link.id)
    end

end
