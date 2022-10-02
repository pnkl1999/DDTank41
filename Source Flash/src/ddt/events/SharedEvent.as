package ddt.events
{
   import flash.events.Event;
   
   public class SharedEvent extends Event
   {
      
      public static const TRANSPARENTCHANGED:String = "transparentChanged";
       
      
      public function SharedEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
