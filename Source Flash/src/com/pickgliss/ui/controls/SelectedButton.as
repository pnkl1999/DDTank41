package com.pickgliss.ui.controls
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.PNGHitAreaFactory;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="select",type="flash.events.Event")]
   public class SelectedButton extends BaseButton implements ISelectable
   {
      
      public static const P_selectedStyle:String = "selectedStyle";
      
      public static const P_unSelectedStyle:String = "unSelectedStyle";
       
      
      protected var _selected:Boolean;
      
      protected var _selectedButton:DisplayObject;
      
      protected var _selectedStyle:String;
      
      protected var _unSelectedButton:DisplayObject;
      
      protected var _unSelectedStyle:String;
      
      private var _autoSelect:Boolean = true;
      
      private var _selectHitArea:Sprite;
      
      private var _unSelectHitArea:Sprite;
      
      public function SelectedButton()
      {
         super();
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
         if(this._autoSelect == param1)
         {
            return;
         }
         this._autoSelect = param1;
      }
      
      override public function dispose() : void
      {
         removeEvent();
         ObjectUtils.disposeObject(this._selectedButton);
         this._selectedButton = null;
         ObjectUtils.disposeObject(this._unSelectedButton);
         this._unSelectedButton = null;
         ObjectUtils.disposeObject(this._selectHitArea);
         ObjectUtils.disposeObject(this._unSelectHitArea);
         this._selectHitArea = null;
         this._unSelectHitArea = null;
         super.dispose();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(this._selectedButton)
         {
            this._selectedButton.visible = this._selected;
         }
         if(this._unSelectedButton)
         {
            this._unSelectedButton.visible = !this._selected;
         }
         dispatchEvent(new Event(Event.SELECT));
         this.drawHitArea();
      }
      
      public function get selectedStyle() : String
      {
         return this._selectedStyle;
      }
      
      public function set selectedStyle(param1:String) : void
      {
         if(this._selectedStyle == param1)
         {
            return;
         }
         this._selectedStyle = param1;
         onPropertiesChanged(P_selectedStyle);
      }
      
      override public function setFrame(param1:int) : void
      {
         super.setFrame(param1);
         if(this._selectedButton)
         {
            DisplayUtils.setFrame(this._selectedButton,_currentFrameIndex);
         }
         if(this._unSelectedButton)
         {
            DisplayUtils.setFrame(this._unSelectedButton,_currentFrameIndex);
         }
      }
      
      public function setSelectedButton(param1:DisplayObject) : void
      {
         ObjectUtils.disposeObject(this._selectedButton);
         this._selectedButton = param1;
         DisplayUtils.setDisplayObjectNotEnable(this._selectedButton);
         this.setFrame(1);
      }
      
      public function setUnselectedButton(param1:DisplayObject) : void
      {
         ObjectUtils.disposeObject(this._unSelectedButton);
         this._unSelectedButton = param1;
         DisplayUtils.setDisplayObjectNotEnable(this._unSelectedButton);
         this.setFrame(1);
      }
      
      public function get unSelectedStyle() : String
      {
         return this._unSelectedStyle;
      }
      
      public function set unSelectedStyle(param1:String) : void
      {
         if(this._unSelectedStyle == param1)
         {
            return;
         }
         this._unSelectedStyle = param1;
         onPropertiesChanged(P_unSelectedStyle);
      }
      
      override protected function __onMouseClick(param1:MouseEvent) : void
      {
         super.__onMouseClick(param1);
         if(this._autoSelect)
         {
            this.selected = !this._selected;
         }
      }
      
      override protected function adaptHitArea() : void
      {
         _PNGHitArea.alpha = 0;
         _PNGHitArea.x = !!this._selected ? Number(Number(this._selectedButton.x)) : Number(Number(this._unSelectedButton.x));
         _PNGHitArea.y = !!this._selected ? Number(Number(this._selectedButton.y)) : Number(Number(this._unSelectedButton.y));
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._selectedButton)
         {
            addChild(this._selectedButton);
         }
         if(this._unSelectedButton)
         {
            addChild(this._unSelectedButton);
         }
      }
      
      override protected function drawHitArea() : void
      {
         if(_PNGHitArea && contains(_PNGHitArea))
         {
            removeChild(_PNGHitArea);
         }
         if(_transparentEnable)
         {
            if(this._selectHitArea == null)
            {
               this._selectHitArea = PNGHitAreaFactory.drawHitArea(DisplayUtils.getDisplayBitmapData(this._selectedButton));
            }
            if(this._unSelectHitArea == null)
            {
               this._unSelectHitArea = PNGHitAreaFactory.drawHitArea(DisplayUtils.getDisplayBitmapData(this._unSelectedButton));
            }
            _PNGHitArea = !!this._selected ? this._selectHitArea : this._unSelectHitArea;
            this.adaptHitArea();
            _PNGHitArea.alpha = 0;
            hitArea = _PNGHitArea;
            addChild(_PNGHitArea);
         }
         else if(_PNGHitArea && contains(_PNGHitArea))
         {
            removeChild(_PNGHitArea);
         }
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[P_unSelectedStyle])
         {
            this.setUnselectedButton(ComponentFactory.Instance.creat(this._unSelectedStyle));
            this.selected = this._selected;
            if(this._selectedButton)
            {
               _width = this._selectedButton.width;
               _height = this._selectedButton.height;
            }
         }
         if(_changedPropeties[P_selectedStyle])
         {
            this.setSelectedButton(ComponentFactory.Instance.creat(this._selectedStyle));
            this.selected = this._selected;
            if(this._unSelectedButton)
            {
               _width = this._unSelectedButton.width;
               _height = this._unSelectedButton.height;
            }
         }
      }
   }
}
