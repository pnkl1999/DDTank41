package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   
   public class ExplainPlane extends BaseExplainFrame
   {
       
      
      private var _bmpPlane:Bitmap;
      
      private var _bmpNameBg:Bitmap;
      
      private var _bmpTxtPlane:Bitmap;
      
      private var _txt:FilterFrameText;
      
      public function ExplainPlane()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bmpPlane = ComponentFactory.Instance.creatBitmap("asset.explain.plane");
         addChild(this._bmpPlane);
         this._bmpNameBg = ComponentFactory.Instance.creatBitmap("asset.explain.nameBg");
         addChild(this._bmpNameBg);
         this._bmpTxtPlane = ComponentFactory.Instance.creatBitmap("asset.explain.bmpPlane");
         addChild(this._bmpTxtPlane);
         this._txt = ComponentFactory.Instance.creat("trainer.explain.txtPlane");
         this._txt.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainPlane.explain");
         addChild(this._txt);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bmpPlane = null;
         this._bmpNameBg = null;
         this._bmpTxtPlane = null;
         this._txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
