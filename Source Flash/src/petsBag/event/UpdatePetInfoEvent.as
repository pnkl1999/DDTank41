package petsBag.event
{
   import flash.events.Event;
   
   public class UpdatePetInfoEvent extends Event
   {
      
      public static const UPDATE:String = "update";
       
      
      public var data:Object;
      
      public function UpdatePetInfoEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
   }
}
