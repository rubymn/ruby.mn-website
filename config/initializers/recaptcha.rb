require 'net/http'

if Rails.env.development?
  ENV['RCC_PRIV'] = 'foo'
  ENV['RCC_PUB']  = 'bar'
  ENV['MH_PRIV']  = 'foo'
  ENV['MH_PUB']   = 'bar'
end

RCC_PUB  = ENV['RCC_PUB']
RCC_PRIV = ENV['RCC_PRIV']
MH_PRIV  = ENV['MH_PRIV']
MH_PUB   = ENV['MH_PUB']

Recaptcha.configure do |config|
  config.public_key  = RCC_PUB
  config.private_key = RCC_PRIV
end
