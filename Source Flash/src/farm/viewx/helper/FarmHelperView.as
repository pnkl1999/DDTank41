package farm.viewx.helper
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.viewx.ConfirmHelperMoneyAlertFrame;
   import farm.viewx.confirmStopHelperFrame;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import store.HelpFrame;
   
   public class FarmHelperView extends Frame
   {
       
      
      private var _titleBg:DisplayObject;
      
      private var _helperFramBg1:ScaleBitmapImage;
      
      private var _helperFramBg2:ScaleBitmapImage;
      
      private var _onekeyStartBtn:TextButton;
      
      private var _onekeyCloseBtn:TextButton;
      
      private var _helperShowText1:FilterFrameText;
      
      private var _helperShowText2:FilterFrameText;
      
      private var _helperShowTime:FilterFrameText;
      
      private var _helperSelSeed:FilterFrameText;
      
      private var _helperSelTime:FilterFrameText;
      
      private var _needSeed:FilterFrameText;
      
      private var _needSeedText:FilterFrameText;
      
      private var _getSeedText:FilterFrameText;
      
      private var _getSeed:FilterFrameText;
      
      private var _getSeedNumOne:int;
      
      private var _getSeedNum:int;
      
      private var _remainTime:FilterFrameText;
      
      private var _helpBtn:TextButton;
      
      private var _farmChoose:ComboBox;
      
      private var _timeChoose:ComboBox;
      
      private var _farmNumChoose:ComboBox;
      
      private var _listArray:Array;
      
      private var _listArrayID:Array;
      
      private var _listSeedNum:Array;
      
      private var _listTimeTextArray:Array;
      
      private var _listTimeArray:Array;
      
      private var _currentTime:int;
      
      private var _currentID:int;
      
      private var _timer:Timer;
      
      private var _timerSeed:Timer;
      
      private var _timeText:FilterFrameText;
      
      private var _timeDiff:int;
      
      private var _autoTime:int;
      
      private var _seedItemInfo:Vector.<ShopItemInfo>;
      
      private var _beginFrame:HelperBeginFrame;
      
      private var _typeString:String;
      
      private var _configmPnl:ConfirmHelperMoneyAlertFrame;
      
      private var _stopHelpeCconfigm:confirmStopHelperFrame;
      
      private var _modelType:int;
      
      public function FarmHelperView()
      {
         super();
         this.initView();
         this.addEvent();
         escEnable = true;
      }
      
      private function initView() : void
      {
         this._listArray = new Array();
         this._listArrayID = new Array();
         this._listSeedNum = new Array();
         this._listTimeTextArray = ["12giờ","24giờ"];
         this._listTimeArray = new Array(12 * 60,24 * 60);
         this._currentTime = 12 * 60;
         this._titleBg = ComponentFactory.Instance.creat("assets.farm.farmHelper.title");
         addChild(this._titleBg);
         this._helperFramBg1 = ComponentFactory.Instance.creatComponentByStylename("helperFrame.bg1");
         addToContent(this._helperFramBg1);
         this._helperFramBg2 = ComponentFactory.Instance.creatComponentByStylename("helperFrame.bg2");
         addToContent(this._helperFramBg2);
         this._onekeyStartBtn = ComponentFactory.Instance.creatComponentByStylename("asset.farm.onekeyStartBtn");
         this._onekeyStartBtn.text = LanguageMgr.GetTranslation("ddt.farm.StartBtn.text");
         this._onekeyStartBtn.enable = false;
         addToContent(this._onekeyStartBtn);
         this._onekeyCloseBtn = ComponentFactory.Instance.creatComponentByStylename("asset.farm.onekeyCloseBtn");
         this._onekeyCloseBtn.visible = false;
         this._onekeyCloseBtn.text = LanguageMgr.GetTranslation("ddt.farm.CloseBtn.text");
         addToContent(this._onekeyCloseBtn);
         this._helperShowText1 = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperShowTxt1");
         this._helperShowText1.text = LanguageMgr.GetTranslation("ddt.farm.helperShow.text1");
         addToContent(this._helperShowText1);
         this._helperShowText2 = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperShowTxt2");
         addToContent(this._helperShowText2);
         this._helperShowTime = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperShowTime");
         addToContent(this._helperShowTime);
         this._helperSelSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperSelSeed");
         this._helperSelSeed.text = LanguageMgr.GetTranslation("ddt.farm.helperSelSeed.text");
         addToContent(this._helperSelSeed);
         this._helperSelTime = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperSelTime");
         this._helperSelTime.text = LanguageMgr.GetTranslation("ddt.farm.helperSeltime.text");
         addToContent(this._helperSelTime);
         this._needSeedText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperNeedSeedText");
         this._needSeedText.text = LanguageMgr.GetTranslation("ddt.farm.helperNeedSeed.text");
         addToContent(this._needSeedText);
         this._needSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperNeedSeed");
         addToContent(this._needSeed);
         this._getSeedText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperGetSeedText");
         this._getSeedText.text = LanguageMgr.GetTranslation("ddt.farm.helperGetSeed.text");
         addToContent(this._getSeedText);
         this._getSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperGetSeed");
         addToContent(this._getSeed);
         this._remainTime = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperRemainTime");
         this._remainTime.text = LanguageMgr.GetTranslation("ddt.farm.helperNeedTime.text");
         addToContent(this._remainTime);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helpBtn");
         this._helpBtn.text = LanguageMgr.GetTranslation("ddt.farm.helpBtn.text");
         addToContent(this._helpBtn);
         this._farmChoose = ComponentFactory.Instance.creatComponentByStylename("asset.farm.farmChoose");
         addToContent(this._farmChoose);
         this._timeChoose = ComponentFactory.Instance.creatComponentByStylename("asset.farm.timeChoose");
         addToContent(this._timeChoose);
         this.setComboxContent();
         this._timeText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperTimerText");
         addToContent(this._timeText);
         if(PlayerManager.Instance.Self.isFarmHelper)
         {
            this.setBtnEna(false);
            this.setTimes();
            this.setGetSeedCount();
         }
         this.setHelperTime();
         this._seedItemInfo = ShopManager.Instance.getValidSortedGoodsByType(ShopType.FARM_SEED_TYPE,1,this._farmChoose.listPanel.vectorListModel.size() + 1);
      }
      
      private function setHelperTime() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Date = null;
         if(FarmModelController.instance.model.isHelperMay || PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= FarmModelController.instance.model.vipLimitLevel)
         {
            if(PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= FarmModelController.instance.model.vipLimitLevel)
            {
               _loc1_ = PlayerManager.Instance.Self.VIPExpireDay as Date;
               this._helperShowTime.text = _loc1_.fullYear + "-" + (_loc1_.month + 1) + "-";
               this._helperShowTime.text += _loc1_.date + " " + this.fixZero(_loc1_.hours) + ":" + this.fixZero(_loc1_.minutes);
               this._helperShowText2.text = LanguageMgr.GetTranslation("ddt.farm.helperShow.text2");
            }
            else
            {
               _loc2_ = FarmModelController.instance.model.stopTime as Date;
               this._helperShowTime.text = _loc2_.fullYear + "-" + (_loc2_.month + 1) + "-";
               this._helperShowTime.text += _loc2_.date + " " + this.fixZero(_loc2_.hours) + ":" + this.fixZero(_loc2_.minutes);
               this._helperShowText2.text = LanguageMgr.GetTranslation("ddt.farm.helperShow.text2");
            }
         }
         else
         {
            this._helperShowTime.text = "";
            this._helperShowText2.text = "";
         }
      }
      
      private function setComboxContent() : void
      {
         if(!this._farmChoose)
         {
            //ConsoleLog.write("A" + this._farmChoose);
            //ConsoleLog.write(this._farmChoose.toString());
         }
         else if(!this._farmChoose.listPanel)
         {
            //ConsoleLog.write("B" + this._farmChoose.listPanel);
         }
         else if(!this._farmChoose.listPanel.vectorListModel)
         {
            //ConsoleLog.write("C" + this._farmChoose.listPanel.vectorListModel);
            //ConsoleLog.write(this._farmChoose.listPanel.vectorListModel.toString());
         }
         var _loc5_:String = null;
         var _loc6_:int = 0;
         this._farmChoose.beginChanges();
         this._farmChoose.selctedPropName = "text";
         var _loc1_:VectorListModel = this._farmChoose.listPanel.vectorListModel;
         _loc1_.clear();
         var _loc2_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         for(var _loc3_:int = 0; _loc3_ < _loc2_.length; _loc3_++)
         {
            if(_loc2_[_loc3_] && _loc2_[_loc3_].TemplateInfo.CategoryID == 32 && _loc2_[_loc3_].TemplateInfo.Property7 == "1")
            {
               if(PlayerManager.Instance.Self.VIPLevel < ServerConfigManager.instance.getPrivilegeMinLevel(ServerConfigManager.PRIVILEGE_CANBUYFERT) || !PlayerManager.Instance.Self.IsVIP)
               {
                  continue;
               }
            }
            if(PlayerManager.Instance.Self.Grade >= _loc2_[_loc3_].LimitGrade)
            {
               _loc5_ = _loc2_[_loc3_].TemplateInfo.Name;
               _loc6_ = _loc2_[_loc3_].TemplateID;
               this._listArray.push(_loc5_);
               this._listArrayID.push(_loc6_);
               this._listSeedNum.push(int(_loc2_[_loc3_].TemplateInfo.Property2));
               _loc1_.append(_loc5_);
               if(PlayerManager.Instance.Self.isFarmHelper && _loc2_[_loc3_].TemplateID == FarmModelController.instance.model.helperArray[1])
               {
                  this._farmChoose.textField.text = _loc2_[_loc3_].TemplateInfo.Name;
               }
            }
         }
         this._farmChoose.listPanel.list.updateListView();
         this._farmChoose.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._farmChoose.commitChanges();
         this._timeChoose.beginChanges();
         this._timeChoose.selctedPropName = "text";
         this._timeChoose.textField.text = "12" + LanguageMgr.GetTranslation("hour");
         var _loc4_:VectorListModel = this._timeChoose.listPanel.vectorListModel;
         _loc4_.clear();
         _loc4_.append(this._listTimeTextArray[0]);
         _loc4_.append(this._listTimeTextArray[1]);
         this._timeChoose.listPanel.list.updateListView();
         this._timeChoose.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick2);
         this._timeChoose.commitChanges();
      }
      
      private function setBtnEna(param1:Boolean = true) : void
      {
         if(this._onekeyStartBtn)
         {
            if(param1 == true)
            {
               if(this._listArrayID.length > 0)
               {
                  this._onekeyStartBtn.enable = param1;
               }
            }
            else
            {
               this._onekeyStartBtn.visible = param1;
            }
         }
         if(this._onekeyCloseBtn)
         {
            this._onekeyCloseBtn.visible = !param1;
         }
         if(this._farmChoose)
         {
            this._farmChoose.enable = param1;
            this._farmChoose.filters = param1 == true ? ComponentFactory.Instance.creatFilters("lightFilter") : ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(this._timeChoose)
         {
            this._timeChoose.enable = param1;
            this._timeChoose.filters = param1 == true ? ComponentFactory.Instance.creatFilters("lightFilter") : ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__closeFarmHelper);
         this._onekeyStartBtn.addEventListener(MouseEvent.CLICK,this.__onekeyStartClick);
         this._onekeyCloseBtn.addEventListener(MouseEvent.CLICK,this.__onekeyCloseClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpClick);
         this._farmChoose.button.addEventListener(MouseEvent.CLICK,this.__comBoxBtnClick);
         this._timeChoose.button.addEventListener(MouseEvent.CLICK,this.__comBoxBtnClick);
         FarmModelController.instance.addEventListener(FarmEvent.BEGIN_HELPER,this.__beginHelper);
         FarmModelController.instance.addEventListener(FarmEvent.STOP_HELPER,this.__stopHelper);
         FarmModelController.instance.addEventListener(FarmEvent.CONFIRM_STOP_HELPER,this.__confirmStopHelper);
         FarmModelController.instance.model.addEventListener(FarmEvent.PAY_HELPER,this.__showHelperTime);
      }
      
      private function __showHelperTime(param1:FarmEvent) : void
      {
         this.setHelperTime();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __closeFarmHelper(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function __beginHelper(param1:FarmEvent) : void
      {
         if(PlayerManager.Instance.Self.isFarmHelper)
         {
            this.setBtnEna(false);
            this.setTimes();
            this.setGetSeedCount();
         }
      }
      
      private function __stopHelper(param1:FarmEvent) : void
      {
         if(!PlayerManager.Instance.Self.isFarmHelper)
         {
            if(this._timer)
            {
               this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
            }
            if(this._timerSeed)
            {
               this._timerSeed.removeEventListener(TimerEvent.TIMER,this.__timerSeedHandler);
            }
            this.setBtnEna(true);
         }
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentID = this._listArrayID[param1.index];
         this._getSeedNumOne = this._listSeedNum[param1.index];
         this._onekeyStartBtn.enable = true;
         if(param1.cellValue == LanguageMgr.GetTranslation("farm.seed1"))
         {
            this._modelType = 0;
         }
         else if(param1.cellValue == LanguageMgr.GetTranslation("farm.seed3"))
         {
            this._modelType = 2;
         }
         else if(param1.cellValue == LanguageMgr.GetTranslation("farm.seed4"))
         {
            this._modelType = 3;
         }
         else
         {
            this._modelType = 1;
         }
         this._needSeed.text = this.getseedCountByID().toString();
         this._getSeed.text = this._getSeedNum.toString() + "/" + this._getSeedNum.toString();
      }
      
      private function __itemClick2(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentTime = this._listTimeArray[param1.index];
         this._needSeed.text = this.getseedCountByID().toString();
         this._getSeed.text = this._getSeedNum.toString() + "/" + this._getSeedNum.toString();
      }
      
      private function getseedCountByID() : int
      {
         var _loc6_:int = 0;
         var _loc1_:int = this.findSeedTimebyID(this._currentID);
         var _loc2_:int = 0;
         var _loc3_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         var _loc4_:int = 0;
         while(_loc4_ < FarmModelController.instance.model.fieldsInfo.length)
         {
            _loc6_ = (new Date().getTime() - _loc3_[_loc4_].payTime.getTime()) / (1000 * 60 * 60);
            if(_loc3_[_loc4_].fieldValidDate > _loc6_ || _loc3_[_loc4_].fieldValidDate == -1)
            {
               _loc2_++;
            }
            _loc4_++;
         }
         var _loc5_:int = int(_loc2_ * this._currentTime / _loc1_);
         this._getSeedNum = _loc2_ * this._currentTime / _loc1_ * this._getSeedNumOne;
         return _loc5_;
      }
      
      private function findSeedTimebyID(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._seedItemInfo.length)
         {
            if(this._currentID == this._seedItemInfo[_loc2_].TemplateID)
            {
               return int(this._seedItemInfo[_loc2_].TemplateInfo.Property3);
            }
            _loc2_++;
         }
         return 0;
      }
      
      private function __comBoxBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __onekeyStartClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._farmChoose.textField.text == null)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         if(FarmModelController.instance.model.isHelperMay || PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= FarmModelController.instance.model.vipLimitLevel)
         {
            _loc3_ = FarmModelController.instance.model.getSeedCountByID(this._currentID);
            _loc4_ = this.getseedCountByID();
            _loc5_ = 0;
            this._beginFrame = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperView.beginFrame");
            this._beginFrame.seedID = this._currentID;
            this._beginFrame.seedTime = this._currentTime;
            this._beginFrame.getCount = this._getSeedNum;
            this._beginFrame.modelType = this._modelType;
            this._beginFrame.needCount = _loc4_ > _loc3_ ? int(int(_loc4_ - _loc3_)) : int(int(0));
            this._beginFrame.haveCount = _loc3_ > _loc4_ ? int(int(_loc4_)) : int(int(_loc3_));
            this._beginFrame.show();
         }
         else
         {
            this._configmPnl = ComponentFactory.Instance.creatComponentByStylename("farm.confirmHelperMoneyAlertFrame");
            LayerManager.Instance.addToLayer(this._configmPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __onekeyCloseClick(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SoundManager.instance.play("008");
         this._stopHelpeCconfigm = ComponentFactory.Instance.creatComponentByStylename("farm.confirmStopHelperFrame");
         LayerManager.Instance.addToLayer(this._stopHelpeCconfigm,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __confirmStopHelper(param1:FarmEvent) : void
      {
         var _loc2_:Array = new Array();
         _loc2_.push(false);
         SocketManager.Instance.out.sendBeginHelper(_loc2_);
         this.dispose();
      }
      
      private function setTimes() : void
      {
         var _loc1_:Date = FarmModelController.instance.model.helperArray[2];
         var _loc2_:int = _loc1_.getTime() / 1000;
         var _loc3_:Date = TimeManager.Instance.Now();
         var _loc4_:int = _loc3_.getTime() / 1000;
         this._autoTime = FarmModelController.instance.model.helperArray[3] * 60;
         if(_loc4_ - _loc2_ < 0)
         {
            this._timeDiff = this._autoTime;
         }
         else
         {
            this._timeDiff = this._autoTime - (_loc4_ - _loc2_);
         }
         this._timer = new Timer(1000,int(this._timeDiff));
         this._timer.start();
         this._timerSeed = new Timer(60000);
         this._timerSeed.start();
         if(this._timeText == null)
         {
            this._timeText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperTimerText");
            addChild(this._timeText);
         }
         if(this._needSeed == null)
         {
            this._needSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperNeedSeed");
            addChild(this._needSeed);
         }
         this._needSeed.text = FarmModelController.instance.model.helperArray[4];
         this._timeChoose.textField.text = FarmModelController.instance.model.helperArray[3] / 60 + LanguageMgr.GetTranslation("hour");
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         this._timerSeed.addEventListener(TimerEvent.TIMER,this.__timerSeedHandler);
      }
      
      private function __timerSeedHandler(param1:TimerEvent) : void
      {
         this.setGetSeedCount();
      }
      
      private function setGetSeedCount() : void
      {
         if(this._getSeed == null)
         {
            this._getSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperGetSeed");
            addChild(this._getSeed);
         }
         this._getSeed.text = String(int((1 - this._timeDiff / this._autoTime) * FarmModelController.instance.model.helperArray[5])) + "/" + FarmModelController.instance.model.helperArray[5].toString();
      }
      
      private function __timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:Array = null;
         this._timeText.text = this.getTimeDiff(this._timeDiff);
         --this._timeDiff;
         if(this._timeDiff == 0)
         {
            _loc2_ = new Array();
            _loc2_.push(false);
            SocketManager.Instance.out.sendBeginHelper(_loc2_);
            this.dispose();
         }
      }
      
      private function getTimeDiff(param1:int) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1 >= 0)
         {
            _loc2_ = Math.floor(param1 / 60 / 60);
            param1 %= 60 * 60;
            _loc3_ = Math.floor(param1 / 60);
            param1 %= 60;
            _loc4_ = param1;
         }
         return this.fixZero(_loc2_) + ":" + this.fixZero(_loc3_) + ":" + this.fixZero(_loc4_);
      }
      
      private function fixZero(param1:uint) : String
      {
         return param1 < 10 ? "0" + String(param1) : String(param1);
      }
      
      private function __helpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("farm.helper.HelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("farm.helper.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("ddt.farm.helper.help.readme");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         this._onekeyStartBtn.removeEventListener(MouseEvent.CLICK,this.__onekeyStartClick);
         this._onekeyCloseBtn.removeEventListener(MouseEvent.CLICK,this.__onekeyCloseClick);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpClick);
         removeEventListener(FrameEvent.RESPONSE,this.__closeFarmHelper);
         this._farmChoose.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._timeChoose.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick2);
         FarmModelController.instance.removeEventListener(FarmEvent.BEGIN_HELPER,this.__beginHelper);
         FarmModelController.instance.removeEventListener(FarmEvent.STOP_HELPER,this.__stopHelper);
         FarmModelController.instance.removeEventListener(FarmEvent.CONFIRM_STOP_HELPER,this.__confirmStopHelper);
         FarmModelController.instance.model.removeEventListener(FarmEvent.PAY_HELPER,this.__showHelperTime);
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
         }
      }
      
      private function removeItem() : void
      {
         if(this._onekeyStartBtn)
         {
            ObjectUtils.disposeObject(this._onekeyStartBtn);
         }
         this._onekeyStartBtn = null;
         if(this._onekeyCloseBtn)
         {
            ObjectUtils.disposeObject(this._onekeyCloseBtn);
         }
         this._onekeyCloseBtn = null;
         if(this._helperShowText1)
         {
            ObjectUtils.disposeObject(this._helperShowText1);
         }
         this._helperShowText1 = null;
         if(this._helperShowText2)
         {
            ObjectUtils.disposeObject(this._helperShowText2);
         }
         this._helperShowText2 = null;
         if(this._helperShowTime)
         {
            ObjectUtils.disposeObject(this._helperShowTime);
         }
         this._helperShowTime = null;
         if(this._farmChoose)
         {
            ObjectUtils.disposeObject(this._farmChoose);
         }
         this._farmChoose = null;
         if(this._timeChoose)
         {
            ObjectUtils.disposeObject(this._timeChoose);
         }
         this._timeChoose = null;
         if(this._farmNumChoose)
         {
            ObjectUtils.disposeObject(this._farmNumChoose);
         }
         this._farmNumChoose = null;
         if(this._listArray)
         {
            ObjectUtils.disposeObject(this._listArray);
         }
         this._listArray = null;
         if(this._helperSelSeed)
         {
            ObjectUtils.disposeObject(this._helperSelSeed);
         }
         this._helperSelTime = null;
         if(this._helperSelTime)
         {
            ObjectUtils.disposeObject(this._helperSelTime);
         }
         this._helperSelTime = null;
         if(this._needSeed)
         {
            ObjectUtils.disposeObject(this._needSeed);
         }
         this._needSeed = null;
         if(this._needSeedText)
         {
            ObjectUtils.disposeObject(this._needSeedText);
         }
         this._needSeedText = null;
         if(this._getSeedText)
         {
            ObjectUtils.disposeObject(this._getSeedText);
         }
         this._getSeedText = null;
         if(this._getSeed)
         {
            ObjectUtils.disposeObject(this._getSeed);
         }
         this._getSeed = null;
         if(this._remainTime)
         {
            ObjectUtils.disposeObject(this._remainTime);
         }
         this._remainTime = null;
         if(this._helperFramBg1)
         {
            ObjectUtils.disposeObject(this._helperFramBg1);
         }
         this._helperFramBg1 = null;
         if(this._helperFramBg2)
         {
            ObjectUtils.disposeObject(this._helperFramBg2);
         }
         this._helperFramBg2 = null;
         if(this._beginFrame)
         {
            ObjectUtils.disposeObject(this._beginFrame);
         }
         this._beginFrame = null;
         if(this._timer)
         {
            ObjectUtils.disposeObject(this._timer);
         }
         this._timer = null;
         if(this._timeText)
         {
            ObjectUtils.disposeObject(this._timeText);
         }
         this._timeText = null;
         if(this._configmPnl)
         {
            this._configmPnl.dispose();
         }
         this._configmPnl = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeItem();
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
