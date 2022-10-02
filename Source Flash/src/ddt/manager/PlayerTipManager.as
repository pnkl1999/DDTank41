package ddt.manager
{
   import ddt.data.player.BasePlayer;
   import ddt.view.tips.PlayerTip;
   
   public class PlayerTipManager
   {
      
      private static var _view:PlayerTip;
      
      private static var _yOffset:int;
       
      
      public function PlayerTipManager()
      {
         super();
      }
      
      public static function show(param1:BasePlayer, param2:int = -1) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.ID == PlayerManager.Instance.Self.ID)
         {
            instance.setSelfDisable(true);
         }
         else
         {
            instance.setSelfDisable(false);
            if(PlayerManager.Instance.Self.IsMarried)
            {
               instance.proposeEnable(false);
            }
         }
         instance.playerInfo = param1;
         instance.show(param2);
      }
      
      public static function get instance() : PlayerTip
      {
         if(_view == null)
         {
            _view = new PlayerTip();
         }
         return _view;
      }
      
      public static function hide() : void
      {
         instance.hide();
      }
   }
}
