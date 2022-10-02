package com.pickgliss.events
{
   import flash.events.Event;
   
   public class InteractiveEvent extends Event
   {
      
      public static const STATE_CHANGED:String = "stateChange";
      
      public static const CLICK:String = "interactive_click";
      
      public static const DOUBLE_CLICK:String = "interactive_double_click";
       
      
      public var ctrlKey:Boolean;
      
      public function InteractiveEvent(param1:String)
      {
         super(param1);
      }
   }
}
