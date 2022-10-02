package com.pickgliss.ui.text
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class FilterFrameText extends TextField implements Disposeable
   {
      
      public static const P_frameFilters:String = "frameFilters";
      
      public static var isInputChangeWmode:Boolean = true;
       
      
      protected var _currentFrameIndex:int;
      
      protected var _filterString:String;
      
      protected var _frameFilter:Array;
      
      protected var _frameTextFormat:Vector.<TextFormat>;
      
      protected var _id:int;
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _isAutoFitLength:Boolean = false;
      
      public var stylename:String;
      
      protected var _textFormatStyle:String;
      
      public function FilterFrameText()
      {
         super();
         autoSize = "left";
         mouseEnabled = false;
         this._currentFrameIndex = 1;
         this._frameTextFormat = new Vector.<TextFormat>();
      }
      
      public static function getStringWidthByTextField(param1:String, param2:int = 14, param3:String = "Arial", param4:String = "left", param5:Boolean = true) : Number
      {
         var _loc6_:FilterFrameText = null;
         (_loc6_ = new FilterFrameText()).defaultTextFormat = new TextFormat(param3,param2,0,param5);
         _loc6_.autoSize = param4;
         _loc6_.text = param1;
         return _loc6_.width;
      }
      
      public function dispose() : void
      {
         this._frameFilter = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         ComponentFactory.Instance.removeComponent(this._id);
      }
      
      public function set filterString(param1:String) : void
      {
         if(this._filterString == param1)
         {
            return;
         }
         this._filterString = param1;
         this.frameFilters = ComponentFactory.Instance.creatFrameFilters(this._filterString);
         this.setFrame(1);
      }
      
      public function set frameFilters(param1:Array) : void
      {
         if(this._frameFilter == param1)
         {
            return;
         }
         this._frameFilter = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function setFocus() : void
      {
         StageReferance.stage.focus = this;
      }
      
      public function setFrame(param1:int) : void
      {
         this._currentFrameIndex = param1;
         if(this._frameFilter != null && this._frameFilter.length >= param1)
         {
            filters = this._frameFilter[param1 - 1];
         }
         if(this._frameTextFormat != null && this._frameTextFormat.length >= param1)
         {
            this.textFormat = this._frameTextFormat[param1 - 1];
         }
      }
      
      protected function set textFormat(param1:TextFormat) : void
      {
         if(param1 == null)
         {
            return;
         }
         setTextFormat(param1);
         defaultTextFormat = param1;
      }
      
      public function set textFormatStyle(param1:String) : void
      {
         var _loc4_:int = 0;
         var _loc3_:* = null;
         if(this._textFormatStyle == param1)
         {
            return;
         }
         this._textFormatStyle = param1;
         var _loc2_:Array = ComponentFactory.parasArgs(this._textFormatStyle);
         this._frameTextFormat = new Vector.<TextFormat>();
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = ComponentFactory.Instance.model.getSet(_loc2_[_loc4_]);
            this._frameTextFormat.push(_loc3_);
            _loc4_++;
         }
         this.setFrame(1);
      }
      
      public function get textFormatStyle() : String
      {
         return this._textFormatStyle;
      }
      
      public function set isAutoFitLength(param1:Boolean) : void
      {
         this._isAutoFitLength = param1;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
      }
      
      override public function set text(param1:String) : void
      {
         var _loc2_:int = 0;
         super.text = param1;
         if(this._isAutoFitLength && textWidth > width)
         {
            _loc2_ = getCharIndexAtPoint(width - 22,5);
            super.text = text.substring(0,_loc2_) + "...";
         }
         if(this._width > 0 || this._height > 0)
         {
            if(wordWrap == true)
            {
               this.width = this._width;
            }
         }
         this.setFrame(this._currentFrameIndex);
      }
      
      override public function set htmlText(param1:String) : void
      {
         if(this._width > 0 || this._height > 0)
         {
            if(wordWrap == true)
            {
               this.width = this._width;
            }
         }
         this.setFrame(this._currentFrameIndex);
         super.htmlText = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         super.width = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = param1;
         super.height = param1;
      }
      
      override public function set type(param1:String) : void
      {
         if(param1 == "input")
         {
            mouseEnabled = true;
         }
         super.type = param1;
      }
   }
}
