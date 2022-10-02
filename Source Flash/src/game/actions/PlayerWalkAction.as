package game.actions
{
   import ddt.manager.SoundManager;
   import ddt.view.character.GameCharacter;
   import flash.geom.Point;
   import game.GameManager;
   import game.animations.AnimationLevel;
   import game.model.LocalPlayer;
   import game.objects.GameLiving;
   import game.objects.GamePlayer;
   
   public class PlayerWalkAction extends BaseAction
   {
       
      
      private var _living:GameLiving;
      
      private var _action:*;
      
      private var _target:Point;
      
      private var _dir:Number;
      
      private var _self:LocalPlayer;
      
      public function PlayerWalkAction(param1:GameLiving, param2:Point, param3:Number, param4:* = null)
      {
         super();
         _isFinished = false;
         this._self = GameManager.Instance.Current.selfGamePlayer;
         this._living = param1;
         this._action = !!Boolean(param4) ? param4 : GameCharacter.WALK;
         this._target = param2;
         this._dir = param3;
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         var _loc2_:PlayerWalkAction = param1 as PlayerWalkAction;
         if(_loc2_)
         {
            this._target = _loc2_._target;
            this._dir = _loc2_._dir;
            return true;
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
         if(this._living.isLiving)
         {
            this._living.startMoving();
         }
         else
         {
            this.finish();
         }
      }
      
      override public function execute() : void
      {
         var _loc1_:Point = null;
         if(Point.distance(this._living.pos,this._target) <= this._living.stepX || this._target.x == this._living.x)
         {
            this.finish();
         }
         else if(this._living.info)
         {
            this._living.info.direction = this._dir;
            _loc1_ = this._living.getNextWalkPoint(this._living.info.direction);
            if(_loc1_ == null || this._living.info.direction > 0 && _loc1_.x >= this._target.x || this._living.info.direction < 0 && _loc1_.x <= this._target.x)
            {
               this.finish();
            }
            else
            {
               this._living.info.pos = _loc1_;
               this._living.doAction(this._action);
               if(this._living is GamePlayer)
               {
                  GamePlayer(this._living).body.WingState = GameCharacter.GAME_WING_MOVE;
               }
               SoundManager.instance.play("044",false,false);
               if(!this._living.info.isHidden)
               {
                  this._living.needFocus(0,0,{
                     "strategy":"directly",
                     "priority":AnimationLevel.MIDDLE
                  });
               }
            }
         }
      }
      
      private function finish() : void
      {
         this._living.info.pos = this._target;
         this._living.info.direction = this._dir;
         this._living.stopMoving();
         this._living.doAction(GameCharacter.STAND);
         _isFinished = true;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this._living.info.pos = this._target;
         this._living.info.direction = this._dir;
         this._living.stopMoving();
      }
   }
}
