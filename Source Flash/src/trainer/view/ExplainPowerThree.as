package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class ExplainPowerThree extends BaseExplainFrame
   {
       
      
      private var _bmpLine:Bitmap;
      
      private var _bmpThree:Bitmap;
      
      private var _bmpPower:Bitmap;
      
      private var _bmpNameBgThree:Bitmap;
      
      private var _bmpNameBgPower:Bitmap;
      
      private var _bmpTxtThere:Bitmap;
      
      private var _bmpTxtPower:Bitmap;
      
      private var _txtThree:FilterFrameText;
      
      private var _txtPower:FilterFrameText;
      
      private var _txtPs:FilterFrameText;
      
      public function ExplainPowerThree()
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
         this._bmpThree = ComponentFactory.Instance.creatBitmap("asset.explain.three");
         addChild(this._bmpThree);
         this._bmpPower = ComponentFactory.Instance.creatBitmap("asset.explain.power");
         addChild(this._bmpPower);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posThreeBg");
         this._bmpNameBgThree = ComponentFactory.Instance.creatBitmap("asset.explain.nameBgSmall");
         this._bmpNameBgThree.x = _loc1_.x;
         this._bmpNameBgThree.y = _loc1_.y;
         addChild(this._bmpNameBgThree);
         _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posPowerBg");
         this._bmpNameBgPower = ComponentFactory.Instance.creatBitmap("asset.explain.nameBgSmall");
         this._bmpNameBgPower.x = _loc2_.x;
         this._bmpNameBgPower.y = _loc2_.y;
         addChild(this._bmpNameBgPower);
         this._bmpTxtThere = ComponentFactory.Instance.creatBitmap("asset.explain.bmpThree");
         addChild(this._bmpTxtThere);
         this._bmpTxtPower = ComponentFactory.Instance.creatBitmap("asset.explain.bmpPower");
         addChild(this._bmpTxtPower);
         this._txtThree = ComponentFactory.Instance.creat("trainer.explain.txtThree");
         this._txtThree.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainPowerThree.three");
         addChild(this._txtThree);
         this._txtPower = ComponentFactory.Instance.creat("trainer.explain.txtPower");
         this._txtPower.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainPowerThree.power");
         addChild(this._txtPower);
         this._txtPs = ComponentFactory.Instance.creat("trainer.explain.txtPsPowerThree");
         this._txtPs.text = LanguageMgr.GetTranslation("ddt.trainer.view.ExplainPowerThree.ps");
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
         this._bmpThree = null;
         this._bmpPower = null;
         this._bmpNameBgThree = null;
         this._bmpNameBgPower = null;
         this._bmpTxtThere = null;
         this._bmpTxtPower = null;
         this._txtThree = null;
         this._txtPower = null;
         this._txtPs = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
