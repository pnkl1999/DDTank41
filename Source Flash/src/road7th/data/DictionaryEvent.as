package road7th.data
{
   import flash.events.Event;
   
   public class DictionaryEvent extends Event
   {
      
      public static const ADD:String = "add";
      
      public static const UPDATE:String = "update";
      
      public static const REMOVE:String = "remove";
      
      public static const CLEAR:String = "clear";
       
      
      public var data:Object;
      
      public function DictionaryEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
   }
}
