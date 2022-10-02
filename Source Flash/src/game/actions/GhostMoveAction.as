package game.actions
{
   import ddt.manager.SoundManager;
   import ddt.view.character.GameCharacter;
   import flash.geom.Point;
   import game.model.Player;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   
   public class GhostMoveAction extends BaseAction
   {
       
      
      private var _startPos:Point;
      
      private var _target:Point;
      
      private var _player:GamePlayer;
      
      private var _vp:Point;
      
      private var _start:Point;
      
      private var _life:int = 0;
      
      private var _pickBoxActions:Array;
      
      public function GhostMoveAction(param1:GamePlayer, param2:Point, param3:Array = null)
      {
         super();
         this._target = param2;
         this._player = param1;
         this._startPos = this._player.pos;
         this._pickBoxActions = param3;
         this._vp = this._target.subtract(this._startPos);
         this._vp.normalize(2);
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         _isPrepare = true;
         SoundManager.instance.play("010",true);
         this._player.startMoving();
         this._player.body.doAction(GameCharacter.SOUL_MOVE);
      }
      
      override public function execute() : void
      {
         var _loc1_:PickBoxAction = null;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         this._player.info.direction = this._vp.x > 0 ? int(int(1)) : int(int(-1));
         if(Point.distance(this._startPos,this._target) > this._vp.length)
         {
            if(this._vp.length < Player.GHOST_MOVE_SPEED)
            {
               this._vp.normalize(this._vp.length * 1.1);
            }
            _loc2_ = this._startPos;
            this._startPos = this._startPos.add(this._vp);
            this._player.info.pos = this._startPos;
            _loc3_ = this._startPos;
            if(this._player is GameLocalPlayer)
            {
               (this._player as GameLocalPlayer).localPlayer.energy -= Math.round(Point.distance(_loc2_,_loc3_) / 1.5);
            }
         }
         else
         {
            this._player.info.pos = this._target;
            if(this._player is GameLocalPlayer)
            {
               GameLocalPlayer(this._player).hideTargetMouseTip();
            }
            this.finish();
         }
         this._life += 40;
         for each(_loc1_ in this._pickBoxActions)
         {
            if(this._life >= _loc1_.time && !_loc1_.executed)
            {
               _loc1_.execute(this._player);
            }
         }
      }
      
      public function finish() : void
      {
         this._player.body.doAction(GameCharacter.SOUL);
         this._player.stopMoving();
         _isFinished = true;
      }
      
      override public function executeAtOnce() : void
      {
         this._player.pos = this._target;
         super.executeAtOnce();
      }
   }
}
