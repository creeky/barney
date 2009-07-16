#require 'script/_testing/helpers/urltools.rb'
require 'helpers/urltools.rb'
#require 'script/_testing/helpers/dbtools.rb'
require 'helpers/dbtools.rb'
#require 'script/_testing/helpers/analysequery.rb'
require 'helpers/analysequery.rb'
#require 'script/_testing/helpers/gameparsers.rb'
require 'helpers/gameparsers.rb'

require 'pp'

$betsports = {
  1 => "Soccer",
  13 => "Tennis",
  16 => "Baseball"
}

$getids = [1, 13, 16]
$checkout = []

$bookmaker = "bet365"

$postq = {
  "txtCurrentPageID" => "1020",
  "txtClassID" => "%d",
  "txtNavigationPB" => {},
  "txtSiteNavigationPB" => {},
  "txtSiteNavigationCachePB" => {}
}

$queryformat = reform_query($postq)
reg = /onclick="javaScript:gPC2\((\d+),'','(\d+)','(\d+)','','(\d+)','(\d+)','','','',(\d+)\);return false;">([^<]+)<\/a>/

$getids.each {
  |sportid|
  out = $queryformat % sportid

  headers = {
    "Cookie" => "aps03=lng=5&cf=N"
  }

  post_request('http://81.94.208.20/home/mainpage.asp', out, headers) {
    |text|
    #File.open(File.dirname(__FILE__) + "/dump#{sportid}.html", "w") { |f| f.write(text); f.close }

    text.scan(reg).each {
      |betmode|
      case sportid
	# FÜR WAS STEHEN DIE EINZELNEN BETMODES??????????
      when 13:
        $checkout.push betmode if ((betmode[2] == "50") && (betmode[4] == "1"))
      when 1:
        $checkout.push betmode if (betmode[2] == "13")
      when 16:
	$checkout.push betmode if (betmode[3] == "1")
      end
    }
  }
}

$postq = {
  "txtNavigationPB" => {},
  "txtSiteNavigationPB" => {
    "dummy" => "0"
  },
  "txtSiteNavigationCachePB" => {}
}

$matches = []

$checkout.each {
  |league|
  $postq["txtClassID"] = league[5]
  $postq["txtNPID"] = league[0]
  $postq["txtSiteNavigationPB"]["c1id"] = league[1]
  $postq["txtSiteNavigationPB"]["c1idtable"] = league[2]
  $postq["txtSiteNavigationPB"]["c2idtable"] = league[4]
  $postq["txtSiteNavigationPB"]["c2id"] = league[3]

  out = reform_query($postq)

  headers = {"Cookie" => "aps03=lng=5&cf=N"}

  post_request('http://81.94.208.20/home/mainpage.asp', out, headers) {
    |text|
   File.open("dump/dump#{league[0]}_#{league[1]}_#{league[2]}_#{league[3]}_#{league[4]}_#{league[5]}.html", "w") { |f| f.write(text+league[6]); f.close }
    parsed = parse_league(text, league[5])
    parsed.each {
      |item|
      item["data"].each {
        |data|
        case league[5]
        when 13:
          match = [league[5], league[6], data[0], data[1], data[2], data[3], nil, data[4]]
        else
          match = [league[5], league[6], data[0], data[1], data[2], data[3], data[4], data[5]]
        end
        $matches << match.map { |x| (x.is_a?(String) ? CGI::unescapeallHTML(x) : x) }
      }
    }
  }
}

File.open("output.txt", "w") { 
|f| 
$matches.each { |match|
	f.puts match
}
f.close }

$matches.each { |match|
  $sport = $betsports[match.shift.to_i]
  #quote = register_quote(match)
}
