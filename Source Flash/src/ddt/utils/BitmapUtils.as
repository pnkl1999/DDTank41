package ddt.utils
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class BitmapUtils
   {
      
      private static var _maskShape:Shape;
      
      private static var _curX:Number;
      
      private static var _curY:Number;
      
      private static var _rowNumber:Number;
      
      private static var _rowWitdh:Number;
      
      private static var _rowHeight:Number;
      
      private static var _frameStep:Number;
      
      private static var _curRow:Number = 0;
      
      private static var _sleepSecond:int = 0;
      
      private static var _callBack:Function;
      
      private static var _timer:Timer;
      
      private static var _isMask:String;
       
      
      public function BitmapUtils()
      {
         super();
      }
      
      public static function updateColor(param1:BitmapData, param2:Number) : BitmapData
      {
         if(!param1 || isNaN(param2))
         {
            return param1;
         }
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         var _loc4_:BitmapData = param1.clone();
         var _loc5_:ColorTransform = getHightlightColorTransfrom(param2);
         if(_loc5_)
         {
            _loc4_.draw(param1,null,_loc5_,null,null,true);
         }
         _loc3_.draw(param1,null,getColorTransfromByColor(param2));
         _loc3_.draw(_loc4_,null,null,BlendMode.HARDLIGHT);
         _loc4_.dispose();
         _loc4_ = null;
         return _loc3_;
      }
      
      public static function getHightlightColorTransfrom(param1:uint) : ColorTransform
      {
         var _loc2_:uint = param1 >> 16 & 255;
         var _loc3_:uint = param1 >> 8 & 255;
         var _loc4_:uint = param1 & 255;
         var _loc5_:uint = param1 >> 24 & 255;
         var _loc6_:int = _loc2_;
         var _loc7_:int = _loc3_;
         var _loc8_:int = _loc4_;
         var _loc9_:Boolean = false;
         if(!(_loc6_ == _loc7_ || _loc6_ == _loc8_ || _loc7_ == _loc8_))
         {
            if(_loc6_ > _loc7_)
            {
               if(_loc6_ > _loc8_)
               {
                  _loc6_ = 50;
                  _loc7_ = 0;
                  _loc8_ = 0;
                  _loc9_ = true;
               }
               else
               {
                  _loc6_ = 0;
                  _loc7_ = 0;
                  _loc8_ = 50;
                  _loc9_ = true;
               }
            }
            else if(_loc7_ > _loc8_)
            {
               _loc6_ = 10;
               _loc7_ = 30;
               _loc8_ = 30;
               _loc9_ = true;
            }
            else
            {
               _loc6_ = 0;
               _loc7_ = 0;
               _loc8_ = 50;
               _loc9_ = true;
            }
         }
         if(_loc9_)
         {
            return new ColorTransform(1,1,1,1,_loc6_,_loc7_,_loc8_,0);
         }
         return null;
      }
      
      public static function setBitmapDataGray(param1:BitmapData) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:Vector.<uint> = param1.getVector(param1.rect);
         var _loc3_:uint = _loc2_.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_] << 16 >>> 24;
            _loc2_[_loc4_] = _loc5_ << 16 | _loc5_ << 8 | _loc5_;
            _loc4_++;
         }
         param1.setVector(param1.rect,_loc2_);
      }
      
      public static function getColorTransfromByColor(param1:uint) : ColorTransform
      {
         var _loc2_:uint = param1 >> 16 & 255;
         var _loc3_:uint = param1 >> 8 & 255;
         var _loc4_:uint = param1 & 255;
         var _loc5_:uint = param1 >> 24 & 255;
         if(!(_loc2_ == _loc3_ || _loc2_ == _loc4_ || _loc3_ == _loc4_))
         {
            if(_loc2_ < _loc3_ && _loc2_ < _loc4_)
            {
               if(_loc3_ < _loc4_)
               {
                  _loc3_ += 40;
                  _loc4_ += 10;
               }
               else
               {
                  _loc3_ += 40;
                  _loc4_ += 10;
               }
            }
            else if(_loc3_ < _loc2_ && _loc3_ < _loc4_)
            {
               if(_loc2_ < _loc4_)
               {
                  _loc2_ += 40;
                  _loc4_ += 10;
               }
               else
               {
                  _loc2_ += 40;
                  _loc4_ += 10;
               }
            }
            else if(_loc4_ < _loc3_ && _loc4_ < _loc2_)
            {
               if(_loc3_ < _loc2_)
               {
                  _loc3_ += 40;
                  _loc2_ += 10;
               }
               else
               {
                  _loc3_ += 40;
                  _loc2_ += 10;
               }
            }
         }
         return new ColorTransform(0,0,0,1,_loc2_,_loc3_,_loc4_,0);
      }
      
      public static function maskMovie(param1:DisplayObject, param2:Shape, param3:String, param4:Number, param5:Number, param6:Number, param7:Number, param8:int, param9:Function) : void
      {
         if(!param1 && !param1.parent)
         {
            return;
         }
         _callBack = param9;
         _maskShape = param2;
         _isMask = param3;
         _curX = 0;
         _curY = 0;
         _rowNumber = param4;
         _rowWitdh = param5;
         _rowHeight = param6;
         _sleepSecond = param8;
         _frameStep = param7;
         _curRow = 0;
         if(_isMask == "true")
         {
            param1.parent.addChild(_maskShape);
            param1.mask = _maskShape;
            _maskShape.addEventListener(Event.ENTER_FRAME,onMaskMovieEnerFrame);
         }
         else
         {
            param1.mask = null;
            _timer = new Timer(_sleepSecond * 1000);
            _timer.addEventListener(TimerEvent.TIMER,onMaskMovieTimer);
            _timer.start();
         }
      }
      
      private static function onMaskMovieEnerFrame(param1:Event) : void
      {
         _maskShape.graphics.beginFill(0);
         _maskShape.graphics.drawRect(_curX,_curY,_frameStep,_rowHeight);
         _maskShape.graphics.endFill();
         _curX += _frameStep;
         if(_curX >= _rowWitdh)
         {
            ++_curRow;
            _curX = 0;
            _curY = _curRow * _rowHeight;
         }
         if(_curRow >= _rowNumber)
         {
            _maskShape.removeEventListener(Event.ENTER_FRAME,onMaskMovieEnerFrame);
            if(_callBack == null)
            {
               return;
            }
            if(_sleepSecond > 0)
            {
               _timer = new Timer(_sleepSecond * 1000);
               _timer.addEventListener(TimerEvent.TIMER,onMaskMovieTimer);
               _timer.start();
            }
            else
            {
               if(_maskShape.parent)
               {
                  _maskShape.parent.removeChild(_maskShape);
               }
               _maskShape = null;
               _callBack();
            }
         }
      }
      
      private static function onMaskMovieTimer(param1:TimerEvent) : void
      {
         _timer.stop();
         _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onMaskMovieTimer);
         _timer = null;
         if(_maskShape && _maskShape.parent)
         {
            _maskShape.parent.removeChild(_maskShape);
         }
         _maskShape = null;
         if(_callBack != null)
         {
            _callBack();
         }
      }
      
      public static function reverseBtimapData(param1:BitmapData) : void
      {
         var _loc2_:int = param1.width;
         var _loc3_:int = param1.height;
         var _loc4_:Vector.<uint> = param1.getVector(new Rectangle(0,0,_loc2_,_loc3_));
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            param1.setVector(new Rectangle(0,_loc5_,_loc2_,1),_loc4_.splice(0,_loc2_).reverse());
            _loc5_++;
         }
      }
   }
}
