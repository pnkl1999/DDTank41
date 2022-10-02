package vip.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.AwardsViewII;
   import ddt.view.bossbox.VipInfoTipBox;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import vip.VipController;
   
   public class GiveYourselfOpenView extends Sprite implements Disposeable
   {
      
      public static var ONE_MONTH_PAY:int = ShopManager.Instance.getMoneyShopItemByTemplateID(11992).getItemPrice(1).moneyValue;
      
      public static var ONE_YEAR_PAY:int = ShopManager.Instance.getMoneyShopItemByTemplateID(11992).getItemPrice(3).moneyValue;
      
      public static var millisecondsPerDay:int = 1000 * 60 * 60 * 24;
       
      
      private const VIP_LEVEL1:String = "112112";
      
      private const VIP_LEVEL2:String = "112113";
      
      private const VIP_LEVEL3:String = "112114";
      
      private const VIP_LEVEL4:String = "112115";
      
      private const VIP_LEVEL5:String = "112116";
      
      private const VIP_LEVEL6:String = "112117";
      
      private const VIP_LEVEL7:String = "112118";
      
      private const VIP_LEVEL8:String = "112119";
      
      private const VIP_LEVEL9:String = "112120";
      
      private var _vipChestsArr:Array;
      
      private var _BG:Scale9CornerImage;
      
      private var _buttomBG:ScaleBitmapImage;
      
      protected var _nameImg:Bitmap;
      
      protected var _VIPDaysImg:Bitmap;
      
      protected var _ownedMoneyImg:Bitmap;
      
      protected var _moneyIconImg:Bitmap;
      
      protected var _offerImage:Bitmap;
      
      protected var _yearDiscountImg:Bitmap;
      
      protected var _showPayMoneyBG:ScaleLeftRightImage;
      
      protected var _openVipBtn:BaseButton;
      
      protected var _renewalVipBtn:BaseButton;
      
      protected var _rewardBtn:BaseButton;
      
      private var _rewardEffet:IEffect;
      
      private var _secondBtnGroup:SelectedButtonGroup;
      
      protected var _oneBtn:SelectedCheckButton;
      
      protected var _twoBtn:SelectedCheckButton;
      
      protected var _threeBtn:SelectedCheckButton;
      
      protected var _forthBtn:SelectedCheckButton;
      
      protected var _otherBtn:SelectedCheckButton;
      
      protected var _otherInput:TextInput;
      
      protected var _money:FilterFrameText;
      
      protected var _monthNum:FilterFrameText;
      
      protected var _showPayMoney:FilterFrameText;
      
      protected var _yearDiscountTxt:FilterFrameText;
      
      protected var _isSelf:Boolean;
      
      private var awards:AwardsViewII;
      
      private var alertFrame:BaseAlerFrame;
      
      private var _vipInfoTipBox:VipInfoTipBox;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      protected var days:int = 0;
      
      protected var payNum:int = 0;
      
      protected var time:String = "";
      
      public function GiveYourselfOpenView()
      {
         this._vipChestsArr = [this.VIP_LEVEL1,this.VIP_LEVEL2,this.VIP_LEVEL3,this.VIP_LEVEL4,this.VIP_LEVEL5,this.VIP_LEVEL6,this.VIP_LEVEL7,this.VIP_LEVEL8,this.VIP_LEVEL9];
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._isSelf = true;
         this.addImg();
         this.addSecondLevelBtn();
         this.addTextAndBtn();
         this.upPayMoneyText();
         this.showOpenOrRenewal();
         this.rewardBtnCanUse();
      }
      
      private function addImg() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.BG");
         this._buttomBG = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.buttomBG");
         this._nameImg = ComponentFactory.Instance.creatBitmap("asset.vip.name");
         this._yearDiscountImg = ComponentFactory.Instance.creatBitmap("asset.vip.yearDiscountBitmap");
         this._VIPDaysImg = ComponentFactory.Instance.creatBitmap("asset.vip.VIPDays");
         this._ownedMoneyImg = ComponentFactory.Instance.creatBitmap("asset.vip.ownedMoney");
         this._moneyIconImg = ComponentFactory.Instance.creatBitmap("asset.vip.moneyIcon");
         this._showPayMoneyBG = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.showMoney");
         addChild(this._BG);
         addChild(this._buttomBG);
         addChild(this._nameImg);
         addChild(this._yearDiscountImg);
         addChild(this._VIPDaysImg);
         addChild(this._ownedMoneyImg);
         addChild(this._moneyIconImg);
         addChild(this._showPayMoneyBG);
         this._nameImg.visible = false;
      }
      
      private function addSecondLevelBtn() : void
      {
         this._secondBtnGroup = new SelectedButtonGroup(false);
         this._oneBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.one");
         addChild(this._oneBtn);
         this._secondBtnGroup.addSelectItem(this._oneBtn);
         this._twoBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.two");
         addChild(this._twoBtn);
         this._secondBtnGroup.addSelectItem(this._twoBtn);
         this._threeBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.three");
         addChild(this._threeBtn);
         this._secondBtnGroup.addSelectItem(this._threeBtn);
         this._forthBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.four");
         addChild(this._forthBtn);
         this._secondBtnGroup.addSelectItem(this._forthBtn);
         this._otherBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.other");
         this._otherBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipView.other");
         addChild(this._otherBtn);
         this._secondBtnGroup.addSelectItem(this._otherBtn);
         this._secondBtnGroup.selectIndex = 1;
         this._oneBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipView.oneMonth");
         this._twoBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipView.threeMonth");
         this._threeBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipView.sixMonth");
         this._forthBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipView.oneYear");
      }
      
      private function addTextAndBtn() : void
      {
         this._money = ComponentFactory.Instance.creat("GiveYourselfOpenView.money");
         this._otherInput = ComponentFactory.Instance.creat("GiveYourselfOpenView.otherText");
         this._monthNum = ComponentFactory.Instance.creat("GiveYourselfOpenView.monthNum");
         this._showPayMoney = ComponentFactory.Instance.creat("GiveYourselfOpenView.showPayMoneyTxt");
         this._yearDiscountTxt = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.yearDiscountTxt");
         this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.openVipBtn");
         this._renewalVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.renewalVipBtn");
         this._rewardBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.rewardBtn");
         this._offerImage = ComponentFactory.Instance.creatBitmap("asset.vip.Offer");
         this._rewardEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._rewardBtn);
         this._yearDiscountTxt.text = LanguageMgr.GetTranslation("ddt.vip.vipView.yearDiscountText");
         addChild(this._otherInput);
         addChild(this._money);
         addChild(this._monthNum);
         addChild(this._openVipBtn);
         addChild(this._renewalVipBtn);
         addChild(this._rewardBtn);
         addChild(this._yearDiscountTxt);
         this._showPayMoneyBG.addChild(this._showPayMoney);
         this._money.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("money");
         this._otherInput.textField.restrict = "0-9";
         this._otherInput.maxChars = 2;
         this._monthNum.text = LanguageMgr.GetTranslation("ddt.vip.vipView.months");
         this._monthNum.visible = false;
         this._otherInput.visible = false;
      }
      
      protected function showOpenOrRenewal() : void
      {
         if(this._isSelf)
         {
            if(PlayerManager.Instance.Self.VIPExp <= 0 && !PlayerManager.Instance.Self.IsVIP)
            {
               this._openVipBtn.visible = true;
               this._renewalVipBtn.visible = false;
            }
            else
            {
               this._openVipBtn.visible = false;
               this._renewalVipBtn.visible = true;
            }
         }
         else
         {
            this._openVipBtn.visible = true;
            this._renewalVipBtn.visible = false;
            this._openVipBtn.x = 148;
         }
      }
      
      private function rewardBtnCanUse() : void
      {
         if(PlayerManager.Instance.Self.IsVIP)
         {
            if(PlayerManager.Instance.Self.canTakeVipReward)
            {
               this._rewardEffet.play();
            }
            else
            {
               this._rewardEffet.stop();
            }
         }
         else
         {
            this._rewardEffet.stop();
         }
      }
      
      private function initEvent() : void
      {
         this._secondBtnGroup.addEventListener(Event.CHANGE,this.__upPayNum);
         this._otherBtn.addEventListener(MouseEvent.CLICK,this.__focusOtherInput);
         this._otherInput.addEventListener(MouseEvent.CLICK,this.__selectOtherBtn);
         this._otherInput.addEventListener(Event.CHANGE,this.__confirmInput);
         this._openVipBtn.addEventListener(MouseEvent.CLICK,this.__openVip);
         this._renewalVipBtn.addEventListener(MouseEvent.CLICK,this.__openVip);
         this._rewardBtn.addEventListener(MouseEvent.CLICK,this.__reward);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function removeEvent() : void
      {
         this._secondBtnGroup.removeEventListener(Event.CHANGE,this.__upPayNum);
         this._otherBtn.removeEventListener(MouseEvent.CLICK,this.__focusOtherInput);
         this._otherInput.removeEventListener(MouseEvent.CLICK,this.__selectOtherBtn);
         this._otherInput.removeEventListener(Event.CHANGE,this.__confirmInput);
         this._openVipBtn.removeEventListener(MouseEvent.CLICK,this.__openVip);
         this._renewalVipBtn.removeEventListener(MouseEvent.CLICK,this.__openVip);
         this._rewardBtn.removeEventListener(MouseEvent.CLICK,this.__reward);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function __reward(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Date = null;
         var _loc4_:Date = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.canTakeVipReward || PlayerManager.Instance.Self.IsVIP == false)
         {
            this._vipInfoTipBox = ComponentFactory.Instance.creat("vip.VipInfoTipFrame");
            this._vipInfoTipBox.escEnable = true;
            this._vipInfoTipBox.vipAwardGoodsList = this.getVIPInfoTip(BossBoxManager.instance.inventoryItemList);
            this._vipInfoTipBox.addEventListener(AwardsView.HAVEBTNCLICK,this.__ShowAwards);
            this._vipInfoTipBox.addEventListener(FrameEvent.RESPONSE,this.__responseVipInfoTipHandler);
            LayerManager.Instance.addToLayer(this._vipInfoTipBox,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            _loc2_ = 0;
            _loc3_ = PlayerManager.Instance.Self.systemDate as Date;
            if(_loc3_.day == 0)
            {
               _loc2_ = 1;
            }
            else
            {
               _loc2_ = 8 - _loc3_.day;
            }
            _loc4_ = new Date(_loc3_.getTime() + _loc2_ * millisecondsPerDay);
            this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.vip.vipView.cueDateScript",_loc4_.month + 1,_loc4_.date),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alertFrame.moveEnable = false;
            this.alertFrame.addEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         }
      }
      
      private function __alertHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         if(this.alertFrame && this.alertFrame.parent)
         {
            this.alertFrame.parent.removeChild(this.alertFrame);
         }
         if(this.alertFrame)
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
      }
      
      private function __responseVipInfoTipHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._vipInfoTipBox.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
               break;
            case FrameEvent.ENTER_CLICK:
               this.showAwards(this._vipInfoTipBox.selectCellInfo);
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.awards.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.awards.dispose();
               this.awards = null;
         }
      }
      
      private function showAwards(param1:ItemTemplateInfo) : void
      {
         this.awards = ComponentFactory.Instance.creat("vip.awardFrame");
         this.awards.escEnable = true;
         this.awards.boxType = 2;
         this.awards.vipAwardGoodsList = this._getStrArr(BossBoxManager.instance.inventoryItemList);
         this.awards.addEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         LayerManager.Instance.addToLayer(this.awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __ShowAwards(param1:Event) : void
      {
         this.awards = ComponentFactory.Instance.creat("vip.awardFrame");
         this.awards.escEnable = true;
         this.awards.boxType = 2;
         this.awards.vipAwardGoodsList = this._getStrArr(BossBoxManager.instance.inventoryItemList);
         this.awards.addEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         LayerManager.Instance.addToLayer(this.awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __sendReward(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDailyAward(3);
         this.awards.removeEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.dispose();
         PlayerManager.Instance.Self.canTakeVipReward = false;
         this.rewardBtnCanUse();
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Money"])
         {
            this._money.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("money");
         }
         if(param1.changedProperties["isVip"] || param1.changedProperties["canTakeVipReward"])
         {
            this.showOpenOrRenewal();
            this.rewardBtnCanUse();
         }
      }
      
      private function __upPayNum(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.upPayMoneyText();
         if(this._secondBtnGroup.selectIndex == 3)
         {
            addChild(this._offerImage);
         }
         else
         {
            DisplayUtils.removeDisplay(this._offerImage);
         }
         if(this._secondBtnGroup.selectIndex == 4)
         {
            this._otherInput.visible = true;
            this._monthNum.visible = true;
         }
         else
         {
            this._otherInput.visible = false;
            this._monthNum.visible = false;
         }
         this._otherInput.text = "";
      }
      
      private function __confirmInput(param1:Event) : void
      {
         if(parseInt(this._otherInput.text) > 24)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipView.checkOtherInput24"));
            this._otherInput.text = "";
         }
         if(this._otherInput.text == "0")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipView.checkOtherInput0"));
            this._otherInput.text = "";
         }
         this.upPayMoneyText();
      }
      
      protected function __openVip(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < this.payNum)
         {
            this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._moneyConfirm.moveEnable = false;
            this._moneyConfirm.addEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
            return;
         }
         if(this._otherBtn.selected && this._otherInput.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipView.checkOtherInput"));
            return;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.vip.vipView.confirmforSelf",this.time,this.payNum);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.vip.vipFrame.ConfirmTitle"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function __moneyConfirmHandler(param1:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
         this._moneyConfirm.dispose();
         if(this._moneyConfirm.parent)
         {
            this._moneyConfirm.parent.removeChild(this._moneyConfirm);
         }
         this._moneyConfirm = null;
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.sendVip();
               this._otherInput.text = "";
               this.upPayMoneyText();
         }
         this._confirmFrame.dispose();
         if(this._confirmFrame.parent)
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      protected function sendVip() : void
      {
         this.days = 0;
         switch(this._secondBtnGroup.selectIndex)
         {
            case 0:
               this.days = 31;
               break;
            case 1:
               this.days = 31 * 3;
               break;
            case 2:
               this.days = 31 * 6;
               break;
            case 3:
               this.days = 365;
               break;
            case 4:
               this.days = parseInt(this._otherInput.text) * 31;
         }
         this.send();
      }
      
      protected function send() : void
      {
         VipController.instance.sendOpenVip(PlayerManager.Instance.Self.NickName,this.days);
      }
      
      private function __focusOtherInput(param1:MouseEvent) : void
      {
         StageReferance.stage.focus = this._otherInput.textField;
      }
      
      private function __selectOtherBtn(param1:MouseEvent) : void
      {
         this._secondBtnGroup.selectIndex = 4;
      }
      
      private function __payBtnClickHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._secondBtnGroup.selectIndex = 0;
         this.upPayMoneyText();
         this._otherInput.text = "";
      }
      
      protected function upPayMoneyText() : void
      {
         this.payNum = 0;
         this.time = "";
         switch(this._secondBtnGroup.selectIndex)
         {
            case 0:
               this.payNum = ONE_MONTH_PAY;
               this.time = "1 mes";
               break;
            case 1:
               this.payNum = ONE_MONTH_PAY * 3;
               this.time = "3 mes";
               break;
            case 2:
               this.payNum = ONE_MONTH_PAY * 6;
               this.time = "6 mes";
               break;
            case 3:
               this.payNum = ONE_YEAR_PAY;
               this.time = "1 Año";
               break;
            case 4:
               this.payNum = ONE_MONTH_PAY * parseInt(this._otherInput.text);
               this.time = this._otherInput.text + " mes";
         }
         this._showPayMoney.htmlText = LanguageMgr.GetTranslation("ddt.vip.vipView.payMoneyShow",this.payNum);
      }
      
      private function _getStrArr(param1:DictionaryData) : Array
      {
         return param1[this._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]];
      }
      
      private function getVIPInfoTip(param1:DictionaryData) : Array
      {
         var _loc2_:Array = null;
         return PlayerManager.Instance.Self.VIPLevel == 9 ? [ItemManager.Instance.getTemplateById(int(this._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1])),ItemManager.Instance.getTemplateById(int(this._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 2]))] : [ItemManager.Instance.getTemplateById(int(this._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1])),ItemManager.Instance.getTemplateById(int(this._vipChestsArr[PlayerManager.Instance.Self.VIPLevel]))];
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         EffectManager.Instance.removeEffect(this._rewardEffet);
         if(this._secondBtnGroup)
         {
            this._secondBtnGroup.dispose();
         }
         this._secondBtnGroup = null;
         if(this._oneBtn)
         {
            ObjectUtils.disposeObject(this._oneBtn);
         }
         this._oneBtn = null;
         if(this._twoBtn)
         {
            ObjectUtils.disposeObject(this._twoBtn);
         }
         this._twoBtn = null;
         if(this._threeBtn)
         {
            ObjectUtils.disposeObject(this._threeBtn);
         }
         this._threeBtn = null;
         if(this._otherBtn)
         {
            ObjectUtils.disposeObject(this._otherBtn);
         }
         this._otherBtn = null;
         if(this._otherInput)
         {
            ObjectUtils.disposeObject(this._otherInput);
         }
         this._otherInput = null;
         if(this._openVipBtn)
         {
            ObjectUtils.disposeObject(this._openVipBtn);
         }
         this._openVipBtn = null;
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._buttomBG)
         {
            ObjectUtils.disposeObject(this._buttomBG);
         }
         this._buttomBG = null;
         if(this._nameImg)
         {
            ObjectUtils.disposeObject(this._nameImg);
         }
         this._nameImg = null;
         if(this._VIPDaysImg)
         {
            ObjectUtils.disposeObject(this._VIPDaysImg);
         }
         this._VIPDaysImg = null;
         if(this._ownedMoneyImg)
         {
            ObjectUtils.disposeObject(this._ownedMoneyImg);
         }
         this._ownedMoneyImg = null;
         if(this._moneyIconImg)
         {
            ObjectUtils.disposeObject(this._moneyIconImg);
         }
         this._moneyIconImg = null;
         if(this._money)
         {
            ObjectUtils.disposeObject(this._money);
         }
         this._money = null;
         if(this._monthNum)
         {
            ObjectUtils.disposeObject(this._monthNum);
         }
         this._monthNum = null;
         if(this._showPayMoneyBG)
         {
            ObjectUtils.disposeObject(this._showPayMoneyBG);
         }
         this._showPayMoneyBG = null;
         if(this._showPayMoney)
         {
            ObjectUtils.disposeObject(this._showPayMoney);
         }
         this._showPayMoney = null;
         if(this._confirmFrame)
         {
            this._confirmFrame.dispose();
         }
         this._confirmFrame = null;
         if(this._moneyConfirm)
         {
            this._moneyConfirm.dispose();
         }
         this._moneyConfirm = null;
         if(this._renewalVipBtn)
         {
            ObjectUtils.disposeObject(this._renewalVipBtn);
         }
         this._renewalVipBtn = null;
         if(this._rewardBtn)
         {
            ObjectUtils.disposeObject(this._rewardBtn);
         }
         this._rewardBtn = null;
         if(this.alertFrame)
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
         ObjectUtils.disposeObject(this._yearDiscountImg);
         this._yearDiscountImg = null;
         ObjectUtils.disposeObject(this._yearDiscountTxt);
         this._yearDiscountTxt = null;
         ObjectUtils.disposeObject(this._offerImage);
         this._offerImage = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
