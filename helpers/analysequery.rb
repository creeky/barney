require 'cgi'

#out = "GID=0&txtsd=11000%231%231&txtTKN=10E6C05295FA4856B1D9F7E4955FA8D7020301&txtGTKN=&sitegroupid=&txtc1text=&txtc1id=0&txtc1idtable=0&txtc2text=&txtc2id=0&txtc2idtable=0&txtNPID=1020&txtPPID=4380&txtCPID=1020&txtLCP=1020&txtCurrentPageID=1020&txtPLBTID=0&txtClassID=1&txtNavigationPB=languageid%3D5%3Bdeviceid%3D0%3Bpageid%3D1020%3Bsiteid%3D11000%3BSiteContentTypeID%3D1%3Boddstypeid%3D2%3Bserverid%3D0%3Bclassificationid%3D78%3Btimezoneid%3D4%3Bdisplayoddstypeid%3D2%3Blanguageprefix%3Dger&txtSiteNavigationPB=pagetemplateid%3D1020%3Bc1text%3D%3Bc1textselect%3D%3Bc2text%3D%3Bc3text%3D%3Bchallengeid%3D0%3Bplbtid%3D0%3Bfixtureid%3D0%3Bplayerid%3D0%3Bcompetitionid%3D0%3Bcardcouponid%3D0%3Bpopupid%3D0%3Blotterycode%3D%3Bpopupneed%3D0%3Bc1id%3D0%3Bc1idtable%3D0%3Bc2id%3D0%3Bc2idtable%3D0%3Bc3id%3D0%3Bc3idtable%3D0%3Bc1idselected%3D0%3Bc1idtableselected%3D0%3Bc2idselected%3D0%3Bc2idtableselected%3D0%3Bc3idselected%3D0%3Bc3idtableselected%3D0%3Bc4idselected%3D0%3Bc4idtableselected%3D0%3Bsectionid%3D0%3Bsplashoption%3D%3BresultTime%3D00%3A00%3A00%3Bnext24hr%3Dfalse%3Bclassificationid%3D1%3Bdummy%3D0%3Bcouponselected%3D&txtSiteNavigationCachePB=pagetemplateid%3D1020%3Bc1text%3D%3Bc1textselect%3D%3Bc2text%3D%3Bc3text%3D%3Bchallengeid%3D0%3Bplbtid%3D0%3Bfixtureid%3D0%3Bplayerid%3D0%3Bcompetitionid%3D0%3Bcardcouponid%3D0%3Bpopupid%3D0%3Blotterycode%3D%3Bpopupneed%3D0%3Bc1id%3D0%3Bc1idtable%3D0%3Bc2id%3D0%3Bc2idtable%3D0%3Bc3id%3D0%3B"

def analyse_query(out)
  result = ""
  result += "postq = {\n"
  idx = 1
  out.split("&").each {
    |item|
    a,b = item.split("=")
    if b=~/%3B/
      result += "  \"#{a}\" => {\n"
      subidx = 1
      CGI::unescape(b).split(";").each {
        |subitem|
        c,d = subitem.split("=")
        if (subidx == CGI::unescape(b).split(";").length)
          result += "    \"#{c}\" => \"#{d}\"\n"
        else
          result += "    \"#{c}\" => \"#{d}\",\n"
        end
        subidx+=1
      }
    if (idx == out.split("&").length)
      result += "  }\n"
    else
      result += "  },\n"
    end
    else
      if (idx == out.split("&").length)
        result += "  \"#{a}\" => \"#{b}\"\n"
      else
        result += "  \"#{a}\" => \"#{b}\",\n"
      end
    end
    idx+=1
  }
  result += "}\n"
end

def reform_query(query)
  query.map {
    |item|
    if (item[1].is_a? Hash)
      "#{item[0]}="+
      CGI::escape(item[1].map {
        |a,b|
        "#{a}=#{b}"
      }.join(";"))
    else
      "#{item[0]}=#{item[1]}"
    end
  }.join("&")
end