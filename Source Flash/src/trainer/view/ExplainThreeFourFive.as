package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class ExplainThreeFourFive extends BaseExplainFrame
   {
       
      
      private var _bmpThree:Bitmap;
      
      private var _bmpFour:Bitmap;
      
      private var _bmpFive:Bitmap;
      
      private var _bmpNameBg1:Bitmap;
      
      private var _bmpNameBg2:Bitmap;
      
      private var _bmpNameBg3:Bitmap;
      
      private var _bmpTxtThree:Bitmap;
      
      private var _bmpTxtFour:Bitmap;
      
      private var _bmpTxtFive:Bitmap;
      
      private var _txtTip:FilterFrameText;
      
      private var _txtPs:FilterFrameText;
      
      public function ExplainThreeFourFive()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc2_:Point = null;
         var _loc1_:Point = null;
         var _loc3_:Point = null;
         _loc2_ = null;
         this._bmpThree = ComponentFactory.Instance.creatBitmap("asset.explain.threeUp");
         addChild(this._bmpThree);
         this._bmpFour = ComponentFactory.Instance.creatBitmap("asset.explain.four");
         addChild(this._bmpFour);
         this._bmpFour = ComponentFactory.Instance.creatBitmap("asset.explain.five");
         addChild(this._bmpFour);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posThreeUpBg");
         this._bmpNameBg1 = ComponentFactory.Instance.creatBitmap("asset.explain.nameBg1");
         this._bmpNameBg1.x = _loc1_.x;
         this._bmpNameBg1.y = _loc1_.y;
         addChild(this._bmpNameBg1);
         _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posFourBg");
         this._bmpNameBg2 = ComponentFactory.Instance.creatBitmap("asset.explain.nameBg1");
         this._bmpNameBg2.x = _loc2_.x;
         this._bmpNameBg2.y = _loc2_.y;
         addChild(this._bmpNameBg2);
         _loc3_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posFiveBg");
         this._bmpNameBg3 = ComponentFactory.Instance.creatBitmap("asset.explain.nameBg1");
         this._bmpNameBg3.x = _loc3_.x;
         this._bmpNameBg3.y = _loc3_.y;
         addChild(this._bmpNameBg3);
         this._bmpTxtThree = ComponentFactory.Instance.creatBitmap("asset.explain.bmpThreeUp");
         addChild(this._bmpTxtThree);
         this._bmpTxtFour = ComponentFactory.Instance.creatBitmap("asset.explain.bmpFour");
         addChild(this._bmpTxtFour);
         this._bmpTxtFive = ComponentFactory.Instance.creatBitmap("asset.explain.bmpFive");
         addChild(this._bmpTxtFive);
         this._txtTip = ComponentFactory.Instance.creat("trainer.explain.txtThreeFourFive");
         this._txtTip.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainThreeFourFive.tip");
         addChild(this._txtTip);
         this._txtPs = ComponentFactory.Instance.creat("trainer.explain.txtPsThreeFourFive");
         this._txtPs.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainThreeFourFive.ps");
         addChild(this._txtPs);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bmpThree = null;
         this._bmpFour = null;
         this._bmpFive = null;
         this._bmpNameBg1 = null;
         this._bmpNameBg2 = null;
         this._bmpNameBg3 = null;
         this._bmpTxtThree = null;
         this._bmpTxtFour = null;
         this._bmpTxtFive = null;
         this._txtTip = null;
         this._txtPs = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
