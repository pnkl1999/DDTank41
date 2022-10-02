package game.actions
{
   import game.objects.GameLiving;
   import road.game.resource.ActionMovie;
   
   public class ChangeDirectionAction extends BaseAction
   {
       
      
      private var _living:GameLiving;
      
      private var _dir:int;
      
      private var _direction:String;
      
      public function ChangeDirectionAction(param1:GameLiving, param2:int)
      {
         super();
         this._living = param1;
         this._dir = param2;
         if(this._dir > 0)
         {
            this._direction = ActionMovie.RIGHT;
         }
         else
         {
            this._direction = ActionMovie.LEFT;
         }
      }
      
      override public function canReplace(param1:BaseAction) : Boolean
      {
         var _loc2_:ChangeDirectionAction = param1 as ChangeDirectionAction;
         if(_loc2_ && this._dir == _loc2_.dir)
         {
            return true;
         }
         return false;
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         var _loc2_:ChangeDirectionAction = param1 as ChangeDirectionAction;
         if(_loc2_ && this._dir == _loc2_.dir)
         {
            return true;
         }
         return false;
      }
      
      public function get dir() : int
      {
         return this._dir;
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         _isPrepare = true;
         if(!this._living.isLiving)
         {
            _isFinished = true;
         }
      }
      
      override public function execute() : void
      {
         this._living.actionMovie.direction = this._direction;
         _isFinished = true;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this._living.actionMovie.direction = this._direction;
      }
   }
}
