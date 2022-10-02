package game.view.playerThumbnail
{
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class ThumbnailTip extends Sprite
   {
       
      
      public function ThumbnailTip()
      {
         super();
      }
      
      public function show() : void
      {
         var _loc1_:Point = null;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         if(stage && parent)
         {
            _loc1_ = parent.globalToLocal(new Point(stage.mouseX,stage.mouseY));
            this.x = _loc1_.x + 15;
            this.y = _loc1_.y + 15;
            if(x + 182 > 1000)
            {
               this.x = x - 182;
            }
            if(y + 234 > 600)
            {
               y = 600 - 234;
            }
         }
      }
   }
}
