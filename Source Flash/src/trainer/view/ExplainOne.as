package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   
   public class ExplainOne extends BaseExplainFrame
   {
       
      
      private var _bmpOne:Bitmap;
      
      private var _bmpNameBg:Bitmap;
      
      private var _bmpTxtOne:Bitmap;
      
      private var _txt:FilterFrameText;
      
      public function ExplainOne()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bmpOne = ComponentFactory.Instance.creatBitmap("asset.explain.one");
         addChild(this._bmpOne);
         this._bmpNameBg = ComponentFactory.Instance.creatBitmap("asset.explain.nameBg");
         addChild(this._bmpNameBg);
         this._bmpTxtOne = ComponentFactory.Instance.creatBitmap("asset.explain.txtOne");
         addChild(this._bmpTxtOne);
         this._txt = ComponentFactory.Instance.creat("trainer.explain.txtOneExplain");
         this._txt.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainOne.explain");
         addChild(this._txt);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,LayerManager.NONE_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bmpOne = null;
         this._bmpNameBg = null;
         this._bmpTxtOne = null;
         this._txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
