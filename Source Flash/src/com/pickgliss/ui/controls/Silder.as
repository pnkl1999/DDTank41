package com.pickgliss.ui.controls
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.IOrientable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Silder extends Component implements IOrientable
   {
      
      public static const P_bar:String = "bar";
      
      public static const P_maskShowAreaInnerRect:String = "maskShowAreaInnerRect";
      
      public static const P_maximum:String = "maximum";
      
      public static const P_minimum:String = "minimum";
      
      public static const P_orientation:String = "orientation";
      
      public static const P_progressBar:String = "progressBar";
      
      public static const P_thumb:String = "thumb";
      
      public static const P_thumbShowInnerRect:String = "thumbShowInnerRect";
      
      public static const P_value:String = "value";
       
      
      protected var _bar:DisplayObject;
      
      protected var _barStyle:String;
      
      protected var _isDragging:Boolean;
      
      protected var _maskShape:Shape;
      
      protected var _maskShowAreaInnerRect:InnerRectangle;
      
      protected var _maskShowAreaInnerRectString:String;
      
      protected var _model:BoundedRangeModel;
      
      protected var _orientation:int = -1;
      
      protected var _progressBar:DisplayObject;
      
      protected var _progressBarStyle:String;
      
      protected var _thumb:BaseButton;
      
      protected var _thumbDownOffset:int;
      
      protected var _thumbShowInnerRect:InnerRectangle;
      
      protected var _thumbShowInnerRectString:String;
      
      protected var _thumbStyle:String;
      
      protected var _value:Number;
      
      public function Silder()
      {
         super();
      }
      
      public function set bar(param1:DisplayObject) : void
      {
         if(this._bar == param1)
         {
            return;
         }
         this._bar = param1;
         onPropertiesChanged(P_bar);
      }
      
      public function set barStyle(param1:String) : void
      {
         if(this._barStyle == param1)
         {
            return;
         }
         this._barStyle = param1;
         this.bar = ComponentFactory.Instance.creat(this._barStyle);
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__onSilderClick);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onThumbMouseUp);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onThumbMouseMoved);
         if(this._thumb)
         {
            this._thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.__onThumbMouseDown);
         }
         ObjectUtils.disposeObject(this._thumb);
         ObjectUtils.disposeObject(this._bar);
         ObjectUtils.disposeObject(this._progressBar);
         ObjectUtils.disposeObject(this._maskShape);
         super.dispose();
      }
      
      public function getModel() : BoundedRangeModel
      {
         return this._model;
      }
      
      public function isVertical() : Boolean
      {
         return this._orientation == 0;
      }
      
      public function set maskShowAreaInnerRectString(param1:String) : void
      {
         if(this._maskShowAreaInnerRectString == param1)
         {
            return;
         }
         this._maskShowAreaInnerRectString = param1;
         this._maskShowAreaInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._maskShowAreaInnerRectString));
         onPropertiesChanged(P_maskShowAreaInnerRect);
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
      
      public function set progressBar(param1:DisplayObject) : void
      {
         if(this._progressBar == param1)
         {
            return;
         }
         this._progressBar = param1;
         onPropertiesChanged(P_progressBar);
      }
      
      public function set progressBarStyle(param1:String) : void
      {
         if(this._progressBarStyle == param1)
         {
            return;
         }
         this._progressBarStyle = param1;
         this.progressBar = ComponentFactory.Instance.creat(this._progressBarStyle);
      }
      
      public function removeStateListener(param1:Function) : void
      {
         removeEventListener(InteractiveEvent.STATE_CHANGED,param1);
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
            ObjectUtils.disposeObject(this._thumb);
            this._thumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onThumbMouseDown);
         }
         this._thumb = param1;
         this._thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.__onThumbMouseDown);
         onPropertiesChanged(P_thumb);
      }
      
      public function set thumbShowInnerRectString(param1:String) : void
      {
         if(this._thumbShowInnerRectString == param1)
         {
            return;
         }
         this._thumbShowInnerRectString = param1;
         this._thumbShowInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._thumbShowInnerRectString));
         onPropertiesChanged(P_thumbShowInnerRect);
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
      
      public function get value() : Number
      {
         return this.getModel().getValue();
      }
      
      public function set value(param1:Number) : void
      {
         if(this._value == param1)
         {
            return;
         }
         this._value = param1;
         this.getModel().setValue(this._value);
         onPropertiesChanged(P_value);
      }
      
      protected function __onModelChange(param1:InteractiveEvent) : void
      {
         dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
      }
      
      protected function __onSilderClick(param1:MouseEvent) : void
      {
         this.scrollThumbToCurrentMousePosition();
         param1.updateAfterEvent();
      }
      
      protected function __onThumbMouseDown(param1:MouseEvent) : void
      {
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
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__onThumbMouseUp);
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__onThumbMouseMoved);
      }
      
      protected function __onThumbMouseMoved(param1:MouseEvent) : void
      {
         this.scrollThumbToCurrentMousePosition();
         param1.updateAfterEvent();
      }
      
      protected function __onThumbMouseUp(param1:MouseEvent) : void
      {
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__onThumbMouseUp);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onThumbMouseMoved);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._bar)
         {
            addChild(this._bar);
         }
         if(this._progressBar)
         {
            addChild(this._progressBar);
            addChild(this._maskShape);
         }
         if(this._thumb)
         {
            addChild(this._thumb);
         }
      }
      
      override protected function init() : void
      {
         this.setupModel(new BoundedRangeModel());
         this.setupMask();
         addEventListener(MouseEvent.CLICK,this.__onSilderClick);
         super.init();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height])
         {
            this.updateSize();
         }
         if(_changedPropeties[P_value] || _changedPropeties[P_thumbShowInnerRect] || _changedPropeties[P_maskShowAreaInnerRect] || _changedPropeties[Component.P_width] || _changedPropeties[Component.P_height] || _changedPropeties[P_maximum] || _changedPropeties[P_minimum])
         {
            this.updateThumbPos();
            this.updateMask();
            if(this._bar)
            {
               this._bar.width = _width;
               this._bar.height = _height;
            }
         }
      }
      
      protected function scrollThumbToCurrentMousePosition() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:Point = getMousePosition();
         var _loc2_:int = _loc1_.x;
         var _loc3_:int = _loc1_.y;
         var _loc4_:Rectangle = this._thumbShowInnerRect.getInnerRect(_width,_height);
         if(this.isVertical())
         {
            _loc5_ = _loc4_.y;
            _loc6_ = _loc4_.y + _loc4_.height;
            _loc7_ = Math.min(_loc6_,Math.max(_loc5_,_loc3_ - this._thumbDownOffset));
         }
         else
         {
            _loc5_ = _loc4_.x;
            _loc6_ = _loc4_.x + _loc4_.width;
            _loc7_ = Math.min(_loc6_,Math.max(_loc5_,_loc2_ - this._thumbDownOffset));
         }
         this.value = this.getValueWithThumbMaxMinPos(_loc5_,_loc6_,_loc7_);
      }
      
      protected function setupMask() : void
      {
         this._maskShape = new Shape();
         this._maskShape.graphics.beginFill(16711680,1);
         this._maskShape.graphics.drawRect(0,0,100,100);
         this._maskShape.graphics.endFill();
      }
      
      protected function updateMask() : void
      {
         if(this._maskShowAreaInnerRect == null)
         {
            return;
         }
         var _loc1_:Rectangle = this._maskShowAreaInnerRect.getInnerRect(_width,_height);
         this._maskShape.x = _loc1_.x;
         this._maskShape.y = _loc1_.y;
         var _loc2_:Number = this.calculateValuePercent();
         if(this.isVertical())
         {
            this._maskShape.height = _loc1_.height * _loc2_;
            this._maskShape.width = _loc1_.width;
         }
         else
         {
            this._maskShape.width = _loc1_.width * _loc2_;
            this._maskShape.height = _loc1_.height;
         }
         if(this._maskShape)
         {
            this._progressBar.mask = this._maskShape;
         }
      }
      
      protected function updateSize() : void
      {
         this._bar.width = _width;
         this._bar.height = _height;
         if(this._progressBar)
         {
            this._progressBar.width = _width;
            this._progressBar.height = _height;
         }
      }
      
      protected function updateThumbPos() : void
      {
         var _loc1_:Rectangle = null;
         var _loc4_:Number = NaN;
         _loc1_ = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc4_ = NaN;
         if(this._thumbShowInnerRect == null)
         {
            return;
         }
         _loc1_ = this._thumbShowInnerRect.getInnerRect(_width,_height);
         _loc4_ = this.calculateValuePercent();
         if(this.isVertical())
         {
            this._thumb.x = _loc1_.x;
            _loc2_ = _loc1_.height;
            _loc3_ = _loc1_.y;
            this._thumb.y = Math.round(_loc4_ * _loc2_) + _loc3_;
         }
         else
         {
            this._thumb.y = _loc1_.y;
            _loc2_ = _loc1_.width;
            _loc3_ = _loc1_.x;
            this._thumb.x = Math.round(_loc4_ * _loc2_) + _loc3_;
         }
         this._thumb.tipData = this._value;
      }
      
      private function calculateValuePercent() : Number
      {
         var _loc1_:Number = NaN;
         if(this._value < this.minimum || isNaN(this._value))
         {
            this._value = this.minimum;
         }
         if(this._value > this.maximum)
         {
            this._value = this.maximum;
         }
         if(this.maximum > this.minimum)
         {
            _loc1_ = (this._value - this.minimum) / (this.maximum - this.minimum);
         }
         else
         {
            _loc1_ = 1;
         }
         return _loc1_;
      }
      
      private function getValueWithThumbMaxMinPos(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = param2 - param1;
         var _loc5_:Number = (param3 - param1) / _loc4_;
         var _loc6_:Number = this.maximum - this.minimum;
         return _loc5_ * _loc6_ + this.minimum;
      }
   }
}
