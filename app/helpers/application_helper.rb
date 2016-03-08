module ApplicationHelper
  
  # aus einem Text wird der als search_string übergebene String
  # extrahiert und mit den als fill_text angegeben Trenner 
  # in rot hervorgehoben angezeigt.
  def extract_result (text, search_string, fill_text=nil)
    n = 200 # Anzahl der Zeichen vor und nach dem Suchtext
    
    r = /(#{search_string})/i.match(text)
    
    if search_string and r = /(#{search_string})/i.match(text)  then
      "#{r.pre_match[0..n]}#{fill_text}<span class='text-danger'>#{r}</span>#{fill_text}#{r.post_match[0..n]}"  
    else
      text[0..n*2]
    end
     
  end
  
  
  
end
