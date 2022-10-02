package game.actions
{
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.view.character.GameCharacter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import game.animations.AnimationLevel;
   import game.model.Player;
   import game.objects.GameLiving;
   import game.objects.GameLocalPlayer;
   import game.objects.SimpleObject;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class SelfPlayerWalkAction extends BaseAction
   {
       
      
      private var _player:GameLocalPlayer;
      
      private var _end:Point;
      
      private var _count:int;
      
      private var _transmissionGate:Boolean = true;
      
      public function SelfPlayerWalkAction(param1:GameLocalPlayer)
      {
         super();
         this._player = param1;
         this._count = 0;
         _isFinished = false;
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         return param1 is SelfPlayerWalkAction;
      }
      
      private function isDirkeyDown() : Boolean
      {
         if(this._player.info.direction == -1)
         {
            return KeyboardManager.isDown(KeyStroke.VK_A.getCode()) || KeyboardManager.isDown(Keyboard.LEFT);
         }
         return KeyboardManager.isDown(KeyStroke.VK_D.getCode()) || KeyboardManager.isDown(Keyboard.RIGHT);
      }
      
      override public function prepare() : void
      {
         this._player.startMoving();
         this._player.needFocus(0,0,{
            "strategy":"directly",
            "priority":AnimationLevel.MIDDLE
         });
      }
      
      override public function execute() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Number = NaN;
         if(!this._player || !this._player.info)
         {
            _isFinished = true;
            return;
         }
         if(this.isDirkeyDown() && (this._player.localPlayer.powerRatio == 0 || this._player.localPlayer.energy > 0) && this._player.localPlayer.isAttacking)
         {
            _loc1_ = this._player.getNextWalkPoint(this._player.info.direction * this._player.player.reverse);
            if(_loc1_)
            {
               this._player.info.pos = _loc1_;
               this._player.body.doAction(this._player.body.walkAction);
               this._player.body.WingState = GameCharacter.GAME_WING_MOVE;
               SoundManager.instance.play("044",false,false);
               this._player.needFocus(0,0,{
                  "strategy":"directly",
                  "priority":AnimationLevel.MIDDLE
               });
               ++this._count;
               if(this._count >= 20)
               {
                  this.sendAction();
               }
            }
            else
            {
               this.sendAction();
               this.finish();
               _loc2_ = this._player.x + this._player.info.direction * Player.MOVE_SPEED;
               if(this._player.canMoveDirection(this._player.info.direction) && this._player.canStand(_loc2_,this._player.y) == false)
               {
                  _loc1_ = this._player.map.findYLineNotEmptyPointDown(_loc2_,this._player.y - GameLiving.stepY,this._player.map.bound.height);
                  if(_loc1_)
                  {
                     this._player.act(new PlayerFallingAction(this._player,_loc1_,true,false));
                     GameInSocketOut.sendGameStartMove(1,_loc1_.x,_loc1_.y,0,true,this._player.map.currentTurn);
                  }
                  else
                  {
                     this._player.act(new PlayerFallingAction(this._player,new Point(_loc2_,this._player.map.bound.height - 70),false,false));
                     GameInSocketOut.sendGameStartMove(1,_loc2_,this._player.map.bound.height,0,false,this._player.map.currentTurn);
                  }
               }
            }
         }
         else
         {
            if(this._player.localPlayer.energy <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.actions.SelfPlayerWalkAction"));
            }
            this.sendAction();
            this.finish();
         }
         if(RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            this.transmissionGate();
         }
      }
      
      private function transmissionGate() : void
      {
         var _loc3_:Object = null;
         var _loc1_:Rectangle = this._player.getCollideRect();
         _loc1_.offset(this._player.x,this._player.y);
         var _loc2_:Array = this._player.map.getCollidedPhysicalObjects(_loc1_,this._player);
         if(_loc2_.length != 0 && this._transmissionGate)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ is SimpleObject && _loc3_.layerType == 3)
               {
                  this._player.localPlayer.isAttacking = false;
                  this._player.showTransmissionEffoct();
                  GameInSocketOut.sendTransmissionGate(true);
                  this._transmissionGate = false;
               }
            }
         }
      }
      
      private function sendAction() : void
      {
         GameInSocketOut.sendGameStartMove(0,this._player.x,this._player.y,this._player.info.direction,this._player.isLiving,this._player.map.currentTurn);
         this._count = 0;
      }
      
      private function finish() : void
      {
         this._player.stopMoving();
         this._player.doAction(GameCharacter.STAND);
         _isFinished = true;
      }
   }
}
