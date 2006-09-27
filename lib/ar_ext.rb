ActiveRecord::Base.class_eval do
  # Write a fixture file for testing
  def self.to_fixture(fixture_path = nil)
    File.open(File.expand_path(fixture_path || "test/fixtures/#{table_name}.yml", RAILS_ROOT), 'w') do |out|
      YAML.dump find(:all).inject({}) { |hsh, record| hsh.merge(record.id => record.attributes) }, out
    end
  end
end
