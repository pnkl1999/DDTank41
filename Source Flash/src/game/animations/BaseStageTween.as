package game.animations
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class BaseStageTween implements IStageTween
   {
       
      
      protected var _target:Point;
      
      protected var _prepared:Boolean = false;
      
      protected var _isFinished:Boolean;
      
      public function BaseStageTween(param1:TweenObject = null)
      {
         super();
         this._isFinished = false;
         if(param1)
         {
            this.initData(param1);
         }
      }
      
      public function get type() : String
      {
         return "BaseStageTween";
      }
      
      public function initData(param1:TweenObject) : void
      {
         if(!param1)
         {
            return;
         }
         this.copyPropertyFromData(param1);
         this._prepared = true;
      }
      
      public function update(param1:DisplayObject) : Point
      {
         return null;
      }
      
      public function set target(param1:Point) : void
      {
         this._target = param1;
         this._prepared = true;
      }
      
      public function get target() : Point
      {
         return this._target;
      }
      
      public function copyPropertyFromData(param1:TweenObject) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.propertysNeed)
         {
            if(param1[_loc2_])
            {
               this[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      protected function get propertysNeed() : Array
      {
         return ["target"];
      }
      
      public function get isFinished() : Boolean
      {
         return this._isFinished;
      }
   }
}
