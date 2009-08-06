require 'cgi'
require 'uri'
require 'net/http'
require 'net/https'

def post_request(url, postbody, headers={})
  url = URI.parse(url)
  req = Net::HTTP::Post.new(url.path)
  req["Content-Length"] = postbody.length
  headers.each_pair {
    |k, v|
    req[k] = v
  }

  req.set_content_type("application/x-www-form-urlencoded")
  req.body = postbody
  res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }

  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    yield res.body if block_given?
  else
    res.error!
  end
end

def get_request(url, headers={}, use_ssl=false)
  url = URI.parse(url)
  req = Net::HTTP::Get.new(url.path + (url.query.empty? ? '' : '?' + url.query))
  headers.each_pair {
    |k, v|
    req[k] = v
  }

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = use_ssl
  res = http.start { |http| http.request(req) }
  
  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    yield res.body if block_given?
  else
    res.error!
  end
end



class CGI
  def CGI.unescapeallHTML(html)
    unescapeHTML(html).gsub('&auml;', 'ä').gsub('&Auml;', 'Ä').gsub('&uuml;', 'ü').gsub('&Uuml;', 'Ü').gsub('&ouml;', 'ö').gsub('&Ouml;', 'Ö')
  end
end

def geturl(url)
  res = Net::HTTP.get_response(URI.parse(url))
  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    res.body
  else
    res.error!
  end
end
