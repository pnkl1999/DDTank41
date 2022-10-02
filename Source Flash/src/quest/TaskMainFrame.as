package quest
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.events.TaskEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import tryonSystem.TryonSystemController;
   import vip.VipController;
   
   public class TaskMainFrame extends Frame
   {
      
      public static const NORMAL:int = 1;
      
      public static const GUIDE:int = 2;
      
      public static const REWARD_UDERLINE:int = 417;
      
      public static const TASK_FRAME_HIDE:String = "taskFrameHide";
      
      private static const SPINEL:int = 11555;
       
      
      private const CATEVIEW_X:int = 30;
      
      private const CATEVIEW_Y:int = 45;
      
      private const CATEVIEW_H:int = 40;
      
      private var cateViewArr:Array;
      
      private var infoView:QuestInfoPanelView;
      
      private var rewardView:QuestRewardView;
      
      private var _questBtn:SimpleBitmapButton;
      
      private var _questBtnShine:MovieClip;
      
      private var _goDungeonBtnShine:MovieClip;
      
      private var _buySpinelBtn:SimpleBitmapButton;
      
      private var _opened:Boolean = false;
      
      private var _currentCateView:QuestCateView;
      
      public var currentNewCateView:QuestCateView;
      
      private var _mainFrameBG:Scale9CornerImage;
      
      private var _leftBGStyleNormal:Bitmap;
      
      private var _leftBGStyleGuide:Scale9CornerImage;
      
      private var _rightBGStyleNormal:Scale9CornerImage;
      
      private var _rightBGStyleGuide:Scale9CornerImage;
      
      private var _leaf:Bitmap;
      
      private var _goDungeonBtn:SimpleBitmapButton;
      
      private var _downloadClientBtn:MovieClip;
      
      private var _gotoAcademy:SimpleBitmapButton;
      
      private var _mcTaskTarget:MovieClip;
      
      private var _timer:Timer;
      
      private var _style:int;
      
      private var _quick:QuickBuyFrame;
      
      public function TaskMainFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      override public function get width() : Number
      {
         return _container.width;
      }
      
      override public function get height() : Number
      {
         return _container.height;
      }
      
      private function initView() : void
      {
         this._mainFrameBG = ComponentFactory.Instance.creatComponentByStylename("asset.quest.TaskMainFrameBG");
         addToContent(this._mainFrameBG);
         this.initStyleNormalBG();
         this.initStyleGuideBG();
         this.addQuestList();
         this.infoView = new QuestInfoPanelView();
         PositionUtils.setPos(this.infoView,"quest.infoPanelPos");
         addToContent(this.infoView);
         this.rewardView = new QuestRewardView();
         PositionUtils.setPos(this.rewardView,"quest.rewardPanelPos");
         addToContent(this.rewardView);
         this._questBtn = ComponentFactory.Instance.creat("core.quest.BtnQuestOver");
         addToContent(this._questBtn);
         this._questBtn.enable = false;
         this._questBtnShine = ComponentFactory.Instance.creat("asset.core.quest.QuestOverBtnShine");
         this._questBtnShine.mouseEnabled = this._questBtnShine.mouseChildren = false;
         PositionUtils.setPos(this._questBtnShine,"QuestOverBtnShine.Pos");
         this._questBtnShine.visible = false;
         addToContent(this._questBtnShine);
         this._goDungeonBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.GoDungeonBtn");
         addToContent(this._goDungeonBtn);
         this._goDungeonBtnShine = ComponentFactory.Instance.creat("asset.core.quest.GoDungeonBtnShine");
         this._goDungeonBtnShine.mouseEnabled = this._questBtnShine.mouseChildren = false;
         this._goDungeonBtnShine.x = this._goDungeonBtn.x + 7;
         this._goDungeonBtnShine.y = this._goDungeonBtn.y - 2;
         this._goDungeonBtnShine.visible = false;
         addToContent(this._goDungeonBtnShine);
         this._goDungeonBtn.visible = this._goDungeonBtnShine.visible = false;
         this._gotoAcademy = ComponentFactory.Instance.creatComponentByStylename("core.quest.gotoAcademyBtn");
         addToContent(this._gotoAcademy);
         this._gotoAcademy.visible = false;
         this._downloadClientBtn = ComponentFactory.Instance.creat("core.quest.DownloadClientBtn");
         addToContent(this._downloadClientBtn);
         this._downloadClientBtn.visible = false;
         this._buySpinelBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.buySpinelBtn");
         addToContent(this._buySpinelBtn);
         this._buySpinelBtn.visible = false;
         addToContent(this._leaf);
         titleText = LanguageMgr.GetTranslation("tank.game.ToolStripView.task");
         this.showStyle(NORMAL);
      }
      
      private function initStyleNormalBG() : void
      {
         this._leftBGStyleNormal = ComponentFactory.Instance.creatBitmap("asset.core.quest.leftBGStyle1");
         this._rightBGStyleNormal = ComponentFactory.Instance.creatComponentByStylename("asset.quest.rightBGStyle1");
         addToContent(this._leftBGStyleNormal);
         addToContent(this._rightBGStyleNormal);
      }
      
      private function initStyleGuideBG() : void
      {
         this._leftBGStyleGuide = ComponentFactory.Instance.creatComponentByStylename("asset.quest.leftBGStyle2");
         this._rightBGStyleGuide = ComponentFactory.Instance.creatComponentByStylename("asset.quest.rightBGStyle2");
         this._leaf = ComponentFactory.Instance.creatBitmap("asset.core.quest.styleGuideleaf");
         addToContent(this._leftBGStyleGuide);
         addToContent(this._rightBGStyleGuide);
      }
      
      private function switchBG(param1:int) : void
      {
         this._leftBGStyleNormal.visible = this._rightBGStyleNormal.visible = param1 == NORMAL ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         this._leaf.visible = this._leftBGStyleGuide.visible = this._rightBGStyleGuide.visible = param1 == GUIDE ? Boolean(Boolean(true)) : Boolean(Boolean(false));
      }
      
      private function addQuestList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:QuestCateView = null;
         if(this.cateViewArr)
         {
            return;
         }
         this.cateViewArr = new Array();
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = new QuestCateView(_loc1_);
            _loc2_.collapse();
            _loc2_.x = this.CATEVIEW_X;
            _loc2_.y = this.CATEVIEW_Y + this.CATEVIEW_H * _loc1_;
            _loc2_.addEventListener(QuestCateView.TITLECLICKED,this.__onTitleClicked);
            _loc2_.addEventListener(Event.CHANGE,this.__onCateViewChange);
            _loc2_.addEventListener(QuestCateView.ENABLE_CHANGE,this.__onEnbleChange);
            this.cateViewArr.push(_loc2_);
            addToContent(_loc2_);
            _loc1_++;
         }
         this.__onEnbleChange(null);
      }
      
      private function __onEnbleChange(param1:Event) : void
      {
         var _loc4_:QuestCateView = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 6)
         {
            _loc4_ = this.cateViewArr[_loc3_];
            if(_loc4_.visible)
            {
               _loc4_.y = this.CATEVIEW_Y + this.CATEVIEW_H * _loc2_;
               _loc2_++;
            }
            _loc3_++;
         }
      }
      
      private function addEvent() : void
      {
         TaskManager.addEventListener(TaskEvent.CHANGED,this.__onDataChanged);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._questBtn.addEventListener(MouseEvent.CLICK,this.__onQuestBtnClicked);
         this._goDungeonBtn.addEventListener(MouseEvent.CLICK,this.__onGoDungeonClicked);
         this._gotoAcademy.addEventListener(MouseEvent.CLICK,this.__gotoAcademy);
         this._downloadClientBtn.addEventListener(MouseEvent.CLICK,this.__downloadClient);
         this._buySpinelBtn.addEventListener(MouseEvent.CLICK,this.__buySpinelClick);
      }
      
      private function removeEvent() : void
      {
         TaskManager.removeEventListener(TaskEvent.CHANGED,this.__onDataChanged);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._questBtn.removeEventListener(MouseEvent.CLICK,this.__onQuestBtnClicked);
         this._goDungeonBtn.removeEventListener(MouseEvent.CLICK,this.__onGoDungeonClicked);
         this._gotoAcademy.removeEventListener(MouseEvent.CLICK,this.__gotoAcademy);
         this._downloadClientBtn.removeEventListener(MouseEvent.CLICK,this.__downloadClient);
         this._buySpinelBtn.removeEventListener(MouseEvent.CLICK,this.__buySpinelClick);
      }
      
      private function __onDataChanged(param1:TaskEvent) : void
      {
         var _loc2_:uint = 0;
         if(!this._currentCateView || this.currentNewCateView != null)
         {
            return;
         }
         if(this._currentCateView.active())
         {
            return;
         }
         _loc2_ = 0;
         while(!(this.cateViewArr[_loc2_] as QuestCateView).active())
         {
            _loc2_++;
            if(_loc2_ == 4)
            {
               return;
            }
         }
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               TaskManager.switchVisible();
			   break;
         }
      }
      
      public function jumpToQuest(param1:QuestInfo) : void
      {
         if(param1.MapID > 0)
         {
            this.showOtherBtn(param1);
         }
         else if(param1.id == 319 || param1.id == 537)
         {
            this.showArrowView(param1);
         }
         else
         {
            this._goDungeonBtnShine.visible = false;
            this._goDungeonBtn.visible = false;
            this._gotoAcademy.visible = false;
            this._downloadClientBtn.visible = false;
            this._questBtn.visible = true;
            this._buySpinelBtn.visible = this.existRewardId(param1,SPINEL);
            this.showStyle(NORMAL);
            this.hideGuide();
         }
         this.infoView.info = param1;
         this.rewardView.info = param1;
         this.rewardView.y = REWARD_UDERLINE - this.rewardView.height + 40;
         this.infoView.height = REWARD_UDERLINE - this.rewardView.height - 15;
         this.showQuestOverBtn(param1.isCompleted);
      }
      
      private function showQuestOverBtn(param1:Boolean) : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.GET_REWARD);
         if(param1)
         {
            this._questBtn.enable = true;
            this._questBtnShine.gotoAndPlay(1);
            this._questBtn.visible = this._questBtnShine.visible = true;
            this._goDungeonBtn.visible = this._goDungeonBtnShine.visible = false;
            this._gotoAcademy.visible = false;
            if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER) && !TaskManager.getQuestByID(318).isCompleted)
            {
               NewHandContainer.Instance.showArrow(ArrowType.GET_REWARD,45,"trainer.getTaskRewardArrowPos","asset.trainer.txtGetReward","trainer.getTaskRewardTipPos",this);
            }
         }
         else
         {
            this._questBtn.enable = false;
            this._questBtnShine.visible = false;
            this._questBtnShine.stop();
         }
      }
      
      private function showOtherBtn(param1:QuestInfo) : void
      {
         if(param1.MapID > 0)
         {
            if(param1.MapID == 2)
            {
               this._gotoAcademy.visible = true;
               this._goDungeonBtn.visible = this._goDungeonBtnShine.visible = false;
               this._downloadClientBtn.visible = false;
               this._questBtn.visible = false;
               this._buySpinelBtn.visible = false;
            }
            else if(param1.MapID == 3)
            {
               this._downloadClientBtn.visible = true;
               this._gotoAcademy.visible = false;
               this._goDungeonBtn.visible = this._goDungeonBtnShine.visible = false;
               this._buySpinelBtn.visible = false;
            }
            else
            {
               this.showStyle(GUIDE);
               this._goDungeonBtn.visible = this._goDungeonBtnShine.visible = true;
               this._goDungeonBtn.enable = !param1.isCompleted;
               this._goDungeonBtnShine.visible = this._goDungeonBtn.enable;
               this._gotoAcademy.visible = false;
               this._downloadClientBtn.visible = false;
               this._questBtn.visible = false;
               this._buySpinelBtn.visible = false;
            }
         }
         else
         {
            this._gotoAcademy.visible = false;
            this._downloadClientBtn.visible = false;
            this._goDungeonBtn.visible = this._goDungeonBtnShine.visible = false;
            this._buySpinelBtn.visible = this.existRewardId(param1,SPINEL);
         }
         if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER) && PlayerManager.Instance.Self.Grade < 2 && this._goDungeonBtn.visible && this._goDungeonBtn.enable)
         {
            this.showGuide();
         }
      }
      
      private function showArrowView(param1:QuestInfo) : void
      {
         if(this._questBtn.enable == false && TaskManager.isAchieved(TaskManager.getQuestByID(318)) && !TaskManager.isAchieved(TaskManager.getQuestByID(319)) && !param1.isCompleted)
         {
            NewHandContainer.Instance.showArrow(ArrowType.BACK_TASKMAINFRAME,-90,"trainer.clickTaskBackArrowPos","","",this);
         }
         else if(this._questBtn.enable == false && !TaskManager.getQuestByID(537).isCompleted && TaskManager.isAchieved(TaskManager.getQuestByID(319)) && !TaskManager.isAchieved(TaskManager.getQuestByID(537)) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER) && !param1.isCompleted)
         {
            NewHandContainer.Instance.showArrow(ArrowType.BACK_TASKMAINFRAME,-90,"trainer.clickTaskBackArrowPos","","",this);
         }
      }
      
      private function existRewardId(param1:QuestInfo, param2:int) : Boolean
      {
         var _loc3_:QuestItemReward = null;
         for each(_loc3_ in param1.itemRewards)
         {
            if(_loc3_.itemID == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      private function showGuide() : void
      {
         this.hideGuide();
         if(!this._mcTaskTarget)
         {
            this._mcTaskTarget = ComponentFactory.Instance.creatCustomObject("trainer.mcTaskTarget");
         }
         if(!this._timer)
         {
            this._timer = new Timer(4000,1);
         }
         addChild(this._mcTaskTarget);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this._timer.start();
      }
      
      private function __timer(param1:TimerEvent) : void
      {
         this.resetTimer();
         removeChild(this._mcTaskTarget);
         NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAT,0,"trainer.clickBeatArrowPos","asset.trainer.txtClickBeat","trainer.clickBeatTipPos",this);
      }
      
      private function resetTimer() : void
      {
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
            this._timer.stop();
            this._timer.reset();
         }
      }
      
      private function hideGuide() : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAT);
         this.resetTimer();
         if(this._mcTaskTarget && this._mcTaskTarget.parent)
         {
            removeChild(this._mcTaskTarget);
         }
      }
      
      private function showStyle(param1:int) : void
      {
         if(this._style == param1)
         {
            return;
         }
         this._style = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.cateViewArr.length)
         {
            (this.cateViewArr[_loc2_] as QuestCateView).taskStyle = param1;
            _loc2_++;
         }
         this.switchBG(param1);
         this.rewardView.taskStyle = param1;
         this.infoView.taskStyle = param1;
      }
      
      private function __onCateViewChange(param1:Event) : void
      {
         var _loc4_:QuestCateView = null;
         var _loc2_:int = 42;
         var _loc3_:int = 0;
         while(_loc3_ < this.cateViewArr.length)
         {
            _loc4_ = this.cateViewArr[_loc3_] as QuestCateView;
            if(_loc4_.visible)
            {
               _loc4_.y = _loc2_;
               _loc2_ += _loc4_.contentHeight;
            }
            _loc3_++;
         }
      }
      
      private function __onTitleClicked(param1:Event) : void
      {
         var _loc4_:QuestCateView = null;
         if(!parent || this.currentNewCateView != null)
         {
            return;
         }
         if(this._currentCateView != param1.target as QuestCateView)
         {
         }
         this._currentCateView = param1.target as QuestCateView;
         var _loc2_:int = this.CATEVIEW_Y;
         var _loc3_:int = 0;
         while(_loc3_ < this.cateViewArr.length)
         {
            _loc4_ = this.cateViewArr[_loc3_] as QuestCateView;
            if(_loc4_ != this._currentCateView)
            {
               _loc4_.collapse();
            }
            if(_loc4_.visible)
            {
               _loc4_.y = _loc2_;
               _loc2_ += _loc4_.contentHeight;
            }
            _loc3_++;
         }
         if(this._currentCateView.questType == 4)
         {
            if(!PlayerManager.Instance.Self.IsVIP)
            {
               VipController.instance.show();
            }
         }
      }
      
      public function switchVisible() : void
      {
         if(parent)
         {
            this.dispose();
         }
         else
         {
            this._show();
         }
      }
      
      private function _show() : void
      {
         if(this._opened == true)
         {
            this.dispose();
         }
         this._opened = true;
         MainToolBar.Instance.unReadTask = false;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function open() : void
      {
         if(!this._opened)
         {
            this._show();
         }
      }
      
      private function __onQuestBtnClicked(param1:MouseEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:QuestItemReward = null;
         var _loc5_:InventoryItemInfo = null;
         if(!this.infoView.info)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc2_:QuestInfo = this.infoView.info;
         if(_loc2_ && !_loc2_.isCompleted)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.dropTaskIII"));
            this._currentCateView.active();
            return;
         }
         if(TaskManager.itemAwardSelected == -1)
         {
            _loc3_ = [];
            for each(_loc4_ in _loc2_.itemRewards)
            {
               _loc5_ = new InventoryItemInfo();
               _loc5_.TemplateID = _loc4_.itemID;
               ItemManager.fill(_loc5_);
               _loc5_.ValidDate = _loc4_.ValidateTime;
               _loc5_.TemplateID = _loc4_.itemID;
               _loc5_.IsJudge = true;
               _loc5_.IsBinds = _loc4_.isBind;
               _loc5_.AttackCompose = _loc4_.AttackCompose;
               _loc5_.DefendCompose = _loc4_.DefendCompose;
               _loc5_.AgilityCompose = _loc4_.AgilityCompose;
               _loc5_.LuckCompose = _loc4_.LuckCompose;
               _loc5_.StrengthenLevel = _loc4_.StrengthenLevel;
               _loc5_.Count = _loc4_.count;
               if(!(0 != _loc5_.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != _loc5_.NeedSex))
               {
                  if(_loc4_.isOptional == 1)
                  {
                     _loc3_.push(_loc5_);
                  }
               }
            }
            TryonSystemController.Instance.show(_loc3_,this.chooseReward,this.cancelChoose);
            return;
         }
         if(this.infoView.info)
         {
            TaskManager.sendQuestFinish(this.infoView.info.QuestID);
            if(TaskManager.isAchieved(TaskManager.getQuestByID(318)) && TaskManager.isAchieved(TaskManager.getQuestByID(319)))
            {
               SocketManager.Instance.out.syncWeakStep(Step.ACHIVED_THREE_QUEST);
            }
         }
      }
      
      private function getSexByInt(param1:Boolean) : int
      {
         if(param1)
         {
            return 1;
         }
         return 2;
      }
      
      private function chooseReward(param1:ItemTemplateInfo) : void
      {
         SocketManager.Instance.out.sendQuestFinish(this.infoView.info.QuestID,param1.TemplateID);
         TaskManager.itemAwardSelected = -1;
      }
      
      private function cancelChoose() : void
      {
         TaskManager.itemAwardSelected = -1;
      }
      
      private function __onGoDungeonClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         if(this.infoView.info.MapID > 0)
         {
            NewHandGuideManager.Instance.mapID = this.infoView.info.MapID;
            if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM)
            {
               StateManager.setState(StateType.ROOM_LIST);
            }
            setTimeout(SocketManager.Instance.out.createUserGuide,500);
         }
      }
      
      private function __gotoAcademy(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AcademyManager.Instance.gotoAcademyState();
      }
      
      private function __downloadClient(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         navigateToURL(new URLRequest(PathManager.solveClientDownloadPath()));
      }
      
      private function __buySpinelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:ShopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(SPINEL);
         if(PlayerManager.Instance.Self.Money < _loc2_.getItemPrice(1).moneyValue)
         {
            LeavePageManager.showFillFrame();
         }
         else
         {
            this._quick = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            this._quick.itemID = SPINEL;
            this._quick.buyFrom = 7;
            this._quick.maxLimit = 3;
            LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      override protected function __onAddToStage(param1:Event) : void
      {
         var _loc5_:QuestCateView = null;
         var _loc6_:QuestCateView = null;
         super.__onAddToStage(param1);
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.cateViewArr.length)
         {
            _loc5_ = this.cateViewArr[_loc3_] as QuestCateView;
            _loc5_.initData();
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.cateViewArr.length)
         {
            _loc6_ = this.cateViewArr[_loc4_] as QuestCateView;
            _loc6_.initData();
            if(_loc6_.data.haveCompleted)
            {
               _loc6_.active();
               return;
            }
            if(_loc6_.length > 0 && _loc2_ < 0)
            {
               _loc2_ = _loc4_;
               _loc6_.active();
            }
            _loc4_++;
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:QuestCateView = null;
         this.hideGuide();
         this.removeEvent();
         this._currentCateView = null;
         this.currentNewCateView = null;
         while(_loc1_ = this.cateViewArr.pop())
         {
            _loc1_.removeEventListener(QuestCateView.TITLECLICKED,this.__onTitleClicked);
            _loc1_.removeEventListener(QuestCateView.ENABLE_CHANGE,this.__onEnbleChange);
            _loc1_.removeEventListener(Event.CHANGE,this.__onCateViewChange);
            _loc1_.dispose();
            _loc1_ = null;
         }
         if(this._quick && this._quick.canDispose)
         {
            this._quick.dispose();
         }
         this._quick = null;
         if(this.rewardView)
         {
            this.rewardView.dispose();
         }
         this.rewardView = null;
         if(this.infoView)
         {
            this.infoView.dispose();
         }
         this.infoView = null;
         if(this._questBtn)
         {
            ObjectUtils.disposeObject(this._questBtn);
         }
         this._questBtn = null;
         if(this._questBtnShine)
         {
            ObjectUtils.disposeObject(this._questBtnShine);
         }
         this._questBtnShine = null;
         if(this._goDungeonBtnShine)
         {
            ObjectUtils.disposeObject(this._goDungeonBtnShine);
         }
         this._goDungeonBtnShine = null;
         if(this._mcTaskTarget)
         {
            ObjectUtils.disposeObject(this._mcTaskTarget);
         }
         this._mcTaskTarget = null;
         if(this._leftBGStyleNormal)
         {
            ObjectUtils.disposeObject(this._leftBGStyleNormal);
         }
         this._leftBGStyleNormal = null;
         if(this._leftBGStyleGuide)
         {
            ObjectUtils.disposeObject(this._leftBGStyleGuide);
         }
         this._leftBGStyleGuide = null;
         if(this._rightBGStyleNormal)
         {
            ObjectUtils.disposeObject(this._rightBGStyleNormal);
         }
         this._rightBGStyleNormal = null;
         if(this._rightBGStyleGuide)
         {
            ObjectUtils.disposeObject(this._rightBGStyleGuide);
         }
         this._rightBGStyleGuide = null;
         if(this._leaf)
         {
            ObjectUtils.disposeObject(this._leaf);
         }
         this._leaf = null;
         if(this._goDungeonBtn)
         {
            ObjectUtils.disposeObject(this._goDungeonBtn);
         }
         this._goDungeonBtn = null;
         if(this._downloadClientBtn)
         {
            ObjectUtils.disposeObject(this._downloadClientBtn);
         }
         this._downloadClientBtn = null;
         if(this._gotoAcademy)
         {
            ObjectUtils.disposeObject(this._gotoAcademy);
         }
         this._gotoAcademy = null;
         if(this._mainFrameBG)
         {
            ObjectUtils.disposeObject(this._mainFrameBG);
         }
         this._mainFrameBG = null;
         this._opened = false;
         this._timer = null;
         TaskManager.selectedQuest = null;
         TaskManager.isShow = false;
         TaskManager.clearNewQuest();
         NewHandContainer.Instance.clearArrowByID(ArrowType.GET_REWARD);
         NewHandContainer.Instance.clearArrowByID(ArrowType.BACK_TASKMAINFRAME);
         MainToolBar.Instance.tipTask();
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(TaskMainFrame.TASK_FRAME_HIDE));
      }
   }
}
