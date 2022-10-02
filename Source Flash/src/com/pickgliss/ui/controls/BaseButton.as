package com.pickgliss.ui.controls
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.PNGHitAreaFactory;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   [Event(name="change",type="flash.events.Event")]
   public class BaseButton extends Component
   {
      
      public static const P_backStyle:String = "backStyle";
      
      public static const P_backgoundRotation:String = "backgoundRotation";
      
      public static const P_pressEnable:String = "pressEnable";
      
      public static const P_transparentEnable:String = "transparentEnable";
      
      public static const P_autoSizeAble:String = "autoSizeAble";
      
      public static const P_stopMovieAtLastFrame:String = "stopMovieAtLastFrame";
       
      
      private var _offsetCount:int;
      
      protected var _PNGHitArea:Sprite;
      
      protected var _back:DisplayObject;
      
      protected var _backStyle:String;
      
      protected var _backgoundRotation:int;
      
      protected var _currentFrameIndex:int = 1;
      
      protected var _enable:Boolean = true;
      
      protected var _filterString:String;
      
      protected var _frameFilter:Array;
      
      protected var _pressEnable:Boolean;
      
      protected var _stopMovieAtLastFrame:Boolean;
      
      private var _displacementEnable:Boolean = true;
      
      private var _pressStartTimer:Timer;
      
      private var _pressStepTimer:Timer;
      
      protected var _transparentEnable:Boolean;
      
      protected var _autoSizeAble:Boolean = true;
      
      private var _useLogID:int = 0;
      
      public function BaseButton()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      public function set useLogID(param1:int) : void
      {
         this._useLogID = param1;
      }
      
      public function get useLogID() : int
      {
         return this._useLogID;
      }
      
      public function get frameFilter() : Array
      {
         return this._frameFilter;
      }
      
      public function set frameFilter(param1:Array) : void
      {
         this._frameFilter = param1;
      }
      
      public function set autoSizeAble(param1:Boolean) : void
      {
         if(this._autoSizeAble == param1)
         {
            return;
         }
         this._autoSizeAble = param1;
         onPropertiesChanged(P_autoSizeAble);
      }
      
      public function get backStyle() : String
      {
         return this._backStyle;
      }
      
      public function set backStyle(param1:String) : void
      {
         if(param1 == this._backStyle)
         {
            return;
         }
         this._backStyle = param1;
         this.backgound = ComponentFactory.Instance.creat(this._backStyle);
         onPropertiesChanged(P_backStyle);
      }
      
      public function set backgound(param1:DisplayObject) : void
      {
         if(this._back == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._back);
         this._back = param1;
         onPropertiesChanged(P_backStyle);
      }
      
      public function get backgound() : DisplayObject
      {
         return this._back;
      }
      
      public function set backgoundRotation(param1:int) : void
      {
         if(this._backgoundRotation == param1)
         {
            return;
         }
         this._backgoundRotation = param1;
         onPropertiesChanged(P_backgoundRotation);
      }
      
      public function get displacement() : Boolean
      {
         return this._displacementEnable;
      }
      
      public function set displacement(param1:Boolean) : void
      {
         this._displacementEnable = param1;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._back)
         {
            this._back.filters = null;
         }
         ObjectUtils.disposeObject(this._back);
         ObjectUtils.disposeObject(this._PNGHitArea);
         this._PNGHitArea = null;
         this._back = null;
         this._frameFilter = null;
         this._pressStepTimer = null;
         this._pressStartTimer = null;
         super.dispose();
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function set enable(param1:Boolean) : void
      {
         if(this._enable == param1)
         {
            return;
         }
         this._enable = param1;
         mouseEnabled = this._enable;
         if(this._enable)
         {
            this.setFrame(1);
         }
         else
         {
            this.setFrame(4);
         }
         this.updatePosition();
      }
      
      private function updatePosition() : void
      {
         x += ComponentSetting.DISPLACEMENT_OFFSET * -this._offsetCount;
         y += ComponentSetting.DISPLACEMENT_OFFSET * -this._offsetCount;
         this._offsetCount = 0;
      }
      
      public function set filterString(param1:String) : void
      {
         if(this._filterString == param1)
         {
            return;
         }
         this._filterString = param1;
         this._frameFilter = ComponentFactory.Instance.creatFrameFilters(this._filterString);
      }
      
      public function set pressEnable(param1:Boolean) : void
      {
         if(this._pressEnable == param1)
         {
            return;
         }
         this._pressEnable = param1;
         onPropertiesChanged(P_pressEnable);
      }
      
      public function get transparentEnable() : Boolean
      {
         return this._transparentEnable;
      }
      
      public function set transparentEnable(param1:Boolean) : void
      {
         if(this._transparentEnable == param1)
         {
            return;
         }
         this._transparentEnable = param1;
         onPropertiesChanged(P_transparentEnable);
      }
      
      protected function __onMouseClick(param1:MouseEvent) : void
      {
         if(!this._enable)
         {
            param1.stopImmediatePropagation();
         }
         else if(this._useLogID != 0 && ComponentSetting.SEND_USELOG_ID != null)
         {
            ComponentSetting.SEND_USELOG_ID(this._useLogID);
         }
      }
      
      protected function adaptHitArea() : void
      {
         this._PNGHitArea.x = this._back.x;
         this._PNGHitArea.y = this._back.y;
      }
      
      override protected function addChildren() : void
      {
         if(this._back)
         {
            addChild(this._back);
         }
      }
      
      protected function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onMouseClick);
         addEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         addEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
         addEventListener(MouseEvent.MOUSE_DOWN,this.__onMousedown);
      }
      
      public function set stopMovieAtLastFrame(param1:Boolean) : void
      {
         if(this._stopMovieAtLastFrame == param1)
         {
            return;
         }
         this._stopMovieAtLastFrame = param1;
         onPropertiesChanged(P_stopMovieAtLastFrame);
      }
      
      public function get stopMovieAtLastFrame() : Boolean
      {
         return this._stopMovieAtLastFrame;
      }
      
      protected function drawHitArea() : void
      {
         if(this._PNGHitArea && contains(this._PNGHitArea))
         {
            removeChild(this._PNGHitArea);
         }
         if(this._back == null)
         {
            return;
         }
         if(this._transparentEnable)
         {
            this._PNGHitArea = PNGHitAreaFactory.drawHitArea(DisplayUtils.getDisplayBitmapData(this._back));
            hitArea = this._PNGHitArea;
            this._PNGHitArea.alpha = 0;
            this.adaptHitArea();
            addChild(this._PNGHitArea);
         }
         else if(this._PNGHitArea && contains(this._PNGHitArea))
         {
            removeChild(this._PNGHitArea);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         mouseChildren = false;
         buttonMode = true;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         super.onProppertiesUpdate();
         if(_changedPropeties[P_pressEnable])
         {
            if(this._pressEnable == true)
            {
               this._pressStartTimer = new Timer(ComponentSetting.BUTTON_PRESS_START_TIME,1);
               this._pressStepTimer = new Timer(ComponentSetting.BUTTON_PRESS_STEP_TIME);
            }
         }
         if(_changedPropeties[P_backStyle] && this._autoSizeAble)
         {
            if(this._back && (this._back.width > 0 || this._back.height > 0))
            {
               _width = this._back.width;
               _height = this._back.height;
            }
         }
         if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height])
         {
            if(this._back)
            {
               this._back.width = _width;
               this._back.height = _height;
            }
         }
         if(_changedPropeties[P_backgoundRotation])
         {
            if(this._back)
            {
               this._back.rotation = this._backgoundRotation;
               _loc1_ = this._back.getRect(this);
               this._back.x = -_loc1_.x;
               this._back.y = -_loc1_.y;
            }
         }
         if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height] || _changedPropeties[P_backStyle] || _changedPropeties[P_backgoundRotation] || _changedPropeties[P_transparentEnable])
         {
            this.drawHitArea();
         }
         this.setFrame(this._currentFrameIndex);
         if(_changedPropeties[P_stopMovieAtLastFrame] && this._stopMovieAtLastFrame)
         {
            _loc2_ = this._back as MovieClip;
            if(_loc2_ != null)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.numChildren)
               {
                  _loc4_ = _loc2_.getChildAt(_loc3_) as MovieClip;
                  if(_loc4_)
                  {
                     _loc4_.gotoAndStop(_loc4_.totalFrames);
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         removeEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollover);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollout);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onMouseup);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.__onMousedown);
         if(this._pressStartTimer)
         {
            this._pressStartTimer.removeEventListener(TimerEvent.TIMER,this.__onPressedStart);
         }
         if(this._pressStepTimer)
         {
            this._pressStepTimer.removeEventListener(TimerEvent.TIMER,this.__onPressStepTimer);
         }
      }
      
      public function setFrame(param1:int) : void
      {
         this._currentFrameIndex = param1;
         DisplayUtils.setFrame(this._back,this._currentFrameIndex);
         if(this._frameFilter == null || param1 <= 0 || param1 > this._frameFilter.length)
         {
            return;
         }
         filters = this._frameFilter[param1 - 1];
      }
      
      private function __onMouseRollout(param1:MouseEvent) : void
      {
         if(this._enable && !param1.buttonDown)
         {
            this.setFrame(1);
         }
      }
      
      private function __onMouseRollover(param1:MouseEvent) : void
      {
         if(this._enable && !param1.buttonDown)
         {
            this.setFrame(2);
         }
      }
      
      private function __onMousedown(param1:MouseEvent) : void
      {
         if(this._enable)
         {
            this.setFrame(3);
         }
         if(this._displacementEnable && this._offsetCount < 1)
         {
            x += ComponentSetting.DISPLACEMENT_OFFSET;
            y += ComponentSetting.DISPLACEMENT_OFFSET;
            ++this._offsetCount;
         }
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__onMouseup);
         if(this._pressEnable)
         {
            this.__onPressStepTimer(null);
            this._pressStartTimer.addEventListener(TimerEvent.TIMER,this.__onPressedStart);
            this._pressStartTimer.start();
         }
      }
      
      private function __onMouseup(param1:MouseEvent) : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onMouseup);
         if(!this._enable)
         {
            return;
         }
         if(this._displacementEnable && this._offsetCount > -1)
         {
            x -= ComponentSetting.DISPLACEMENT_OFFSET;
            y -= ComponentSetting.DISPLACEMENT_OFFSET;
            --this._offsetCount;
         }
         if(!(param1.target is DisplayObject))
         {
            this.setFrame(1);
         }
         if(param1.target == this)
         {
            this.setFrame(2);
         }
         else
         {
            this.setFrame(1);
         }
         if(this._pressEnable)
         {
            this._pressStartTimer.stop();
            this._pressStepTimer.stop();
            this._pressStepTimer.removeEventListener(TimerEvent.TIMER,this.__onPressStepTimer);
         }
      }
      
      private function __onPressStepTimer(param1:TimerEvent) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function __onPressedStart(param1:TimerEvent) : void
      {
         this._pressStartTimer.removeEventListener(TimerEvent.TIMER,this.__onPressedStart);
         this._pressStartTimer.reset();
         this._pressStartTimer.stop();
         this._pressStepTimer.start();
         this._pressStepTimer.addEventListener(TimerEvent.TIMER,this.__onPressStepTimer);
      }
   }
}
