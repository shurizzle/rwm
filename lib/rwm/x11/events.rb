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
  module Events
    class Helper
      def self.attribute (which=nil)
        if which
          @__attribute__ = which.to_s.to_sym
        else
          @__attribute__ ||= nil
        end
      end

      def self.attach_method (meth, &block)
        return unless block_given?

        class_eval {
          define_method(meth, &block)
        }
      end

      def self.manage (attr, *args)
        if attr.is_a?(Array)
          original, new = attr[0, 2]
        else
          original, new = [attr] * 2
        end
        attribute = @__attribute__
        args.flatten!

        case args.size
        when 0
          attach_method(new) {
            struct[attribute][original]
          }

          attach_method("#{new}=") {|x|
            struct[attribute][original] = x
          }
        when 1
          if args.first.is_a?(Class)
            attach_method(new) {
              args.first.new(struct[attribute][original])
            }

            attach_method("#{new}=") {|x|
              struct[attribute][original] = x.to_c
            }
          else
            manage([original, new], args.first, nil)
          end
        when 2
          attach_method(new) {
            self.instance_exec(struct[attribute][original], &args[0])
          } if args[0]

          attach_method("#{new}=") {|x|
            struct[attribute][original] = self.instance_exec(x, &args[1])
          } if args[1]
        end
      end

      def initialize (struct)
        @struct = struct
      end

      def struct
        @struct
      end
      alias to_c struct
    end

    Window = [lambda {|w|
      X11::Window.new(self.display, w)
    }, lambda(&:to_c)]

    module Common
      def self.included (klass)
        klass.class_eval {
          manage :serial
          manage [:send_event, :send_event?]
          manage :display, Display
          manage :window, Window

          def self.inherited (klass)
            klass.attribute self.attribute
          end
        }
      end
    end

    class Any < Helper
      attribute :xany
      include Common
    end

    class Key < Helper
      attribute :xkey
      include Common

      manage :root, Window
      manage :subwindow, Window
      manage :time
      manage :x
      manage :y
      manage :x_root
      manage :y_root
      manage :state
      manage :keycode
      manage [:same_screen, :same_screen?]
    end

    class KeyPress < Key
    end

    class KeyRelease < Key
    end

    class Button < Helper
      attribute :xbutton
      include Common

      manage :root, Window
      manage :subwindow, Window
      manage :time
      manage :x
      manage :y
      manage :x_root
      manage :y_root
      manage :state
      manage :button
      manage [:same_screen, :same_screen?]
    end

    class ButtonPress < Button
    end

    class ButtonRelease < Button
    end

    class MotionNotify < Helper
      attribute :xmotion
      include Common

      manage :root, Window
      manage :subwindow, Window
      manage :time
      manage :x
      manage :y
      manage :x_root
      manage :y_root
      manage :state
      manage :is_hint
      manage [:same_screen, :same_screen?]
    end

    class EnterNotify < Helper
      attribute :xcrossing
    end

    class LeaveNotify < Helper
      attribute :xcrossing
      include Common

      manage :root, Window
      manage :subwindow, Window
      manage :time
      manage :x
      manage :y
      manage :x_root
      manage :y_root
      manage :mode
      manage :detail
    end

    class Focus < Helper
      attribute :xfocus
      include Common

      manage :mode
      manage :detail
    end

    class FocusIn < Focus
    end

    class FocusOut < Focus
    end

    class KeymapNotify < Helper
      attribute :xkeymap
      include Common

      manage :key_vector, lambda {|v|
        v.to_a
      }, lambda {|v|
        v = v.join if v.is_a?(Array)
        FFI::MemoryPointer.from_string(v[0, 32])
      }
    end

    class Expose < Helper
      attribute :xexpose
      include Common

      manage :x
      manage :y
      manage :width
      manage :height
      manage :count
    end

    class GraphicsExpose < Helper
      attribute :xgraphicsexpose
      include Common

      manage :x
      manage :y
      manage :width
      manage :height
      manage :count
      manage :major_code
      manage :minor_code
    end

    class NoExpose < Helper
      attribute :xnoexpose

      manage :serial
      manage [:send_event, :send_event?]
      manage :display
      manage :drawable
      manage :major_code
      manage :minor_code
    end

    class VisibilityNotify < Helper
      attribute :xvisibility
      include Common

      manage :state
    end

    class CreateNotify < Helper
      attribute :xcreatewindow
      include Common

      manage :parent, Window
      manage :x
      manage :y
      manage :width
      manage :height
      manage :border_width
      manage [:override_redirect, :override_redirect?]
    end

    class DestroyNotify < Helper
      attribute :xdestroywindow
      include Common

      manage :event, Window
    end

    class UnmapNotify < Helper
      attribute :xunmap
      include Common

      manage :event, Window
      manage [:from_configure, :from_configure?]
    end

    class MapNotify < Helper
      attribute :xmap
      include Common

      manage :event, Window
      manage [:override_redirect, :override_redirect?]
    end

    class MapRequest < Helper
      attribute :xmaprequest
      include Common

      manage :parent, Window
    end

    class ReparentNotify < Helper
      attribute :xreparent
      include Common

      manage :event, Window
      manage :parent, Window
      manage :x
      manage :y
      manage [:override_redirect, :override_redirect?]
    end

    class ConfigureNotify < Helper
      attribute :xconfigure
      include Common

      manage :event, Window
      manage :x
      manage :y
      manage :width
      manage :height
      manage :border_width
      manage :above, Window
      manage [:override_redirect, :override_redirect?]
    end

    class ConfigureRequest < Helper
      attribute :xconfigurerequest
      include Common

      manage :parent, Window
      manage :x
      manage :y
      manage :width
      manage :height
      manage :border_width
      manage :above, Window
      manage :detail
      manage :value_mask
    end

    class GravityNotify < Helper
      attribute :xgravity
      include Common

      manage :event, Window
      manage :x
      manage :y
    end

    class ResizeRequest < Helper
      attribute :xresizerequest
      include Common

      manage :width
      manage :height
    end

    class CirculateNotify < Helper
      attribute :xcirculate
      include Common

      manage :event, Window
      manage :place
    end

    class CirculateRequest < Helper
      attribute :xcirculaterequest
      include Common

      manage :event, Window
      manage :place
    end

    class PropertyNotify < Helper
      attribute :xproperty
      include Common

      manage :atom
      manage :time
      manage :state
    end

    class SelectionClear < Helper
      attribute :xselectionclear
      include Common

      manage :selection
      manage :time
    end

    class SelectionRequest < Helper
      attribute :xselectionrequest

      manage :serial
      manage [:send_event, :send_event?]
      manage :display, Display
      manage :owner, Window
      manage :requestor, Window
      manage :selection
      manage :target
      manage :property
      manage :time
    end

    class SelectionNotify < Helper
      attribute :xselection

      manage :serial
      manage [:send_event, :send_event?]
      manage :display, Display
      manage :requestor, Window
      manage :selection
      manage :target
      manage :property
      manage :time
    end

    class ColormapNotify < Helper
      attribute :xcolormap
      include Common

      manage :colormap
      manage [:new, :c_new]
      manage :state
    end

    class ClientMessage < Helper
      attribute :xclient
      include Common

      manage :message_type
      manage :format
      manage :data, lambda {|x|x}, false
    end

    class MappingNotify < Helper
      attribute :xmapping
      include Common

      manage :request
      manage :first_keycode
      manage :count
    end

    class GenericEvent < Helper
      attribute :xgeneric

      manage :display, Display
      manage :resourceid
      manage :serial
      manage :error_code
      manage :request_code
      manage :minor_code
    end
  end

  class Event
    include Events

    TYPE2EVENT = [nil, Any, KeyPress, KeyRelease, ButtonPress, ButtonRelease,
      MotionNotify, EnterNotify, LeaveNotify, FocusIn, FocusOut, KeymapNotify,
      Expose, GraphicsExpose, NoExpose, VisibilityNotify, CreateNotify,
      DestroyNotify, UnmapNotify, MapNotify, MapRequest, ReparentNotify,
      ConfigureNotify, ResizeRequest, CirculateNotify, CirculateRequest,
      PropertyNotify, SelectionClear, SelectionRequest, SelectionNotify,
      ColormapNotify, ClientMessage, MappingNotify, GenericEvent]

    def self.index (event)
      TYPE2EVENT.index(event)
    end

    def self.new (event)
      event = event.typecast(C::XEvent) unless event.is_a?(C::XEvent)
      (TYPE2EVENT[event[:type]] || Any).new(event)
    end
  end

  module C
    class XEvent
      X11::Event::TYPE2EVENT.compact.each {|type|
        define_method(type.attribute) {
          type.new(self)
        }
      }
    end
  end
end
