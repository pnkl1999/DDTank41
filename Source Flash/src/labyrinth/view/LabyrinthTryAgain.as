package labyrinth.view
{
   import baglocked.BaglockedManager;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import game.TryAgain;
   import game.model.MissionAgainInfo;
   
   public class LabyrinthTryAgain extends TryAgain
   {
       
      
      public function LabyrinthTryAgain(param1:MissionAgainInfo, param2:Boolean = true)
      {
         super(param1,param2);
      }
      
      override protected function __tryagainClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.checkMoneys(_info.value))
         {
            return;
         }
         tryagain(false);
      }
      
      private function checkMoneys(param1:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Money < param1)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
   }
}
