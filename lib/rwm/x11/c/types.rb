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
    module Bool
      extend FFI::DataConverter
      native_type FFI::Type::INT

      def self.to_native (value, ctx)
        value ? 1 : 0
      end

      def self.from_native (value, ctx)
        !value.zero?
      end
    end
    FFI.typedef(Bool, :Bool)

    FFI.typedef(:uint32, :CARD32)
    XID = FFI.typedef(:ulong, :XID)

    VisualID = FFI.typedef(:CARD32, :VisualID)
    Window = FFI.typedef(:XID, :Window)
    Colormap = FFI.typedef(:XID, :Colormap)
    GContext = FFI.typedef(:XID, :GContext)
    Cursor = FFI.typedef(:XID, :Cursor)
    KeySym = FFI.typedef(:XID, :KeySym)
    Drawable = FFI.typedef(:XID, :Drawable)
    KeyCode = FFI.typedef(:uchar, :KeyCode)
    Time = FFI.typedef(:ulong, :Time)
    Atom = FFI.typedef(:ulong, :Atom)

    class Display < FFI::Struct
      layout \
        :ext_data, :pointer,
        :private1, :pointer,
        :fd, :int,
        :private2, :int,
        :proto_major_version, :int,
        :proto_minor_version, :int,
        :vendor, :string,
        :private3, :XID,
        :private4, :XID,
        :private5, :XID,
        :private6, :int,
        :resource_alloc, :pointer,
        :byte_order, :int,
        :bitmap_unit, :int,
        :bitmap_pad, :int,
        :bitmap_bit_order, :int,
        :nformats, :int,
        :pixmap_format, :pointer,
        :private8, :int,
        :release, :int,
        :private9, :pointer,
        :private10, :pointer,
        :qlen, :int,
        :last_request_read, :ulong,
        :request, :ulong,
        :private11, :pointer,
        :private12, :pointer,
        :private13, :pointer,
        :private14, :pointer,
        :max_request_size, :uint,
        :db, :pointer,
        :private15, :pointer,
        :display_name, :string,
        :default_screen, :int,
        :nscreens, :int,
        :screens, :pointer,
        :motion_buffer, :ulong,
        :private16, :ulong,
        :min_keycode, :int,
        :max_keycode, :int,
        :private17, :pointer,
        :private18, :pointer,
        :private19, :int,
        :xdefaults, :string
    end

    class GC < FFI::Struct
      layout \
        :ext_data, :pointer,
        :gid, :GContext
    end

    class Screen < FFI::Struct
      layout \
        :ext_data, :pointer,
        :display, :pointer,
        :root, :Window,
        :width, :int,
        :height, :int,
        :mwidth, :int,
        :mheight, :int,
        :ndepths, :int,
        :depths, :pointer,
        :root_depth, :int,
        :root_visual, :pointer,
        :default_gc, GC,
        :cmap, Colormap,
        :white_pixel, :ulong,
        :black_pixel, :ulong,
        :max_maps, :int,
        :min_maps, :int,
        :save_unders, :Bool,
        :root_input_mask, :long
    end

    class XWindowAttributes < FFI::Struct
      layout \
        :x, :int,
        :y, :int,
        :width, :int,
        :height, :int,
        :border_width, :int,
        :depth, :int,
        :visual, :pointer,
        :root, :Window,
        :class, :int,
        :bit_gravity, :int,
        :win_gravity, :int,
        :backing_store, :int,
        :backing_planes, :ulong,
        :backing_pixel, :ulong,
        :save_under, :Bool,
        :colormap, :Colormap,
        :map_installed, :Bool,
        :map_state, :int,
        :all_event_masks, :long,
        :your_event_masks, :long,
        :do_not_propagate_mask, :long,
        :override_redirect, :Bool,
        :screen, :pointer
    end

    class Visual < FFI::Struct
      layout \
        :ext_data, :pointer,
        :visualid, :VisualID,
        :class, :int,
        :read_mask, :ulong,
        :green_mask, :ulong,
        :blue_mask, :ulong,
        :buts_per_rgb, :int,
        :map_entries, :int
    end

    class XAnyEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window
    end

    class XKeyEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :root, :Window,
        :subwindow, :Window,
        :time, :Time,
        :x, :int,
        :y, :int,
        :x_root, :int,
        :y_root, :int,
        :state, :uint,
        :keycode, :uint,
        :same_screen, :Bool
    end

    class XButtonEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :root, :Window,
        :subwindow, :Window,
        :time, :Time,
        :x, :int,
        :y, :int,
        :x_root, :int,
        :y_root, :int,
        :state, :uint,
        :button, :uint,
        :same_screen, :Bool
    end

    class XMotionEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :root, :Window,
        :subwindow, :Window,
        :time, :Time,
        :x, :int,
        :y, :int,
        :x_root, :int,
        :y_root, :int,
        :state, :uint,
        :is_hint, :char,
        :same_screen, :Bool
    end

    class XCrossingEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :root, :Window,
        :subwindow, :Window,
        :time, :Time,
        :x, :int,
        :y, :int,
        :x_root, :int,
        :y_root, :int,
        :mode, :int,
        :detail, :int,
        :same_screen, :Bool,
        :focus, :Bool,
        :state, :uint
    end

    class XFocusChangeEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :mode, :int,
        :detail, :int
    end

    class XExposeEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :x, :int,
        :y, :int,
        :width, :int,
        :height, :int,
        :count, :int
    end

    class XGraphicsExposeEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :drawable, :Drawable,
        :x, :int,
        :y, :int,
        :width, :int,
        :height, :int,
        :count, :int,
        :major_code, :int,
        :minor_code, :int
    end

    class XNoExposeEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :drawable, :Drawable,
        :major_code, :int,
        :minor_code, :int
    end

    class XVisibilityEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :state, :int
    end

    class XCreateWindowEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :parent, :Window,
        :window, :Window,
        :x, :int,
        :y, :int,
        :width, :int,
        :height, :int,
        :border_width, :int,
        :override_redirect, :Bool
    end

    class XDestroyWindowEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window
    end

    class XUnmapEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window,
        :from_configure, :Bool
    end

    class XMapEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window,
        :override_redirect, :Bool
    end

    class XMapRequestEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window,
        :parent, :Window,
        :x, :int,
        :y, :int,
        :override_redirect, :Bool
    end

    class XReparentEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window,
        :parent, :Window,
        :x, :int,
        :y, :int,
        :override_redirect, :Bool
    end

    class XConfigureEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window,
        :x, :int,
        :y, :int,
        :width, :int,
        :height, :int,
        :border_width, :int,
        :above, :Window,
        :override_redirect, :Bool
    end

    class XGravityEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window,
        :x, :int,
        :y, :int
    end

    class XResizeRequestEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :width, :int,
        :height, :int
    end

    class XConfigureRequestEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window,
        :x, :int,
        :y, :int,
        :width, :int,
        :height, :int,
        :border_width, :int,
        :above, :Window,
        :detail, :int,
        :value_mask, :ulong
    end

    class XCirculateEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window,
        :place, :int
    end

    class XCirculateRequestEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :event, :Window,
        :window, :Window,
        :place, :int
    end

    class XPropertyEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :atom, :Atom,
        :time, :Time,
        :state, :int
    end

    class XSelectionClearEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :selection, :Atom,
        :time, :Time
    end

    class XSelectionRequestEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :owner, :Window,
        :requestor, :Window,
        :selection, :Atom,
        :target, :Atom,
        :property, :Atom,
        :time, :Time
    end

    class XSelectionEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :requestor, :Window,
        :selection, :Atom,
        :target, :Atom,
        :property, :Atom,
        :time, :Time
    end

    class XColormapEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :colormap, :Colormap,
        :new, :Bool,
        :state, :int
    end

    class XClientMessageEvent < FFI::Struct
      class Data < FFI::Struct
        layout \
          :b, [:char, 20],
          :s, [:short, 10],
          :l, [:long, 5]
      end

      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :message_type, :Atom,
        :format, :int,
        :data, Data
    end

    class XMappingEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :request, :int,
        :first_keycode, :int,
        :count, :int
    end

    class XErrorEvent < FFI::Struct
      layout \
        :type, :int,
        :display, :pointer,
        :resourceid, :XID,
        :serial, :ulong,
        :error_code, :uchar,
        :request_code, :uchar,
        :minor_code, :uchar
    end

    class XKeymapEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :window, :Window,
        :key_vector, [:char, 32]
    end

    class XGenericEvent < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :extension, :int,
        :evtype, :int
    end

    class XGenericEventCookie < FFI::Struct
      layout \
        :type, :int,
        :serial, :ulong,
        :send_event, :Bool,
        :display, :pointer,
        :extension, :int,
        :evtype, :int,
        :cookie, :uint,
        :data, :pointer
    end

    class XEvent < FFI::Union
      layout \
        :type, :int,
        :xany, XAnyEvent,
        :xkey, XKeyEvent,
        :xbutton, XButtonEvent,
        :xmotion, XMotionEvent,
        :xcrossing, XCrossingEvent,
        :xfocus, XFocusChangeEvent,
        :xexpose, XExposeEvent,
        :xgraphicsexpose, XGraphicsExposeEvent,
        :xnoexpose, XNoExposeEvent,
        :xvisibility, XVisibilityEvent,
        :xcreatewindow, XCreateWindowEvent,
        :xdestroywindow, XDestroyWindowEvent,
        :xunmap, XUnmapEvent,
        :xmap, XMapEvent,
        :xmaprequest, XMapRequestEvent,
        :xreparent, XReparentEvent,
        :xconfigure, XConfigureEvent,
        :xgravity, XGravityEvent,
        :xresizerequest, XResizeRequestEvent,
        :xconfigurerequest, XConfigureRequestEvent,
        :xcirculate, XCirculateEvent,
        :xcirculaterequest, XCirculateRequestEvent,
        :xproperty, XPropertyEvent,
        :xselectionclear, XSelectionClearEvent,
        :xselectionrequest, XSelectionRequestEvent,
        :xselection, XSelectionEvent,
        :xcolormap, XColormapEvent,
        :xclient, XClientMessageEvent,
        :xmapping, XMappingEvent,
        :xerror, XErrorEvent,
        :xkeymap, XKeymapEvent,
        :xgeneric, XGenericEvent,
        :xcookie, XGenericEventCookie,
        :pad, [:long, 24]
    end
  end
end
