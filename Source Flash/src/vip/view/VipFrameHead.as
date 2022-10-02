package vip.view
{
   import bagAndInfo.info.LevelProgress;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.view.PlayerPortraitView;
   import ddt.view.common.VipLevelIcon;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class VipFrameHead extends Sprite implements Disposeable
   {
      
      private static var eachLevelEXP:Array = [0,150,350,700,1250,2050,3050,4250,5650];
       
      
      private var _topBG:Scale9CornerImage;
      
      private var _selfName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _ClockImg:Bitmap;
      
      private var _dueTime:FilterFrameText;
      
      private var _vipLevelProgress:LevelProgress;
      
      private var _vipHelpBtn:BaseButton;
      
      private var _selfLevel:FilterFrameText;
      
      private var _nextLevel:FilterFrameText;
      
      private var _dueDataWord:Bitmap;
      
      private var _dueData:FilterFrameText;
      
      private var _DueTipSprite:Sprite;
      
      private var _DueTip:OneLineTip;
      
      private var _portrait:PlayerPortraitView;
      
      private var _isVipRechargeShow:Boolean = false;
      
      private var _helpFrame:VIPHelpFrame;
      
      public function VipFrameHead(param1:Boolean = false)
      {
         super();
         this._isVipRechargeShow = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._topBG = ComponentFactory.Instance.creatComponentByStylename("VIPFrame.topBG");
         if(this._isVipRechargeShow)
         {
            this._topBG.width = 355;
         }
         this._selfName = ComponentFactory.Instance.creat("VipStatusView.name");
         this._vipIcon = ComponentFactory.Instance.creatCustomObject("VipStatusView.vipIcon");
         this._ClockImg = ComponentFactory.Instance.creatBitmap("asset.vip.timeBitmap");
         this._dueTime = ComponentFactory.Instance.creat("VIPFrame.dueTime");
         this._vipLevelProgress = ComponentFactory.Instance.creat("VIPFrame.vipLevelProgress");
         if(!this._isVipRechargeShow)
         {
            this._dueDataWord = ComponentFactory.Instance.creatBitmap("asset.vip.dueDate");
            this._dueData = ComponentFactory.Instance.creat("VipStatusView.dueDate");
            this._vipHelpBtn = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.vipHelp");
         }
         this._selfLevel = ComponentFactory.Instance.creat("VipStatusView.selfLevel");
         this._nextLevel = ComponentFactory.Instance.creat("VipStatusView.nextLevel");
         this._portrait = ComponentFactory.Instance.creatCustomObject("vip.PortraitView",["right"]);
         this._portrait.info = PlayerManager.Instance.Self;
         addChild(this._topBG);
         addChild(this._portrait);
         addChild(this._ClockImg);
         addChild(this._dueTime);
         addChild(this._vipLevelProgress);
         if(!this._isVipRechargeShow)
         {
            addChild(this._vipHelpBtn);
            addChild(this._dueDataWord);
            addChild(this._dueData);
         }
         addChild(this._selfLevel);
         addChild(this._nextLevel);
         this.addTipSprite();
         this.upView();
         this.addEvent();
      }
      
      private function addTipSprite() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         this._DueTipSprite = new Sprite();
         this._DueTipSprite.graphics.beginFill(0,0);
         this._DueTipSprite.graphics.drawRect(0,0,75,35);
         this._DueTipSprite.graphics.endFill();
         _loc1_ = ComponentFactory.Instance.creatCustomObject("Vip.DueTipSpritePos");
         this._DueTipSprite.x = _loc1_.x;
         this._DueTipSprite.y = _loc1_.y;
         addChild(this._DueTipSprite);
         this._DueTip = new OneLineTip();
         addChild(this._DueTip);
         this._DueTip.x = this._ClockImg.x;
         this._DueTip.y = this._ClockImg.y + 25;
         this._DueTip.visible = false;
      }
      
      private function addEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         if(this._vipHelpBtn)
         {
            this._vipHelpBtn.addEventListener(MouseEvent.CLICK,this.__showHelpFrame);
         }
         this._DueTipSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__showDueTip);
         this._DueTipSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__hideDueTip);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         if(this._vipHelpBtn)
         {
            this._vipHelpBtn.removeEventListener(MouseEvent.CLICK,this.__showHelpFrame);
         }
         if(this._DueTipSprite)
         {
            this._DueTipSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__showDueTip);
            this._DueTipSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__hideDueTip);
         }
      }
      
      private function __showDueTip(param1:MouseEvent) : void
      {
         this._DueTip.visible = true;
      }
      
      private function __hideDueTip(param1:MouseEvent) : void
      {
         this._DueTip.visible = false;
      }
      
      private function __showHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("vip.viphelpFrame");
         this._helpFrame.show();
         this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._helpFrame.dispose();
               this._helpFrame = null;
         }
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["isVip"] || param1.changedProperties["VipExpireDay"] || param1.changedProperties["VIPNextLevelDaysNeeded"])
         {
            this.upView();
         }
      }
      
      private function upView() : void
      {
         var _loc3_:Date = null;
         if(PlayerManager.Instance.Self.VIPLevel != 9)
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.dueTime.tip",PlayerManager.Instance.Self.VIPNextLevelDaysNeeded,PlayerManager.Instance.Self.VIPLevel + 1);
         }
         else
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradFull");
         }
         if(!PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPExp <= 0)
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.youarenovip");
         }
         this._selfName.text = PlayerManager.Instance.Self.NickName;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            if(this._vipName)
            {
               ObjectUtils.disposeObject(this._vipName);
            }
            this._vipName = VipController.instance.getVipNameTxt(263,PlayerManager.Instance.Self.typeVIP);
            this._vipName.x = this._selfName.x;
            this._vipName.y = this._selfName.y;
            this._vipName.text = this._selfName.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._selfName);
         }
         else
         {
            addChild(this._selfName);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._vipIcon.setInfo(PlayerManager.Instance.Self,true,true);
         this._vipIcon.x = this._selfName.x + this._selfName.textWidth + 15;
         addChild(this._vipIcon);
         this._selfLevel.text = "LV" + PlayerManager.Instance.Self.VIPLevel;
         this._nextLevel.text = "LV" + (PlayerManager.Instance.Self.VIPLevel + 1);
         if(!this._isVipRechargeShow)
         {
            _loc3_ = PlayerManager.Instance.Self.VIPExpireDay as Date;
            this._dueData.text = _loc3_.fullYear + "-" + (_loc3_.month + 1) + "-" + _loc3_.date;
         }
         if(!PlayerManager.Instance.Self.IsVIP && !this._isVipRechargeShow)
         {
            this._dueData.text = "";
         }
         if(PlayerManager.Instance.Self.VIPLevel == 9)
         {
            this._nextLevel.text = "";
         }
         if(!PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPExp <= 0)
         {
            this._dueTime.text = 0 + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
         }
         else
         {
            this._dueTime.text = PlayerManager.Instance.Self.VIPNextLevelDaysNeeded + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
         }
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(PlayerManager.Instance.Self.VIPLevel == 9)
         {
            _loc2_ = 1;
            _loc1_ = 1;
         }
         else
         {
            _loc1_ = PlayerManager.Instance.Self.VIPExp - ServerConfigManager.instance.VIPExpNeededForEachLv[PlayerManager.Instance.Self.VIPLevel - 1];
            _loc2_ = ServerConfigManager.instance.VIPExpNeededForEachLv[PlayerManager.Instance.Self.VIPLevel] - ServerConfigManager.instance.VIPExpNeededForEachLv[PlayerManager.Instance.Self.VIPLevel - 1];
         }
         this._vipLevelProgress.setProgress(_loc1_,_loc2_);
         this._vipLevelProgress.labelText = PlayerManager.Instance.Self.VIPExp.toString();
         this.grayOrLightVIP();
      }
      
      private function grayOrLightVIP() : void
      {
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._vipLevelProgress.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._vipIcon.filters = null;
            this._vipLevelProgress.filters = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._topBG)
         {
            ObjectUtils.disposeObject(this._topBG);
         }
         this._topBG = null;
         if(this._vipIcon)
         {
            ObjectUtils.disposeObject(this._vipIcon);
         }
         this._vipIcon = null;
         if(this._ClockImg)
         {
            ObjectUtils.disposeObject(this._ClockImg);
         }
         this._ClockImg = null;
         if(this._dueTime)
         {
            ObjectUtils.disposeObject(this._dueTime);
         }
         this._dueTime = null;
         if(this._vipLevelProgress)
         {
            ObjectUtils.disposeObject(this._vipLevelProgress);
         }
         this._vipLevelProgress = null;
         if(this._vipHelpBtn)
         {
            ObjectUtils.disposeObject(this._vipHelpBtn);
            this._vipHelpBtn = null;
         }
         if(this._selfLevel)
         {
            ObjectUtils.disposeObject(this._selfLevel);
         }
         this._selfLevel = null;
         if(this._nextLevel)
         {
            ObjectUtils.disposeObject(this._nextLevel);
         }
         this._nextLevel = null;
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(this._DueTipSprite)
         {
            ObjectUtils.disposeObject(this._DueTipSprite);
         }
         this._DueTipSprite = null;
         if(this._DueTip)
         {
            ObjectUtils.disposeObject(this._DueTip);
         }
         this._DueTip = null;
         if(this._dueDataWord)
         {
            ObjectUtils.disposeObject(this._dueDataWord);
         }
         this._dueDataWord = null;
         if(this._dueData)
         {
            ObjectUtils.disposeObject(this._dueData);
         }
         this._dueData = null;
         if(this._helpFrame)
         {
            this._helpFrame.dispose();
         }
         this._helpFrame = null;
         if(parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
