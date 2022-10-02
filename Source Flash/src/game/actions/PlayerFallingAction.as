package game.actions
{
   import flash.geom.Point;
   import game.GameManager;
   import game.animations.AnimationLevel;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.objects.GameLiving;
   
   public class PlayerFallingAction extends BaseAction
   {
       
      
      protected var _player:GameLiving;
      
      private var _info:Living;
      
      private var _target:Point;
      
      private var _isLiving:Boolean;
      
      private var _canIgnore:Boolean;
      
      private var _self:LocalPlayer;
      
      public function PlayerFallingAction(param1:GameLiving, param2:Point, param3:Boolean, param4:Boolean)
      {
         super();
         this._target = param2;
         this._isLiving = param3;
         if(!this._isLiving)
         {
            this._target.y += 70;
         }
         this._info = param1.info;
         this._player = param1;
         this._self = GameManager.Instance.Current.selfGamePlayer;
         this._canIgnore = param4;
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         var _loc2_:PlayerFallingAction = param1 as PlayerFallingAction;
         if(_loc2_ && _loc2_._target.y < this._target.y)
         {
            return true;
         }
         return false;
      }
      
      override public function canReplace(param1:BaseAction) : Boolean
      {
         if(param1 is PlayerWalkAction)
         {
            if(this._canIgnore)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         _isPrepare = true;
         if(this._player.isLiving)
         {
            if(this._player.x == this._target.x || !this._canIgnore)
            {
               this._player.startMoving();
               this._player.info.isFalling = true;
            }
            else
            {
               this.finish();
            }
         }
         else
         {
            this.finish();
         }
      }
      
      override public function execute() : void
      {
         if(this._target.y - this._info.pos.y <= Player.FALL_SPEED)
         {
            this.executeAtOnce();
         }
         else
         {
            this._info.pos = new Point(this._target.x,this._info.pos.y + Player.FALL_SPEED);
            this._player.needFocus(0,0,{
               "strategy":"directly",
               "priority":AnimationLevel.LOW
            });
         }
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this._info.pos = this._target;
         this._player.map.setCenter(this._info.pos.x,this._info.pos.y - 150,false);
         if(!this._isLiving)
         {
            this._info.die();
         }
         this.finish();
      }
      
      private function finish() : void
      {
         _isFinished = true;
         this._player.stopMoving();
         this._player.info.isFalling = false;
      }
   }
}
