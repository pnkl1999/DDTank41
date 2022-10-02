package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class TipColorBlock extends Sprite
   {
       
      
      private var sp:Sprite;
      
      private var colorBoard:Bitmap;
      
      public function TipColorBlock(param1:uint)
      {
         super();
         addChild(ComponentFactory.Instance.creat("asset.core.tip.color"));
         this.colorBoard = ComponentFactory.Instance.creat("asset.core.tip.ColorPiece");
         addChild(this.colorBoard);
         this.sp = new Sprite();
         this.sp.graphics.clear();
         this.sp.graphics.beginFill(param1,1);
         this.sp.graphics.drawRect(0,0,14,14);
         this.sp.graphics.endFill();
         this.sp.x = this.colorBoard.x + 1;
         this.sp.y = this.colorBoard.y + 1;
         addChild(this.sp);
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function dispose() : void
      {
         if(parent)
         {
            removeChild(this.sp);
            removeChild(this.colorBoard);
            this.sp = null;
            this.colorBoard = null;
            parent.removeChild(this);
         }
      }
   }
}
