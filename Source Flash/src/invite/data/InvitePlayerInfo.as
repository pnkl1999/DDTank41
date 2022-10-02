package invite.data
{
   import ddt.data.player.PlayerInfo;
   
   public class InvitePlayerInfo extends PlayerInfo
   {
       
      
      public var invited:Boolean = false;
      
      public function InvitePlayerInfo()
      {
         super();
      }
   }
}
