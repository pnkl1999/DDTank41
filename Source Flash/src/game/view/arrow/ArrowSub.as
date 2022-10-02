package game.view.arrow
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ArrowSub extends Sprite implements Disposeable
   {
       
      
      private var _center:Bitmap;
      
      public var arrowChonghe_mc:Bitmap;
      
      public var arrow:Bitmap;
      
      public var arrowClone_mc:Bitmap;
      
      private var _halfRound:Bitmap;
      
      public var green_mc:Bitmap;
      
      public var circle_mc:Bitmap;
      
      public function ArrowSub()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this.circle_mc = ComponentFactory.Instance.creatBitmap("asset.game.circleAsset");
         addChild(this.circle_mc);
         this.green_mc = ComponentFactory.Instance.creatBitmap("asset.game.greenAsset");
         addChild(this.green_mc);
         this._halfRound = ComponentFactory.Instance.creatBitmap("asset.game.angle.halfround");
         addChild(this._halfRound);
         this.arrowClone_mc = ComponentFactory.Instance.creatBitmap("asset.game.arrowCloneAsset");
         addChild(this.arrowClone_mc);
         this.arrow = ComponentFactory.Instance.creatBitmap("asset.game.handAsset");
         addChild(this.arrow);
         this.arrowChonghe_mc = ComponentFactory.Instance.creatBitmap("asset.game.chonghexianAsset");
         addChild(this.arrowChonghe_mc);
         this._center = ComponentFactory.Instance.creatBitmap("asset.game.arrowCenterAsset");
         addChild(this._center);
      }
      
      public function dispose() : void
      {
         removeChild(this.circle_mc);
         this.circle_mc.bitmapData.dispose();
         this.circle_mc = null;
         removeChild(this.green_mc);
         this.green_mc.bitmapData.dispose();
         this.green_mc = null;
         removeChild(this._halfRound);
         this._halfRound.bitmapData.dispose();
         this._halfRound = null;
         removeChild(this.arrowClone_mc);
         this.arrowClone_mc.bitmapData.dispose();
         this.arrowClone_mc = null;
         removeChild(this.arrow);
         this.arrow.bitmapData.dispose();
         this.arrow = null;
         removeChild(this.arrowChonghe_mc);
         this.arrowChonghe_mc.bitmapData.dispose();
         this.arrowChonghe_mc = null;
         removeChild(this._center);
         this._center.bitmapData.dispose();
         this._center = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
