package com.pickgliss.ui.controls
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   
   public class IconButton extends TextButton
   {
      
      public static const P_icon:String = "icon";
      
      public static const P_iconInnerRect:String = "iconInnerRect";
       
      
      protected var _icon:DisplayObject;
      
      protected var _iconInnerRect:InnerRectangle;
      
      protected var _iconInnerRectString:String;
      
      protected var _iconStyle:String;
      
      public function IconButton()
      {
         super();
      }
      
      override public function dispose() : void
      {
         if(this._icon)
         {
            ObjectUtils.disposeObject(this._icon);
         }
         this._icon = null;
         super.dispose();
      }
      
      public function set icon(param1:DisplayObject) : void
      {
         if(this._icon == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._icon);
         this._icon = param1;
         onPropertiesChanged(P_icon);
      }
      
      public function set iconInnerRectString(param1:String) : void
      {
         if(this._iconInnerRectString == param1)
         {
            return;
         }
         this._iconInnerRectString = param1;
         this._iconInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._iconInnerRectString));
         onPropertiesChanged(P_iconInnerRect);
      }
      
      public function set iconStyle(param1:String) : void
      {
         if(this._iconStyle == param1)
         {
            return;
         }
         this._iconStyle = param1;
         this.icon = ComponentFactory.Instance.creat(this._iconStyle);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._icon)
         {
            addChild(this._icon);
         }
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[Component.P_width] || _changedPropeties[Component.P_height] || _changedPropeties[P_iconInnerRect] || _changedPropeties[P_icon])
         {
            this.updateIconPos();
         }
      }
      
      protected function updateIconPos() : void
      {
         if(this._icon && this._iconInnerRect)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._icon,this._iconInnerRect,_width,_height);
         }
      }
      
      override public function setFrame(param1:int) : void
      {
         super.setFrame(param1);
         DisplayUtils.setFrame(this._icon,param1);
      }
   }
}
