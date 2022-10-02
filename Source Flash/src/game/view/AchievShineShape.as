package game.view
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   
   public class AchievShineShape extends Shape
   {
       
      
      private var _color:int = 0;
      
      private var _radius:int;
      
      private var _alphas:Array;
      
      private var _ratios:Array;
      
      public function AchievShineShape()
      {
         super();
      }
      
      public function setColor(param1:int) : void
      {
         this._color = param1;
         this.draw();
      }
      
      private function draw() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         _loc1_.beginGradientFill(GradientType.RADIAL,[this._color,this._color],this._alphas,this._ratios);
         _loc1_.drawCircle(0,0,this._radius);
         _loc1_.endFill();
      }
      
      public function set radius(param1:int) : void
      {
         this._radius = param1;
         this.draw();
      }
      
      public function set alphas(param1:String) : void
      {
         this._alphas = param1.split(",");
         this.draw();
      }
      
      public function set ratios(param1:String) : void
      {
         this._ratios = param1.split(",");
         this.draw();
      }
   }
}
