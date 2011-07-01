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

module X11
  Mask = Class.new(Hash) {
    alias __get__ []

    def [](what)
      self.__get__(what) ||
        self.__get__(what.is_a?(String) ? what.to_sym : what.to_s)
    end
  }.new.merge({
    NoEvent:              0,
    KeyPress:             1,
    KeyRelease:           (1<<1),
    ButtonPress:          (1<<2),
    ButtonRelease:        (1<<3),
    EnterWindow:          (1<<4),
    LeaveWindow:          (1<<5),
    PointerMotion:        (1<<6),
    PointerMotionHint:    (1<<7),
    Button1Motion:        (1<<8),
    Button2Motion:        (1<<9),
    Button3Motion:        (1<<10),
    Button4Motion:        (1<<11),
    Button5Motion:        (1<<12),
    ButtonMotion:         (1<<13),
    KeymapState:          (1<<14),
    Exposure:             (1<<15),
    VisibilityChange:     (1<<16),
    StructureNotify:      (1<<17),
    ResizeRedirect:       (1<<18),
    SubstructureNotify:   (1<<19),
    SubstructureRedirect: (1<<20),
    FocusChange:          (1<<21),
    PropertyChange:       (1<<22),
    ColormapChange:       (1<<23),
    OwnerGrabButton:      (1<<24),
    Shift:                1,
    Lock:                 (1<<1),
    Control:              (1<<2),
    Mod1:                 (1<<3),
    Mod2:                 (1<<4),
    Mod3:                 (1<<5),
    Mod4:                 (1<<6),
    Mod5:                 (1<<7)
  }).freeze
end
