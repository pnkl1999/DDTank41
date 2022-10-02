package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.QualityType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class BadgeTip extends Sprite implements ITip, Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _line1:Image;
      
      private var _line2:Image;
      
      private var _nameTxt:FilterFrameText;
      
      private var _desTxt:FilterFrameText;
      
      private var _validDateTxt:FilterFrameText;
      
      private var _tipdata:Object;
      
      public function BadgeTip()
      {
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.BadgeTipBg");
         addChild(this._bg);
         this._line1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._line2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         PositionUtils.setPos(this._line1,"asset.core.badgeTipLinePos1");
         PositionUtils.setPos(this._line2,"asset.core.badgeTipLinePos2");
         this._line2.width = 154;
         this._line1.width = 154;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.badgeTipNameTxt");
         this._desTxt = ComponentFactory.Instance.creatComponentByStylename("core.badgeTip.DescriptionTxt");
         this._validDateTxt = ComponentFactory.Instance.creatComponentByStylename("core.badgeTipItemDateTxt");
         addChild(this._line1);
         addChild(this._line2);
         addChild(this._nameTxt);
         addChild(this._desTxt);
         addChild(this._validDateTxt);
      }
      
      public function get tipData() : Object
      {
         return this._tipdata;
      }
      
      public function set tipData(param1:Object) : void
      {
         var _loc2_:Date = null;
         var _loc3_:Number = NaN;
         this._tipdata = param1;
         this._nameTxt.text = this._tipdata.name;
         this._nameTxt.textColor = QualityType.QUALITY_COLOR[4];
         this._desTxt.text = LanguageMgr.GetTranslation("core.badgeTip.description",this._tipdata.LimitLevel);
         if(this._tipdata.ValidDate)
         {
            this._validDateTxt.visible = true;
            this._line2.visible = true;
            this._bg.height = 135;
            if(this._tipdata.buyDate)
            {
               _loc2_ = this._tipdata.buyDate;
               _loc3_ = _loc2_.time + this._tipdata.ValidDate * 24 * 60 * 60 * 1000 - TimeManager.Instance.Now().time;
               this._validDateTxt.text = LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.validity") + Math.ceil(_loc3_ / TimeManager.DAY_TICKS).toString() + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
            }
            else
            {
               this._validDateTxt.text = LanguageMgr.GetTranslation("ddt.consortion.skillTip.validity",this._tipdata.ValidDate + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day"));
            }
         }
         else
         {
            this._bg.height = 90;
            this._line2.visible = false;
            this._validDateTxt.visible = false;
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._line1);
         this._line1 = null;
         ObjectUtils.disposeObject(this._line2);
         this._line2 = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._desTxt);
         this._desTxt = null;
         ObjectUtils.disposeObject(this._validDateTxt);
         this._validDateTxt = null;
         this._tipdata = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
