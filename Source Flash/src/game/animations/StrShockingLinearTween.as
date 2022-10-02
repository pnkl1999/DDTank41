package game.animations
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class StrShockingLinearTween extends StrLinearTween
   {
       
      
      protected var shockingX:int;
      
      protected var shockingY:int;
      
      protected var shockingFreq:uint = 1;
      
      protected var life:uint;
      
      public function StrShockingLinearTween(param1:TweenObject = null)
      {
         super(param1);
         this.life = 0;
      }
      
      override public function get type() : String
      {
         return "StrShockingLinearTween";
      }
      
      override public function copyPropertyFromData(param1:TweenObject) : void
      {
         this.shockingX = param1.shockingX;
         this.shockingY = param1.shockingY;
         duration = param1.duration;
         target = param1.target;
         speed = param1.speed;
      }
      
      override public function update(param1:DisplayObject) : Point
      {
         var _loc2_:Point = super.update(param1);
         if(!_loc2_)
         {
            return null;
         }
         if(this.life == duration)
         {
            _isFinished = true;
            return _loc2_;
         }
         if(this.life == 0)
         {
            _loc2_.x += this.shockingX;
            this.shockingX = -this.shockingX;
            _loc2_.y += this.shockingY;
            this.shockingY = -this.shockingY;
         }
         ++this.life;
         if(this.life % this.shockingFreq == 0)
         {
            _loc2_.x += this.shockingX * 2;
            this.shockingX = -this.shockingX;
            _loc2_.y += this.shockingY * 2;
            this.shockingY = -this.shockingY;
         }
         return _loc2_;
      }
      
      override protected function get propertysNeed() : Array
      {
         return ["target","speed","shockingX","shockingY","shockingFreq"];
      }
   }
}
