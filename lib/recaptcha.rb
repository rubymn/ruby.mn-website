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
  
  def get_challenge(error='')
    "<script type=\"text/javascript\" src=\"#{@proto}://#{@host}/challenge?k=#{CGI.escape(@pubkey)}&error=#{CGI.escape(error)}\"> </script>"
  end

  def last_error
    @last_error
  end
  def validate(remoteip, challenge, response, errors)
    msg = "Captcha failed."
    return true if remoteip == '0.0.0.0'
    if not response
      errors.add_to_base(msg)
      return false
    end
    http = Net::HTTP.new(@vhost, 80)
    path='/verify'
    data = "privatekey=#{CGI.escape(@privkey)}&remoteip=#{CGI.escape(remoteip)}&challenge=#{CGI.escape(challenge)}&response=#{CGI.escape(response)}"
    resp, data = http.post(path, data, {'Content-Type'=>'application/x-www-form-urlencoded'})
    response = data.split
    result = response[0].chomp
    @last_error=response[1].chomp
    errors.add_to_base(msg) if  result != 'true'
    result == 'true' 

  end

end
