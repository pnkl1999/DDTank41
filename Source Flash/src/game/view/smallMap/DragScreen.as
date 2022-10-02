package game.view.smallMap
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class DragScreen extends Sprite
   {
       
      
      private var _w:int = 60;
      
      private var _h:int = 60;
      
      public function DragScreen(param1:int, param2:int)
      {
         super();
         this._w = param1 < 1 ? int(int(1)) : int(int(param1));
         this._h = param2 < 1 ? int(int(1)) : int(int(param2));
         buttonMode = true;
         this.drawBackground();
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,10066329);
         _loc1_.beginFill(16777215,0.4);
         _loc1_.drawRect(0,0,this._w,this._h);
         _loc1_.endFill();
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._w != param1)
         {
            this._w = param1 < 1 ? int(int(1)) : int(int(param1));
            this.drawBackground();
         }
      }
      
      override public function set height(param1:Number) : void
      {
         if(this._h != param1)
         {
            this._h = param1 < 1 ? int(int(1)) : int(int(param1));
            this.drawBackground();
         }
      }
      
      public function dispose() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
