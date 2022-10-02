package com.pickgliss.events
{
   public class ModelEvent
   {
       
      
      private var source:Object;
      
      public function ModelEvent(param1:Object)
      {
         super();
         this.source = param1;
      }
      
      public function getSource() : Object
      {
         return this.source;
      }
   }
}
