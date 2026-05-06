# Ruby IRB (interactive Ruby) configuration. HISTORICAL - Ruby not actively used.
# Enables tab completion and saves IRB history. source_for() helper uses gvim.
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

IRB.conf[:SAVE_HISTORY] = 1000

