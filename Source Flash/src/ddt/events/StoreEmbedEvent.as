package ddt.events
{
   import flash.events.Event;
   
   public class StoreEmbedEvent extends Event
   {
      
      public static const ItemChang:String = "itemChange";
       
      
      public function StoreEmbedEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
