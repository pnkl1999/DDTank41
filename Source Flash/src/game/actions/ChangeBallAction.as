package game.actions
{
   import game.model.Player;
   
   public class ChangeBallAction extends BaseAction
   {
       
      
      private var _player:Player;
      
      private var _currentBomb:int;
      
      private var _isSpecialSkill:Boolean;
      
      public function ChangeBallAction(param1:Player, param2:Boolean, param3:int)
      {
         super();
         this._player = param1;
         this._currentBomb = param3;
         this._isSpecialSkill = param2;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         if(!this._player.isExist)
         {
            return;
         }
         this._player.isSpecialSkill = this._isSpecialSkill;
         this._player.currentBomb = this._currentBomb;
         if(this._player.isSpecialSkill)
         {
            this._player.addState(-1);
         }
      }
   }
}
