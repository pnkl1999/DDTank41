package game.actions
{
   import ddt.view.character.GameCharacter;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   
   public class PlayerBeatAction extends BaseAction
   {
       
      
      private var _player:GamePlayer;
      
      private var _count:int;
      
      public function PlayerBeatAction(param1:GamePlayer)
      {
         super();
         this._player = param1;
         this._count = 0;
      }
      
      override public function prepare() : void
      {
         this._player.body.doAction(GameCharacter.HIT);
         this._player.map.setTopPhysical(this._player);
         if(this._player is GameLocalPlayer)
         {
            GameLocalPlayer(this._player).aim.visible = false;
         }
      }
      
      override public function execute() : void
      {
         ++this._count;
         if(this._count >= 50)
         {
            if(this._player is GameLocalPlayer)
            {
               GameLocalPlayer(this._player).aim.visible = true;
            }
            _isFinished = true;
         }
      }
   }
}
