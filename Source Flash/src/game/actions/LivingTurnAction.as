package game.actions
{
   import game.objects.GameLiving;
   
   public class LivingTurnAction extends BaseAction
   {
      
      public static const PLUS:int = 0;
      
      public static const REDUCE:int = 1;
       
      
      private var _movie:GameLiving;
      
      private var _rotation:int;
      
      private var _speed:int;
      
      private var _endPlay:String;
      
      private var _dir:int;
      
      private var _turnRo:int;
      
      private var isVXTGplayer:Boolean = false;
      
      public function LivingTurnAction(param1:GameLiving, param2:int, param3:int, param4:String)
      {
         super();
         _isFinished = false;
         this._movie = param1;
         this._rotation = param2;
         this._speed = param3;
         this._endPlay = param4;
         if(param2 == 0)
         {
            this.isVXTGplayer = true;
         }
      }
      
      override public function connect(param1:BaseAction) : Boolean
      {
         var _loc2_:LivingTurnAction = param1 as LivingTurnAction;
         if(_loc2_)
         {
            this._rotation = _loc2_._rotation;
            this._speed = _loc2_._speed;
            this._endPlay = _loc2_._endPlay;
            this._dir = this._movie.rotation > this._rotation ? int(int(REDUCE)) : int(int(PLUS));
            return true;
         }
         return false;
      }
      
      override public function prepare() : void
      {
         if(this._rotation == 0)
         {
            this._movie.rotation = 0;
         }
         if(this._movie)
         {
            this._dir = this._movie.rotation > this._rotation ? int(int(REDUCE)) : int(int(PLUS));
            this._turnRo = this._movie.rotation;
            if(this._rotation == 0)
            {
               this._movie.rotation = 0;
            }
         }
         else
         {
            _isFinished = true;
         }
      }
      
      override public function execute() : void
      {
         var _loc1_:Boolean = false;
         if(this._rotation == 0)
         {
            _loc1_ = true;
            this._movie.rotation = 0;
         }
         if(this._dir == PLUS)
         {
            if(this._turnRo + this._speed >= this._rotation)
            {
               this.finish();
            }
            else
            {
               this._turnRo += this._speed;
               this._movie.rotation = this._turnRo;
               if(_loc1_)
               {
                  this._movie.rotation = 0;
               }
            }
         }
         else if(this._turnRo - this._speed <= this._rotation)
         {
            this.finish();
         }
         else
         {
            this._turnRo -= this._speed;
            this._movie.rotation = this._turnRo;
            if(_loc1_)
            {
               this._movie.rotation = 0;
            }
         }
      }
      
      private function finish() : void
      {
         this._movie.rotation = this._rotation;
         this._movie.doAction(this._endPlay);
         if(this._rotation == 0)
         {
            this._movie.rotation = 0;
         }
         _isFinished = true;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this._movie.rotation = this._rotation;
         this._movie.doAction(this._endPlay);
      }
   }
}
