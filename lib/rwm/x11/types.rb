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
  class Display
    def initialize (name=nil)
      pointer = (name.is_a?(String) or !name) ? X11::C.XOpenDisplay(name) : name
      @dpy = pointer.is_a?(X11::C::Display) ? pointer : pointer.typecast(X11::C::Display)
    end

    def ungrab_pointer (time=0)
      C.XUngrabPointer(to_c, time)
    end

    def keysym_to_keycode (keysym)
      C.XKeysymToKeycode(to_c, keysym)
    end

    def check_typed_event (event)
      event = Event.index(event)
      ev = FFI::MemoryPointer.new(C::XEvent)
      C.XCheckTypedEvent(to_c, event, ev) or return
      Event.new(ev)
    end

    def screen (which)
      Screen.new(self, @dpy[:screens] + (which * C::Screen.size))
    end

    def default_screen
      self.screen(@dpy[:default_screen])
    end

    def screens
      (0...@dpy[:nscreens]).map {|i|
        self.screen(i)
      }
    end

    def next_event
      ev = FFI::MemoryPointer.new(C::XEvent)
      C.XNextEvent(to_c, ev)
      Event.new(ev)
    end

    def each_event
      loop {
        next_event.tap {|ev|
          yield ev if block_given?
        }
      }
    end

    def close
      C.XCloseDisplay(to_c)
    end

    def to_c
      @dpy.pointer
    end
  end

  class Screen
    def initialize (dpy, screen)
      @dpy = dpy
      @scr = screen.typecast(X11::C::Screen)
    end

    def root_window
      Window.new(@dpy, @scr[:root])
    end

    def to_c
      @scr.pointer
    end
  end

  class Window
    class Attributes
      def initialize (attr)
        attr = attr.typecast(C::XWindowAttributes) unless attr.is_a?(C::XWindowAttributes)
        @attr = attr
      end

      %w{x y width height border_width depth bit_gravity win_gravity backing_store
      backing_planes backing_pixel colormap map_state all_event_masks your_event_masks
      do_not_propagate_mask}.each {|meth|
        class_eval {
          define_method(meth) {
            @attr[meth.to_sym]
          }
        }
      }

      def override_redirect?
        @attr[:override_redirect]
      end

      def save_under?
        @attr[:save_under]
      end

      def map_installed?
        @attr[:map_installed]
      end

      def c_class
        @attr[:class]
      end

      def root
        Window.new(@attr[:root])
      end

      def visual
        Visual.new(@attr[:visual])
      end

      def screen
        Screen.new(@attr.screen)
      end
    end

    GRAB_MODE = {sync: false, async: true}

    def initialize (dpy, window)
      @dpy = dpy
      @win = window
    end

    def nil?
      @win.zero?
    end

    def attributes
      attr = FFI::MemoryPointer.new(C::XWindowAttributes)
      C.XGetWindowAttributes(@dpy.to_c, @win, attr)
      Attributes.new(attr)
    end
    alias attr attributes

    def grab_pointer (owner_events=true, event_mask=0, pointer_mode=:async,
                      keyboard_mode=:async, confine_to=0, cursor=0, time=0)
      C.XGrabPointer(@dpy.to_c, @win, !!owner_events, event_mask, mode2int(pointer_mode),
                     mode2int(keyboard_mode), confine_to.to_c, cursor, time)
    end

    def ungrab_pointer (time=0)
      @dpy.ungrab_pointer(time)
    end

    def keysym_to_keycode (keysym)
      C.XKeysymToKeycode(to_c, keysym)
    end

    def move_resize (x, y, width, height)
      C.XMoveResizeWindow(@dpy.to_c, @win, x, y, width, height)
    end

    def raise
      C.XRaiseWindow(@dpy.to_c, @win)
    end

    def grab_key (keycode, modifiers=0, owner_events=true, pointer_mode=:async, keyboard_mode=:async)
      C.XGrabKey(@dpy.to_c, keycode.to_keycode, modifiers, @win, !!owner_events,
                 mode2int(pointer_mode), mode2int(keyboard_mode))
    end

    def ungrab_key (keycode, modifiers=0)
      C.XUngrabKey(@dpy.to_c, keycode.to_keycode, modifiers, @win)
    end

    def grab_button (button, modifiers=0, owner_events=true, event_mask=4,
                     pointer_mode=:async, keyboard_mode=:async, confine_to=0, cursor=0)
      C.XGrabButton(@dpy.to_c, button, modifiers, @win, !!owner_events, event_mask,
                    mode2int(pointer_mode), mode2int(keyboard_mode), confine_to.to_c, cursor.to_c)
    end

    def ungrab_button (button, modifiers=0)
      C.XUngrabButton(@dpy.to_c, button, modifiers, @win)
    end

    def to_c
      @win
    end

    private
    def mode2int (mode)
      (mode == true or GRAB_MODE[mode]) ? 1 : 0
    end
  end

  class Visual
    def initialize (visual)
      visual = visual.typecast(C::Visual) unless visual.is_a?(C::Visual)
      @vis = visual
    end

    %w{red_mask green_mask blue_mask bits_per_rgb map_entries}.each {|meth|
      class_eval {
        define_method(meth) {
        @vis[meth]
        }
      }
    }

    def visual_id
      @vis[:VisualID]
    end

    def c_class
      @vis[:class]
    end
  end
end
