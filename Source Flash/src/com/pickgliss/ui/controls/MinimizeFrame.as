package com.pickgliss.ui.controls
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.MouseEvent;
   
   public class MinimizeFrame extends Frame
   {
      
      public static const P_minimizeButton:String = "minimizeButton";
      
      public static const P_minimizeRect:String = "minimizeInnerRect";
       
      
      protected var _minimizeButton:BaseButton;
      
      protected var _minimizeInnerRect:InnerRectangle;
      
      protected var _minimizeRectString:String;
      
      protected var _minimizeStyle:String;
      
      public function MinimizeFrame()
      {
         super();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._minimizeButton)
         {
            addChild(this._minimizeButton);
         }
      }
      
      public function set minimizeRectString(param1:String) : void
      {
         if(this._minimizeRectString == param1)
         {
            return;
         }
         this._minimizeRectString = param1;
         this._minimizeInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._minimizeRectString));
         onPropertiesChanged(P_closeInnerRect);
      }
      
      public function get minimizeButton() : BaseButton
      {
         return this._minimizeButton;
      }
      
      public function set minimizeButton(param1:BaseButton) : void
      {
         if(this._minimizeButton == param1)
         {
            return;
         }
         if(this._minimizeButton)
         {
            this._minimizeButton.removeEventListener(MouseEvent.CLICK,this.__onMinimizeClick);
            ObjectUtils.disposeObject(this._minimizeButton);
         }
         this._minimizeButton = param1;
         onPropertiesChanged(P_minimizeButton);
      }
      
      public function set minimizeStyle(param1:String) : void
      {
         if(this._minimizeStyle == param1)
         {
            return;
         }
         this._minimizeStyle = param1;
         this.minimizeButton = ComponentFactory.Instance.creat(this._minimizeStyle);
      }
      
      protected function updateMinimizePos() : void
      {
         if(this._minimizeButton && this._minimizeInnerRect)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._minimizeButton,this._minimizeInnerRect,_width,_height);
         }
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[P_minimizeButton])
         {
            this._minimizeButton.addEventListener(MouseEvent.CLICK,this.__onMinimizeClick);
         }
         if(_changedPropeties[P_minimizeButton] || _changedPropeties[P_minimizeRect])
         {
            this.updateMinimizePos();
         }
      }
      
      protected function __onMinimizeClick(param1:MouseEvent) : void
      {
         onResponse(FrameEvent.MINIMIZE_CLICK);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._minimizeButton)
         {
            this._minimizeButton.removeEventListener(MouseEvent.CLICK,this.__onMinimizeClick);
            ObjectUtils.disposeObject(this._minimizeButton);
         }
         this._minimizeButton = null;
      }
   }
}
