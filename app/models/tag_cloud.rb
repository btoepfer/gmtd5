# Diese Klasse bündelt alle Funktionen zum Erzeugen einer TagCloud für einen User
# Hierzu werden alle Tags des Users, die in mindestens einer Notiz verwendet werden
# berücksichtigt. Auf Basis der Häufigkeit der Zuordnung werden den Tags unterschiedliche
# Klassen zugeordnet, die die Schriftgröße und -farbe definieren.
# Es werden die maximal 30 meist verwendeten Tags angezeigt.
# Instanceattribute:
# tags: die 30 meist verwendeten Tags als Array of Hashes in der Form
#       [{name: xxx, id: 111, tag_count: 23}, {}, ...]
#
# Instancemethoden
# html: diese liefert ein array mit der kompletten Cloud als anklickbare Links
#       ["<span class='tc-lg'><a href=notes?t=111>xxx</a></span>"]

class TagCloud
  attr_reader :tags
  
  def initialize(user)
    @max = 0
    @min = 100000000000000000
    @tags = get_tags(user)
  end
  
  def html
    html_cloud = []
    self.tags.each do |tag|
      html_cloud << "<span class=\"#{get_class(tag[:tag_count])}\"><a href=notes?t=#{tag[:id]}>#{tag[:name]}</a></span>"
    end
    html_cloud
  end
  
  private 
  def get_tags(user)
    rcr = []
    
    # Generiert das folgende SQL-Statement:
    # SELECT  COUNT(*) AS count_all, tags.id AS tags_id, tags.name AS tags_name 
    #   FROM "tags" 
    #   INNER JOIN "notes_tags" ON "notes_tags"."tag_id" = "tags"."id" 
    #   INNER JOIN "notes" ON "notes"."id" = "notes_tags"."note_id" 
    #  GROUP BY tags.id, tags.name  
    #  ORDER BY count(tags.id) desc 
    #  LIMIT 30
    tags = Tag.joins(:notes).group('tags.id', 'tags.name').order("count(tags.id) desc").limit(30).count
    
    # Nun erzeugen wir ein Arrays von Hashes
    # der Form [{tag_count: 23, id:11, name: xxx}, {}, ...]
    rcr = tags.map do |tag|
      rc = {}
      rc[:tag_count] = tag[1]
      rc[:id]        = tag[0][0]
      rc[:name]      = tag[0][1]
      
      # ... und berechnen den Maximal und Minimalwert
      @max = rc[:tag_count] if rc[:tag_count] > @max
      @min = rc[:tag_count] if rc[:tag_count] < @min
      
      # Als Ergebnis geben wir einen Hash zurück
      rc
    end
    
    # Sortierung des Hashes nach dem Namen in Großbuchstaben
    return rcr.sort_by {|rc| rc[:name].upcase}
  end
  
  def get_class(tag_count)
    rc = ""
    v1 = ((@max - @min)/4).floor
    v_arr = [@min+v1, @min+v1*2, @max-v1]
    c = tag_count.to_i
    if c <= v_arr[0] then
      rc = "tc-xs"
    elsif c.between?(v_arr[0], v_arr[1])  then
      rc = "tc-md"
    elsif c.between?(v_arr[1], v_arr[2])  then
      rc = "tc-lg"
    else
      rc = "tc-xl"
    end
    return rc
  end
  
  
end
