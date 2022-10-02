package com.pickgliss.ui.controls
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   
   public class TextInput extends Component
   {
      
      public static const P_back:String = "back";
      
      public static const P_focusBack:String = "focusBack";
      
      public static const P_focusBackgoundInnerRect:String = "focusBackOuterRect";
      
      public static const P_textField:String = "textField";
      
      public static const P_textInnerRect:String = "textInnerRect";
      
      public static const P_backgroundColor:String = "backgroundColor";
      
      public static const P_enable:String = "enable";
       
      
      protected var _back:DisplayObject;
      
      protected var _backStyle:String;
      
      protected var _focusBack:DisplayObject;
      
      protected var _focusBackgoundInnerRect:InnerRectangle;
      
      protected var _focusBackgoundInnerRectString:String;
      
      protected var _focusBackStyle:String;
      
      protected var _textField:TextField;
      
      protected var _textInnerRect:InnerRectangle;
      
      protected var _textInnerRectString:String;
      
      protected var _textStyle:String;
      
      protected var _backgroundColor:uint;
      
      protected var _filterString:String;
      
      protected var _frameFilter:Array;
      
      protected var _enable:Boolean = true;
      
      protected var _currentFrameIndex:int = 1;
      
      public function TextInput()
      {
         super();
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
      
      public function set backgroundColor(param1:uint) : void
      {
         if(this._back || !param1)
         {
            return;
         }
         this._backgroundColor = param1;
         onPropertiesChanged(P_backgroundColor);
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set filterString(param1:String) : void
      {
         if(this._filterString == param1)
         {
            return;
         }
         this._filterString = param1;
         this._frameFilter = ComponentFactory.Instance.creatFrameFilters(this._filterString);
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function set enable(param1:Boolean) : void
      {
         if(this._enable == param1)
         {
            return;
         }
         this._enable = param1;
         onPropertiesChanged(P_enable);
      }
      
      protected function setFrame(param1:int) : void
      {
         this._currentFrameIndex = param1;
         DisplayUtils.setFrame(this._back,this._currentFrameIndex);
         if(this._frameFilter == null || param1 <= 0 || param1 > this._frameFilter.length)
         {
            return;
         }
         filters = this._frameFilter[param1 - 1];
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._focusBack);
         this._focusBack = null;
         if(this._textField)
         {
            this._textField.removeEventListener(FocusEvent.FOCUS_IN,this.__onFocusText);
            this._textField.removeEventListener(FocusEvent.FOCUS_OUT,this.__onFocusText);
         }
         ObjectUtils.disposeObject(this._textField);
         this._textField = null;
         graphics.clear();
         super.dispose();
      }
      
      public function set focusBack(param1:DisplayObject) : void
      {
         if(this._focusBack == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._focusBack);
         this._focusBack = param1;
         this._focusBack.visible = false;
         onPropertiesChanged();
      }
      
      public function set focusBackgoundInnerRectString(param1:String) : void
      {
         if(this._focusBackgoundInnerRectString == param1)
         {
            return;
         }
         this._focusBackgoundInnerRectString = param1;
         this._focusBackgoundInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._focusBackgoundInnerRectString));
         onPropertiesChanged(P_focusBackgoundInnerRect);
      }
      
      public function set focusBackStyle(param1:String) : void
      {
         if(this._focusBackStyle == param1)
         {
            return;
         }
         this._focusBackStyle = param1;
         this.focusBack = ComponentFactory.Instance.creat(this._focusBackStyle);
      }
      
      public function get textField() : TextField
      {
         return this._textField;
      }
      
      public function set textField(param1:TextField) : void
      {
         if(this._textField == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._textField);
         this._textField = param1;
         onPropertiesChanged(P_textField);
      }
      
      public function set textInnerRectString(param1:String) : void
      {
         if(this._textInnerRectString == param1)
         {
            return;
         }
         this._textInnerRectString = param1;
         this._textInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._textInnerRectString));
         onPropertiesChanged(P_textInnerRect);
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
      
      protected function __onFocusText(param1:Event) : void
      {
         if(this._focusBack)
         {
            this._focusBack.visible = param1.type == FocusEvent.FOCUS_IN;
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._back)
         {
            addChild(this._back);
         }
         if(this._focusBack)
         {
            addChild(this._focusBack);
         }
         if(this._textField)
         {
            addChild(this._textField);
         }
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         this._textField.displayAsPassword = param1;
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._textField.displayAsPassword;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         this._textField.multiline = param1;
      }
      
      public function get multiline() : Boolean
      {
         return this._textField.multiline;
      }
      
      public function set maxChars(param1:int) : void
      {
         this._textField.maxChars = param1;
      }
      
      public function get maxChars() : int
      {
         return this._textField.maxChars;
      }
      
      public function set autoSize(param1:String) : void
      {
         this._textField.autoSize = param1;
      }
      
      public function get autoSize() : String
      {
         return this._textField.autoSize;
      }
      
      public function set text(param1:String) : void
      {
         this._textField.text = param1;
      }
      
      public function get text() : String
      {
         return this._textField.text;
      }
      
      public function setFocus() : void
      {
         StageReferance.stage.focus = this._textField;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         var _loc1_:Rectangle = null;
         super.onProppertiesUpdate();
         if(_changedPropeties[P_textField])
         {
            this._textField.type = TextFieldType.INPUT;
            this._textField.wordWrap = true;
            this._textField.addEventListener(FocusEvent.FOCUS_IN,this.__onFocusText);
            this._textField.addEventListener(FocusEvent.FOCUS_OUT,this.__onFocusText);
         }
         if(this._back)
         {
            this._back.width = _width;
            this._back.height = _height;
            _loc1_ = this._textInnerRect.getInnerRect(_width,_height);
            this._textField.width = _loc1_.width;
            this._textField.height = _loc1_.height;
            this._textField.x = _loc1_.x;
            this._textField.y = _loc1_.y;
            if(this._focusBack)
            {
               DisplayUtils.layoutDisplayWithInnerRect(this._focusBack,this._focusBackgoundInnerRect,_width,_height);
            }
         }
         else
         {
            this._textField.width = _width;
            this._textField.height = _height;
         }
         if(_changedPropeties[P_backgroundColor])
         {
            graphics.beginFill(this._backgroundColor);
            graphics.drawRect(0,0,_width,_height);
            graphics.endFill();
         }
         if(_changedPropeties[P_enable])
         {
            mouseChildren = mouseEnabled = this._enable;
            if(this._enable)
            {
               this.setFrame(1);
            }
            else
            {
               this.setFrame(2);
            }
         }
      }
   }
}
