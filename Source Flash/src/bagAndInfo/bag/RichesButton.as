package bagAndInfo.bag
{
   import com.pickgliss.ui.core.TransformableComponent;
   import flash.display.Graphics;
   
   public class RichesButton extends TransformableComponent
   {
       
      
      public function RichesButton()
      {
         super();
      }
      
      override public function draw() : void
      {
         this.drawBackground();
         super.draw();
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         _loc1_.beginFill(16777215,0);
         _loc1_.drawRect(0,0,_width <= 0 ? Number(Number(1)) : Number(Number(_width)),_height <= 0 ? Number(Number(1)) : Number(Number(_height)));
         _loc1_.endFill();
      }
   }
}
