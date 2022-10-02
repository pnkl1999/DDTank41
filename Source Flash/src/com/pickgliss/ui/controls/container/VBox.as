package com.pickgliss.ui.controls.container
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class VBox extends BoxContainer
   {
       
      
      public function VBox()
      {
         super();
      }
      
      override public function arrange() : void
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:int = 0;
         _loc4_ = null;
         _width = 0;
         _height = 0;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         _loc3_ = 0;
         while(_loc3_ < _childrenList.length)
         {
            _loc4_ = _childrenList[_loc3_];
            _loc4_.y = _loc1_;
            _loc1_ += this.getItemHeight(_loc4_);
            _loc1_ += _spacing;
            if(_autoSize == CENTER && _loc3_ != 0)
            {
               _loc2_ = _childrenList[0].x - (_loc4_.width - _childrenList[0].width) / 2;
            }
            else if(_autoSize == RIGHT_OR_BOTTOM && _loc3_ != 0)
            {
               _loc2_ = _childrenList[0].x - (_loc4_.width - _childrenList[0].width);
            }
            else
            {
               _loc2_ = _loc4_.x;
            }
            _loc4_.x = _loc2_;
            _height += this.getItemHeight(_loc4_);
            _width = Math.max(_width,_loc4_.width);
            _loc3_++;
         }
         _height += _spacing * (numChildren - 1);
         _height = Math.max(0,_height);
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function getItemHeight(param1:DisplayObject) : Number
      {
         if(isStrictSize)
         {
            return _strictSize;
         }
         return param1.height;
      }
   }
}
