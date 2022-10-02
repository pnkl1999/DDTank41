package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class ExplainTwoTwenty extends BaseExplainFrame
   {
       
      
      private var _bmpLine:Bitmap;
      
      private var _bmpTwo:Bitmap;
      
      private var _bmpTwenty:Bitmap;
      
      private var _bmpNameBgTwo:Bitmap;
      
      private var _bmpNameBgTwenty:Bitmap;
      
      private var _bmpTxtTwo:Bitmap;
      
      private var _bmpTxtTwenty:Bitmap;
      
      private var _txtTwo:FilterFrameText;
      
      private var _txtTwenty:FilterFrameText;
      
      private var _txtPs:FilterFrameText;
      
      public function ExplainTwoTwenty()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc2_:Point = null;
         var _loc1_:Point = null;
         _loc2_ = null;
         this._bmpLine = ComponentFactory.Instance.creatBitmap("asset.explain.line");
         addChild(this._bmpLine);
         this._bmpTwo = ComponentFactory.Instance.creatBitmap("asset.explain.two");
         addChild(this._bmpTwo);
         this._bmpTwenty = ComponentFactory.Instance.creatBitmap("asset.explain.twenty");
         addChild(this._bmpTwenty);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posThreeBg");
         this._bmpNameBgTwo = ComponentFactory.Instance.creatBitmap("asset.explain.nameBgSmall");
         this._bmpNameBgTwo.x = _loc1_.x;
         this._bmpNameBgTwo.y = _loc1_.y;
         addChild(this._bmpNameBgTwo);
         _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posPowerBg");
         this._bmpNameBgTwenty = ComponentFactory.Instance.creatBitmap("asset.explain.nameBgSmall");
         this._bmpNameBgTwenty.x = _loc2_.x;
         this._bmpNameBgTwenty.y = _loc2_.y;
         addChild(this._bmpNameBgTwenty);
         this._bmpTxtTwo = ComponentFactory.Instance.creatBitmap("asset.explain.bmpTwo");
         addChild(this._bmpTxtTwo);
         this._bmpTxtTwenty = ComponentFactory.Instance.creatBitmap("asset.explain.bmpTwenty");
         addChild(this._bmpTxtTwenty);
         this._txtTwo = ComponentFactory.Instance.creat("trainer.explain.txtThree");
         this._txtTwo.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainTwoTwenty.two");
         addChild(this._txtTwo);
         this._txtTwenty = ComponentFactory.Instance.creat("trainer.explain.txtPower");
         this._txtTwenty.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainTwoTwenty.twenty");
         addChild(this._txtTwenty);
         this._txtPs = ComponentFactory.Instance.creat("trainer.explain.txtPsPowerThree");
         this._txtPs.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainTwoTwenty.ps");
         addChild(this._txtPs);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bmpLine = null;
         this._bmpTwo = null;
         this._bmpTwenty = null;
         this._bmpNameBgTwo = null;
         this._bmpNameBgTwenty = null;
         this._bmpTxtTwo = null;
         this._bmpTxtTwenty = null;
         this._txtTwo = null;
         this._txtTwenty = null;
         this._txtPs = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
