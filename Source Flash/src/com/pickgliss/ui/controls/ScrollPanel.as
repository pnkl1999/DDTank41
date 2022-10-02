package com.pickgliss.ui.controls
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.geom.IntDimension;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.geom.IntRectangle;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.IViewprot;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ScrollPanel extends Component
   {
      
      public static const AUTO:int = 1;
      
      public static const OFF:int = 2;
      
      public static const ON:int = 0;
      
      public static const P_backgound:String = "backgound";
      
      public static const P_backgoundInnerRect:String = "backgoundInnerRect";
      
      public static const P_hScrollProxy:String = "hScrollProxy";
      
      public static const P_hScrollbar:String = "vScrollbar";
      
      public static const P_hScrollbarInnerRect:String = "hScrollbarInnerRect";
      
      public static const P_vScrollProxy:String = "vScrollProxy";
      
      public static const P_vScrollbar:String = "vScrollbar";
      
      public static const P_vScrollbarInnerRect:String = "vScrollbarInnerRect";
      
      public static const P_viewSource:String = "viewSource";
      
      public static const P_viewportInnerRect:String = "viewportInnerRect";
       
      
      protected var _backgound:DisplayObject;
      
      protected var _backgoundInnerRect:InnerRectangle;
      
      protected var _backgoundInnerRectString:String;
      
      protected var _backgoundStyle:String;
      
      protected var _hScrollProxy:int;
      
      protected var _hScrollbar:Scrollbar;
      
      protected var _hScrollbarInnerRect:InnerRectangle;
      
      protected var _hScrollbarInnerRectString:String;
      
      protected var _hScrollbarStyle:String;
      
      protected var _vScrollProxy:int;
      
      protected var _vScrollbar:Scrollbar;
      
      protected var _vScrollbarInnerRect:InnerRectangle;
      
      protected var _vScrollbarInnerRectString:String;
      
      protected var _vScrollbarStyle:String;
      
      protected var _viewSource:IViewprot;
      
      protected var _viewportInnerRect:InnerRectangle;
      
      protected var _viewportInnerRectString:String;
      
      public function ScrollPanel(param1:Boolean = true)
      {
         super();
         if(param1)
         {
            this._viewSource = new DisplayObjectViewport();
            this._viewSource.addStateListener(this.__onViewportStateChanged);
         }
      }
      
      public function set backgound(param1:DisplayObject) : void
      {
         if(this._backgound == param1)
         {
            return;
         }
         if(this._backgound)
         {
            ObjectUtils.disposeObject(this._backgound);
         }
         this._backgound = param1;
         onPropertiesChanged(P_backgound);
      }
      
      public function set backgoundInnerRectString(param1:String) : void
      {
         if(this._backgoundInnerRectString == param1)
         {
            return;
         }
         this._backgoundInnerRectString = param1;
         this._backgoundInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._backgoundInnerRectString));
         onPropertiesChanged(P_backgoundInnerRect);
      }
      
      public function set backgoundStyle(param1:String) : void
      {
         if(this._backgoundStyle == param1)
         {
            return;
         }
         this._backgoundStyle = param1;
         this.backgound = ComponentFactory.Instance.creat(this._backgoundStyle);
      }
      
      public function get displayObjectViewport() : DisplayObjectViewport
      {
         return this._viewSource as DisplayObjectViewport;
      }
      
      override public function dispose() : void
      {
         if(this._vScrollbar)
         {
            this._vScrollbar.removeStateListener(this.__onScrollValueChange);
            ObjectUtils.disposeObject(this._vScrollbar);
         }
         this._vScrollbar = null;
         if(this._hScrollbar)
         {
            this._hScrollbar.removeStateListener(this.__onScrollValueChange);
            ObjectUtils.disposeObject(this._hScrollbar);
         }
         this._hScrollbar = null;
         if(this._backgound)
         {
            ObjectUtils.disposeObject(this._backgound);
         }
         this._backgound = null;
         if(this._viewSource)
         {
            ObjectUtils.disposeObject(this._viewSource);
         }
         this._viewSource = null;
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.__onMouseWheel);
         super.dispose();
      }
      
      public function getShowHScrollbarExtendHeight() : Number
      {
         var _loc1_:Rectangle = null;
         if(_height == 0 || this._hScrollbarInnerRect == null)
         {
            return 0;
         }
         var _loc2_:Rectangle = this._viewportInnerRect.getInnerRect(_width,_height);
         var _loc3_:Rectangle = this._hScrollbarInnerRect.getInnerRect(_width,_height);
         _loc1_ = _loc2_.union(_loc3_);
         return _loc2_.height - _loc1_.height;
      }
      
      public function getVisibleRect() : IntRectangle
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:IntDimension = this._viewSource.getViewSize();
         if(this._hScrollbar == null)
         {
            _loc2_ = 0;
            _loc4_ = _loc5_.width;
         }
         else
         {
            _loc2_ = this._hScrollbar.scrollValue;
            _loc4_ = this._hScrollbar.visibleAmount;
         }
         if(this._vScrollbar == null)
         {
            _loc1_ = 0;
            _loc3_ = _loc5_.height;
         }
         else
         {
            _loc1_ = this._vScrollbar.scrollValue;
            _loc3_ = this._vScrollbar.visibleAmount;
         }
         return new IntRectangle(_loc2_,_loc1_,_loc4_,_loc3_);
      }
      
      public function set hScrollProxy(param1:int) : void
      {
         if(this._hScrollProxy == param1)
         {
            return;
         }
         this._hScrollProxy = param1;
         onPropertiesChanged(P_hScrollProxy);
      }
      
      public function get hScrollbar() : Scrollbar
      {
         return this._hScrollbar;
      }
      
      public function set hScrollbar(param1:Scrollbar) : void
      {
         if(this._hScrollbar == param1)
         {
            return;
         }
         if(this._hScrollbar)
         {
            this._hScrollbar.removeStateListener(this.__onScrollValueChange);
            ObjectUtils.disposeObject(this._hScrollbar);
         }
         this._hScrollbar = param1;
         this._hScrollbar.addStateListener(this.__onScrollValueChange);
         onPropertiesChanged(P_hScrollbar);
      }
      
      public function set hScrollbarInnerRectString(param1:String) : void
      {
         if(this._hScrollbarInnerRectString == param1)
         {
            return;
         }
         this._hScrollbarInnerRectString = param1;
         this._hScrollbarInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._hScrollbarInnerRectString));
         onPropertiesChanged(P_hScrollbarInnerRect);
      }
      
      public function set hScrollbarStyle(param1:String) : void
      {
         if(this._hScrollbarStyle == param1)
         {
            return;
         }
         this._hScrollbarStyle = param1;
         this.hScrollbar = ComponentFactory.Instance.creat(this._hScrollbarStyle);
      }
      
      public function set hUnitIncrement(param1:int) : void
      {
         this._viewSource.horizontalUnitIncrement = param1;
      }
      
      public function invalidateViewport(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:IntPoint = null;
         if(this._viewSource is DisplayObjectViewport)
         {
            if(param1)
            {
               this.displayObjectViewport.invalidateView();
               _loc2_ = this.viewPort.getViewSize().height;
               _loc3_ = new IntPoint(0,_loc2_);
               this.viewPort.viewPosition = _loc3_;
            }
            else
            {
               this.displayObjectViewport.invalidateView();
            }
         }
      }
      
      public function setView(param1:DisplayObject) : void
      {
         if(this._viewSource is DisplayObjectViewport)
         {
            this.displayObjectViewport.setView(param1);
         }
      }
      
      public function set vScrollProxy(param1:int) : void
      {
         if(this._vScrollProxy == param1)
         {
            return;
         }
         this._vScrollProxy = param1;
         onPropertiesChanged(P_vScrollProxy);
      }
      
      public function get vScrollbar() : Scrollbar
      {
         return this._vScrollbar;
      }
      
      public function set vScrollbar(param1:Scrollbar) : void
      {
         if(this._vScrollbar == param1)
         {
            return;
         }
         if(this._vScrollbar)
         {
            this._vScrollbar.removeStateListener(this.__onScrollValueChange);
            ObjectUtils.disposeObject(this._vScrollbar);
         }
         this._vScrollbar = param1;
         this._vScrollbar.addStateListener(this.__onScrollValueChange);
         onPropertiesChanged(P_vScrollbar);
      }
      
      public function set vScrollbarInnerRectString(param1:String) : void
      {
         if(this._vScrollbarInnerRectString == param1)
         {
            return;
         }
         this._vScrollbarInnerRectString = param1;
         this._vScrollbarInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._vScrollbarInnerRectString));
         onPropertiesChanged(P_vScrollbarInnerRect);
      }
      
      public function set vScrollbarStyle(param1:String) : void
      {
         if(this._vScrollbarStyle == param1)
         {
            return;
         }
         this._vScrollbarStyle = param1;
         this.vScrollbar = ComponentFactory.Instance.creat(this._vScrollbarStyle);
      }
      
      public function set vUnitIncrement(param1:int) : void
      {
         this._viewSource.verticalUnitIncrement = param1;
      }
      
      public function get viewPort() : IViewprot
      {
         return this._viewSource;
      }
      
      public function set viewPort(param1:IViewprot) : void
      {
         if(this._viewSource == param1)
         {
            return;
         }
         if(this._viewSource)
         {
            this._viewSource.removeStateListener(this.__onViewportStateChanged);
            ObjectUtils.disposeObject(this._viewSource);
         }
         this._viewSource = param1;
         this._viewSource.addStateListener(this.__onViewportStateChanged);
         onPropertiesChanged(P_viewSource);
      }
      
      public function set viewportInnerRectString(param1:String) : void
      {
         if(this._viewportInnerRectString == param1)
         {
            return;
         }
         this._viewportInnerRectString = param1;
         this._viewportInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._viewportInnerRectString));
         onPropertiesChanged(P_viewportInnerRect);
      }
      
      protected function __onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:IntPoint = this._viewSource.viewPosition.clone();
         _loc2_.y -= param1.delta * this._viewSource.verticalUnitIncrement;
         this._viewSource.viewPosition = _loc2_;
      }
      
      public function setViewPosition(param1:int) : void
      {
         var _loc2_:IntPoint = this._viewSource.viewPosition.clone();
         _loc2_.y += param1 * this._viewSource.verticalUnitIncrement;
         this._viewSource.viewPosition = _loc2_;
      }
      
      protected function __onScrollValueChange(param1:InteractiveEvent) : void
      {
         this.viewPort.scrollRectToVisible(this.getVisibleRect());
      }
      
      protected function __onViewportStateChanged(param1:InteractiveEvent) : void
      {
         this.syncScrollPaneWithViewport();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._backgound)
         {
            addChild(this._backgound);
         }
         if(this._viewSource)
         {
            addChild(this._viewSource.asDisplayObject());
         }
         if(this._vScrollbar)
         {
            addChild(this._vScrollbar);
         }
         if(this._hScrollbar)
         {
            addChild(this._hScrollbar);
         }
      }
      
      override protected function init() : void
      {
         this.initEvent();
         super.init();
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.__onMouseWheel);
      }
      
      protected function layoutComponent() : void
      {
         if(this._vScrollbar)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._vScrollbar,this._vScrollbarInnerRect,_width,_height);
         }
         if(this._hScrollbar)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._hScrollbar,this._hScrollbarInnerRect,_width,_height);
         }
         if(this._backgound)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._backgound,this._backgoundInnerRect,_width,_height);
         }
         if(this._viewSource)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._viewSource.asDisplayObject(),this._viewportInnerRect,_width,_height);
         }
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[Component.P_height] || _changedPropeties[Component.P_width] || _changedPropeties[P_vScrollbarInnerRect] || _changedPropeties[P_hScrollbarInnerRect] || _changedPropeties[P_vScrollbar] || _changedPropeties[P_hScrollbar] || _changedPropeties[P_viewportInnerRect] || _changedPropeties[P_viewSource])
         {
            this.layoutComponent();
         }
         if(_changedPropeties[P_viewSource])
         {
            this.syncScrollPaneWithViewport();
         }
         if(_changedPropeties[P_vScrollProxy] || _changedPropeties[P_hScrollProxy])
         {
            if(this._vScrollbar)
            {
               this._vScrollbar.visible = this._vScrollProxy == ON;
            }
            if(this._hScrollbar)
            {
               this._hScrollbar.visible = this._hScrollProxy == ON;
            }
         }
      }
      
      protected function syncScrollPaneWithViewport() : void
      {
         var _loc1_:IntDimension = null;
         var _loc2_:IntDimension = null;
         var _loc3_:IntPoint = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this._viewSource != null)
         {
            _loc1_ = this._viewSource.getExtentSize();
            if(_loc1_.width <= 0 || _loc1_.height <= 0)
            {
               return;
            }
            _loc2_ = this._viewSource.getViewSize();
            _loc3_ = this._viewSource.viewPosition;
            if(this._vScrollbar != null)
            {
               _loc4_ = _loc1_.height;
               _loc5_ = _loc2_.height;
               _loc6_ = Math.max(0,Math.min(_loc3_.y,_loc5_ - _loc4_));
               this._vScrollbar.unitIncrement = this._viewSource.verticalUnitIncrement;
               this._vScrollbar.blockIncrement = this._viewSource.verticalBlockIncrement;
               this._vScrollbar.getModel().setRangeProperties(_loc6_,_loc4_,0,_loc5_,false);
            }
            if(this._hScrollbar != null)
            {
               _loc4_ = _loc1_.width;
               _loc5_ = _loc2_.width;
               _loc6_ = Math.max(0,Math.min(_loc3_.x,_loc5_ - _loc4_));
               this._hScrollbar.unitIncrement = this._viewSource.horizontalUnitIncrement;
               this._hScrollbar.blockIncrement = this._viewSource.horizontalBlockIncrement;
               this._hScrollbar.getModel().setRangeProperties(_loc6_,_loc4_,0,_loc5_,false);
            }
            this.updateAutoHiddenScroll();
         }
      }
      
      private function updateAutoHiddenScroll() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         if(this._vScrollbar == null && this._hScrollbar == null)
         {
            return;
         }
         if(this._vScrollbar != null)
         {
            if(this._vScrollProxy == AUTO)
            {
               this._vScrollbar.visible = this._vScrollbar.getThumbVisible();
            }
            if(this._vScrollProxy == AUTO && this._vScrollbar.maximum == 0)
            {
               this._vScrollbar.visible = false;
            }
         }
         if(this._hScrollbar)
         {
            if(this._hScrollProxy == AUTO)
            {
               this._hScrollbar.visible = this._hScrollbar.getThumbVisible();
            }
            if(this._hScrollProxy == AUTO && this._hScrollbar.maximum == 0)
            {
               this._hScrollbar.visible = false;
            }
         }
         if(this._vScrollProxy == AUTO || this._hScrollProxy == AUTO)
         {
            _loc2_ = this._viewportInnerRect.getInnerRect(_width,_height);
            if(this._vScrollbarInnerRect)
            {
               _loc3_ = this._vScrollbarInnerRect.getInnerRect(_width,_height);
            }
            if(this._hScrollbarInnerRect)
            {
               _loc4_ = this._hScrollbarInnerRect.getInnerRect(_width,_height);
            }
            if(this._vScrollbar != null)
            {
               if(!this._vScrollbar.getThumbVisible() || this._vScrollbar.visible == false)
               {
                  _loc1_ = _loc2_.union(_loc3_);
               }
            }
            if(this._hScrollbar != null)
            {
               if(!this._hScrollbar.getThumbVisible() || this._hScrollbar.visible == false)
               {
                  if(_loc1_)
                  {
                     _loc1_ = _loc1_.union(_loc4_);
                  }
                  else
                  {
                     _loc1_ = _loc2_.union(_loc4_);
                  }
               }
            }
            if(_loc1_ == null)
            {
               _loc1_ = _loc2_;
            }
            this._viewSource.x = _loc1_.x;
            this._viewSource.y = _loc1_.y;
            this._viewSource.width = _loc1_.width;
            this._viewSource.height = _loc1_.height;
         }
      }
   }
}
