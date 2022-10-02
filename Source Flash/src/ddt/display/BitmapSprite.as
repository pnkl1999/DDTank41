package ddt.display
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class BitmapSprite extends Sprite implements Disposeable
   {
       
      
      protected var _bitmap:BitmapObject;
      
      protected var _matrix:Matrix;
      
      protected var _repeat:Boolean;
      
      protected var _smooth:Boolean;
      
      protected var _w:int;
      
      protected var _h:int;
      
      public function BitmapSprite(param1:BitmapObject = null, param2:Matrix = null, param3:Boolean = true, param4:Boolean = false)
      {
         super();
         this._bitmap = param1;
         this._matrix = param2;
         this._repeat = param3;
         this._smooth = param4;
         this.configUI();
      }
      
      public function set bitmapObject(param1:BitmapObject) : void
      {
         var _loc2_:BitmapObject = this._bitmap;
         this._bitmap = param1;
         this.drawBitmap();
         if(_loc2_)
         {
            _loc2_.dispose();
         }
      }
      
      public function get bitmapObject() : BitmapObject
      {
         return this._bitmap;
      }
      
      protected function drawBitmap() : void
      {
         var _loc1_:Graphics = null;
         if(this._bitmap)
         {
            _loc1_ = graphics;
            _loc1_.clear();
            _loc1_.beginBitmapFill(this._bitmap,this._matrix,this._repeat,this._smooth);
            _loc1_.drawRect(0,0,this._bitmap.width,this._bitmap.height);
            _loc1_.endFill();
         }
      }
      
      protected function configUI() : void
      {
         this.drawBitmap();
      }
      
      public function dispose() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._bitmap)
         {
            this._bitmap.dispose();
            this._bitmap = null;
         }
      }
   }
}
