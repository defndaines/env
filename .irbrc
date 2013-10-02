require 'irb/completion'
require 'irb/ext/save-history'

def irb_verbosity_toggle
  irb_context.echo ^= true
end

def source_for(object, method)
  location = object.method(method).source_location
  `gvim #{location[0]} +#{location[1]}` if location
  location
end
