package game.actions
{
   import ddt.command.PlayerAction;
   import ddt.data.BallInfo;
   import ddt.data.EquipType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BallManager;
   import ddt.manager.SoundManager;
   import ddt.view.character.GameCharacter;
   import game.model.LocalPlayer;
   import game.objects.ActionType;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   import game.objects.SimpleBomb;
   import game.objects.SkillBomb;
   import game.view.Bomb;
   import phy.bombs.BaseBomb;
   
   public class ShootBombAction extends BaseAction
   {
       
      
      private var _player:GamePlayer;
      
      private var _showAction:PlayerAction;
      
      private var _hideAction:PlayerAction;
      
      private var _bombs:Array;
      
      private var _isShoot:Boolean;
      
      private var _shootInterval:int;
      
      private var _info:BallInfo;
      
      private var _event:CrazyTankSocketEvent;
      
      public function ShootBombAction(param1:GamePlayer, param2:Array, param3:CrazyTankSocketEvent, param4:int)
      {
         super();
         this._player = param1;
         this._bombs = param2;
         this._event = param3;
         this._shootInterval = param4;
         this._event.executed = false;
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         _isPrepare = true;
         if(this._player == null || this._player.body == null || this._player.player == null)
         {
            this.finish();
            return;
         }
         this._info = BallManager.findBall(this._player.player.currentBomb);
         this._showAction = this._info.ActionType == 0 ? GameCharacter.THROWS : GameCharacter.SHOT;
         this._hideAction = this._info.ActionType == 0 ? GameCharacter.HIDETHROWS : GameCharacter.HIDEGUN;
         if(this._player.isLiving)
         {
            this._player.body.doAction(this._showAction);
            if(this._player.weaponMovie)
            {
               this._player.weaponMovie.visible = true;
               this._player.setWeaponMoiveActionSyc("shot");
               this._player.body.WingState = GameCharacter.GAME_WING_SHOOT;
            }
         }
      }
      
      override public function execute() : void
      {
         if(this._player == null || this._player.body == null || this._player.body.currentAction == null)
         {
            this.finish();
            return;
         }
         if(this._player.body.currentAction != this._showAction)
         {
            if(this._player.weaponMovie)
            {
               this._player.weaponMovie.visible = false;
            }
            this._player.body.WingState = GameCharacter.GAME_WING_WAIT;
         }
         if(!this._isShoot)
         {
            if(!this._player.body.actionPlaying() || this._player.body.currentAction != this._showAction)
            {
               this.executeImp(false);
            }
         }
         else
         {
            --this._shootInterval;
            if(this._shootInterval <= 0)
            {
               if(this._player.body.currentAction == this._showAction)
               {
                  if(this._player.isLiving)
                  {
                     this._player.body.doAction(this._hideAction);
                  }
                  if(this._player.weaponMovie)
                  {
                     this._player.setWeaponMoiveActionSyc("end");
                  }
                  this._player.body.WingState = GameCharacter.GAME_WING_WAIT;
               }
               this.finish();
            }
         }
      }
      
      private function setSelfShootFinish() : void
      {
         if(!this._player.isExist)
         {
            return;
         }
         if(!this._player.info.isSelf)
         {
            return;
         }
         if(GameLocalPlayer(this._player).shootOverCount >= LocalPlayer(this._player.info).shootCount)
         {
            GameLocalPlayer(this._player).shootOverCount = LocalPlayer(this._player.info).shootCount;
         }
         else
         {
            ++GameLocalPlayer(this._player).shootOverCount;
         }
      }
      
      private function finish() : void
      {
         _isFinished = true;
         this._event.executed = true;
         this.setSelfShootFinish();
      }
      
      private function executeImp(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Bomb = null;
         var _loc4_:int = 0;
         var _loc5_:BaseBomb = null;
         if(!this._isShoot)
         {
            this._isShoot = true;
            SoundManager.instance.play(this._info.ShootSound);
            _loc2_ = 0;
            while(_loc2_ < this._bombs.length)
            {
               _loc4_ = 0;
               while(_loc4_ < this._bombs[_loc2_].Actions.length)
               {
                  if(this._bombs[_loc2_].Actions[_loc4_].type == ActionType.KILL_PLAYER)
                  {
                     this._bombs.unshift(this._bombs.splice(_loc2_,1)[0]);
                     break;
                  }
                  _loc4_++;
               }
               _loc2_++;
            }
            for each(_loc3_ in this._bombs)
            {
               if(_loc3_.Template.ID == EquipType.LaserBomdID)
               {
                  _loc5_ = new SkillBomb(_loc3_,this._player.info);
               }
               else
               {
                  _loc5_ = new SimpleBomb(_loc3_,this._player.info,this._player.player.currentWeapInfo.refineryLevel);
               }
               this._player.map.addPhysical(_loc5_);
               if(param1)
               {
                  _loc5_.bombAtOnce();
               }
            }
         }
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this.executeImp(true);
      }
   }
}
