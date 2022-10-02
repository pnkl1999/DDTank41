package store.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class StoneCellFrame extends Sprite
   {
       
      
      private var _textField:FilterFrameText;
      
      private var _textFieldX:Number;
      
      private var _textFieldY:Number;
      
      private var _bg:Bitmap;
      
      private var _text:String;
      
      private var _textStyle:String;
      
      private var _backStyle:String;
      
      public function StoneCellFrame()
      {
         super();
      }
      
      public function set label(param1:String) : void
      {
         if(this._textField == null)
         {
            return;
         }
         this._text = param1;
         this._textField.text = this._text;
         this._textField.x = this.textFieldX;
         this._textField.y = this.textFieldY;
      }
      
      private function init() : void
      {
         addChild(this._bg);
         addChild(this._textField);
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._textField)
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = null;
      }
      
      public function get textStyle() : String
      {
         return this._textStyle;
      }
      
      public function set textStyle(param1:String) : void
      {
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         this._textStyle = param1;
         this._textField = ComponentFactory.Instance.creatComponentByStylename(this._textStyle);
         addChild(this._textField);
      }
      
      public function get backStyle() : String
      {
         return this._backStyle;
      }
      
      public function set backStyle(param1:String) : void
      {
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         this._backStyle = param1;
         this._bg = ComponentFactory.Instance.creatBitmap(this._backStyle);
         addChild(this._bg);
      }
      
      public function get textFieldX() : Number
      {
         return this._textFieldX;
      }
      
      public function set textFieldX(param1:Number) : void
      {
         this._textFieldX = param1;
      }
      
      public function get textFieldY() : Number
      {
         return this._textFieldY;
      }
      
      public function set textFieldY(param1:Number) : void
      {
         this._textFieldY = param1;
      }
   }
}
