package ddt.events
{
   import flash.events.Event;
   
   public class DungeonInfoEvent extends Event
   {
      
      public static const DungeonHelpChanged:String = "DungeonHelpChanged";
       
      
      public function DungeonInfoEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
