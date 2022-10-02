package com.pickgliss.ui.controls.list
{
   import com.pickgliss.events.ModelEvent;
   
   public class ListDataEvent extends ModelEvent
   {
       
      
      private var index0:int;
      
      private var index1:int;
      
      private var removedItems:Array;
      
      public function ListDataEvent(param1:Object, param2:int, param3:int, param4:Array)
      {
         super(param1);
         this.index0 = param2;
         this.index1 = param3;
         this.removedItems = param4.concat();
      }
      
      public function getIndex0() : int
      {
         return this.index0;
      }
      
      public function getIndex1() : int
      {
         return this.index1;
      }
      
      public function getRemovedItems() : Array
      {
         return this.removedItems.concat();
      }
   }
}
