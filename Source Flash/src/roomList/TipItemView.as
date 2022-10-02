package roomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class TipItemView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _bgII:Bitmap;
      
      private var _value:int;
      
      private var _cellWidth:int;
      
      private var _cellheight:int;
      
      public function TipItemView(param1:Bitmap, param2:int, param3:int, param4:int)
      {
         this._value = param2;
         this._bg = param1;
         this._cellWidth = param3;
         this._cellheight = param4;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         addChild(this._bg);
         this._bg.x = this._cellWidth / 2 - this._bg.width / 2;
         this._bgII = ComponentFactory.Instance.creat("asset.roomList.white");
         this._bgII.width = this._cellWidth;
         this._bgII.height = this._cellheight;
         this._bgII.alpha = 0;
         addChild(this._bgII);
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function dispose() : void
      {
         if(this._bgII && this._bgII.bitmapData)
         {
            this._bgII.bitmapData.dispose();
            this._bgII = null;
         }
         if(this._bg && this._bg.bitmapData)
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
