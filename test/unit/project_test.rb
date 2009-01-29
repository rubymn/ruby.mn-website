require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects, :users

  def test_create
    assert_not_nil users(:bob)
    project = Project.new(:title => 'New project', 
                          :description => 'Really New Project',
                          :url => 'http://www.example.com',
                          :source_url => 'http://www.exampel.com',
                          :user_id => users(:bob).id)
    project.user = users(:bob)
    project.save
    loaded = Project.find(project.id)
    assert_not_nil loaded
    assert_equal loaded.user, users(:bob)
  end

  def test_fixtures
    Project.find(:all).each do |e|
      assert e.valid?, "#{e.id} is invalid"
    end
  end
end
