package game.view.smallMap
{
   import flash.display.Graphics;
   import phy.object.SmallObject;
   
   public class SmallBox extends SmallObject
   {
       
      
      private var _movieTime:Number = 0.8;
      
      public function SmallBox()
      {
         super();
         _radius = 3;
         _color = 16777215;
      }
      
      override public function onFrame(param1:int) : void
      {
         _elapsed += param1;
         if(_elapsed >= this._movieTime * 1000)
         {
            _elapsed = 0;
         }
         this.draw();
      }
      
      override protected function draw() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         var _loc2_:Number = _elapsed / (this._movieTime * 1000);
         _loc1_.beginFill(_color,_loc2_);
         _loc1_.drawCircle(0,0,_radius);
         _loc1_.endFill();
      }
   }
}
