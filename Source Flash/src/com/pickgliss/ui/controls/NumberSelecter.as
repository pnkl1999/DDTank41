package com.pickgliss.ui.controls
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class NumberSelecter extends Component
   {
      
      public static const P_back:String = "P_back";
      
      public static const P_upStyle:String = "P_upStyle";
      
      public static const P_downStyle:String = "P_downStyle";
      
      public static const P_targetFieldStyle:String = "P_targetFieldStyle";
       
      
      private var _back:DisplayObject;
      
      private var _backStyle:String;
      
      private var _upDisplay:DisplayObject;
      
      private var _upStyle:String;
      
      private var _downDisplay:DisplayObject;
      
      private var _downStyle:String;
      
      private var _targetField:TextField;
      
      private var _targetFieldStyle:String;
      
      private var _currentValue:Number;
      
      private var _increment:Number = 1;
      
      protected var _valueLimit:Point;
      
      public function NumberSelecter()
      {
         super();
      }
      
      public function set valueLimit(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         this._valueLimit = new Point(_loc2_[0],_loc2_[1]);
         this.currentValue = this._valueLimit.x;
      }
      
      public function get currentValue() : Number
      {
         return this._currentValue;
      }
      
      public function get increment() : Number
      {
         return this._increment;
      }
      
      public function set increment(param1:Number) : void
      {
         this._increment = param1;
      }
      
      public function get targetFieldStyle() : String
      {
         return this._targetFieldStyle;
      }
      
      public function set targetFieldStyle(param1:String) : void
      {
         if(param1 == this._upStyle)
         {
            return;
         }
         this._targetFieldStyle = param1;
         this.targetField = ComponentFactory.Instance.creat(this._targetFieldStyle);
      }
      
      public function set targetField(param1:TextField) : void
      {
         if(this._targetField == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._targetField);
         this._targetField = param1;
         onPropertiesChanged(P_targetFieldStyle);
      }
      
      public function get upStyle() : String
      {
         return this._upStyle;
      }
      
      public function set upStyle(param1:String) : void
      {
         if(param1 == this._upStyle)
         {
            return;
         }
         this._upStyle = param1;
         this.upDisplay = ComponentFactory.Instance.creat(this._upStyle);
      }
      
      public function set upDisplay(param1:DisplayObject) : void
      {
         if(this._upDisplay == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._upDisplay);
         this._upDisplay = param1;
         onPropertiesChanged(P_upStyle);
      }
      
      public function get downStyle() : String
      {
         return this._downStyle;
      }
      
      public function set downStyle(param1:String) : void
      {
         if(param1 == this._downStyle)
         {
            return;
         }
         this._downStyle = param1;
         this.downDisplay = ComponentFactory.Instance.creat(this._downStyle);
      }
      
      public function set downDisplay(param1:DisplayObject) : void
      {
         if(this._downDisplay == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._downDisplay);
         this._downDisplay = param1;
         onPropertiesChanged(P_downStyle);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._back)
         {
            addChild(this._back);
         }
         if(this._targetField && !(this._targetField.parent is TextInput))
         {
            addChild(this._targetField);
         }
         if(this._upDisplay)
         {
            addChild(this._upDisplay);
         }
         if(this._downDisplay)
         {
            addChild(this._downDisplay);
         }
         this.setReduceBtnState();
      }
      
      private function __fieldChange(param1:Event) : void
      {
         if(!this._targetField)
         {
            return;
         }
         switch(param1.currentTarget)
         {
            case this._upDisplay:
               this.currentValue -= this._increment;
               break;
            case this._downDisplay:
               this.currentValue += this._increment;
         }
         this.setText(this._currentValue);
         this.validate();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         if(_changedPropeties[P_upStyle] || _changedPropeties[P_downStyle])
         {
            if(this._upDisplay)
            {
               _width = Math.max(this._upDisplay.x + this._upDisplay.width,_width);
               _height = Math.max(this._upDisplay.y + this._upDisplay.height,_height);
               this._upDisplay.addEventListener(MouseEvent.CLICK,this.__fieldChange);
            }
            if(this._downDisplay)
            {
               _width = Math.max(this._downDisplay.x + this._downDisplay.width,_width);
               _height = Math.max(this._downDisplay.y + this._downDisplay.height,_height);
               this._downDisplay.addEventListener(MouseEvent.CLICK,this.__fieldChange);
            }
         }
         if(_changedPropeties[P_targetFieldStyle])
         {
            this._targetField.restrict = "0-9";
            this.setText(this._valueLimit.x);
            this._targetField.addEventListener(FocusEvent.FOCUS_OUT,this.validate);
            this._targetField.addEventListener(MouseEvent.MOUSE_WHEEL,this.__onMouseWheel);
            this._targetField.addEventListener(Event.CHANGE,this.__targetFieldChange);
         }
         super.onProppertiesUpdate();
      }
      
      private function setReduceBtnState() : void
      {
         if(this._upDisplay)
         {
            if(this.currentValue <= this._valueLimit.x)
            {
               (this._upDisplay as BaseButton).enable = false;
               this._upDisplay.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
               (this._upDisplay as BaseButton).enable = true;
               this._upDisplay.filters = null;
            }
         }
         if(this._downDisplay)
         {
            if(this.currentValue >= this._valueLimit.y)
            {
               (this._downDisplay as BaseButton).enable = false;
               this._downDisplay.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
               (this._downDisplay as BaseButton).enable = true;
               this._downDisplay.filters = null;
            }
         }
      }
      
      protected function __targetFieldChange(param1:Event) : void
      {
         if(this._targetField.text.length <= 0)
         {
            this.currentValue = this._valueLimit.x;
            this.setText(this._currentValue);
         }
         this.validate();
      }
      
      private function __onMouseWheel(param1:MouseEvent) : void
      {
         if(param1.delta < 0)
         {
            this.currentValue += this._increment;
         }
         else
         {
            this.currentValue -= this._increment;
         }
         this.setText(this._currentValue);
         this.validate();
      }
      
      public function set back(param1:DisplayObject) : void
      {
         if(this._back == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._back);
         this._back = param1;
         onPropertiesChanged(P_back);
      }
      
      public function set backStyle(param1:String) : void
      {
         if(this._backStyle == param1)
         {
            return;
         }
         this._backStyle = param1;
         this.back = ComponentFactory.Instance.creat(this._backStyle);
      }
      
      public function validate(param1:FocusEvent = null) : void
      {
         if(!this._targetField.text == "")
         {
            this.currentValue = Number(this._targetField.text);
         }
         if(this._currentValue > this._valueLimit.y)
         {
            this.currentValue = this._valueLimit.y;
         }
         if(this._currentValue < this._valueLimit.x)
         {
            this.currentValue = this._valueLimit.x;
         }
         this.setText(this._currentValue);
         if(!param1)
         {
            StageReferance.stage.focus = this._targetField;
         }
         this.setReduceBtnState();
      }
      
      public function set currentValue(param1:Number) : void
      {
         if(this._currentValue == param1)
         {
            return;
         }
         this._currentValue = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function setText(param1:int) : void
      {
         this._targetField.text = String(param1);
         this._targetField.setSelection(this._targetField.length,this._targetField.length);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._targetField);
         this._targetField = null;
         ObjectUtils.disposeObject(this._upDisplay);
         this._upDisplay = null;
         ObjectUtils.disposeObject(this._downDisplay);
         this._downDisplay = null;
      }
   }
}
