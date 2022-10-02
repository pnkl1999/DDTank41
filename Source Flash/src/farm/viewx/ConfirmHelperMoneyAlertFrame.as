package farm.viewx
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class ConfirmHelperMoneyAlertFrame extends BaseAlerFrame
   {
       
      
      private var _addBtn:BaseButton;
      
      private var _removeBtn:BaseButton;
      
      private var _bg3:Scale9CornerImage;
      
      private var _timeTxt:FilterFrameText;
      
      private var _payTxt:FilterFrameText;
      
      private var _bgTitle:DisplayObject;
      
      private var _secondBtnGroup:SelectedButtonGroup;
      
      private var _oneBtn:SelectedCheckButton;
      
      private var _twoBtn:SelectedCheckButton;
      
      private var _showPayMoneyBG:Image;
      
      private var _showPayMoney:FilterFrameText;
      
      private var payNum:int = 0;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      private var _money:int;
      
      private var _outFun:Function;
      
      public function ConfirmHelperMoneyAlertFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("ddt.farms.helperMoneyComfirmPnlTitle");
         _loc1_.bottomGap = 37;
         _loc1_.buttonGape = 115;
         _loc1_.customPos = ComponentFactory.Instance.creat("farm.confirmHelperMoneyAlertBtnPos");
         this.info = _loc1_;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bgTitle = ComponentFactory.Instance.creat("assets.farm.titleSmall");
         addChild(this._bgTitle);
         PositionUtils.setPos(this._bgTitle,PositionUtils.creatPoint("farm.confirmHelperMoneyAlertTitlePos"));
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("farm.confirmHelperMoneyAlertFrame.bg3");
         addToContent(this._bg3);
         this._timeTxt = ComponentFactory.Instance.creat("farm.helperMoney.timeText");
         this._timeTxt.text = LanguageMgr.GetTranslation("ddt.farms.helperMoneyComfirm.timeText");
         addToContent(this._timeTxt);
         this._payTxt = ComponentFactory.Instance.creat("farm.helperMoney.payText");
         this._payTxt.text = LanguageMgr.GetTranslation("ddt.farms.helperMoneyComfirm.payText");
         addToContent(this._payTxt);
         this._secondBtnGroup = new SelectedButtonGroup(false);
         this._oneBtn = ComponentFactory.Instance.creatComponentByStylename("confirmHelperMoneyAlertFrame.selectOne");
         addToContent(this._oneBtn);
         this._secondBtnGroup.addSelectItem(this._oneBtn);
         this._twoBtn = ComponentFactory.Instance.creatComponentByStylename("confirmHelperMoneyAlertFrame.selectTwo");
         addToContent(this._twoBtn);
         this._secondBtnGroup.addSelectItem(this._twoBtn);
         this._secondBtnGroup.selectIndex = 0;
         this._oneBtn.text = LanguageMgr.GetTranslation("ddt.farms.confirmHelperMoneyAlertFrame.selectOneText");
         this._twoBtn.text = LanguageMgr.GetTranslation("ddt.farms.confirmHelperMoneyAlertFrame.selectTwoText");
         this._showPayMoney = ComponentFactory.Instance.creat("confirmHelperMoneyAlertFrame.showPayMoneyTxt");
         addToContent(this._showPayMoney);
         this.upPayMoneyText();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._secondBtnGroup.addEventListener(Event.CHANGE,this.__upPayNum);
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               _loc2_ = 0;
               switch(this._secondBtnGroup.selectIndex)
               {
                  case 0:
                     _loc2_ = FarmModelController.instance.model.payAutoTimeToWeek;
                     break;
                  case 1:
                     _loc2_ = FarmModelController.instance.model.payAutoTimeToMonth;
               }
               if(this.checkMoney(false,this.payNum))
               {
                  return;
               }
               if(PlayerManager.Instance.Self.Money < this.payNum)
               {
                  this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this._moneyConfirm.moveEnable = false;
                  this._moneyConfirm.addEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
               }
               else
               {
                  FarmModelController.instance.helperRenewMoney(_loc2_,false);
               }
               break;
         }
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this.dispose();
      }
      
      public function checkMoney(param1:Boolean, param2:int, param3:Function = null) : Boolean
      {
         this._money = param2;
         this._outFun = param3;
         if(PlayerManager.Instance.Self.Money < param2)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      private function __moneyConfirmHandler(param1:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         this._moneyConfirm.dispose();
         this._moneyConfirm = null;
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __upPayNum(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.upPayMoneyText();
      }
      
      protected function upPayMoneyText() : void
      {
         this.payNum = 0;
         switch(this._secondBtnGroup.selectIndex)
         {
            case 0:
               this.payNum = FarmModelController.instance.model.payAutoMoneyToWeek;
               break;
            case 1:
               this.payNum = FarmModelController.instance.model.payAutoMoneyToMonth;
         }
         this._showPayMoney.htmlText = LanguageMgr.GetTranslation("ddt.farms.confirmHelperMoneyAlertFrame.payMoneyShow",this.payNum);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         if(this._secondBtnGroup)
         {
            this._secondBtnGroup.removeEventListener(Event.CHANGE,this.__upPayNum);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._timeTxt)
         {
            ObjectUtils.disposeObject(this._timeTxt);
            this._timeTxt = null;
         }
         if(this._showPayMoney)
         {
            ObjectUtils.disposeObject(this._showPayMoney);
         }
         this._showPayMoney = null;
         if(this._secondBtnGroup)
         {
            ObjectUtils.disposeObject(this._secondBtnGroup);
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
         if(this._addBtn)
         {
            ObjectUtils.disposeObject(this._addBtn);
         }
         this._addBtn = null;
         if(this._removeBtn)
         {
            ObjectUtils.disposeObject(this._removeBtn);
         }
         this._removeBtn = null;
         if(this._bgTitle)
         {
            ObjectUtils.disposeObject(this._bgTitle);
         }
         this._bgTitle = null;
         if(this._bg3)
         {
            ObjectUtils.disposeObject(this._bg3);
         }
         this._bg3 = null;
         super.dispose();
      }
   }
}
