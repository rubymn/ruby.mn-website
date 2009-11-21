RCC_PRIV='foo'
RCC_PUB='bar'
TCRBB_LIST_ADDRESS='test@example.com'
module CustomHelper
  def login(attr={})
    u = Factory.create(:user, attr)
    @request.session[:uid]=u.id
    u
  end
  def login_as(u)
    session[:uid]=u.id
  end

  def assert_restful_routes(resource)
    "simple case route testing"
    assert_routing "/#{resource}", {:controller=>"#{resource}", :action=>'index'}
    assert_routing "/#{resource}/1", {:controller=>"#{resource}", :action=>'show', :id=>'1'}
    assert_routing "/#{resource}/1/edit", {:controller=>"#{resource}", :action=>'edit', :id=>'1'}
    assert_routing "/#{resource}/new", {:controller=>"#{resource}", :action=>'new'}
    assert_recognizes({:controller=>"#{resource}", :action=>'destroy', :id=>'1'}, {:path=>"/#{resource}/1", :method=>:delete})
    assert_recognizes({:controller=>"#{resource}", :action=>'update', :id=>'1'}, {:path=>"/#{resource}/1", :method=>:put})

    test_methods = ['test_destroy', 'test_update', 'test_edit', 'test_new', 'test_create', 'test_index', 'test_show']
    test_methods.delete_if  {|t|  self.methods.include?(t)}
    fail "You haven't tested all the routes. \nRemaining:\n\t#{test_methods.join("\n\t")}" if test_methods.size != 0
  end
  def assert_bounced
    assert_redirected_to new_session_path
    assert_nil session[:uid]
  end
end
