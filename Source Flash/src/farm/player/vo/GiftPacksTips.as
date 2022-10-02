package farm.player.vo
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class GiftPacksTips extends Sprite
   {
       
      
      private var _btnBg:Bitmap;
      
      private var _tipMovie:MovieClip;
      
      public function GiftPacksTips()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this.buttonMode = true;
         this._btnBg = ComponentFactory.Instance.creatBitmap("asset.farm.midautumnpacks");
         addChild(this._btnBg);
         this._tipMovie = ComponentFactory.Instance.creat("asset.farm.midautumnanimation");
         PositionUtils.setPos(this._tipMovie,"farm.midautumnanimation");
         addChild(this._tipMovie);
      }
      
      public function dispose() : void
      {
         if(this._btnBg)
         {
            this._btnBg.bitmapData.dispose();
            this._btnBg = null;
         }
      }
   }
}
