##################################################
### Find move destinations #######################
##################################################

module Destinations
  def all_extensions_for filename
    destination_map.keys.map{ |extension|
      safe_extension=Regexp.escape(extension)
      (filename =~ Regexp.new("#{safe_extension}$")) ? extension : nil
    }.compact
  end
  
  def destination_for filename
    longest_extension=
      all_extensions_for(filename).sort{|a,b| 
      -(a<=>b)
    }[0]

    destination_map[longest_extension]
  end
end
