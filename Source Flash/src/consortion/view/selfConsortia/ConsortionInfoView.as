package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.FilterFrameTextWithTips;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import road7th.utils.StringHelper;
   import vip.VipController;
   
   public class ConsortionInfoView extends Sprite implements Disposeable
   {
       
      
      private var _badgeBtn:BuyBadgeButton;
      
      private var _shopIcon:BuildingLevelItem;
      
      private var _storeIcon:BuildingLevelItem;
      
      private var _bankIcon:BuildingLevelItem;
      
      private var _skillIcon:BuildingLevelItem;
      
      private var _infoWordBG:MutipleImage;
      
      private var _level:ScaleFrameImage;
      
      private var _consortionName:FilterFrameText;
      
      private var _chairmanName:FilterFrameText;
      
      private var _vipChairman:GradientText;
      
      private var _count:FilterFrameText;
      
      private var _riches:FilterFrameText;
      
      private var _honor:FilterFrameText;
      
      private var _repute:FilterFrameText;
      
      private var _weekPay:FilterFrameTextWithTips;
      
      private var _consortiaInfo:ConsortiaInfo;
      
      public function ConsortionInfoView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._badgeBtn = new BuyBadgeButton();
         PositionUtils.setPos(this._badgeBtn,"consortiaBadgeBtn.pos");
         this._shopIcon = new BuildingLevelItem(ConsortionModel.SHOP);
         PositionUtils.setPos(this._shopIcon,"shopIcon.pos");
         this._storeIcon = new BuildingLevelItem(ConsortionModel.STORE);
         PositionUtils.setPos(this._storeIcon,"storeIcon.pos");
         this._bankIcon = new BuildingLevelItem(ConsortionModel.BANK);
         PositionUtils.setPos(this._bankIcon,"bankIcon.pos");
         this._skillIcon = new BuildingLevelItem(ConsortionModel.SKILL);
         PositionUtils.setPos(this._skillIcon,"skillIcon.pos");
         this._infoWordBG = ComponentFactory.Instance.creatComponentByStylename("consortion.wordBG");
         this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.level");
         this._consortionName = ComponentFactory.Instance.creatComponentByStylename("consortion.name");
         this._chairmanName = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanName");
         this._count = ComponentFactory.Instance.creatComponentByStylename("consortion.count");
         this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.riches");
         this._honor = ComponentFactory.Instance.creatComponentByStylename("consortion.offer");
         this._repute = ComponentFactory.Instance.creatComponentByStylename("consortion.repute");
         this._weekPay = ComponentFactory.Instance.creatComponentByStylename("consortion.weekPay");
         this._weekPay.mouseEnabled = true;
         this._weekPay.selectable = false;
         addChild(this._badgeBtn);
         addChild(this._shopIcon);
         addChild(this._storeIcon);
         addChild(this._bankIcon);
         addChild(this._skillIcon);
         addChild(this._infoWordBG);
         addChild(this._level);
         addChild(this._consortionName);
         addChild(this._count);
         addChild(this._riches);
         addChild(this._honor);
         addChild(this._repute);
         addChild(this._weekPay);
         this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
         PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__consortiaInfoPropChange);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.LEVEL_UP_RULE_CHANGE,this._levelUpRuleChange);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
         PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__consortiaInfoPropChange);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.LEVEL_UP_RULE_CHANGE,this._levelUpRuleChange);
      }
      
      private function _levelUpRuleChange(param1:ConsortionEvent) : void
      {
         this.setWeekyPay();
      }
      
      private function _consortiaInfoChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["consortiaInfo"])
         {
            this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
         }
      }
      
      private function __consortiaInfoPropChange(param1:PlayerPropertyEvent) : void
      {
         this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
      }
      
      private function setWeekyPay() : void
      {
         if(this._consortiaInfo && this._consortiaInfo.Level != 0 && ConsortionModelControl.Instance.model.levelUpData != null)
         {
            this._weekPay.text = String(ConsortionModelControl.Instance.model.getLevelData(this._consortiaInfo.Level).Deduct);
            if(this._weekPay.text != "")
            {
               this._weekPay.mouseEnabled = true;
            }
            else
            {
               this._weekPay.mouseEnabled = false;
            }
            this._weekPay.tipData = StringHelper.parseTime(this._consortiaInfo.DeductDate,7);
         }
      }
      
      private function set consortionInfo(param1:ConsortiaInfo) : void
      {
         var _loc2_:TextFormat = null;
         this._consortiaInfo = param1;
         if(param1.ConsortiaID != 0)
         {
            this._shopIcon.mouseChildren = this._shopIcon.mouseEnabled = this._storeIcon.mouseChildren = this._storeIcon.mouseEnabled = this._bankIcon.mouseChildren = this._bankIcon.mouseEnabled = this._skillIcon.mouseChildren = this._skillIcon.mouseEnabled = true;
            this._shopIcon.tipData = param1.ShopLevel;
            this._storeIcon.tipData = param1.SmithLevel;
            this._bankIcon.tipData = param1.StoreLevel;
            this._skillIcon.tipData = param1.BufferLevel;
            this._level.setFrame(param1.Level);
            this._consortionName.text = param1.ConsortiaName;
            if(param1.ChairmanIsVIP)
            {
               ObjectUtils.disposeObject(this._vipChairman);
               this._vipChairman = VipController.instance.getVipNameTxt(142,param1.ChairmanTypeVIP);
               _loc2_ = new TextFormat();
               _loc2_.align = "center";
               _loc2_.bold = true;
               this._vipChairman.textField.defaultTextFormat = _loc2_;
               this._vipChairman.textSize = 18;
               this._vipChairman.x = this._chairmanName.x;
               this._vipChairman.y = this._chairmanName.y;
               this._vipChairman.text = param1.ChairmanName;
               addChild(this._vipChairman);
               DisplayUtils.removeDisplay(this._chairmanName);
            }
            else
            {
               this._chairmanName.text = param1.ChairmanName;
               addChild(this._chairmanName);
               DisplayUtils.removeDisplay(this._vipChairman);
            }
            this._count.text = String(param1.Count);
            this._riches.text = String(param1.Riches);
            this._honor.text = String(param1.Honor);
            this._repute.text = String(param1.Repute);
            this._badgeBtn.badgeID = param1.BadgeID;
            this.setWeekyPay();
         }
         else
         {
            this._weekPay.mouseEnabled = false;
            this._shopIcon.mouseChildren = this._shopIcon.mouseEnabled = this._storeIcon.mouseChildren = this._storeIcon.mouseEnabled = this._bankIcon.mouseChildren = this._bankIcon.mouseEnabled = this._skillIcon.mouseChildren = this._skillIcon.mouseEnabled = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._badgeBtn.dispose();
         this._badgeBtn = null;
         ObjectUtils.disposeAllChildren(this);
         this._shopIcon = null;
         this._storeIcon = null;
         this._bankIcon = null;
         this._skillIcon = null;
         this._infoWordBG = null;
         this._level = null;
         this._consortionName = null;
         this._chairmanName = null;
         this._vipChairman = null;
         this._count = null;
         this._riches = null;
         this._honor = null;
         this._repute = null;
         this._weekPay = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
