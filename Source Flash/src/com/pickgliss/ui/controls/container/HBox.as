package com.pickgliss.ui.controls.container
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class HBox extends BoxContainer
   {
       
      
      public function HBox()
      {
         super();
      }
      
      override public function arrange() : void
      {
         var _loc4_:DisplayObject = null;
         _loc4_ = null;
         _width = 0;
         _height = 0;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _childrenList.length)
         {
            _loc4_ = _childrenList[_loc3_];
            _loc4_.x = _loc1_;
            _loc1_ += this.getItemWidth(_loc4_);
            _loc1_ += _spacing;
            if(_autoSize == CENTER && _loc3_ != 0)
            {
               _loc2_ = _childrenList[0].y - (_loc4_.height - _childrenList[0].height) / 2;
            }
            else if(_autoSize == RIGHT_OR_BOTTOM && _loc3_ != 0)
            {
               _loc2_ = _childrenList[0].y - (_loc4_.height - _childrenList[0].height);
            }
            else
            {
               _loc2_ = _childrenList[0].y;
            }
            _loc4_.y = _loc2_;
            _width += this.getItemWidth(_loc4_);
            _height = Math.max(_height,_loc4_.height);
            _loc3_++;
         }
         _width += _spacing * (numChildren - 1);
         _width = Math.max(0,_width);
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function getItemWidth(param1:DisplayObject) : Number
      {
         if(isStrictSize)
         {
            return _strictSize;
         }
         return param1.width;
      }
   }
}
