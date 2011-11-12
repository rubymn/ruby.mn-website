# guard :test, :all_on_start => true do
#   watch('test/test_helper.rb') { "test" }
#   watch('config/routes.rb')    { "test" }
#   watch('app/controllers/application_controller.rb')  { "test/functionals" }
#   watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_controller_test.rb" }
#   watch(%r{^test/.+_test\.rb$})
#   watch(%r{^app/(.+)\.rb$})                           { |m| "test/#{m[1]}_test.rb" }
#   watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "test/functionals/#{m[1]}_controller_test.rb" }
# end

guard 'bundler' do
  watch 'Gemfile'
end
