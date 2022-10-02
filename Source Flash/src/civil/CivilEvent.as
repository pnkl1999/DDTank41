package civil
{
   import flash.events.Event;
   
   public class CivilEvent extends Event
   {
      
      public static const CIVIL_PLAYERINFO_ARRAY_CHANGE:String = "civilplayerinfoarraychange";
      
      public static const CIVIL_MARRY_STATE_CHANGE:String = "civilmarrystatechange";
      
      public static const SELECT_CLICK_ITEM:String = "selectclickitem";
      
      public static const CIVIL_UPDATE:String = "CivilUpdate";
      
      public static const CIVIL_UPDATE_BTN:String = "CivilUpdateBtn";
      
      public static const SELECTED_CHANGE:String = "selected_change";
      
      public static const REGISTER_CHANGE:String = "register_change";
       
      
      public var data:Object;
      
      public function CivilEvent(param1:String, param2:Object = null)
      {
         super(param1,param2);
         this.data = param2;
      }
   }
}
