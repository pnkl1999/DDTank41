package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   
   public class ExplainTen extends BaseExplainFrame
   {
       
      
      private var _bmpTen:Bitmap;
      
      private var _bmpNameBg:Bitmap;
      
      private var _bmpTxtTen:Bitmap;
      
      private var _txt:FilterFrameText;
      
      public function ExplainTen()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bmpTen = ComponentFactory.Instance.creatBitmap("asset.explain.ten");
         addChild(this._bmpTen);
         this._bmpNameBg = ComponentFactory.Instance.creatBitmap("asset.explain.nameBg");
         addChild(this._bmpNameBg);
         this._bmpTxtTen = ComponentFactory.Instance.creatBitmap("asset.explain.txtTen");
         addChild(this._bmpTxtTen);
         this._txt = ComponentFactory.Instance.creat("trainer.explain.txtTenExplain");
         this._txt.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainTen.explain");
         addChild(this._txt);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bmpTen = null;
         this._bmpNameBg = null;
         this._bmpTxtTen = null;
         this._txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
