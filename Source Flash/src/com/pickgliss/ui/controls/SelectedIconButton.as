package com.pickgliss.ui.controls
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class SelectedIconButton extends SelectedButton
   {
      
      public static const P_icon:String = "icon";
      
      public static const P_iconInnerRect:String = "iconInnerRect";
       
      
      protected var _selectedIcon:DisplayObject;
      
      protected var _selectedIconInnerRect:InnerRectangle;
      
      protected var _selectedIconInnerRectString:String;
      
      protected var _selectedIconStyle:String;
      
      protected var _unselectedIcon:DisplayObject;
      
      protected var _unselectedIconInnerRect:InnerRectangle;
      
      protected var _unselectedIconInnerRectString:String;
      
      protected var _unselectedIconStyle:String;
      
      public function SelectedIconButton()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override public function set selected(param1:Boolean) : void
      {
         _selected = param1;
         if(_selectedButton)
         {
            _selectedButton.visible = _selected;
         }
         if(_unSelectedButton)
         {
            _unSelectedButton.visible = !_selected;
         }
         if(this._selectedIcon)
         {
            this._selectedIcon.visible = _selected;
         }
         if(this._unselectedIcon)
         {
            this._unselectedIcon.visible = !_selected;
         }
         dispatchEvent(new Event(Event.SELECT));
         drawHitArea();
      }
      
      public function set selectedIcon(param1:DisplayObject) : void
      {
         if(this._selectedIcon == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._selectedIcon);
         this._selectedIcon = param1;
         onPropertiesChanged(P_icon);
      }
      
      public function set selectedIconInnerRectString(param1:String) : void
      {
         if(this._selectedIconInnerRectString == param1)
         {
            return;
         }
         this._selectedIconInnerRectString = param1;
         this._selectedIconInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._selectedIconInnerRectString));
         onPropertiesChanged(P_iconInnerRect);
      }
      
      public function set selectedIconStyle(param1:String) : void
      {
         if(this._selectedIconStyle == param1)
         {
            return;
         }
         this._selectedIconStyle = param1;
         this._selectedIcon = ComponentFactory.Instance.creat(this._selectedIconStyle);
      }
      
      public function set unselectedIcon(param1:DisplayObject) : void
      {
         if(this._unselectedIcon == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._unselectedIcon);
         this._unselectedIcon = param1;
         onPropertiesChanged(P_icon);
      }
      
      public function set unselectedIconInnerRectString(param1:String) : void
      {
         if(this._unselectedIconInnerRectString == param1)
         {
            return;
         }
         this._unselectedIconInnerRectString = param1;
         this._unselectedIconInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._unselectedIconInnerRectString));
         onPropertiesChanged(P_iconInnerRect);
      }
      
      public function set unselectedIconStyle(param1:String) : void
      {
         if(this._unselectedIconStyle == param1)
         {
            return;
         }
         this._unselectedIconStyle = param1;
         this._unselectedIcon = ComponentFactory.Instance.creat(this._unselectedIconStyle);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._selectedIcon)
         {
            addChild(this._selectedIcon);
         }
         if(this._unselectedIcon)
         {
            addChild(this._unselectedIcon);
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
      
      override public function setFrame(param1:int) : void
      {
         super.setFrame(param1);
         DisplayUtils.setFrame(this._selectedIcon,param1);
         DisplayUtils.setFrame(this._unselectedIcon,param1);
      }
      
      protected function updateIconPos() : void
      {
         if(this._unselectedIcon && this._unselectedIconInnerRect)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._unselectedIcon,this._unselectedIconInnerRect,_width,_height);
         }
         if(this._selectedIcon && this._selectedIconInnerRect)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._selectedIcon,this._selectedIconInnerRect,_width,_height);
         }
      }
   }
}
