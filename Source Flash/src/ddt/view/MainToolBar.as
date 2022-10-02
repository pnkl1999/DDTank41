package ddt.view
{
	import bagAndInfo.BagAndInfoManager;
	import com.pickgliss.effect.EffectManager;
	import com.pickgliss.effect.EffectTypes;
	import com.pickgliss.effect.IEffect;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.LayerManager;
	import com.pickgliss.ui.controls.BaseButton;
	import com.pickgliss.ui.controls.container.HBox;
	import ddt.bagStore.BagStore;
	import ddt.manager.KeyboardShortcutsManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.LeavePageManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SoundManager;
	import ddt.manager.StateManager;
	import ddt.manager.TaskManager;
	import ddt.states.StateType;
	import email.manager.MailManager;
	import email.view.EmailEvent;
	import farm.FarmModelController;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import gotopage.view.GotoPageController;
	import im.IMController;
	import quest.QuestBubbleManager;
	import setting.controll.SettingController;
	import trainer.controller.WeakGuildManager;
	import trainer.data.ArrowType;
	import trainer.data.Step;
	import trainer.view.NewHandContainer;
	
	public class MainToolBar extends Sprite
	{
		
		private static var _instance:MainToolBar;
		
		
		private var _goSupplyBtn:BaseButton;
		
		private var _goShopBtn:BaseButton;
		
		private var _goBagBtn:BaseButton;
		
		private var _goEmailBtn:BaseButton;
		
		private var _goTaskBtn:BaseButton;
		
		private var _goFriendListBtn:BaseButton;
		
		private var _goSettingBtn:BaseButton;
		
		private var _goChannelBtn:BaseButton;
		
		private var _goReturnBtn:BaseButton;
		
		private var _callBackFun:Function;
		
		private var _unReadEmail:Boolean;
		
		private var _unReadTask:Boolean;
		
		private var _enabled:Boolean;
		
		private var _unReadMovement:Boolean;
		
		private var _bagEffectEnable:Boolean;
		
		private var _taskEffectEnable:Boolean;
		
		private var _returnEffectEnable:Boolean;
		
		private var _boxContainer:HBox;
		
		private var allBtns:Array;
		
		private var _emailShineEffect:IEffect;
		
		private var _taskShineEffect:IEffect;
		
		private var _bagShineEffect:IEffect;
		
		private var _returnShineEffect:IEffect;
		
		public function MainToolBar()
		{
			super();
			this.initView();
		}
		
		public static function get Instance() : MainToolBar
		{
			if(_instance == null)
			{
				_instance = new MainToolBar();
			}
			return _instance;
		}
		
		public function initView() : void
		{
			this._goSupplyBtn = ComponentFactory.Instance.creat("toolbar.gochargebtn");
			this._goShopBtn = ComponentFactory.Instance.creat("toolbar.goshopbtn");
			this._goBagBtn = ComponentFactory.Instance.creat("toolbar.gobagbtn");
			this._goEmailBtn = ComponentFactory.Instance.creat("toolbar.goemailbtn");
			this._goTaskBtn = ComponentFactory.Instance.creat("toolbar.gotaskbtn");
			this._goFriendListBtn = ComponentFactory.Instance.creat("toolbar.goimbtn");
			this._goSettingBtn = ComponentFactory.Instance.creat("toolbar.gosettingbtn");
			this._goChannelBtn = ComponentFactory.Instance.creat("toolbar.turntobtn");
			this._goReturnBtn = ComponentFactory.Instance.creat("toolbar.gobackbtn");
			this._goShopBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.shop");
			this._goBagBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.bag");
			this._goEmailBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.email");
			this._goTaskBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.task");
			this._goFriendListBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.friend");
			this._goSettingBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.set");
			this._goChannelBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.channel");
			this._goReturnBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.back");
			this.allBtns = [];
			this.allBtns.push(this._goShopBtn);
			this.allBtns.push(this._goBagBtn);
			this.allBtns.push(this._goEmailBtn);
			this.allBtns.push(this._goTaskBtn);
			this.allBtns.push(this._goFriendListBtn);
			this.allBtns.push(this._goSettingBtn);
			this.allBtns.push(this._goChannelBtn);
			this.allBtns.push(this._goReturnBtn);
			this.allBtns.push(this._goSupplyBtn);
			var _loc1_:uint = 0;
			while(_loc1_ < this.allBtns.length)
			{
				addChild(this.allBtns[_loc1_]);
				_loc1_++;
			}
			var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("toolbar.emailShineIconPos");
			var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("toolbar.taskShineIconPos");
			var _loc4_:Point = ComponentFactory.Instance.creatCustomObject("toolbar.bagShineIconPos");
			var _loc5_:Point = ComponentFactory.Instance.creatCustomObject("toolbar.ShineAssetPos");
			this._emailShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goEmailBtn,"asset.toolbar.emailBtnAsset2","asset.toolbar.GlowAniAccect",_loc2_,_loc5_);
			if(MailManager.Instance.Model.hasUnReadEmail())
			{
				this._emailShineEffect.play();
				this._unReadEmail = true;
			}
			else
			{
				this._emailShineEffect.stop();
				this._unReadEmail = false;
			}
			this._taskShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goTaskBtn,"asset.toolbar.tasklBtnAsset2","asset.toolbar.GlowAniAccect",_loc3_,_loc5_);
			this._bagShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goBagBtn,"asset.toolbar.bagBtnAsset","asset.toolbar.GlowAniAccect",_loc4_,_loc5_);
			this._returnShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goReturnBtn,"asset.toolbar.returnBtnAsset","asset.toolbar.GlowAniAccect",_loc4_,_loc5_);
		}
		
		public function enableAll() : void
		{
			KeyboardShortcutsManager.Instance.forbiddenSection(1,true);
			this.enabled = true;
			this.setShopBtnEnable(true);
			this.setBagEnable(true);
			this._goEmailBtn.enable = true;
			this._goTaskBtn.enable = true;
			this.setFriendBtnEnable(true);
			this._goSettingBtn.enable = true;
			this._goChannelBtn.enable = true;
			this._goReturnBtn.enable = true;
			this.setSupplyBtnEnable(true);
			this.updateEmail();
		}
		
		public function disableAll() : void
		{
			this.enabled = false;
			this.setShopBtnEnable(false);
			this.setBagEnable(false);
			this._goEmailBtn.enable = false;
			this._goTaskBtn.enable = false;
			this.setFriendBtnEnable(false);
			this._goSettingBtn.enable = false;
			this._goChannelBtn.enable = false;
			this._goReturnBtn.enable = false;
			this.setSupplyBtnEnable(false);
		}
		
		private function initEvent() : void
		{
			this._goSupplyBtn.addEventListener(MouseEvent.CLICK,this.__onSupplyClick);
			this._goShopBtn.addEventListener(MouseEvent.CLICK,this.__onShopClick);
			this._goBagBtn.addEventListener(MouseEvent.CLICK,this.__onBagClick);
			this._goEmailBtn.addEventListener(MouseEvent.CLICK,this.__onEmailClick);
			this._goTaskBtn.addEventListener(MouseEvent.CLICK,this.__onTaskClick);
			this._goFriendListBtn.addEventListener(MouseEvent.CLICK,this.__onImClick);
			this._goSettingBtn.addEventListener(MouseEvent.CLICK,this.__onSettingClick);
			this._goChannelBtn.addEventListener(MouseEvent.CLICK,this.__onChannelClick);
			this._goReturnBtn.addEventListener(MouseEvent.CLICK,this.__onReturnClick);
			MailManager.Instance.Model.addEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
		}
		
		public function set backFunction(param1:Function) : void
		{
			this._callBackFun = param1;
		}
		
		private function removeEvent() : void
		{
			this._goSupplyBtn.removeEventListener(MouseEvent.CLICK,this.__onSupplyClick);
			this._goShopBtn.removeEventListener(MouseEvent.CLICK,this.__onShopClick);
			this._goBagBtn.removeEventListener(MouseEvent.CLICK,this.__onBagClick);
			this._goEmailBtn.removeEventListener(MouseEvent.CLICK,this.__onEmailClick);
			this._goTaskBtn.removeEventListener(MouseEvent.CLICK,this.__onTaskClick);
			this._goFriendListBtn.removeEventListener(MouseEvent.CLICK,this.__onImClick);
			this._goSettingBtn.removeEventListener(MouseEvent.CLICK,this.__onSettingClick);
			this._goChannelBtn.removeEventListener(MouseEvent.CLICK,this.__onChannelClick);
			this._goReturnBtn.removeEventListener(MouseEvent.CLICK,this.__onReturnClick);
			MailManager.Instance.Model.addEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
		}
		
		public function show() : void
		{
			this.initEvent();
			this.enableAll();
			LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
			this.refresh();
		}
		
		public function hide() : void
		{
			this.dispose();
		}
		
		public function setRoomStartState() : void
		{
			KeyboardShortcutsManager.Instance.forbiddenSection(1,false);
			this._goReturnBtn.enable = this._goChannelBtn.enable = this._goEmailBtn.enable = this._goSettingBtn.enable = false;
			this.setBagEnable(false);
			this.setShopBtnEnable(false);
			this.setSupplyBtnEnable(false);
			this._emailShineEffect.stop();
		}
		
		private function setSeverListStartState() : void
		{
			this._goReturnBtn.enable = this._goChannelBtn.enable = this._goTaskBtn.enable = this._goEmailBtn.enable = this._goSettingBtn.enable = false;
			this.setFriendBtnEnable(false);
			this.setBagEnable(false);
			this.setShopBtnEnable(false);
			this.setSupplyBtnEnable(false);
			if(this._emailShineEffect)
			{
				this._emailShineEffect.stop();
			}
			if(this._taskShineEffect)
			{
				this._taskShineEffect.stop();
			}
		}
		
		public function setReturnEnable(param1:Boolean) : void
		{
			this._goReturnBtn.enable = param1;
		}
		
		private function dispose() : void
		{
			this.removeEvent();
			QuestBubbleManager.Instance.dispose();
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		private function __onReturnClick(param1:MouseEvent) : void
		{
			SoundManager.instance.play("015");
			if(this._returnShineEffect && this._returnEffectEnable)
			{
				this._returnEffectEnable = false;
				this._returnShineEffect.stop();
				this._returnShineEffect = null;
			}
			if(StateManager.currentStateType == StateType.MAIN)
			{
				KeyboardShortcutsManager.Instance.forbiddenFull();
			}
			else if(StateManager.currentStateType == StateType.FARM)
			{
				FarmModelController.instance.exitFarm(PlayerManager.Instance.Self.ID);
			}
			if(this._callBackFun != null)
			{
				this._callBackFun();
			}
			else
			{
				StateManager.back();
			}
		}
		
		private function __onImClick(param1:MouseEvent) : void
		{
			SoundManager.instance.play("003");
			IMController.Instance.switchVisible();
		}
		
		private function __onChannelClick(param1:MouseEvent) : void
		{
			SoundManager.instance.play("003");
			GotoPageController.Instance.switchVisible();
		}
		
		private function __onSettingClick(param1:MouseEvent) : void
		{
			SoundManager.instance.play("003");
			SettingController.Instance.switchVisible();
		}
		
		private function __onEmailClick(param1:MouseEvent) : void
		{
			SoundManager.instance.play("003");
			this._emailShineEffect.stop();
			this._unReadEmail = false;
			MailManager.Instance.switchVisible();
		}
		
		private function __onTaskClick(param1:MouseEvent) : void
		{
			SoundManager.instance.play("003");
			if(this._taskShineEffect && this._taskEffectEnable)
			{
				this._taskEffectEnable = false;
				this._taskShineEffect.stop();
			}
			//TaskManager.MainFrame.switchVisible();
			TaskManager.switchVisible();
		}
		
		private function __onBagClick(param1:MouseEvent) : void
		{
			SoundManager.instance.play("003");
			if(this._bagShineEffect && this._bagEffectEnable)
			{
				this._bagEffectEnable = false;
				this._bagShineEffect.stop();
				this._bagShineEffect = null;
			}
			BagAndInfoManager.Instance.showBagAndInfo();
		}
		
		private function __onShopClick(param1:MouseEvent) : void
		{
			SoundManager.instance.play("003");
			StateManager.setState(StateType.SHOP);
		}
		
		private function __onSupplyClick(param1:MouseEvent) : void
		{
			LeavePageManager.leaveToFillPath();
		}
		
		public function set unReadEmail(param1:Boolean) : void
		{
			if(param1 == this._unReadEmail)
			{
				return;
			}
			this._unReadEmail = param1;
			if(this._enabled)
			{
				this.updateEmail();
			}
		}
		
		public function set unReadTask(param1:Boolean) : void
		{
			if(this._unReadTask == param1)
			{
				return;
			}
			this._unReadTask = param1;
			if(this._enabled)
			{
				this.updateTask();
			}
		}
		
		public function get unReadTask() : Boolean
		{
			return this._unReadTask;
		}
		
		public function set unReadMovement(param1:Boolean) : void
		{
		}
		
		public function get unReadMovement() : Boolean
		{
			return this._unReadMovement;
		}
		
		private function __updateEmail(param1:EmailEvent) : void
		{
			if(MailManager.Instance.Model.hasUnReadEmail())
			{
				this.unReadEmail = true;
			}
			else
			{
				this.unReadEmail = false;
			}
		}
		
		public function set enabled(param1:Boolean) : void
		{
			this._enabled = param1;
			this.update();
		}
		
		public function showTaskHightLight() : void
		{
			this.unReadTask = true;
		}
		
		public function hideTaskHightLight() : void
		{
			this.unReadTask = false;
		}
		
		public function showmovementHightLight() : void
		{
			this.unReadMovement = true;
		}
		
		private function update() : void
		{
			var _loc1_:uint = 0;
			while(_loc1_ < this.allBtns.length)
			{
				this.updateByIndex(_loc1_);
				_loc1_++;
			}
		}
		
		public function setRoomState() : void
		{
			this._goChannelBtn.enable = false;
		}
		
		public function setShopState() : void
		{
			this.setBagEnable(false);
		}
		
		public function setStoreEnableFalse() : void
		{
			this.setBagEnable(false);
		}
		
		public function setStoreEnableTrue() : void
		{
			this.setBagEnable(true);
		}
		
		public function setAuctionHouseState() : void
		{
			this.setBagEnable(false);
		}
		
		private function updateByIndex(param1:uint) : void
		{
			if(!this._enabled)
			{
				this.setEnableByIndex(param1,false);
			}
			else if(param1 == 3)
			{
				this.updateTask();
			}
			else if(param1 == 2)
			{
				this.updateEmail();
			}
			else
			{
				this.setEnableByIndex(param1,true);
			}
		}
		
		private function updateTask() : void
		{
			if(this._unReadTask)
			{
				this._taskShineEffect.play();
			}
			else
			{
				this._taskShineEffect.stop();
			}
			this._goTaskBtn.enable = true;
			this.tipTask();
		}
		
		private function updateMovement() : void
		{
			this._goChannelBtn.enable = true;
		}
		
		private function updateEmail() : void
		{
			if(!this._goEmailBtn.enable)
			{
				return;
			}
			if(this._unReadEmail)
			{
				this._emailShineEffect.play();
			}
			else
			{
				this._emailShineEffect.stop();
			}
			this._goEmailBtn.enable = true;
		}
		
		public function __player(param1:MouseEvent) : void
		{
			SoundManager.instance.play("008");
		}
		
		private function refresh() : void
		{
			if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.BAG_OPEN))
			{
				if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.BAG_OPEN_SHOW) && parent && this._goBagBtn.enable)
				{
					WeakGuildManager.Instance.showMainToolBarBtnOpen(Step.BAG_OPEN_SHOW,"trainer.posBarBag");
				}
			}
			if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.IM_OPEN))
			{
				if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.IM_SHOW) && parent && this._goFriendListBtn.enable)
				{
					WeakGuildManager.Instance.showMainToolBarBtnOpen(Step.IM_SHOW,"trainer.posBarIM");
				}
			}
			if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.SHOP_OPEN))
			{
				if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.SHOP_SHOW_BAR) && parent && this._goShopBtn.enable)
				{
					WeakGuildManager.Instance.showMainToolBarBtnOpen(Step.SHOP_SHOW_BAR,"trainer.posBarShop");
				}
			}
		}
		
		private function setBagEnable(param1:Boolean) : void
		{
			if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.BAG_OPEN))
			{
				this._goBagBtn.enable = param1;
				KeyboardShortcutsManager.Instance.prohibitNewHandBag(true);
			}
			else
			{
				this._goBagBtn.enable = false;
				KeyboardShortcutsManager.Instance.prohibitNewHandBag(false);
			}
		}
		
		private function setFriendBtnEnable(param1:Boolean) : void
		{
			if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.IM_OPEN))
			{
				this._goFriendListBtn.enable = param1;
				KeyboardShortcutsManager.Instance.prohibitNewHandFriend(true);
			}
			else
			{
				this._goFriendListBtn.enable = false;
				KeyboardShortcutsManager.Instance.prohibitNewHandFriend(false);
			}
		}
		
		private function setShopBtnEnable(param1:Boolean) : void
		{
			if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.SHOP_OPEN))
			{
				this._goShopBtn.enable = param1;
			}
			else
			{
				this._goShopBtn.enable = false;
			}
		}
		
		private function setSupplyBtnEnable(param1:Boolean) : void
		{
			if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.SHOP_OPEN))
			{
				this._goSupplyBtn.enable = param1;
			}
			else
			{
				this._goSupplyBtn.enable = false;
			}
		}
		
		private function setEnableByIndex(param1:int, param2:Boolean) : void
		{
			if(param1 == 0)
			{
				this.setShopBtnEnable(param2);
			}
			else if(param1 == 1)
			{
				this.setBagEnable(param2);
			}
			else if(param1 == 4)
			{
				this.setFriendBtnEnable(param2);
			}
			else if(param1 == 8)
			{
				this.setSupplyBtnEnable(param2);
			}
			else
			{
				this.allBtns[param1] = param2;
			}
		}
		
		public function tipTask() : void
		{
			if(!WeakGuildManager.Instance.switchUserGuide || !PathManager.solveUserGuildEnable())
			{
				return;
			}
			if(StateManager.currentStateType != StateType.MAIN && StateManager.currentStateType != StateType.MATCH_ROOM)
			{
				return;
			}
			if(NewHandContainer.Instance.hasArrow(ArrowType.HALL_BUILD) || NewHandContainer.Instance.hasArrow(ArrowType.HALL_STORE) || NewHandContainer.Instance.hasArrow(ArrowType.START_GAME))
			{
				return;
			}
			NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TASK);
			if(this._unReadTask && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.ACHIVED_THREE_QUEST))
			{
				NewHandContainer.Instance.showArrow(ArrowType.CLICK_TASK,0,"trainer.posClickTask","asset.trainer.txtGetReward","trainer.posClickTaskTxt",this);
			}
			else if(PlayerManager.Instance.Self.Grade < 3)
			{
				NewHandContainer.Instance.showArrow(ArrowType.CLICK_TASK,0,"trainer.posClickTask","asset.trainer.txtClickTask","trainer.posClickTaskTxt",this);
			}
		}
		
		private function beforeUserGuide11() : void
		{
			this._bagEffectEnable = true;
		}
		
		private function beforeUserGuide31() : void
		{
			this._taskEffectEnable = true;
		}
		
		private function beforeUserGuide39() : void
		{
			this._returnEffectEnable = true;
		}
		
		private function checkUserGuideTask32() : Boolean
		{
			this.unReadTask = false;
			return true;
		}
		
		private function checkUserGuideTask33() : Boolean
		{
			if(!TaskManager.MainFrame.parent)
			{
				return true;
			}
			return false;
		}
		
		private function beforeUserGuide40() : void
		{
			this.unReadTask = true;
		}
		
		private function checkUserGuideTask41() : Boolean
		{
			if(TaskManager.isAchieved(TaskManager.getQuestByID(1)))
			{
				return true;
			}
			return false;
		}
		
		private function checkUserGuideTask42() : Boolean
		{
			if(!TaskManager.MainFrame.parent)
			{
				return true;
			}
			return false;
		}
		
		private function checkUserGuideTask47() : Boolean
		{
			if(BagStore.instance.storeOpenAble)
			{
				return false;
			}
			return true;
		}
		
		private function checkUserGuideTask50() : Boolean
		{
			if(TaskManager.isAchieved(TaskManager.getQuestByID(2)))
			{
				return true;
			}
			return false;
		}
		
		private function checkUserGuideTask51() : Boolean
		{
			if(!TaskManager.MainFrame.parent)
			{
				return true;
			}
			return false;
		}
		
		private function checkUserGuide61() : Boolean
		{
			if(TaskManager.MainFrame.parent)
			{
				return true;
			}
			if(StateManager.currentStateType != StateType.MATCH_ROOM)
			{
				return true;
			}
			return false;
		}
	}
}
