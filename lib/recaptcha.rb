require 'net/http'
require 'net/https'
class ReCaptchaClient

  def initialize(pubkey, privkey, ssl=true)
    @pubkey = pubkey
    @privkey=privkey
    @host = ssl ? 'api-secure.recaptcha.net':'api.recaptcha.net'
    @vhost = 'api-verify.recaptcha.net'
    @proto = ssl ? 'https' : 'http'
    @ssl = ssl
  end
  
  def get_challenge
    "<script type=\"text/javascript\" src=\"#{@proto}://#{@host}/challenge?k=#{@pubkey}\"> </script>"
  end

  def validate(remoteip, challenge, response, errors)
    return true if remoteip == '0.0.0.0'
    if not response
      errors.add_to_base("Captcha failed. Try again (unless you're a bot)")
      return false
    end
    http = Net::HTTP.new(@vhost, 80)
    path='/verify'
    data = "privatekey=#{CGI.escape(@privkey)}&remoteip=#{CGI.escape(remoteip)}&challenge=#{CGI.escape(challenge)}&response=#{CGI.escape(response)}"
    resp, data = http.post(path, data, {'Content-Type'=>'application/x-www-form-urlencoded'})
    response = data.split
    result = response[0].chomp
    err = response[1].chomp
    errors.add_to_base("Captcha failed. Try again (unless you're a bot).") if (errors and  result != 'true')
    return result == 'true' 

  end

end
