package cityWide
{
   import ddt.data.player.PlayerInfo;
   import flash.events.Event;
   
   public class CityWideEvent extends Event
   {
      
      public static const ONS_PLAYERINFO:String = "ons_playerInfo";
       
      
      private var _playerInfo:PlayerInfo;
      
      public function CityWideEvent(param1:String, param2:PlayerInfo = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._playerInfo = param2;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
   }
}
