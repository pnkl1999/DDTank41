package com.pickgliss.ui.controls
{
   import com.pickgliss.events.InteractiveEvent;
   import flash.events.EventDispatcher;
   
   public class BoundedRangeModel extends EventDispatcher
   {
       
      
      private var value:int;
      
      private var extent:int;
      
      private var min:int;
      
      private var max:int;
      
      private var isAdjusting:Boolean;
      
      public function BoundedRangeModel(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 100)
      {
         super();
         this.isAdjusting = false;
         if(param4 >= param3 && param1 >= param3 && param1 + param2 >= param1 && param1 + param2 <= param4)
         {
            this.value = param1;
            this.extent = param2;
            this.min = param3;
            this.max = param4;
            return;
         }
         throw new RangeError("invalid range properties");
      }
      
      public function getValue() : int
      {
         return this.value;
      }
      
      public function getExtent() : int
      {
         return this.extent;
      }
      
      public function getMinimum() : int
      {
         return this.min;
      }
      
      public function getMaximum() : int
      {
         return this.max;
      }
      
      public function setValue(param1:int) : void
      {
         param1 = Math.min(param1,this.max - this.extent);
         var _loc2_:int = Math.max(param1,this.min);
         this.setRangeProperties(_loc2_,this.extent,this.min,this.max,this.isAdjusting);
      }
      
      public function setExtent(param1:int) : void
      {
         var _loc2_:int = Math.max(0,param1);
         if(this.value + _loc2_ > this.max)
         {
            _loc2_ = this.max - this.value;
         }
         this.setRangeProperties(this.value,_loc2_,this.min,this.max,this.isAdjusting);
      }
      
      public function setMinimum(param1:int) : void
      {
         var _loc2_:int = Math.max(param1,this.max);
         var _loc3_:int = Math.max(param1,this.value);
         var _loc4_:int = Math.min(_loc2_ - _loc3_,this.extent);
         this.setRangeProperties(_loc3_,_loc4_,param1,_loc2_,this.isAdjusting);
      }
      
      public function setMaximum(param1:int) : void
      {
         var _loc2_:int = Math.min(param1,this.min);
         var _loc3_:int = Math.min(param1 - _loc2_,this.extent);
         var _loc4_:int = Math.min(param1 - _loc3_,this.value);
         this.setRangeProperties(_loc4_,_loc3_,_loc2_,param1,this.isAdjusting);
      }
      
      public function setValueIsAdjusting(param1:Boolean) : void
      {
         this.setRangeProperties(this.value,this.extent,this.min,this.max,param1);
      }
      
      public function getValueIsAdjusting() : Boolean
      {
         return this.isAdjusting;
      }
      
      public function setRangeProperties(param1:int, param2:int, param3:int, param4:int, param5:Boolean) : void
      {
         if(param3 > param4)
         {
            param3 = param4;
         }
         if(param1 > param4)
         {
            param4 = param1;
         }
         if(param1 < param3)
         {
            param3 = param1;
         }
         if(param2 + param1 > param4)
         {
            param2 = param4 - param1;
         }
         if(param2 < 0)
         {
            param2 = 0;
         }
         var _loc6_:Boolean = param1 != this.value || param2 != this.extent || param3 != this.min || param4 != this.max || param5 != this.isAdjusting;
         if(_loc6_)
         {
            this.value = param1;
            this.extent = param2;
            this.min = param3;
            this.max = param4;
            this.isAdjusting = param5;
            this.fireStateChanged();
         }
      }
      
      public function addStateListener(param1:Function, param2:int = 0, param3:Boolean = false) : void
      {
         addEventListener(InteractiveEvent.STATE_CHANGED,param1,false,param2);
      }
      
      public function removeStateListener(param1:Function) : void
      {
         removeEventListener(InteractiveEvent.STATE_CHANGED,param1);
      }
      
      protected function fireStateChanged() : void
      {
         dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
      }
      
      override public function toString() : String
      {
         var _loc1_:String = "value=" + this.getValue() + ", " + "extent=" + this.getExtent() + ", " + "min=" + this.getMinimum() + ", " + "max=" + this.getMaximum() + ", " + "adj=" + this.getValueIsAdjusting();
         return "BoundedRangeModel" + "[" + _loc1_ + "]";
      }
   }
}
