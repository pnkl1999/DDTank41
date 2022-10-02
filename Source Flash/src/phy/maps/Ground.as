package phy.maps
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class Ground extends Tile
   {
       
      
      private var _bound:Rectangle;
      
      public function Ground(param1:BitmapData, param2:Boolean)
      {
         super(param1,param2);
         this._bound = new Rectangle(0,0,width,height);
      }
      
      public function IsEmpty(param1:int, param2:int) : Boolean
      {
         return GetAlpha(param1,param2) <= 150;
      }
      
      public function IsRectangleEmpty(param1:Rectangle) : Boolean
      {
         param1 = this._bound.intersection(param1);
         if(param1.width == 0 || param1.height == 0)
         {
            return true;
         }
         if(!this.IsXLineEmpty(param1.x,param1.y,param1.width))
         {
            return false;
         }
         if(param1.height > 1)
         {
            if(!this.IsXLineEmpty(param1.x,param1.y + param1.height - 1,param1.width))
            {
               return false;
            }
            if(!this.IsYLineEmtpy(param1.x,param1.y + 1,param1.height - 1))
            {
               return false;
            }
            if(param1.width > 1 && !this.IsYLineEmtpy(param1.x + param1.width - 1,param1.y,param1.height - 1))
            {
               return false;
            }
         }
         return true;
      }
      
      public function IsRectangeEmptyQuick(param1:Rectangle) : Boolean
      {
         param1 = this._bound.intersection(param1);
         if(this.IsEmpty(param1.right,param1.bottom) && this.IsEmpty(param1.left,param1.bottom) && this.IsEmpty(param1.right,param1.top) && this.IsEmpty(param1.left,param1.top))
         {
            return true;
         }
         return false;
      }
      
      public function IsXLineEmpty(param1:int, param2:int, param3:int) : Boolean
      {
         param1 = param1 < 0 ? int(int(0)) : int(int(param1));
         param3 = param1 + param3 > width ? int(int(width - param1)) : int(int(param3));
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            if(!this.IsEmpty(param1 + _loc4_,param2))
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      public function IsYLineEmtpy(param1:int, param2:int, param3:int) : Boolean
      {
         param2 = param2 < 0 ? int(int(0)) : int(int(param2));
         param3 = param2 + param3 > height ? int(int(height - param2)) : int(int(param3));
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            if(!this.IsEmpty(param1,param2 + _loc4_))
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
   }
}
