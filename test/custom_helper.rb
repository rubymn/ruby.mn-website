RCC_PRIV='foo'
RCC_PUB='bar'
module CustomHelper
  def login(attr={})
    u = Factory.create(:user, attr)
    @request.session[:uid]=u.id
    u
  end
  def login_as(u)
    session[:uid]=u.id
  end

  def assert_bounced
    assert_redirected_to new_session_path
    assert_nil session[:uid]
  end
end
class Test::Unit::TestCase
  def self.should_have_attached_file(attachment)
    klass = self.name.gsub(/Test$/, '').constantize

    context "To support a paperclip attachment named #{attachment}, #{klass}" do
      should_have_db_column("#{attachment}_file_name",    :type => :string)
      should_have_db_column("#{attachment}_content_type", :type => :string)
      should_have_db_column("#{attachment}_file_size",    :type => :integer)
    end

    should "have a paperclip attachment named ##{attachment}" do
      assert klass.new.respond_to?(attachment.to_sym), 
        "@#{klass.name.underscore} doesn't have a paperclip field named #{attachment}"
      assert_equal Paperclip::Attachment, klass.new.send(attachment.to_sym).class
    end
  end
end
