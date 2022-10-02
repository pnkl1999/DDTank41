package ddt.utils
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class GraphicsUtils
   {
       
      
      public function GraphicsUtils()
      {
         super();
      }
      
      public static function drawSector(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Sprite
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc6_:Sprite = new Sprite();
         var _loc7_:Number = param3;
         var _loc8_:Number = 0;
         if(param4 != 0)
         {
            _loc7_ = Math.cos(param4 * Math.PI / 180) * param3;
            _loc8_ = Math.sin(param4 * Math.PI / 180) * param3;
         }
         _loc6_.graphics.beginFill(16776960,1);
         _loc6_.graphics.moveTo(param1,param2);
         _loc6_.graphics.lineTo(param1 + _loc7_,param2 - _loc8_);
         var _loc9_:Number = param5 * Math.PI / 180 / param5;
         var _loc10_:Number = Math.cos(_loc9_);
         var _loc11_:Number = Math.sin(_loc9_);
         var _loc13_:Number = 0;
         while(_loc13_ < param5)
         {
            _loc14_ = _loc10_ * _loc7_ - _loc11_ * _loc8_;
            _loc15_ = _loc10_ * _loc8_ + _loc11_ * _loc7_;
            _loc7_ = _loc14_;
            _loc8_ = _loc15_;
            _loc6_.graphics.lineTo(_loc7_ + param1,-_loc8_ + param2);
            _loc13_++;
         }
         _loc6_.graphics.lineTo(param1,param2);
         _loc6_.graphics.endFill();
         return _loc6_;
      }
      
      public static function drawDisplayMask(param1:DisplayObject) : DisplayObject
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,true,16711680);
         _loc2_.draw(param1);
         var _loc3_:Shape = new Shape();
         _loc3_.cacheAsBitmap = true;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.width)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_.height)
            {
               _loc6_ = _loc2_.getPixel32(_loc4_,_loc5_);
               _loc7_ = _loc6_ >> 24 & 255;
               _loc8_ = _loc7_ / 255;
               if(_loc6_ > 0)
               {
                  _loc3_.graphics.beginFill(0,_loc8_);
                  _loc3_.graphics.drawCircle(_loc4_,_loc5_,1);
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function changeSectorAngle(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         param1.graphics.clear();
         var _loc7_:Number = param4;
         var _loc8_:Number = 0;
         if(param5 != 0)
         {
            _loc7_ = Math.cos(param5 * Math.PI / 180) * param4;
            _loc8_ = Math.sin(param5 * Math.PI / 180) * param4;
         }
         param1.graphics.beginFill(16776960,1);
         param1.graphics.moveTo(param2,param3);
         param1.graphics.lineTo(param2 + _loc7_,param3 - _loc8_);
         var _loc9_:Number = param6 * Math.PI / 180 / param6;
         var _loc10_:Number = Math.cos(_loc9_);
         var _loc11_:Number = Math.sin(_loc9_);
         var _loc13_:Number = 0;
         while(_loc13_ < param6)
         {
            _loc14_ = _loc10_ * _loc7_ - _loc11_ * _loc8_;
            _loc15_ = _loc10_ * _loc8_ + _loc11_ * _loc7_;
            _loc7_ = _loc14_;
            _loc8_ = _loc15_;
            param1.graphics.lineTo(_loc7_ + param2,-_loc8_ + param3);
            _loc13_++;
         }
         param1.graphics.lineTo(param2,param3);
         param1.graphics.endFill();
      }
   }
}
