package game.actions.newHand
{
   import game.GameManager;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.view.Bomb;
   import game.view.map.MapView;
   
   public class NewHandFightHelpAction extends BaseNewHandFightHelpAction
   {
       
      
      private var _player:LocalPlayer;
      
      private var _enemyPlayer:Player;
      
      private var _bombs:Array;
      
      private var _shootOverCount:int;
      
      private var _map:MapView;
      
      public function NewHandFightHelpAction(param1:LocalPlayer, param2:int, param3:MapView)
      {
         super();
         this._player = param1;
         this._bombs = this._player.lastFireBombs;
         this._shootOverCount = param2;
         this._map = param3;
      }
      
      override public function prepare() : void
      {
         super.prepare();
         if(!isInNewHandRoom)
         {
            _isFinished = true;
            return;
         }
         this._enemyPlayer = this.getNewHandEnemy();
         if(!this._enemyPlayer || !this._player.isLiving || !_gameInfo)
         {
            _isFinished = true;
         }
         else if(_gameInfo.currentLiving != this._player && this._shootOverCount > 0)
         {
            _isFinished = false;
         }
         else if(_gameInfo.currentLiving == this._player)
         {
            this._player.NewHandEnemyBlood = this._enemyPlayer.blood;
            this._player.NewHandEnemyIsFrozen = this._enemyPlayer.isFrozen;
            this._player.NewHandSelfBlood = this._player.blood;
            _isFinished = true;
         }
         else
         {
            _isFinished = true;
         }
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         if(!this._player || !_gameInfo || !this._map || !this._enemyPlayer)
         {
            return;
         }
         if(this.checkShootDirection())
         {
            return;
         }
         if(this.checkShootOutMap())
         {
            return;
         }
         if(this.checkHurtEnemy())
         {
            return;
         }
      }
      
      override public function execute() : void
      {
         super.execute();
         this._player = null;
         this._bombs = null;
         _gameInfo = null;
         this._map = null;
         this._enemyPlayer = null;
      }
      
      private function getNewHandEnemy() : Player
      {
         var _loc1_:Living = null;
         for each(_loc1_ in GameManager.Instance.Current.livings)
         {
            if(_loc1_.isPlayer() && _loc1_.isLiving && _loc1_ != this._player)
            {
               return _loc1_ as Player;
            }
         }
         return null;
      }
      
      private function checkShootDirection() : Boolean
      {
         var _loc1_:Bomb = this.getRecentBomb();
         if(_loc1_ == null || _loc1_.Template.ID == Bomb.FLY_BOMB)
         {
            return false;
         }
         var _loc2_:int = this._enemyPlayer.pos.x > this._player.pos.x ? int(int(1)) : int(int(-1));
         var _loc3_:int = _loc1_.target.x >= _loc1_.X ? int(int(1)) : int(int(-1));
         if(_loc2_ != _loc3_)
         {
            showFightTip("tank.trainer.fightAction.newHandTip1");
            return true;
         }
         return false;
      }
      
      private function checkShootOutMap() : Boolean
      {
         var _loc1_:Bomb = null;
         for each(_loc1_ in this._bombs)
         {
            if(_loc1_.Template.ID != 64 && this._map.IsOutMap(_loc1_.target.x,_loc1_.target.y))
            {
               ++this._player.NewHandHurtEnemyCounter;
               this.checkHurtEnemy(false);
               showFightTip("tank.trainer.fightAction.newHandTip2");
               return true;
            }
         }
         return false;
      }
      
      private function checkHurtSelf() : Boolean
      {
         var _loc1_:int = this._player.NewHandSelfBlood > 0 ? int(int(this._player.NewHandSelfBlood)) : int(int(this._player.maxBlood));
         if(_loc1_ > this._player.blood)
         {
            ++this._player.NewHandHurtSelfCounter;
            if(this._player.NewHandHurtSelfCounter > 0)
            {
               showFightTip("tank.trainer.fightAction.newHandTip4");
               return true;
            }
         }
         else
         {
            this._player.NewHandHurtSelfCounter = 0;
         }
         return false;
      }
      
      private function getRecentBomb() : Bomb
      {
         var _loc2_:Bomb = null;
         var _loc3_:Bomb = null;
         var _loc4_:int = 0;
         var _loc1_:int = -1;
         for each(_loc3_ in this._bombs)
         {
            _loc4_ = _loc3_.Template.ID;
            if(_loc3_ && (_loc4_ != 64 && _loc4_ != Bomb.FLY_BOMB && _loc4_ != Bomb.FREEZE_BOMB) && (_loc1_ == -1 || Math.abs(_loc3_.target.x - this._enemyPlayer.pos.x) < _loc1_))
            {
               _loc1_ = Math.abs(_loc3_.target.x - this._enemyPlayer.pos.x);
               _loc2_ = _loc3_;
            }
         }
         return _loc2_;
      }
      
      private function checkHurtEnemy(param1:Boolean = true) : Boolean
      {
         var _loc2_:Bomb = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._player.NewHandEnemyBlood > this._enemyPlayer.blood || this._player.NewHandEnemyIsFrozen && !this._enemyPlayer.isFrozen)
         {
            this._player.NewHandHurtEnemyCounter = 0;
         }
         else
         {
            _loc2_ = this.getRecentBomb();
            if(_loc2_ == null)
            {
               return false;
            }
            ++this._player.NewHandHurtEnemyCounter;
            if(this._player.NewHandHurtEnemyCounter > 1)
            {
               _loc3_ = this._enemyPlayer.pos.x > this._player.pos.x ? int(int(1)) : int(int(-1));
               _loc4_ = _loc2_.target.x > this._enemyPlayer.pos.x ? int(int(1)) : int(int(-1));
               if(param1)
               {
                  showFightTip("tank.trainer.fightAction.newHandTip3" + (_loc3_ == _loc4_ ? "Small" : "Large"));
               }
               return true;
            }
         }
         return false;
      }
   }
}
