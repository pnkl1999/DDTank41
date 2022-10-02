package labyrinth.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import labyrinth.LabyrinthManager;
   import labyrinth.data.CleanOutInfo;
   import road7th.data.DictionaryEvent;
   
   public class CleanOutFrame extends BaseAlerFrame
   {
       
      
      private var _rightBG:Bitmap;
      
      private var _leftBG:Bitmap;
      
      private var _startCleanOutBtn:SimpleBitmapButton;
      
      private var _speededUpBtn:SimpleBitmapButton;
      
      private var _cancelBtn:SimpleBitmapButton;
      
      private var _rightValue:FilterFrameText;
      
      private var _rightValueI:FilterFrameText;
      
      private var _rightValueII:FilterFrameText;
      
      private var _tipContainer:Sprite;
      
      private var _tipTitle:FilterFrameText;
      
      private var _tipContent:FilterFrameText;
      
      private var _list:ListPanel;
      
      private var _textFormat:TextFormat;
      
      private var _timer:Timer;
      
      private var _remainTime:int;
      
      private var _currentRemainTime:int;
      
      private var _chatBtn:SimpleBitmapButton;
      
      private var _vipIcon:Bitmap;
      
      private var _freeAccTips:FilterFrameText;
      
      private var _currentFloor:int = 0;
      
      private var _btnState:int;
      
      public function CleanOutFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.title"));
         _loc1_.moveEnable = false;
         info = _loc1_;
         this._rightBG = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.CleanOutFrame.rightBG");
         addToContent(this._rightBG);
         this._leftBG = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.CleanOutFrame.leftBG");
         addToContent(this._leftBG);
         this._startCleanOutBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CleanOutFrame.startCleanOutButton");
         addToContent(this._startCleanOutBtn);
         this._speededUpBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CleanOutFrame.speededUpButton");
         addToContent(this._speededUpBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CleanOutFrame.cancelButton");
         addToContent(this._cancelBtn);
         this._rightValue = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.rightValue");
         addToContent(this._rightValue);
         this._rightValueI = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.rightValueI");
         addToContent(this._rightValueI);
         this._rightValueII = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.rightValueII");
         addToContent(this._rightValueII);
         this._chatBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.chatButton");
         this._chatBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.chat");
         addToContent(this._chatBtn);
         this._vipIcon = ComponentFactory.Instance.creat("asset.seniorVipIcon.small_9");
         PositionUtils.setPos(this._vipIcon,"ddt.labyrinth.vipIconPos");
         addToContent(this._vipIcon);
         this._freeAccTips = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.freeAccTips");
         addToContent(this._freeAccTips);
         this._freeAccTips.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.freeAccTips");
         this._tipContainer = ComponentFactory.Instance.creatCustomObject("labyrinth.CleanOutFrame.tipContainer");
         addToContent(this._tipContainer);
         this._tipTitle = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.CleanOutFrame.tipTitleText",LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.leftTitle"),this._tipContainer);
         this._tipContent = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.CleanOutFrame.tipContentText",LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.leftTip"),this._tipContainer);
         this._textFormat = ComponentFactory.Instance.model.getSet("ddt.labyrinth.CleanOutFrame.rightValueIITF");
         this._currentFloor = LabyrinthManager.Instance.model.currentFloor;
         this._list = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.List");
         addToContent(this._list);
         this.btnState = 0;
         this.initEvent();
         PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.CLEAN_OUT,PlayerState.AUTO);
         SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
      }
      
      private function initEvent() : void
      {
         this._startCleanOutBtn.addEventListener(MouseEvent.CLICK,this.__startCleanOut);
         this._speededUpBtn.addEventListener(MouseEvent.CLICK,this.__speededUp);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancel);
         this._chatBtn.addEventListener(MouseEvent.CLICK,this.__chatClick);
         LabyrinthManager.Instance.model.cleanOutInfos.addEventListener(DictionaryEvent.ADD,this.__addInfo);
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.UPDATE_REMAIN_TIME,this.__updateRemainTime);
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
      }
      
      protected function __chatClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LabyrinthManager.Instance.chat();
      }
      
      protected function __updateInfo(param1:Event) : void
      {
         this.updateTextVlaue();
         this.updateButton();
      }
      
      protected function __updateRemainTime(param1:Event) : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer = null;
         }
         this._remainTime = LabyrinthManager.Instance.model.remainTime;
         this._currentRemainTime = LabyrinthManager.Instance.model.currentRemainTime;
         if(this._remainTime > 0)
         {
            this._timer = new Timer(1000,this._remainTime);
            this._timer.addEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer.start();
         }
      }
      
      private function removeEvent() : void
      {
         this._startCleanOutBtn.removeEventListener(MouseEvent.CLICK,this.__startCleanOut);
         this._speededUpBtn.removeEventListener(MouseEvent.CLICK,this.__speededUp);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancel);
         LabyrinthManager.Instance.model.cleanOutInfos.removeEventListener(DictionaryEvent.ADD,this.__addInfo);
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.UPDATE_REMAIN_TIME,this.__updateRemainTime);
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
      }
      
      private function updateRightValueI() : void
      {
         var _loc1_:int = 0;
         if(this._btnState == 0 || this._btnState == 2)
         {
            _loc1_ = LabyrinthManager.Instance.model.cleanOutAllTime;
         }
         else
         {
            _loc1_ = this._remainTime;
         }
         var _loc2_:String = _loc1_ / 60 >= 10 ? String(Math.floor(_loc1_ / 60)) : "0" + String(Math.floor(_loc1_ / 60));
         var _loc3_:String = _loc1_ % 60 >= 10 ? String(Math.floor(_loc1_ % 60)) : "0" + String(Math.floor(_loc1_ % 60));
         this._rightValueI.text = "00 : " + _loc2_ + " : " + _loc3_;
      }
      
      protected function __updateTimer(param1:TimerEvent) : void
      {
         if(this._remainTime != 0)
         {
            --this._remainTime;
         }
         if(this._currentRemainTime != 0)
         {
            --this._currentRemainTime;
         }
         this.updateRightValueI();
         if(this._currentRemainTime == 0)
         {
            SocketManager.Instance.out.labyrinthCleanOutTimerComplete();
         }
      }
      
      protected function __addInfo(param1:DictionaryEvent) : void
      {
         this._list.vectorListModel.removeAt(this._list.vectorListModel.elements.length - 1);
         this._list.vectorListModel.append(param1.data as CleanOutInfo);
         ++this._currentFloor;
         if(this._currentFloor != LabyrinthManager.Instance.model.myProgress + 1)
         {
            this._list.vectorListModel.append(null);
         }
      }
      
      protected function __cancel(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.btnState = 0;
         SocketManager.Instance.out.labyrinthStopCleanOut();
         LabyrinthManager.Instance.model.cleanOutInfos.clear();
         this._list.vectorListModel.clear();
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer = null;
         }
         onResponse(FrameEvent.CLOSE_CLICK);
      }
      
      protected function __speededUp(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc3_:int = Math.ceil(LabyrinthManager.Instance.model.remainTime / 60) * ServerConfigManager.instance.WarriorFamRaidPricePerMin;
         if(PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= 4)
         {
            _loc3_ = Math.ceil(_loc3_ / 2);
            _loc2_ = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.warning",_loc3_);
         }
         else
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.warning",_loc3_);
         }
         var _loc4_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc4_.moveEnable = false;
         _loc4_.addEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
      }
      
      protected function __onFrameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         ObjectUtils.disposeObject(param1.target);
         var _loc3_:int = Math.ceil(LabyrinthManager.Instance.model.remainTime / 60) * ServerConfigManager.instance.WarriorFamRaidPricePerMin;
         if(PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= 4)
         {
            _loc3_ = Math.ceil(_loc3_ / 2);
         }
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < _loc3_)
            {
               LeavePageManager.showFillFrame();
               _loc2_ = null;
               return;
            }
            SocketManager.Instance.out.labyrinthSpeededUpCleanOut(false);
            _loc2_ = null;
            this.btnState = 2;
            this.reset();
         }
      }
      
      private function reset() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer = null;
         }
         this._rightValueI.text = "00 : 00 : 00";
      }
      
      protected function __startCleanOut(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < LabyrinthManager.Instance.model.cleanOutGold)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.giftLack"));
            return;
         }
         this.btnState = 1;
         this._list.vectorListModel.append(null);
         SocketManager.Instance.out.labyrinthCleanOut();
      }
      
      private function set btnState(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               this._btnState = 0;
               this._startCleanOutBtn.visible = true;
               this._tipContainer.visible = true;
               this._speededUpBtn.visible = false;
               this._cancelBtn.visible = false;
               this._list.visible = false;
               break;
            case 1:
               this._btnState = 1;
               this._startCleanOutBtn.visible = false;
               this._tipContainer.visible = false;
               this._speededUpBtn.visible = true;
               this._cancelBtn.visible = true;
               this._list.visible = true;
               break;
            case 2:
               this._btnState = 2;
               this._startCleanOutBtn.visible = false;
               this._tipContainer.visible = false;
               this._speededUpBtn.visible = true;
               this._cancelBtn.visible = true;
               this._list.visible = true;
         }
         this.updateTextVlaue();
      }
      
      private function updateTextVlaue() : void
      {
         var _loc1_:int = LabyrinthManager.Instance.model.myProgress;
         var _loc2_:int = LabyrinthManager.Instance.model.currentFloor - 1;
         var _loc3_:int = LabyrinthManager.Instance.model.cleanOutGold;
         this._remainTime = LabyrinthManager.Instance.model.remainTime;
         if(this._btnState == 0 || this._btnState == 2)
         {
            this._rightValue.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightValueTextII",_loc1_);
            this._rightValueII.text = String(_loc3_);
            if(this._btnState == 2)
            {
               this._rightValue.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightValueText",_loc1_);
               this._rightValueII.text = LabyrinthManager.Instance.model.accumulateExp.toString();
            }
         }
         else
         {
            this._rightValue.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightValueText",_loc2_);
            this._rightValueII.text = LabyrinthManager.Instance.model.accumulateExp.toString();
         }
         this.updateRightValueI();
         this.updateButton();
      }
      
      private function updateButton() : void
      {
         var _loc1_:Boolean = LabyrinthManager.Instance.model.currentFloor == LabyrinthManager.Instance.model.myProgress + 1;
         if(!LabyrinthManager.Instance.model.completeChallenge || _loc1_)
         {
            this._startCleanOutBtn.enable = false;
            this._speededUpBtn.enable = false;
            this.reset();
         }
      }
      
      public function continueCleanOut() : void
      {
         this.btnState = 1;
         this._list.vectorListModel.append(null);
         SocketManager.Instance.out.labyrinthCleanOut();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         SocketManager.Instance.out.labyrinthStopCleanOut();
         PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.ONLINE,PlayerState.AUTO);
         SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
         this.removeEvent();
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer = null;
         }
         super.dispose();
         ObjectUtils.disposeObject(this._rightBG);
         this._rightBG = null;
         ObjectUtils.disposeObject(this._leftBG);
         this._leftBG = null;
         ObjectUtils.disposeObject(this._startCleanOutBtn);
         this._startCleanOutBtn = null;
         ObjectUtils.disposeObject(this._speededUpBtn);
         this._speededUpBtn = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
         ObjectUtils.disposeObject(this._rightValue);
         this._rightValue = null;
         ObjectUtils.disposeObject(this._rightValueI);
         this._rightValueI = null;
         ObjectUtils.disposeObject(this._rightValueII);
         this._rightValueII = null;
         ObjectUtils.disposeObject(this._tipContainer);
         this._tipContainer = null;
         ObjectUtils.disposeObject(this._tipTitle);
         this._tipTitle = null;
         ObjectUtils.disposeObject(this._tipContent);
         this._tipContent = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._chatBtn);
         this._chatBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
