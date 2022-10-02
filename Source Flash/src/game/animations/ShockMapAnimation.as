package game.animations
{
   import game.objects.SimpleBomb;
   import game.view.map.MapView;
   import phy.object.PhysicalObj;
   
   public class ShockMapAnimation implements IAnimate
   {
       
      
      private var _bomb:PhysicalObj;
      
      private var _finished:Boolean;
      
      private var _age:Number;
      
      private var _life:Number;
      
      private var _radius:Number;
      
      private var _x:Number;
      
      private var _y:Number;
      
      private var _scale:int;
      
      public function ShockMapAnimation(param1:PhysicalObj, param2:Number = 7, param3:Number = 0)
      {
         var _loc4_:SimpleBomb = null;
         super();
         this._age = 0;
         this._life = param3;
         this._finished = false;
         this._bomb = param1;
         this._radius = param2;
         this._scale = 1;
         if(this._bomb is SimpleBomb)
         {
            _loc4_ = this._bomb as SimpleBomb;
            if(_loc4_.target && _loc4_.owner)
            {
               if(_loc4_.target.x - _loc4_.owner.pos.x < 0)
               {
                  this._scale = -1;
               }
            }
         }
      }
      
      public function get level() : int
      {
         return AnimationLevel.HIGHT;
      }
      
      public function get scale() : int
      {
         return this._scale;
      }
      
      public function canAct() : Boolean
      {
         return !this._finished || this._life > 0;
      }
      
      public function canReplace(param1:IAnimate) : Boolean
      {
         return true;
      }
      
      public function prepare(param1:AnimationSet) : void
      {
      }
      
      public function cancel() : void
      {
         this._finished = true;
         this._life = 0;
      }
      
      public function update(param1:MapView) : Boolean
      {
         --this._life;
         if(!this._finished)
         {
            if(this._age == 0)
            {
               this._x = param1.x;
               this._y = param1.y;
            }
            this._age += 0.25;
            if(this._age < 1.5)
            {
               this._radius = -this._radius;
               param1.x = this._x + this._radius * this.scale;
               param1.y = this._y + this._radius;
            }
            else
            {
               param1.x = this._x;
               param1.y = this._y;
               this._finished = true;
            }
            return true;
         }
         return false;
      }
      
      public function get finish() : Boolean
      {
         return this._finished;
      }
   }
}
