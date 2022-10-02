package com.pickgliss.utils
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public final class DisplayUtils
   {
      
      private static const ZERO_POINT:Point = new Point(0,0);
       
      
      public function DisplayUtils()
      {
         super();
      }
      
      public static function removeDisplay(... rest) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in rest)
         {
            if(_loc2_ && _loc2_.parent)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
         return rest[0];
      }
      
      public static function drawRectShape(param1:Number, param2:Number, param3:Shape = null) : Shape
      {
         var _loc4_:Shape = null;
         if(param3 == null)
         {
            _loc4_ = new Shape();
         }
         else
         {
            _loc4_ = param3;
         }
         _loc4_.graphics.clear();
         _loc4_.graphics.beginFill(16711680,1);
         _loc4_.graphics.drawRect(0,0,param1,param2);
         _loc4_.graphics.endFill();
         return _loc4_;
      }
      
      public static function drawTextShape(param1:TextField) : DisplayObject
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
      
      public static function isInTheStage(param1:Point, param2:DisplayObjectContainer = null) : Boolean
      {
         var _loc3_:Point = param1;
         if(param2)
         {
            _loc3_ = param2.localToGlobal(param1);
         }
         if(_loc3_.x < 0 || _loc3_.y < 0 || _loc3_.x > StageReferance.stageWidth || _loc3_.y > StageReferance.stageHeight)
         {
            return false;
         }
         return true;
      }
      
      public static function layoutDisplayWithInnerRect(param1:DisplayObject, param2:InnerRectangle, param3:int, param4:int) : void
      {
         var _loc5_:Rectangle = null;
         if(param2 == null)
         {
            return;
         }
         if(param1 is Component)
         {
            Component(param1).beginChanges();
         }
         _loc5_ = param2.getInnerRect(param3,param4);
         param1.x = _loc5_.x;
         param1.y = _loc5_.y;
         param1.width = _loc5_.width;
         param1.height = _loc5_.height;
         if(param1 is Component)
         {
            Component(param1).commitChanges();
         }
      }
      
      public static function setFrame(param1:DisplayObject, param2:int) : void
      {
         if(param1 is Image)
         {
            Image(param1).setFrame(param2);
         }
         else if(param1 is MovieClip)
         {
            MovieClip(param1).gotoAndStop(param2);
         }
         else if(param1 is FilterFrameText)
         {
            FilterFrameText(param1).setFrame(param2);
         }
         else if(param1 is GradientText)
         {
            GradientText(param1).setFrame(param2);
         }
      }
      
      public static function setDisplayObjectNotEnable(param1:DisplayObject) : void
      {
         if(param1 is InteractiveObject)
         {
            InteractiveObject(param1).mouseEnabled = false;
         }
         if(param1 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param1).mouseChildren = false;
            DisplayObjectContainer(param1).mouseEnabled = false;
         }
      }
      
      public static function getTextFieldLineHeight(param1:TextField) : int
      {
         return param1.getLineMetrics(0).height;
      }
      
      public static function getTextFieldCareLinePosY(param1:TextField) : Number
      {
         var _loc2_:int = param1.caretIndex - 1;
         var _loc3_:int = param1.text.charCodeAt(_loc2_);
         var _loc4_:int = param1.getLineIndexOfChar(_loc2_);
         var _loc5_:int = 0;
         if(_loc3_ == 13)
         {
            _loc5_ = _loc4_ + 1;
         }
         else
         {
            _loc5_ = _loc4_;
         }
         return getTextFieldLineHeight(param1) * _loc5_;
      }
      
      public static function getTextFieldCareLinePosX(param1:TextField) : Number
      {
         var _loc2_:int = param1.caretIndex - 1;
         var _loc3_:Rectangle = param1.getCharBoundaries(_loc2_);
         if(_loc3_ == null)
         {
            return 0;
         }
         return _loc3_.x + _loc3_.width;
      }
      
      public static function getVisibleSize(param1:DisplayObject) : Rectangle
      {
         var _loc3_:Rectangle = null;
         var _loc4_:BitmapData = new BitmapData(2000,2000,true,0);
         _loc4_.draw(param1);
         _loc3_ = _loc4_.getColorBoundsRect(4278190080,0,false);
         _loc4_.dispose();
         return new Rectangle(_loc3_.x,_loc3_.y,_loc3_.x + _loc3_.width,_loc3_.y + _loc3_.height);
      }
      
      public static function getTextFieldMaxLineWidth(param1:String, param2:TextFormat, param3:Boolean) : Number
      {
         var _loc5_:Array = null;
         var _loc4_:TextField = new TextField();
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         if(param3)
         {
            param1 = param1.replace("<BR>","\n");
            param1 = param1.replace("<Br>","\n");
            param1 = param1.replace("<bR>","\n");
            param1 = param1.replace("<br>","\n");
         }
         _loc5_ = param1.split("\n");
         var _loc6_:Number = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            if(param3)
            {
               _loc4_.htmlText = _loc5_[_loc7_];
            }
            else
            {
               _loc4_.text = _loc5_[_loc7_];
               _loc4_.setTextFormat(param2);
            }
            _loc6_ = Math.max(_loc6_,_loc4_.width);
            _loc7_++;
         }
         return _loc6_ + 2;
      }
      
      public static function isTargetOrContain(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1 == param2)
         {
            return true;
         }
         if(param2 is DisplayObjectContainer)
         {
            return DisplayObjectContainer(param2).contains(param1);
         }
         return false;
      }
      
      public static function getPointFromObject(param1:Point, param2:DisplayObject, param3:DisplayObject) : Point
      {
         param1 = param2.localToGlobal(param1);
         return param3.globalToLocal(param1);
      }
      
      public static function clearChildren(param1:Sprite) : void
      {
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
      }
      
      public static function getDisplayBitmapData(param1:DisplayObject) : BitmapData
      {
         if(param1 is Bitmap)
         {
            return Bitmap(param1).bitmapData;
         }
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         _loc2_.draw(param1);
         return _loc2_;
      }
      
      public static function localizePoint(param1:DisplayObject, param2:DisplayObject, param3:Point = null) : Point
      {
         return param1.globalToLocal(param2.localToGlobal(!!Boolean(param3) ? param3 : new Point(0,0)));
      }
      
      public static function setDisplayPos(param1:DisplayObject, param2:Point) : void
      {
         param1.x = param2.x;
         param1.y = param2.y;
      }
      
      public static function changeSize(param1:DisplayObject, param2:int, param3:int) : void
      {
         param1.width = param2;
         param1.height = param3;
      }
      
      public static function horizontalArrange(param1:Sprite, param2:int = 1, param3:Number = 0, param4:Number = 0) : void
      {
         var _loc14_:DisplayObject = null;
         var _loc8_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         _loc14_ = null;
         var _loc5_:int = 0;
         var _loc6_:int = ZERO_POINT.x;
         var _loc7_:int = ZERO_POINT.y;
         _loc8_ = 0;
         var _loc9_:int = 0;
         var _loc10_:int = Math.ceil(param1.numChildren / param2);
         var _loc11_:int = 0;
         while(_loc11_ < _loc10_)
         {
            _loc12_ = 0;
            _loc13_ = 0;
            while(_loc13_ < param2)
            {
               _loc14_ = param1.getChildAt(_loc5_++);
               _loc14_.x = _loc6_;
               _loc14_.y = _loc7_;
               _loc8_ = Math.max(_loc8_,_loc6_ + _loc14_.width);
               _loc9_ = Math.max(_loc9_,_loc7_ + _loc14_.height);
               _loc6_ += _loc14_.width + param3;
               if(_loc12_ < _loc14_.height)
               {
                  _loc12_ = _loc14_.height;
               }
               if(_loc5_ >= param1.numChildren)
               {
                  changeSize(param1,_loc8_,_loc9_);
                  return;
               }
               _loc13_++;
            }
            _loc6_ = ZERO_POINT.x;
            _loc7_ += _loc12_ + param4;
            _loc11_++;
         }
         changeSize(param1,_loc8_,_loc9_);
      }
      
      public static function verticalArrange(param1:Sprite, param2:int = 1, param3:Number = 0, param4:Number = 0) : void
      {
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:DisplayObject = null;
         var _loc5_:int = 0;
         var _loc6_:int = ZERO_POINT.x;
         var _loc7_:int = ZERO_POINT.y;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = Math.ceil(param1.numChildren / param2);
         var _loc11_:int = 0;
         while(_loc11_ < _loc10_)
         {
            _loc12_ = 0;
            _loc13_ = 0;
            while(_loc13_ < param2)
            {
               _loc14_ = param1.getChildAt(_loc5_++);
               _loc14_.x = _loc6_;
               _loc14_.y = _loc7_;
               _loc8_ = Math.max(_loc8_,_loc6_ + _loc14_.width);
               _loc9_ = Math.max(_loc9_,_loc7_ + _loc14_.height);
               _loc7_ += _loc14_.height + param4;
               if(_loc12_ < _loc14_.width)
               {
                  _loc12_ = _loc14_.width;
               }
               if(_loc5_ >= param1.numChildren)
               {
                  changeSize(param1,_loc8_,_loc9_);
                  return;
               }
               _loc13_++;
            }
            _loc6_ += _loc12_ + param3;
            _loc7_ = ZERO_POINT.y;
            _loc11_++;
         }
         changeSize(param1,_loc8_,_loc9_);
      }
   }
}
