package littleGame.model
{
   import ddt.data.player.PlayerInfo;
   import littleGame.events.LittleLivingEvent;
   
   public class LittlePlayer extends LittleLiving
   {
       
      
      private var _playerInfo:PlayerInfo;
      
      public function LittlePlayer(playerInfo:PlayerInfo, id:int, x:int, y:int, type:int)
      {
         this._playerInfo = playerInfo;
         super(id,x,y,type);
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      override public function get isPlayer() : Boolean
      {
         return true;
      }
      
      override public function toString() : String
      {
         return "LittlePlayer_" + this._playerInfo.NickName;
      }
      
      public function set headType($type:int) : void
      {
         dispatchEvent(new LittleLivingEvent(LittleLivingEvent.HeadChanged,$type));
      }
   }
}
