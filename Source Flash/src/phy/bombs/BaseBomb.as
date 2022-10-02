package phy.bombs
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import phy.object.PhysicalObj;
   
   public class BaseBomb extends PhysicalObj
   {
       
      
      protected var _movie:Sprite;
      
      protected var _shape:Bitmap;
      
      protected var _border:Bitmap;
      
      public function BaseBomb(param1:int, param2:Number = 10, param3:Number = 100, param4:Number = 1, param5:Number = 1)
      {
         super(param1,1,param2,param3,param4,param5);
         _testRect = new Rectangle(-3,-3,6,6);
      }
      
      public function setMovie(param1:Sprite, param2:Bitmap, param3:Bitmap) : void
      {
         this._movie = param1;
         if(this._movie)
         {
            this._movie.x = 0;
            this._movie.y = 0;
            addChild(this._movie);
         }
         this._shape = param2;
         this._border = param3;
      }
      
      override public function update(param1:Number) : void
      {
         super.update(param1);
      }
      
      public function get bombRectang() : Rectangle
      {
         if(_map && this._shape)
         {
            return this._shape.getRect(_map);
         }
         return new Rectangle(x - 200,y - 200,400,400);
      }
      
      override protected function collideGround() : void
      {
         this.bomb();
      }
      
      public function bomb() : void
      {
         this.DigMap();
         this.die();
      }
      
      public function bombAtOnce() : void
      {
      }
      
      protected function DigMap() : void
      {
         if(this._shape && this._shape.width > 0 && this._shape.height > 0)
         {
            _map.Dig(pos,this._shape,this._border);
         }
      }
      
      override public function die() : void
      {
         super.die();
         if(_map)
         {
            _map.removePhysical(this);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._movie && this._movie.parent)
         {
            this._movie.parent.removeChild(this._movie);
         }
         this._shape = null;
         this._border = null;
      }
   }
}
