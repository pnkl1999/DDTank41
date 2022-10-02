package ddt.events
{
   import flash.events.Event;
   
   public class CEvent extends Event
   {
      
      public static const HALL_PLAYER_ARRIVED:String = "hall_player_arrived";
      
      public static const HALL_AREA_CLICKED:String = "hall_area_clicked";
      
      public static const OPEN_VIEW:String = "openview";
      
      public static const CLOSE_VIEW:String = "closeView";
      
      public static const EQUIP_GHOST_RESULT:String = "equip_ghost_result";
      
      public static const EQUIP_GHOST_RATIO:String = "equip_ghost_ratio";
      
      public static const EQUIP_GHOST_STATE:String = "equip_ghost_state";
      
      public static const EQUIP_GHOST_DATA:String = "equip_ghost_data";
       
      
      private var _data:Object;
      
      public function CEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._data = param2;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}
