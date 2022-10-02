package com.pickgliss.ui.controls
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   
   public class SelectedCheckButton extends SelectedButton
   {
      
      public static const P_fieldX:String = "fieldX";
      
      public static const P_fieldY:String = "fieldY";
      
      public static const P_text:String = "text";
      
      public static const P_textField:String = "textField";
       
      
      protected var _field:DisplayObject;
      
      protected var _fieldX:Number;
      
      protected var _fieldY:Number;
      
      protected var _text:String;
      
      protected var _textStyle:String;
      
      public function SelectedCheckButton()
      {
         super();
      }
      
      override public function dispose() : void
      {
         if(this._field)
         {
            ObjectUtils.disposeObject(this._field);
         }
         this._field = null;
         graphics.clear();
         super.dispose();
      }
      
      public function set fieldX(param1:Number) : void
      {
         if(this._fieldX == param1)
         {
            return;
         }
         this._fieldX = param1;
         onPropertiesChanged(P_fieldX);
      }
      
      public function set fieldY(param1:Number) : void
      {
         if(this._fieldY == param1)
         {
            return;
         }
         this._fieldY = param1;
         onPropertiesChanged(P_fieldY);
      }
      
      public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         onPropertiesChanged(P_text);
      }
      
      public function set textField(param1:DisplayObject) : void
      {
         if(this._field == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._field);
         this._field = param1;
         onPropertiesChanged(P_textField);
      }
      
      public function set textStyle(param1:String) : void
      {
         if(this._textStyle == param1)
         {
            return;
         }
         this._textStyle = param1;
         this.textField = ComponentFactory.Instance.creat(this._textStyle);
      }
      
      public function get textWidth() : int
      {
         return TextField(this._field).textWidth;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._field)
         {
            addChild(this._field);
         }
      }
      
      protected function drawClickArea() : void
      {
         graphics.beginFill(16711935,0);
         graphics.drawRect(0,0,_width,_height);
         graphics.endFill();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[P_fieldX] || _changedPropeties[P_fieldY])
         {
            if(this._field)
            {
               this._field.x = this._fieldX;
               this._field.y = this._fieldY;
            }
         }
         if(_changedPropeties[P_text])
         {
            if(this._field)
            {
               if(this._field is TextField)
               {
                  TextField(this._field).text = this._text;
               }
               _width = this._field.x + this._field.width;
               _height = Math.max(this._field.height,_selectedButton.height);
               this.drawClickArea();
            }
         }
         if(_changedPropeties[Component.P_height] || _changedPropeties[Component.P_width])
         {
            this.drawClickArea();
         }
      }
   }
}
