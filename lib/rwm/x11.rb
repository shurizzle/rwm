#--
# Copyleft shura. [ shura1991@gmail.com ]
#
# This file is part of rwm.
#
# rwm is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# rwm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with rwm. If not, see <http://www.gnu.org/licenses/>.
#++

require 'rwm/x11/c'
require 'rwm/x11/types'
require 'rwm/x11/events'
require 'rwm/x11/masks'

class String
  def to_keysym
    X11::C.XStringToKeysym(self)
  end

  def to_keycode (dpy=nil)
    to_keysym.to_keycode(dpy)
  end
end

class Fixnum
  def to_keycode! (dpy=nil)
    (dpy || ObjectSpace.each_object(X11::Display).first || X11::Display.new).
      keysym_to_keycode(self).tap {|kc|
      kc.instance_eval {
        keycode!
      }
    }
  end

  def to_keycode (dpy=nil)
    keycoded? ? self : to_keycode!
  end

  def to_c
    self
  end

  private
  def keycoded?
    @kc ||= false
  end

  def keycode!
    @kc = true
  end
end

module X11
  ComboMod = Hash.new {|*|
    raise ArgumentError, "Modifier doesn't exist"
  }.merge!({
    'W' => Mask[:Mod4],
    'S' => Mask[:Shift],
    'A' => Mask[:Mod1],
    'C' => Mask[:Control]
  }).freeze

  def self.combo (str)
    *mods, key = str.split('-')
    mods = mods.map {|mod|
      ComboMod[mod]
    }.inject(:|)

    [mods, key]
  end
end
