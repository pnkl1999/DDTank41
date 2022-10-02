package ddt.display
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   
   public class BitmapShape extends Shape implements Disposeable
   {
       
      
      private var _bitmap:BitmapObject;
      
      private var _matrix:Matrix;
      
      private var _repeat:Boolean;
      
      private var _smooth:Boolean;
      
      public function BitmapShape(param1:BitmapObject = null, param2:Matrix = null, param3:Boolean = true, param4:Boolean = false)
      {
         super();
         this._bitmap = param1;
         this._matrix = param2;
         this._repeat = param3;
         this._smooth = param4;
         this.draw();
      }
      
      public function set bitmapObject(param1:BitmapObject) : void
      {
      }
      
      public function get bitmapObject() : BitmapObject
      {
         return this._bitmap;
      }
      
      protected function draw() : void
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
      
      public function dispose() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._bitmap)
         {
            this._bitmap.dispose();
         }
      }
   }
}
