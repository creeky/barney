def correct_quote(quote)
  return -1.0 if quote.nil?
  quote = quote.to_f
  if (quote.abs > 100)
    return quote/100 if (quote > 0)
    return ((100/quote.abs+1)*100).round/100 if (quote < 0)
  else
    return quote if quote > 0
  end

  return -1.0
end

$sport_cache = {
}

def get_sport(sport)
  if ($sport_cache.has_key? $bookmaker) && ($sport_cache[$bookmaker].has_key? sport)
    return $sport_cache[$bookmaker][sport]
  else
    return sport
  end
end

$logpath = "dbtools.log"
$log = File.open($logpath, "w")

def log(s)
  $log << s << "\n"
end

def register_quote(args)
  leaguename, date, team1_name, team2_name, q1, qx, q2 = args

  q1 = correct_quote(q1)
  qx = correct_quote(qx)
  q2 = correct_quote(q2)

  needupdate = false

  $sport = get_sport($sport)

  unless ($obj_cache[:sport] && ($obj_cache[:sport].name == $sport))
    $obj_cache[:sport] = Sport.find_by_name($sport) || Sport.create(:name => $sport)
    needupdate = true
  end

  unless ($obj_cache[:bookmaker] && ($obj_cache[:bookmaker].name == $bookmaker))
    $obj_cache[:bookmaker] = Bookmaker.find_by_name($bookmaker) || Bookmaker.create(:name => $bookmaker)  
    needupdate = true
  end

  if (needupdate || !($obj_cache[:league] && ($obj_cache[:league].name == leaguename)))
    $obj_cache[:league] = League.find_for_bookmakerid($obj_cache[:bookmaker].id, leaguename)
    unless $obj_cache[:league]
      $obj_cache[:league] = $obj_cache[:sport].leagues.find(:first, :conditions => ['name = ?', leaguename])
      unless $obj_cache[:league]
        $obj_cache[:league] = $obj_cache[:sport].leagues.create(:name => leaguename)
        $obj_cache[:league].leagueindices.create(:bookmaker_id => $obj_cache[:bookmaker].id, :name => leaguename)
      end
    end
  end

  team1 = Team.find_or_create_for_bookmakerid_and_sport($obj_cache[:bookmaker].id, $obj_cache[:sport], team1_name)
  team2 = Team.find_or_create_for_bookmakerid_and_sport($obj_cache[:bookmaker].id, $obj_cache[:sport], team2_name)

  game = Game.find_by_leagueid_and_teamids($obj_cache[:league].id, team1.id, team2.id)
  unless game
    game = $obj_cache[:league].games.create(:team_id_1 => team1.id, :team_id_2 => team2.id)
  end

  oldquote = game.quotes.find(:first, :conditions => ["bookmaker_id = ?", $obj_cache[:bookmaker].id])
  if oldquote
    oq1 = oldquote.quote_one; oq2 = oldquote.quote_two; oqt = oldquote.quote_tie
    if ((oq1 != q1) || (oq2 != q2) || (oqt != qx))
      log "UPDATE: (Team1: #{team1.name}, Team2: #{team2.name}, Bookmaker: #{$obj_cache[:bookmaker].name}, GameID: #{game.id}) 1X2 [#{oq1}, #{oqt}, #{oq2}] -> [#{q1}, #{qx}, #{q2}]"
      oldquote.update_attributes(:quote_one => q1, :quote_tie => qx, :quote_two => q2)
      print "^"
    else
      log "SKIP  : (Team1: #{team1.name}, Team2: #{team2.name}, Bookmaker: #{$obj_cache[:bookmaker].name}, GameID: #{game.id}) 1X2 [#{oq1}, #{oqt}, #{oq2}] -> [#{q1}, #{qx}, #{q2}]"
      print "."
    end
  else
    quote = game.quotes.new(:bookmaker_id => $obj_cache[:bookmaker].id, :quote_one => q1, :quote_tie => qx, :quote_two => q2)
    log "NEW   : (Team1: #{team1.name}, Team2: #{team2.name}, Bookmaker: #{$obj_cache[:bookmaker].name}, GameID: #{game.id}) 1X2 [#{q1}, #{qx}, #{q2}]"
    success = quote.save
    print (success ? '*' : 'F')
  end
end

$obj_cache = {
  :sport => nil,
  :bookmaker => nil,
  :league => nil
}