package com.pickgliss.ui.controls
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.IOrientable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class Scrollbar extends Component implements IOrientable
   {
      
      public static const HORIZONTAL:int = 1;
      
      public static const P_decreaseButton:String = "decreaseButton";
      
      public static const P_decreaseButtonInnerRect:String = "decreaseButtonInnerRect";
      
      public static const P_increaseButton:String = "increaseButton";
      
      public static const P_increaseButtonInnerRect:String = "increaseButtonInnerRect";
      
      public static const P_maximum:String = "maximum";
      
      public static const P_minimum:String = "minimum";
      
      public static const P_orientation:String = "orientation";
      
      public static const P_scrollValue:String = "scrollValue";
      
      public static const P_thumb:String = "thumb";
      
      public static const P_thumbAreaInnerRect:String = "thumbAreaInnerRect";
      
      public static const P_thumbMinSize:String = "thumbMinSize";
      
      public static const P_track:String = "track";
      
      public static const P_trackInnerRect:String = "trackInnerRect";
      
      public static const P_valueIsAdjusting:String = "valueIsAdjusting";
      
      public static const P_visibleAmount:String = "visibleAmount";
      
      public static const VERTICAL:int = 0;
       
      
      protected var _blockIncrement:int = 20;
      
      protected var _currentTrackClickDirction:int = 0;
      
      protected var _decreaseButton:BaseButton;
      
      protected var _decreaseButtonInnerRect:InnerRectangle;
      
      protected var _decreaseButtonInnerRectString:String;
      
      protected var _decreaseButtonStyle:String;
      
      protected var _increaseButton:BaseButton;
      
      protected var _increaseButtonInnerRect:InnerRectangle;
      
      protected var _increaseButtonInnerRectString:String;
      
      protected var _increaseButtonStyle:String;
      
      protected var _isDragging:Boolean;
      
      protected var _model:BoundedRangeModel;
      
      protected var _orientation:int;
      
      protected var _thumb:BaseButton;
      
      protected var _thumbAreaInnerRect:InnerRectangle;
      
      protected var _thumbAreaInnerRectString:String;
      
      protected var _thumbDownOffset:int;
      
      protected var _thumbMinSize:int;
      
      protected var _thumbRect:Rectangle;
      
      protected var _thumbStyle:String;
      
      protected var _track:DisplayObject;
      
      protected var _trackClickTimer:Timer;
      
      protected var _trackInnerRect:InnerRectangle;
      
      protected var _trackInnerRectString:String;
      
      protected var _trackStyle:String;
      
      protected var _unitIncrement:int = 2;
      
      public function Scrollbar()
      {
         super();
      }
      
      public function addStateListener(param1:Function, param2:int = 0, param3:Boolean = false) : void
      {
         addEventListener(InteractiveEvent.STATE_CHANGED,param1,false,param2);
      }
      
      public function get blockIncrement() : int
      {
         return this._blockIncrement;
      }
      
      public function set blockIncrement(param1:int) : void
      {
         this._blockIncrement = param1;
      }
      
      public function set decreaseButton(param1:BaseButton) : void
      {
         if(this._decreaseButton == param1)
         {
            return;
         }
         if(this._decreaseButton)
         {
            this._decreaseButton.removeEventListener(Event.CHANGE,this.__increaseButtonClicked);
         }
         ObjectUtils.disposeObject(this._decreaseButton);
         this._decreaseButton = param1;
         if(this._decreaseButton)
         {
            this._decreaseButton.pressEnable = true;
         }
         if(this._decreaseButton)
         {
            this._decreaseButton.addEventListener(Event.CHANGE,this.__increaseButtonClicked);
         }
         onPropertiesChanged(P_decreaseButton);
      }
      
      public function set decreaseButtonInnerRectString(param1:String) : void
      {
         if(this._decreaseButtonInnerRectString == param1)
         {
            return;
         }
         this._decreaseButtonInnerRectString = param1;
         this._decreaseButtonInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._decreaseButtonInnerRectString));
         onPropertiesChanged(P_decreaseButtonInnerRect);
      }
      
      public function set decreaseButtonStyle(param1:String) : void
      {
         if(this._decreaseButtonStyle == param1)
         {
            return;
         }
         this._decreaseButtonStyle = param1;
         this.decreaseButton = ComponentFactory.Instance.creat(this._decreaseButtonStyle);
      }
      
      override public function dispose() : void
      {
         if(this._thumb)
         {
            this._thumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onThumbDown);
         }
         ObjectUtils.disposeObject(this._thumb);
         this._thumb = null;
         if(this._decreaseButton)
         {
            this._decreaseButton.removeEventListener(Event.CHANGE,this.__decreaseButtonClicked);
         }
         ObjectUtils.disposeObject(this._decreaseButton);
         this._decreaseButton = null;
         if(this._increaseButton)
         {
            this._increaseButton.removeEventListener(Event.CHANGE,this.__increaseButtonClicked);
         }
         ObjectUtils.disposeObject(this._increaseButton);
         this._increaseButton = null;
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onThumbUp);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onThumbMoved);
         if(this._track && this._track is InteractiveObject)
         {
            this._track.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onTrackClickStart);
            this._track.removeEventListener(MouseEvent.MOUSE_UP,this.__onTrackClickStop);
            this._track.removeEventListener(MouseEvent.MOUSE_OUT,this.__onTrackClickStop);
            this._trackClickTimer.stop();
            this._trackClickTimer.removeEventListener(TimerEvent.TIMER,this.__onTrackPressed);
         }
         ObjectUtils.disposeObject(this._track);
         this._track = null;
         this._trackClickTimer = null;
         super.dispose();
      }
      
      public function set downButtonStyle(param1:String) : void
      {
         if(this._decreaseButtonStyle == param1)
         {
            return;
         }
         this._decreaseButtonStyle = param1;
         this.increaseButton = ComponentFactory.Instance.creat(this._decreaseButtonStyle);
      }
      
      public function getModel() : BoundedRangeModel
      {
         return this._model;
      }
      
      public function getThumbVisible() : Boolean
      {
         return this._thumb.visible;
      }
      
      public function set increaseButton(param1:BaseButton) : void
      {
         if(this._increaseButton == param1)
         {
            return;
         }
         if(this._increaseButton)
         {
            this._increaseButton.removeEventListener(Event.CHANGE,this.__decreaseButtonClicked);
         }
         ObjectUtils.disposeObject(this._increaseButton);
         this._increaseButton = param1;
         if(this._increaseButton)
         {
            this._increaseButton.pressEnable = true;
         }
         if(this._increaseButton)
         {
            this._increaseButton.addEventListener(Event.CHANGE,this.__decreaseButtonClicked);
         }
         onPropertiesChanged(P_increaseButton);
      }
      
      public function set increaseButtonInnerRectString(param1:String) : void
      {
         if(this._increaseButtonInnerRectString == param1)
         {
            return;
         }
         this._increaseButtonInnerRectString = param1;
         this._increaseButtonInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._increaseButtonInnerRectString));
         onPropertiesChanged(P_increaseButtonInnerRect);
      }
      
      public function set increaseButtonStyle(param1:String) : void
      {
         if(this._increaseButtonStyle == param1)
         {
            return;
         }
         this._increaseButtonStyle = param1;
         this.increaseButton = ComponentFactory.Instance.creat(this._increaseButtonStyle);
      }
      
      public function isVertical() : Boolean
      {
         return this._orientation == 0;
      }
      
      public function get maximum() : int
      {
         return this.getModel().getMaximum();
      }
      
      public function set maximum(param1:int) : void
      {
         if(this.getModel().getMaximum() == param1)
         {
            return;
         }
         this.getModel().setMaximum(param1);
         onPropertiesChanged(P_maximum);
      }
      
      public function get minimum() : int
      {
         return this.getModel().getMinimum();
      }
      
      public function set minimum(param1:int) : void
      {
         if(this.getModel().getMinimum() == param1)
         {
            return;
         }
         this.getModel().setMinimum(param1);
         onPropertiesChanged(P_minimum);
      }
      
      public function get orientation() : int
      {
         return this._orientation;
      }
      
      public function set orientation(param1:int) : void
      {
         if(this._orientation == param1)
         {
            return;
         }
         this._orientation = param1;
         onPropertiesChanged(P_orientation);
      }
      
      public function removeStateListener(param1:Function) : void
      {
         removeEventListener(InteractiveEvent.STATE_CHANGED,param1);
      }
      
      public function get scrollValue() : int
      {
         return this.getModel().getValue();
      }
      
      public function set scrollValue(param1:int) : void
      {
         this.getModel().setValue(param1);
         onPropertiesChanged(P_scrollValue);
      }
      
      public function setupModel(param1:BoundedRangeModel) : void
      {
         if(this._model)
         {
            this._model.removeStateListener(this.__onModelChange);
         }
         else
         {
            this._model = param1;
         }
         this._model.addStateListener(this.__onModelChange);
      }
      
      public function set thumb(param1:BaseButton) : void
      {
         if(this._thumb == param1)
         {
            return;
         }
         if(this._thumb)
         {
            this._thumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onThumbDown);
         }
         ObjectUtils.disposeObject(this._thumb);
         this._thumb = param1;
         if(this._thumb)
         {
            this._thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.__onThumbDown);
         }
         onPropertiesChanged(P_thumb);
      }
      
      public function set thumbAreaInnerRectString(param1:String) : void
      {
         if(this._thumbAreaInnerRectString == param1)
         {
            return;
         }
         this._thumbAreaInnerRectString = param1;
         this._thumbAreaInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._thumbAreaInnerRectString));
         onPropertiesChanged(P_thumbAreaInnerRect);
      }
      
      public function get thumbMinSize() : int
      {
         return this._thumbMinSize;
      }
      
      public function set thumbMinSize(param1:int) : void
      {
         if(this._thumbMinSize == param1)
         {
            return;
         }
         this._thumbMinSize = param1;
         onPropertiesChanged(P_thumbMinSize);
      }
      
      public function set thumbStyle(param1:String) : void
      {
         if(this._thumbStyle == param1)
         {
            return;
         }
         this._thumbStyle = param1;
         this.thumb = ComponentFactory.Instance.creat(this._thumbStyle);
      }
      
      public function set track(param1:DisplayObject) : void
      {
         if(this._track == param1)
         {
            return;
         }
         if(this._track && this._track is InteractiveObject)
         {
            this._track.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onTrackClickStart);
            this._track.removeEventListener(MouseEvent.MOUSE_UP,this.__onTrackClickStop);
            this._track.removeEventListener(MouseEvent.MOUSE_OUT,this.__onTrackClickStop);
         }
         ObjectUtils.disposeObject(this._track);
         this._track = param1;
         if(this._track is InteractiveObject)
         {
            InteractiveObject(this._track).mouseEnabled = true;
         }
         this._track.addEventListener(MouseEvent.MOUSE_DOWN,this.__onTrackClickStart);
         this._track.addEventListener(MouseEvent.MOUSE_UP,this.__onTrackClickStop);
         this._track.addEventListener(MouseEvent.MOUSE_OUT,this.__onTrackClickStop);
         onPropertiesChanged(P_track);
      }
      
      public function set trackInnerRectString(param1:String) : void
      {
         if(this._trackInnerRectString == param1)
         {
            return;
         }
         this._trackInnerRectString = param1;
         this._trackInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._trackInnerRectString));
         onPropertiesChanged(P_trackInnerRect);
      }
      
      public function set trackStyle(param1:String) : void
      {
         if(this._trackStyle == param1)
         {
            return;
         }
         this._trackStyle = param1;
         this.track = ComponentFactory.Instance.creat(this._trackStyle);
      }
      
      public function get unitIncrement() : int
      {
         return this._unitIncrement;
      }
      
      public function set unitIncrement(param1:int) : void
      {
         this._unitIncrement = param1;
      }
      
      public function get valueIsAdjusting() : Boolean
      {
         return this.getModel().getValueIsAdjusting();
      }
      
      public function set valueIsAdjusting(param1:Boolean) : void
      {
         if(this.getModel().getValueIsAdjusting() == param1)
         {
            return;
         }
         this.getModel().setValueIsAdjusting(param1);
         onPropertiesChanged(P_valueIsAdjusting);
      }
      
      public function get visibleAmount() : int
      {
         return this.getModel().getExtent();
      }
      
      public function set visibleAmount(param1:int) : void
      {
         if(this.getModel().getExtent() == param1)
         {
            return;
         }
         this.getModel().setExtent(param1);
         onPropertiesChanged(P_visibleAmount);
      }
      
      protected function __decreaseButtonClicked(param1:Event) : void
      {
         this.scrollByIncrement(this._unitIncrement);
      }
      
      protected function __increaseButtonClicked(param1:Event) : void
      {
         this.scrollByIncrement(-this._unitIncrement);
      }
      
      protected function __onModelChange(param1:InteractiveEvent) : void
      {
         dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
      }
      
      protected function __onScrollValueChange(param1:InteractiveEvent) : void
      {
         if(!this._isDragging)
         {
            this.updatePosByScrollvalue();
         }
      }
      
      protected function __onThumbDown(param1:MouseEvent) : void
      {
         this.valueIsAdjusting = true;
         var _loc2_:Point = getMousePosition();
         var _loc3_:int = _loc2_.x;
         var _loc4_:int = _loc2_.y;
         if(this.isVertical())
         {
            this._thumbDownOffset = _loc4_ - this._thumb.y;
         }
         else
         {
            this._thumbDownOffset = _loc3_ - this._thumb.x;
         }
         this._isDragging = true;
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__onThumbUp);
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__onThumbMoved);
      }
      
      protected function __onThumbMoved(param1:MouseEvent) : void
      {
         this.scrollThumbToCurrentMousePosition();
         param1.updateAfterEvent();
      }
      
      protected function __onThumbUp(param1:MouseEvent) : void
      {
         this._isDragging = false;
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onThumbUp);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onThumbMoved);
      }
      
      protected function __onTrackClickStart(param1:MouseEvent) : void
      {
         this._currentTrackClickDirction = this.getValueWithPosition(getMousePosition()) > this.scrollValue ? int(int(1)) : int(int(-1));
         this.scrollToAimPoint(getMousePosition());
         this._trackClickTimer.addEventListener(TimerEvent.TIMER,this.__onTrackPressed);
         this._track.addEventListener(MouseEvent.MOUSE_UP,this.__onTrackClickStop);
         this._track.addEventListener(MouseEvent.MOUSE_OUT,this.__onTrackClickStop);
         this._trackClickTimer.start();
      }
      
      protected function __onTrackClickStop(param1:MouseEvent) : void
      {
         this._trackClickTimer.stop();
         this._trackClickTimer.removeEventListener(TimerEvent.TIMER,this.__onTrackPressed);
         this._track.removeEventListener(MouseEvent.MOUSE_UP,this.__onTrackClickStop);
         this._track.removeEventListener(MouseEvent.MOUSE_OUT,this.__onTrackClickStop);
      }
      
      protected function __onTrackPressed(param1:TimerEvent) : void
      {
         this.scrollToAimPoint(getMousePosition());
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._track)
         {
            addChild(this._track);
         }
         if(this._increaseButton)
         {
            addChild(this._increaseButton);
         }
         if(this._decreaseButton)
         {
            addChild(this._decreaseButton);
         }
         if(this._thumb)
         {
            addChild(this._thumb);
         }
      }
      
      protected function getValueWithPosition(param1:Point) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = param1.x;
         var _loc3_:int = param1.y;
         var _loc4_:Rectangle = this._thumbAreaInnerRect.getInnerRect(_width,_height);
         if(this.isVertical())
         {
            _loc5_ = _loc4_.y;
            _loc6_ = _loc4_.y + _loc4_.height - this._thumbRect.height;
            _loc7_ = _loc3_;
         }
         else
         {
            _loc5_ = _loc4_.x;
            _loc6_ = _loc4_.x + _loc4_.width - this._thumbRect.width;
            _loc7_ = _loc2_;
         }
         return this.getValueWithThumbMaxMinPos(_loc5_,_loc6_,_loc7_);
      }
      
      override protected function init() : void
      {
         this.setupModel(new BoundedRangeModel());
         this._thumbRect = new Rectangle();
         this._trackClickTimer = new Timer(ComponentSetting.BUTTON_PRESS_STEP_TIME);
         this.addStateListener(this.__onScrollValueChange);
         super.init();
      }
      
      protected function layoutComponent() : void
      {
         DisplayUtils.layoutDisplayWithInnerRect(this._increaseButton,this._increaseButtonInnerRect,_width,_height);
         DisplayUtils.layoutDisplayWithInnerRect(this._decreaseButton,this._decreaseButtonInnerRect,_width,_height);
         DisplayUtils.layoutDisplayWithInnerRect(this._track,this._trackInnerRect,_width,_height);
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[Component.P_height] || _changedPropeties[Component.P_width] || _changedPropeties[P_decreaseButtonInnerRect] || _changedPropeties[P_increaseButtonInnerRect] || _changedPropeties[P_trackInnerRect] || _changedPropeties[P_thumbAreaInnerRect])
         {
            this.layoutComponent();
         }
         if(_changedPropeties[P_maximum] || _changedPropeties[P_minimum] || _changedPropeties[P_scrollValue] || _changedPropeties[P_valueIsAdjusting] || _changedPropeties[P_visibleAmount] || _changedPropeties[P_thumbAreaInnerRect] || _changedPropeties[P_thumbMinSize] || _changedPropeties[P_thumb])
         {
            this.updatePosByScrollvalue();
         }
      }
      
      protected function scrollByIncrement(param1:int) : void
      {
         this.scrollValue += param1;
      }
      
      protected function scrollThumbToCurrentMousePosition() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:Point = getMousePosition();
         var _loc2_:int = _loc1_.x;
         var _loc3_:int = _loc1_.y;
         var _loc4_:Rectangle = this._thumbAreaInnerRect.getInnerRect(_width,_height);
         if(this.isVertical())
         {
            _loc5_ = _loc4_.y;
            _loc6_ = _loc4_.y + _loc4_.height - this._thumbRect.height;
            _loc7_ = Math.min(_loc6_,Math.max(_loc5_,_loc3_ - this._thumbDownOffset));
            this.setThumbPosAndSize(this._thumbRect.x,_loc7_,this._thumbRect.width,this._thumbRect.height);
         }
         else
         {
            _loc5_ = _loc4_.x;
            _loc6_ = _loc4_.x + _loc4_.width - this._thumbRect.width;
            _loc7_ = Math.min(_loc6_,Math.max(_loc5_,_loc2_ - this._thumbDownOffset));
            this.setThumbPosAndSize(_loc7_,this._thumbRect.y,this._thumbRect.width,this._thumbRect.height);
         }
         var _loc8_:int = this.getValueWithThumbMaxMinPos(_loc5_,_loc6_,_loc7_);
         this.scrollValue = _loc8_;
      }
      
      protected function scrollToAimPoint(param1:Point) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = this.getValueWithPosition(param1);
         if(_loc2_ > this.scrollValue && this._currentTrackClickDirction > 0)
         {
            _loc3_ = this.blockIncrement;
         }
         else
         {
            if(!(_loc2_ < this.scrollValue && this._currentTrackClickDirction < 0))
            {
               return;
            }
            _loc3_ = -this.blockIncrement;
         }
         this.scrollByIncrement(_loc3_);
      }
      
      protected function setThumbPosAndSize(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._thumbRect.x = this._thumb.x = param1;
         this._thumbRect.y = this._thumb.y = param2;
         this._thumbRect.width = this._thumb.width = param3;
         this._thumbRect.height = this._thumb.height = param4;
      }
      
      protected function updatePosByScrollvalue() : void
      {
         var _loc8_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:int = this.minimum;
         var _loc2_:int = this.visibleAmount;
         var _loc3_:int = this.maximum - _loc1_;
         var _loc4_:int = this.scrollValue;
         var _loc5_:Rectangle = this._thumbAreaInnerRect.getInnerRect(_width,_height);
         if(_loc3_ <= 0)
         {
            this._thumb.visible = false;
            return;
         }
         if(this.isVertical())
         {
            _loc6_ = _loc5_.height;
            _loc7_ = Math.floor(_loc6_ * (_loc2_ / _loc3_));
            this._thumb.visible = _loc7_ > 0 && _loc7_ < _loc5_.height;
         }
         else
         {
            _loc6_ = _loc5_.width;
            _loc7_ = Math.floor(_loc6_ * (_loc2_ / _loc3_));
            this._thumb.visible = _loc7_ < _loc5_.width;
         }
         this._increaseButton.mouseEnabled = this._decreaseButton.mouseEnabled = this._thumb.visible;
         if(_loc6_ > this.thumbMinSize)
         {
            _loc7_ = Math.max(_loc7_,this.thumbMinSize);
            this._increaseButton.mouseEnabled = this._decreaseButton.mouseEnabled = this._thumb.visible;
            _loc8_ = _loc6_ - _loc7_;
            if(_loc3_ - _loc2_ == 0)
            {
               _loc9_ = 0;
            }
            else
            {
               _loc9_ = Math.round(_loc8_ * ((_loc4_ - _loc1_) / (_loc3_ - _loc2_)));
            }
            if(this.isVertical())
            {
               this.setThumbPosAndSize(_loc5_.x,_loc9_ + _loc5_.y,_loc5_.width,_loc7_);
            }
            else
            {
               this.setThumbPosAndSize(_loc5_.x + _loc9_,_loc5_.y,_loc7_,_loc5_.height);
            }
            return;
         }
         this._thumb.visible = false;
      }
      
      private function getValueWithThumbMaxMinPos(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param3 >= param2)
         {
            _loc4_ = this._model.getMaximum() - this._model.getExtent();
         }
         else
         {
            _loc5_ = this._model.getMaximum() - this._model.getExtent();
            _loc6_ = _loc5_ - this._model.getMinimum();
            _loc7_ = param3 - param1;
            _loc8_ = param2 - param1;
            _loc9_ = Math.round(_loc7_ / _loc8_ * _loc6_);
            _loc4_ = _loc9_ + this._model.getMinimum();
         }
         return _loc4_;
      }
   }
}
