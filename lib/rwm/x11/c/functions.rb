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
  module C
    attach_function :XOpenDisplay, [:string], :pointer
    attach_function :XCloseDisplay, [:pointer], :int

    attach_function :XGrabButton, [:pointer, :uint, :uint, :Window, :Bool, :uint, :int, :int, :Window, :Cursor], :int
    attach_function :XGrabKey, [:pointer, :int, :uint, :Window, :Bool, :int, :int], :int
    attach_function :XGrabKeyboard, [:pointer, :Window, :Bool, :int, :int, :Time], :int
    attach_function :XGrabPointer, [:pointer, :Window, :Bool, :uint, :int, :int, :Window, :Cursor, :Time], :int

    attach_function :XUngrabButton, [:pointer, :uint, :uint, :Window], :int
    attach_function :XUngrabKey, [:pointer, :int, :uint, :Window], :int
    attach_function :XUngrabKeyboard, [:pointer, :Time], :int
    attach_function :XUngrabPointer, [:pointer, :Time], :int

    attach_function :XGetWindowAttributes, [:pointer, :Window, :pointer], :int
    attach_function :XMoveResizeWindow, [:pointer, :Window, :int, :int, :uint, :uint], :int
    attach_function :XRaiseWindow, [:pointer, :Window], :int

    attach_function :XNextEvent, [:pointer, :pointer], :int
    attach_function :XCheckTypedEvent, [:pointer, :int, :pointer], :Bool

    attach_function :XStringToKeysym, [:string], :KeySym
    attach_function :XKeysymToKeycode, [:pointer, :KeySym], :KeyCode
  end
end
