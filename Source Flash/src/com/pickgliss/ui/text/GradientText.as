package com.pickgliss.ui.text
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class GradientText extends Component
   {
      
      public static const P_alpha:String = "alpha";
      
      public static const P_color:String = "color";
      
      public static const P_frameFilters:String = "frameFilters";
      
      public static const P_ratio:String = "ratio";
      
      public static const P_textField:String = "textField";
      
      public static const P_size:String = "textSize";
       
      
      protected var _filterString:String;
      
      protected var _frameFilter:Array;
      
      private var _colorStyle:String = "";
      
      private var _alphaStyle:String = "";
      
      private var _ratioStyle:String = "";
      
      private var _colors:Array;
      
      private var _alphas:Array;
      
      private var _ratios:Array;
      
      private var _gradientRotation:Number = 90;
      
      private var _currentFrame:int = 1;
      
      private var _currentMatrix:Matrix;
      
      private var _gradientBox:Shape;
      
      private var _textField:TextField;
      
      private var _textFieldStyle:String = "";
      
      private var _textSize:int;
      
      public function GradientText()
      {
         super();
      }
      
      public function set gradientRotation(param1:Number) : void
      {
         this._gradientRotation = param1;
      }
      
      public function set colors(param1:String) : void
      {
         if(param1 == this._colorStyle)
         {
            return;
         }
         this._colorStyle = param1;
         this._colors = [];
         var _loc2_:Array = this._colorStyle.split("|");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            this._colors.push(_loc2_[_loc3_].split(","));
            _loc3_++;
         }
         onPropertiesChanged(P_color);
      }
      
      public function set alphas(param1:String) : void
      {
         if(param1 == this._alphaStyle)
         {
            return;
         }
         this._alphaStyle = param1;
         if(this._alphas)
         {
            this._alphas = [];
         }
         this._alphas = this._alphaStyle.split(",");
         onPropertiesChanged(P_alpha);
      }
      
      public function set ratios(param1:String) : void
      {
         if(param1 == this._ratioStyle)
         {
            return;
         }
         this._ratioStyle = param1;
         if(this._ratios)
         {
            this._ratios = [];
         }
         this._ratios = this._ratioStyle.split(",");
         onPropertiesChanged(P_ratio);
      }
      
      public function set filterString(param1:String) : void
      {
         if(this._filterString == param1)
         {
            return;
         }
         this._filterString = param1;
         this.frameFilters = ComponentFactory.Instance.creatFrameFilters(this._filterString);
      }
      
      public function set frameFilters(param1:Array) : void
      {
         if(this._frameFilter == param1)
         {
            return;
         }
         this._frameFilter = param1;
         onPropertiesChanged(P_frameFilters);
      }
      
      public function set text(param1:String) : void
      {
         this._textField.text = param1;
         this.refreshBox();
      }
      
      public function get text() : String
      {
         return this._textField.text;
      }
      
      public function set textSize(param1:int) : void
      {
         if(this._textSize == param1)
         {
            return;
         }
         this._textSize = param1;
         onPropertiesChanged(P_size);
      }
      
      public function get textSize() : int
      {
         return this._textSize;
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
         this._textField = param1;
         this._textSize = int(this._textField.defaultTextFormat.size);
         onPropertiesChanged(P_textField);
      }
      
      public function set textFieldStyle(param1:String) : void
      {
         if(param1 == this._textFieldStyle)
         {
            return;
         }
         this._textFieldStyle = param1;
         this.textField = ComponentFactory.Instance.creat(this._textFieldStyle);
      }
      
      override protected function addChildren() : void
      {
         if(this._textField)
         {
            addChild(this._textField);
            this._textField.cacheAsBitmap = true;
         }
         if(this._gradientBox)
         {
            this._gradientBox.x = this._textField.x;
            this._gradientBox.y = this._textField.y;
            addChild(this._gradientBox);
            this._gradientBox.cacheAsBitmap = true;
            this._gradientBox.mask = this._textField;
         }
      }
      
      override public function get width() : Number
      {
         return this._textField.width;
      }
      
      public function get textWidth() : Number
      {
         return this._textField.textWidth;
      }
      
      public function getCharIndexAtPoint(param1:Number, param2:Number) : int
      {
         return this._textField.getCharIndexAtPoint(param1,param2);
      }
      
      public function setFrame(param1:int) : void
      {
         if(this._currentFrame == param1)
         {
            return;
         }
         this._currentFrame = param1;
         this.refreshBox();
         filters = this._frameFilter[param1 - 1];
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[P_textField] || _changedPropeties[P_color] || _changedPropeties[P_alpha] || _changedPropeties[P_ratio] || _changedPropeties[P_size])
         {
            this.refreshBox();
         }
         if(_changedPropeties[P_frameFilters])
         {
            filters = this._frameFilter[0];
         }
      }
      
      override public function dispose() : void
      {
         if(this._textField)
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = null;
         if(this._gradientBox)
         {
            this._gradientBox.graphics.clear();
         }
         this._gradientBox = null;
         super.dispose();
      }
      
      private function refreshBox() : void
      {
         var _loc1_:TextFormat = this._textField.getTextFormat();
         _loc1_.size = this._textSize;
         this._textField.setTextFormat(_loc1_);
         if(this._textField.textWidth > this._textField.width)
         {
            _width = this._textField.width = this._textField.textWidth + 8;
         }
         this._currentMatrix = new Matrix();
         this._currentMatrix.createGradientBox(this._textField.width,this._textField.height,Math.PI / 2,0,0);
         if(this._gradientBox == null)
         {
            this._gradientBox = new Shape();
         }
         this._gradientBox.graphics.clear();
         this._gradientBox.graphics.beginGradientFill(GradientType.LINEAR,this._colors[this._currentFrame - 1],this._alphas,this._ratios,this._currentMatrix);
         this._gradientBox.graphics.drawRect(0,0,this._textField.width,this._textField.height);
         this._gradientBox.graphics.endFill();
      }
   }
}
