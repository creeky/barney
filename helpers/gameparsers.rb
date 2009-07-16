$rx = {
  "split" => {
    "1" => '<table width="565" cellspacing="0" cellpadding="0" border="0" class="o3" xmlns:fo="http://www.w3.org/1999/XSL/Format">',
    "16" => 'NOTHING',
    "12" => 'NOTHING',
    "13" => '<tr class="h1"><td colspan="7" class="bnn xyz"><table width="100%" cellspacing="0" cellpadding="0" border="0" class=""><tr class="b1 rh1">'
  },

  "name" => {
    "1" => /<td class="bn3[^"]*?" width="360">([^<]+)<\/td>/,
    "16" => /<h3 id="cHdr" title="[^"]+">([^<]+)<\/h3>/,
    "12" => /<h3 id="cHdr" title="[^"]+">([^<]+)<\/h3>/,
    "13" => /<td class="bn3[^"]*?" width="360">([^<]+)<\/td><td width="100"/
  },

  "data" => {
    "1" =>
/<td class="acn[^"]*?">(\d+ \w+ \d+:\d+)<\/td>.*?<td class="an3[^"]+?"[^>]+>(.+?) v (.+?)<\/td>.*?<td class="dcpng bcn cbt"*?"[^>]+>(\d+\.\d+).+?<td class="dcpnl bcn cbt"*?"[^>]+>(\d+\.\d+).+?<td class="dcpng bcn cbt"*?"[^>]+>(\d+\.\d+)/m,

    "16" =>
/<td class="acn[^"]*?" rowspan="2" width="60">(\d  \w  \d :\d )<\/td>.*?<td class="ank[^"]*?">[^<]*<\/td>.*?<td class="ank[^"]*?">(. ?) .*?<td class="dcpng cbt bcn".*?">(\d \.\d ).*?<td class="[ab]nk[^"]*?">[^<]*<\/td>.*?<td class="bnk[^"]*?">(. ?)<br>.*?<td class="dcpng bcn".*?">(\d \.\d )/m,

    "12" =>
/<td class="acn[^"]*?" rowspan="2">.*?(\d+ \w+ \d+:\d+)<\/td>.*?<td class="ank[^"]*?">(\d+)<\/td>.*?<td class="ank[^"]*?">(.+?)<\/td>.*?<td class="acn[^"]*?">[+-]\d+\.\d+<\/td>.*?<td class="acn[^"]*?".*?>\d+\.\d+<\/td>.*?<td class="acn[^"]*?">O \d+\.\d+<\/td><td class="acn[^"]*?".*?>(\d+\.\d+)<\/td>.*?<td class="bnk[^"]*?">(\d+)<\/td>.*?<td class="bnk[^"]*?">(.+?)<\/td>.*?<td class="bcn[^"]*?">[+-]\d+\.\d+<\/td><td class="bcn[^"]*?".*?>(\d+\.\d+)<\/td>/m,

  "13" =>
/<td class="acn[^"]*" width="80">(\d+ \w+ \d+:\d+)<\/td><td class="aln[^"]*" width="250">(.+?)\s+  v  \s+([^<]+)<\/td><td id="gp1" class="ars[^"]*">(\d+\.\d+)<[^<]+><\/td><td id="gp1" class="ars[^"]*">(\d+\.\d+)</
  }
}

def parse_league(cont, sportid)
  cont.split($rx["split"][sportid]).map {
    |chunk|
    {
      "name" => chunk.scan($rx["name"][sportid]),
      "data" => chunk.scan($rx["data"][sportid])
    }
  }.delete_if {
    |item|
    (item["name"] == []) || (item["data"] == [])
  }.map {
    |item|
    {
      "name" => item["name"].flatten[0],
      "data" => item["data"]
    }
  }
end

def parse_test(cont, sportid)
  chunks = cont.split($rx["split"][sportid])

  p chunks.length
  id = 0
  chunks.each {
    |chunk|
    File.open("chunk#{id}.html", "w") { |fp| fp.write(chunk) }
    p chunk.scan($rx["name"][sportid])
    p chunk.scan($rx["data"][sportid])
    id+=1
  }
end
