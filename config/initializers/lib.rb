# must be implicitly required or else it will never load, rails does some late binding things for their open classes
require File.join(Rails.root, 'lib/flash.rb')
