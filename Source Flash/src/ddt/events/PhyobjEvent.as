package ddt.events
{
   import flash.events.Event;
   
   public class PhyobjEvent extends Event
   {
      
      public static const CHANGE:String = "phyobjChange";
       
      
      public var action:String;
      
      public function PhyobjEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(PhyobjEvent.CHANGE,param2,param3);
         this.action = param1;
      }
   }
}
