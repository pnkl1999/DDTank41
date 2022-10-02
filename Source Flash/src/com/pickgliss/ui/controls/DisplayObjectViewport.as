package com.pickgliss.ui.controls
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.geom.IntDimension;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.geom.IntRectangle;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.IViewprot;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class DisplayObjectViewport extends Component implements IViewprot
   {
      
      public static const P_horizontalBlockIncrement:String = "horizontalBlockIncrement";
      
      public static const P_horizontalUnitIncrement:String = "horizontalUnitIncrement";
      
      public static const P_verticalBlockIncrement:String = "verticalBlockIncrement";
      
      public static const P_verticalUnitIncrement:String = "verticalUnitIncrement";
      
      public static const P_view:String = "view";
      
      public static const P_viewPosition:String = "viewPosition";
       
      
      protected var _horizontalBlockIncrement:int;
      
      protected var _horizontalUnitIncrement:int;
      
      protected var _maskShape:Shape;
      
      protected var _mouseActiveObjectShape:Shape;
      
      protected var _verticalBlockIncrement:int;
      
      protected var _verticalUnitIncrement:int;
      
      protected var _viewContainer:Sprite;
      
      protected var _viewHeight:int;
      
      protected var _viewPosition:IntPoint;
      
      protected var _viewWidth:int;
      
      private var _view:DisplayObject;
      
      public function DisplayObjectViewport()
      {
         this._horizontalBlockIncrement = ComponentSetting.SCROLL_BLOCK_INCREMENT;
         this._horizontalUnitIncrement = ComponentSetting.SCROLL_UINT_INCREMENT;
         this._verticalBlockIncrement = ComponentSetting.SCROLL_BLOCK_INCREMENT;
         this._verticalUnitIncrement = ComponentSetting.SCROLL_UINT_INCREMENT;
         super();
      }
      
      public function addStateListener(param1:Function, param2:int = 0, param3:Boolean = false) : void
      {
         addEventListener(InteractiveEvent.STATE_CHANGED,param1);
      }
      
      override public function dispose() : void
      {
         if(this._view is Component)
         {
            Component(this._view).removeEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onResize);
         }
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         if(this._mouseActiveObjectShape)
         {
            ObjectUtils.disposeObject(this._mouseActiveObjectShape);
         }
         this._mouseActiveObjectShape = null;
         if(this._maskShape)
         {
            ObjectUtils.disposeObject(this._maskShape);
         }
         this._maskShape = null;
         super.dispose();
      }
      
      public function getExtentSize() : IntDimension
      {
         return new IntDimension(_width,_height);
      }
      
      public function getViewSize() : IntDimension
      {
         return new IntDimension(this._viewWidth,this._viewHeight);
      }
      
      public function getViewportPane() : Component
      {
         return this;
      }
      
      public function get horizontalBlockIncrement() : int
      {
         return this._horizontalBlockIncrement;
      }
      
      public function set horizontalBlockIncrement(param1:int) : void
      {
         if(this._horizontalBlockIncrement == param1)
         {
            return;
         }
         this._horizontalBlockIncrement = param1;
         onPropertiesChanged(P_horizontalBlockIncrement);
      }
      
      public function get horizontalUnitIncrement() : int
      {
         return this._horizontalUnitIncrement;
      }
      
      public function set horizontalUnitIncrement(param1:int) : void
      {
         if(this._horizontalUnitIncrement == param1)
         {
            return;
         }
         this._horizontalUnitIncrement = param1;
         onPropertiesChanged(P_horizontalUnitIncrement);
      }
      
      public function removeStateListener(param1:Function) : void
      {
         removeEventListener(InteractiveEvent.STATE_CHANGED,param1);
      }
      
      public function scrollRectToVisible(param1:IntRectangle) : void
      {
         this.viewPosition = new IntPoint(param1.x,param1.y);
      }
      
      public function setView(param1:DisplayObject) : void
      {
         if(this._view == param1)
         {
            return;
         }
         if(this._view is Component)
         {
            Component(this._view).removeEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onResize);
         }
         if(this._view)
         {
            ObjectUtils.disposeObject(param1);
         }
         this._view = param1;
         if(this._view is Component)
         {
            Component(this._view).addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onResize);
         }
         onPropertiesChanged(P_view);
      }
      
      public function setViewportTestSize(param1:IntDimension) : void
      {
      }
      
      public function get verticalBlockIncrement() : int
      {
         return this._verticalBlockIncrement;
      }
      
      public function set verticalBlockIncrement(param1:int) : void
      {
         if(this._verticalBlockIncrement == param1)
         {
            return;
         }
         this._verticalBlockIncrement = param1;
         onPropertiesChanged(P_verticalBlockIncrement);
      }
      
      public function get verticalUnitIncrement() : int
      {
         return this._verticalUnitIncrement;
      }
      
      public function set verticalUnitIncrement(param1:int) : void
      {
         if(this._verticalUnitIncrement == param1)
         {
            return;
         }
         this._verticalUnitIncrement = param1;
         onPropertiesChanged(P_verticalUnitIncrement);
      }
      
      public function get viewPosition() : IntPoint
      {
         return this._viewPosition;
      }
      
      public function set viewPosition(param1:IntPoint) : void
      {
         if(this._viewPosition.equals(param1))
         {
            return;
         }
         this._viewPosition.setLocation(param1);
         onPropertiesChanged(P_viewPosition);
      }
      
      public function invalidateView() : void
      {
         onPropertiesChanged(P_view);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._mouseActiveObjectShape);
         addChild(this._maskShape);
         addChild(this._viewContainer);
      }
      
      protected function creatMaskShape() : void
      {
         this._maskShape = new Shape();
         this._maskShape.graphics.beginFill(16711680,1);
         this._maskShape.graphics.drawRect(0,0,100,100);
         this._maskShape.graphics.endFill();
         this._mouseActiveObjectShape = new Shape();
         this._mouseActiveObjectShape.graphics.beginFill(16711680,0);
         this._mouseActiveObjectShape.graphics.drawRect(0,0,100,100);
         this._mouseActiveObjectShape.graphics.endFill();
      }
      
      protected function fireStateChanged(param1:Boolean = true) : void
      {
         dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
      }
      
      protected function getViewMaxPos() : IntPoint
      {
         var _loc1_:IntDimension = this.getExtentSize();
         var _loc2_:IntDimension = this.getViewSize();
         var _loc3_:IntPoint = new IntPoint(_loc2_.width - _loc1_.width,_loc2_.height - _loc1_.height);
         if(_loc3_.x < 0)
         {
            _loc3_.x = 0;
         }
         if(_loc3_.y < 0)
         {
            _loc3_.y = 0;
         }
         return _loc3_;
      }
      
      override protected function init() : void
      {
         this.creatMaskShape();
         this._viewContainer = new Sprite();
         this._viewPosition = new IntPoint(0,0);
         super.init();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[Component.P_height] || _changedPropeties[Component.P_width])
         {
            this.updateShowMask();
         }
         if(_changedPropeties[P_view] || _changedPropeties[P_viewPosition])
         {
            this._viewWidth = this._view.width;
            this._viewHeight = this._view.height;
            this._viewContainer.addChild(this._view);
            this._view.mask = this._maskShape;
            this.updatePos();
            this.fireStateChanged();
         }
      }
      
      protected function restrictionViewPos(param1:IntPoint) : IntPoint
      {
         var _loc2_:IntPoint = this.getViewMaxPos();
         param1.x = Math.max(0,Math.min(_loc2_.x,param1.x));
         param1.y = Math.max(0,Math.min(_loc2_.y,param1.y));
         return param1;
      }
      
      protected function updatePos() : void
      {
         this.restrictionViewPos(this._viewPosition);
         this._view.x = -this._viewPosition.x;
         this._view.y = -this._viewPosition.y;
      }
      
      protected function updateShowMask() : void
      {
         this._mouseActiveObjectShape.width = this._maskShape.width = _width;
         this._mouseActiveObjectShape.height = this._maskShape.height = _height;
      }
      
      private function __onResize(param1:ComponentEvent) : void
      {
         if(param1.changedProperties[Component.P_height] || param1.changedProperties[Component.P_width])
         {
            onPropertiesChanged(P_view);
         }
      }
   }
}
