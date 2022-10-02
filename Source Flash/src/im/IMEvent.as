package im
{
   import flash.events.Event;
   
   public class IMEvent extends Event
   {
      
      public static const ADDNEW_FRIEND:String = "addnewfriend";
      
      public static const ADD_NEW_GROUP:String = "addNewGroup";
      
      public static const UPDATE_GROUP:String = "updateGroup";
      
      public static const DELETE_GROUP:String = "deleteGroup";
       
      
      public var data:Object;
      
      public function IMEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         this.data = param2;
         super(param1,param3,param4);
      }
   }
}
