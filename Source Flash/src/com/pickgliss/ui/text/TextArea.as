package com.pickgliss.ui.text
{
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.DisplayObjectViewport;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   public class TextArea extends ScrollPanel
   {
      
      public static const P_textField:String = "textField";
       
      
      protected var _currentTextHeight:int = 0;
      
      protected var _enable:Boolean = true;
      
      protected var _textField:FilterFrameText;
      
      protected var _textStyle:String;
      
      public function TextArea()
      {
         super();
         _viewSource.addEventListener(MouseEvent.CLICK,this.__onTextAreaClick);
         _viewSource.addEventListener(MouseEvent.MOUSE_OVER,this.__onTextAreaOver);
         _viewSource.addEventListener(MouseEvent.MOUSE_OUT,this.__onTextAreaOut);
      }
      
      override public function dispose() : void
      {
         Mouse.cursor = MouseCursor.AUTO;
         _viewSource.removeEventListener(MouseEvent.CLICK,this.__onTextAreaClick);
         _viewSource.removeEventListener(MouseEvent.MOUSE_OVER,this.__onTextAreaOver);
         _viewSource.removeEventListener(MouseEvent.MOUSE_OUT,this.__onTextAreaOut);
         this._textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextKeyDown);
         this._textField.removeEventListener(Event.CHANGE,this.__onTextChanged);
         ObjectUtils.disposeObject(this._textField);
         this._textField = null;
         super.dispose();
      }
      
      public function get editable() : Boolean
      {
         return this._textField.type == TextFieldType.INPUT;
      }
      
      public function set editable(param1:Boolean) : void
      {
         if(param1)
         {
            this._textField.type = TextFieldType.INPUT;
            _viewSource.addEventListener(MouseEvent.MOUSE_OVER,this.__onTextAreaOver);
            _viewSource.addEventListener(MouseEvent.MOUSE_OUT,this.__onTextAreaOut);
         }
         else
         {
            this._textField.type = TextFieldType.DYNAMIC;
            _viewSource.removeEventListener(MouseEvent.MOUSE_OVER,this.__onTextAreaOver);
            _viewSource.removeEventListener(MouseEvent.MOUSE_OUT,this.__onTextAreaOut);
         }
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._textField.mouseEnabled = this._enable;
         if(this._enable)
         {
            _viewSource.addEventListener(MouseEvent.MOUSE_OVER,this.__onTextAreaOver);
            _viewSource.addEventListener(MouseEvent.MOUSE_OUT,this.__onTextAreaOut);
         }
         else
         {
            _viewSource.removeEventListener(MouseEvent.MOUSE_OVER,this.__onTextAreaOver);
            _viewSource.removeEventListener(MouseEvent.MOUSE_OUT,this.__onTextAreaOut);
         }
      }
      
      public function get maxChars() : int
      {
         return this._textField.maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         this._textField.maxChars = param1;
      }
      
      public function get text() : String
      {
         return this._textField.text;
      }
      
      public function set text(param1:String) : void
      {
         this._textField.text = param1;
         DisplayObjectViewport(_viewSource).invalidateView();
      }
      
      public function set htmlText(param1:String) : void
      {
         this._textField.htmlText = param1;
         DisplayObjectViewport(_viewSource).invalidateView();
      }
      
      public function get htmlText() : String
      {
         return this._textField.htmlText;
      }
      
      public function get textField() : FilterFrameText
      {
         return this._textField;
      }
      
      public function set textField(param1:FilterFrameText) : void
      {
         if(this._textField == param1)
         {
            return;
         }
         if(this._textField)
         {
            this._textField.removeEventListener(Event.CHANGE,this.__onTextChanged);
            this._textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextKeyDown);
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = param1;
         this._textField.multiline = true;
         this._textField.mouseWheelEnabled = false;
         this._textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextKeyDown);
         this._textField.addEventListener(Event.CHANGE,this.__onTextChanged);
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
      
      override protected function layoutComponent() : void
      {
         var _loc1_:Rectangle = null;
         _loc1_ = null;
         super.layoutComponent();
         _loc1_ = _viewportInnerRect.getInnerRect(_width,_height);
         this._textField.x = _loc1_.x;
         this._textField.y = _loc1_.y;
         this._textField.width = _viewSource.width;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[P_textField])
         {
            DisplayObjectViewport(_viewSource).setView(this._textField);
         }
      }
      
      private function __onTextAreaClick(param1:MouseEvent) : void
      {
         this._textField.setFocus();
      }
      
      private function __onTextAreaOut(param1:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.AUTO;
      }
      
      private function __onTextAreaOver(param1:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.IBEAM;
      }
      
      private function __onTextChanged(param1:Event) : void
      {
         this.upScrollArea();
      }
      
      private function __onTextKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            param1.stopPropagation();
         }
         else if(param1.keyCode == Keyboard.UP)
         {
            this.upScrollArea();
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            this.upScrollArea();
         }
         else if(param1.keyCode == Keyboard.DELETE)
         {
            this.upScrollArea();
         }
      }
      
      public function upScrollArea() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:IntPoint = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         DisplayObjectViewport(_viewSource).invalidateView();
         if(this._textField.caretIndex <= 0)
         {
            viewPort.viewPosition = new IntPoint(0,0);
         }
         else
         {
            _loc1_ = DisplayUtils.getTextFieldLineHeight(this._textField);
            _loc2_ = viewPort.viewPosition;
            _loc3_ = DisplayUtils.getTextFieldCareLinePosX(this._textField);
            _loc4_ = DisplayUtils.getTextFieldCareLinePosY(this._textField);
            _loc5_ = _loc3_ - _loc2_.x;
            _loc6_ = _loc4_ + _loc1_ - _loc2_.y;
            DisplayObjectViewport(_viewSource).invalidateView();
            _loc7_ = _loc2_.x;
            _loc8_ = _loc2_.y;
            if(_loc5_ < 0)
            {
               _loc7_ = _loc3_;
            }
            else if(_loc5_ > viewPort.getExtentSize().width)
            {
               _loc7_ = _loc3_ + viewPort.getExtentSize().width;
            }
            if(_loc6_ < _loc1_)
            {
               _loc8_ = _loc4_;
            }
            else if(_loc6_ > viewPort.getExtentSize().height)
            {
               _loc8_ = _loc4_ + viewPort.getExtentSize().height;
            }
            if(_loc7_ > 0 || _loc8_ > 0)
            {
               viewPort.viewPosition = new IntPoint(_loc7_,_loc8_);
            }
         }
      }
   }
}
