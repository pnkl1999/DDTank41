package game.view.arrow
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ArrowBg extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      public var arrowSub:ArrowSub;
      
      private var _ruling:Bitmap;
      
      public function ArrowBg()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.angle.back");
         addChild(this._bg);
         this.arrowSub = ComponentFactory.Instance.creatCustomObject("asset.game.arrowSub") as ArrowSub;
         addChild(this.arrowSub);
         this._ruling = ComponentFactory.Instance.creatBitmap("asset.game.angle.dail");
         addChild(this._ruling);
      }
      
      public function dispose() : void
      {
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         this.arrowSub.dispose();
         this.arrowSub = null;
         removeChild(this._ruling);
         this._ruling.bitmapData.dispose();
         this._ruling = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
