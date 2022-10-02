package academy
{
   import flash.events.Event;
   
   public class AcademyEvent extends Event
   {
      
      public static const ACADEMY_PLAYERINFO_ARRAY_CHANGE:String = "Academyplayerinfoarraychange";
      
      public static const ACADEMY_MARRY_STATE_CHANGE:String = "Academymarrystatechange";
      
      public static const SELECT_ACADEMY_ITEM:String = "selectclickitem";
      
      public static const ACADEMY_UPDATE_LIST:String = "AcademyUpdateList";
      
      public static const ACADEMY_UPDATE_BTN:String = "AcademyUpdateBtn";
      
      public static const SELECTED_CHANGE:String = "selected_change";
      
      public static const REGISTER_CHANGE:String = "registerChange";
      
      public static const ACADEMY_PLAYER_CHANGE:String = "academyPlayerChange";
       
      
      public function AcademyEvent(param1:String)
      {
         super(param1);
      }
   }
}
