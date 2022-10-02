package activeEvents
{
   import flash.events.Event;
   
   public class ActiveConductEvent extends Event
   {
      
      public static const ONLINK:String = "on_link";
       
      
      public var _data:Object;
      
      public function ActiveConductEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         this._data = param2;
         super(param1,param3,param4);
      }
   }
}
