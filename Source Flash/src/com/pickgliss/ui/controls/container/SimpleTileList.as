package com.pickgliss.ui.controls.container
{
   import com.pickgliss.ui.controls.BaseButton;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class SimpleTileList extends BoxContainer
   {
       
      
      public var startPos:Point;
      
      protected var _column:int;
      
      protected var _arrangeType:int;
      
      protected var _hSpace:Number = 0;
      
      protected var _rowNum:int;
      
      protected var _vSpace:Number = 0;
      
      private var _selectedIndex:int;
      
      public function SimpleTileList(param1:int = 1, param2:int = 0)
      {
         this.startPos = new Point(0,0);
         super();
         this._column = param1;
         this._arrangeType = param2;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
      }
      
      public function get hSpace() : Number
      {
         return this._hSpace;
      }
      
      public function set hSpace(param1:Number) : void
      {
         this._hSpace = param1;
         onProppertiesUpdate();
      }
      
      public function get vSpace() : Number
      {
         return this._vSpace;
      }
      
      public function set vSpace(param1:Number) : void
      {
         this._vSpace = param1;
         onProppertiesUpdate();
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         param1.addEventListener(MouseEvent.CLICK,this.__itemClick);
         super.addChild(param1);
         return param1;
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         if(_loc2_ as BaseButton)
         {
            return;
         }
         this._selectedIndex = getChildIndex(_loc2_);
      }
      
      override public function arrange() : void
      {
         this.caculateRows();
         if(this._arrangeType == 0)
         {
            this.horizontalArrange();
         }
         else
         {
            this.verticalArrange();
         }
      }
      
      private function horizontalArrange() : void
      {
         var _loc7_:int = 0;
         var _loc9_:DisplayObject = null;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         _loc7_ = 0;
         _loc9_ = null;
         _loc2_ = 0;
         var _loc3_:int = 0;
         _loc4_ = 0;
         var _loc5_:int = 0;
         _loc7_ = 0;
         var _loc8_:int = 0;
         _loc9_ = null;
         var _loc1_:int = 0;
         _loc2_ = this.startPos.x;
         _loc3_ = this.startPos.y;
         _loc4_ = 0;
         _loc5_ = 0;
         var _loc6_:int = 0;
         while(_loc6_ < this._rowNum)
         {
            _loc7_ = 0;
            _loc8_ = 0;
            while(_loc8_ < this._column)
            {
               _loc9_ = getChildAt(_loc1_++);
               _loc9_.x = _loc2_;
               _loc9_.y = _loc3_;
               _loc4_ = Math.max(_loc4_,_loc2_ + _loc9_.width);
               _loc5_ = Math.max(_loc5_,_loc3_ + _loc9_.height);
               _loc2_ += _loc9_.width + this._hSpace;
               if(_loc7_ < _loc9_.height)
               {
                  _loc7_ = _loc9_.height;
               }
               if(_loc1_ >= numChildren)
               {
                  this.changeSize(_loc4_,_loc5_);
                  return;
               }
               _loc8_++;
            }
            _loc2_ = this.startPos.x;
            _loc3_ += _loc7_ + this._vSpace;
            _loc6_++;
         }
         this.changeSize(_loc4_,_loc5_);
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function verticalArrange() : void
      {
         var _loc2_:int = 0;
         var _loc9_:DisplayObject = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc9_ = null;
         var _loc1_:int = 0;
         _loc2_ = this.startPos.x;
         var _loc3_:int = this.startPos.y;
         var _loc4_:int = 0;
         _loc5_ = 0;
         var _loc6_:int = 0;
         while(_loc6_ < this._rowNum)
         {
            _loc7_ = 0;
            _loc8_ = 0;
            while(_loc8_ < this._column)
            {
               _loc9_ = getChildAt(_loc1_++);
               _loc9_.x = _loc2_;
               _loc9_.y = _loc3_;
               _loc4_ = Math.max(_loc4_,_loc2_ + _loc9_.width);
               _loc5_ = Math.max(_loc5_,_loc3_ + _loc9_.height);
               _loc3_ += _loc9_.height + this._vSpace;
               if(_loc7_ < _loc9_.width)
               {
                  _loc7_ = _loc9_.width;
               }
               if(_loc1_ >= numChildren)
               {
                  this.changeSize(_loc4_,_loc5_);
                  return;
               }
               _loc8_++;
            }
            _loc2_ += _loc7_ + this._hSpace;
            _loc3_ = this.startPos.y;
            _loc6_++;
         }
         this.changeSize(_loc4_,_loc5_);
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function changeSize(param1:int, param2:int) : void
      {
         if(param1 != _width || param2 != _height)
         {
            width = param1;
            height = param2;
         }
      }
      
      private function caculateRows() : void
      {
         this._rowNum = Math.ceil(numChildren / this._column);
      }
      
      override public function dispose() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_) as DisplayObject;
            _loc2_.removeEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc1_++;
         }
         super.dispose();
      }
   }
}
