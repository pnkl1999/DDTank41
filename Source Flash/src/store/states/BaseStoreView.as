package store.states
{
	import bagAndInfo.cell.BagCell;
	import baglocked.BaglockedManager;
	import com.pickgliss.events.FrameEvent;
	import com.pickgliss.ui.AlertManager;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.LayerManager;
	import com.pickgliss.ui.controls.BaseButton;
	import com.pickgliss.ui.controls.alert.BaseAlerFrame;
	import com.pickgliss.ui.core.Disposeable;
	import com.pickgliss.ui.image.MovieImage;
	import com.pickgliss.ui.image.Scale9CornerImage;
	import com.pickgliss.utils.ObjectUtils;
	import consortion.ConsortionModelControl;
	import ddt.data.BagInfo;
	import ddt.data.EquipType;
	import ddt.data.StoneType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.events.CellEvent;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.manager.SoundManager;
	import ddt.manager.TaskManager;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import store.IStoreViewBG;
	import store.StoreController;
	import store.StoreMainView;
	import store.StoreTips;
	import store.StrengthDataManager;
	import store.data.StoreModel;
	import store.events.ChoosePanelEvnet;
	import store.events.StoreDargEvent;
	import store.events.StoreIIEvent;
	import store.forge.ForgeMainView;
	import store.view.Compose.StoreIIComposeBG;
	import store.view.ConsortiaRateManager;
	import store.view.embed.StoreEmbedBG;
	import store.view.fusion.StoreIIFusionBG;
	import store.view.storeBag.StoreBagCell;
	import store.view.storeBag.StoreBagController;
	import store.view.strength.StoreIIStrengthBG;
	import store.view.transfer.StoreIITransferBG;
	
	public class BaseStoreView extends Sprite implements Disposeable
	{
		
		
		protected var _controller:StoreController;
		
		protected var _model:StoreModel;
		
		public var _storeview:StoreMainView;
		
		public var _forgeview:ForgeMainView;
		
		protected var _tip:StoreTips;
		
		protected var _storeBag:StoreBagController;
		
		private var _soundTimer:Timer;
		
		protected var _guideEmbed:MovieClip;
		
		private var _type:String;
		
		private var _consortiaManagerBtn:BaseButton;
		
		private var _consortiaBtnEffect:MovieImage;
		
		public function BaseStoreView(param1:StoreController, param2:String)
		{
			super();
			this._controller = param1;
			this._model = this._controller.Model;
			this.init();
			this.initEvent();
			this.type = param2;
			this._soundTimer = new Timer(7500,1);
		}
		
		private function init() : void
		{
			var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("store.scale9BG");
			addChild(_loc1_);
			var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.store.StoreBG");
			addChild(_loc2_);
			this._consortiaManagerBtn = ComponentFactory.Instance.creat("store.consortiaManagerBtn");
			addChild(this._consortiaManagerBtn);
			this._consortiaBtnEffect = ComponentFactory.Instance.creatComponentByStylename("store.ManagerEffect");
			addChild(this._consortiaBtnEffect);
			this._consortiaManagerBtn.visible = this._consortiaBtnEffect.visible = this._consortiaBtnEffect.mouseChildren = this._consortiaBtnEffect.mouseEnabled = false;
			this._forgeview = ComponentFactory.Instance.creat("store.forgeview");
			this._forgeview.visible = false;
			addChild(this._forgeview);
			this._storeview = ComponentFactory.Instance.creat("store.MainView");
			this._storeview.visible = true;
			addChild(this._storeview);
			this._storeBag = new StoreBagController(this._model);
			this._storeBag.getBagView().visible = true;
			addChild(this._storeBag.getView());
			this._tip = ComponentFactory.Instance.creat("store.storeTip");
			addChild(this._tip);
		}
		
		public function showForeView(param1:int = 0) : void
		{
			ForgeMainView.IsExalt = false;
			if(param1 == 0)
			{
				this._storeBag.getBagView().visible = true;
				if(this._forgeview)
				{
					this._forgeview.visible = false;
				}
				this._storeview.currentPanelIndex = this._storeview.panelIndex;
				this._storeview.visible = true;
				return;
			}
			this._forgeview.changeHandler(null);
			ForgeMainView.ISFRIST = true;
			if(ForgeMainView.IsExalt)
			{
				this._storeBag.getBagView().visible = true;
			}
			else
			{
				this._storeBag.getBagView().visible = false;
			}
			this._storeview.visible = false;
			this._forgeview.visible = true;
		}
		
		protected function initEvent() : void
		{
			this._consortiaManagerBtn.addEventListener(MouseEvent.CLICK,this.assetBtnClickHandler);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_COMPOSE,this.__showTipsIII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_STRENGTH,this.__showTip);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_FUSION,this.__showTipII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_TRANSFER,this.__showTipsIII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_REFINERY,this.__showTipsIII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_ADVANCE,this.__showExaltTips);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EMBED,this.__showTipsIII);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED,this.__openHoleComplete);
			this._storeBag.getView().addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
			this._storeBag.getView().addEventListener(StoreDargEvent.START_DARG,this.startShine);
			this._storeBag.getView().addEventListener(StoreDargEvent.STOP_DARG,this.stopShine);
			this._storeview.addEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT,this.refresh);
			this._storeview.addEventListener(StoreIIEvent.EMBED_CLICK,this.embedClickHandler);
			this._storeview.addEventListener(StoreIIEvent.EMBED_INFORCHANGE,this.embedInfoChangeHandler);
			this._forgeview.addEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT,this.refresh);
			ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._changeConsortia);
		}
		
		protected function removeEvent() : void
		{
			this._consortiaManagerBtn.removeEventListener(MouseEvent.CLICK,this.assetBtnClickHandler);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_COMPOSE,this.__showTipsIII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_STRENGTH,this.__showTip);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_FUSION,this.__showTipII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_TRANSFER,this.__showTipsIII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_REFINERY,this.__showTipsIII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_EMBED,this.__showTipsIII);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_ADVANCE,this.__showExaltTips);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED,this.__openHoleComplete);
			this._storeBag.getView().removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
			this._storeBag.getView().removeEventListener(StoreDargEvent.START_DARG,this.startShine);
			this._storeBag.getView().removeEventListener(StoreDargEvent.STOP_DARG,this.stopShine);
			this._storeview.removeEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT,this.refresh);
			this._storeview.removeEventListener(StoreIIEvent.EMBED_CLICK,this.embedClickHandler);
			this._storeview.removeEventListener(StoreIIEvent.EMBED_INFORCHANGE,this.embedInfoChangeHandler);
			this._forgeview.removeEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT,this.refresh);
			ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._changeConsortia);
		}
		
		protected function __showExaltTips(param1:CrazyTankSocketEvent) : void
		{
			var _loc2_:int = param1.pkg.readByte();
			var _loc3_:int = param1.pkg.readInt();
			if(_loc2_ == 0)
			{
				this._tip.showSuccess();
				StrengthDataManager.instance.exaltFinish();
			}
			else
			{
				StrengthDataManager.instance.exaltFail(_loc3_);
			}
		}
		
		public function setAutoLinkNum(param1:int) : void
		{
			this._model.NeedAutoLink = param1;
		}
		
		private function refresh(param1:ChoosePanelEvnet) : void
		{
			this._model.currentPanel = param1.currentPanle;
			this._storeBag.setList(this._model);
			this._storeBag.changeMsg(this._model.currentPanel + 1);
		}
		
		private function __cellDoubleClick(param1:CellEvent) : void
		{
			var _loc2_:IStoreViewBG = null;
			param1.stopImmediatePropagation();
			if(PlayerManager.Instance.Self.bagLocked)
			{
				SoundManager.instance.play("008");
				BaglockedManager.Instance.show();
				return;
			}
			var _loc3_:BagCell = param1.data as StoreBagCell;
			if(ForgeMainView.IsExalt)
			{
				_loc2_ = this._forgeview.exaltPanel;
			}
			else
			{
				_loc2_ = this._storeview.currentPanel;
			}
			_loc2_.dragDrop(_loc3_);
		}
		
		private function autoLink(param1:int, param2:int) : void
		{
			var _loc3_:BagCell = null;
			var _loc4_:IStoreViewBG = null;
			if(ForgeMainView.IsExalt)
			{
				_loc4_ = this._forgeview.exaltPanel;
			}
			else
			{
				_loc4_ = this._storeview.currentPanel;
			}
			if(param1 == BagInfo.EQUIPBAG)
			{
				_loc3_ = this._storeBag.getEquipCell(param2);
			}
			else
			{
				_loc3_ = this._storeBag.getPropCell(param2);
			}
			_loc4_.dragDrop(_loc3_);
		}
		
		private function startShine(param1:StoreDargEvent) : void
		{
			var _loc2_:StoreIIStrengthBG = null;
			var _loc3_:StoreIIComposeBG = null;
			var _loc4_:StoreIIFusionBG = null;
			var _loc5_:IStoreViewBG = this._storeview.currentPanel;
			if(_loc5_ is StoreIIStrengthBG)
			{
				_loc2_ = _loc5_ as StoreIIStrengthBG;
				if(param1.sourceInfo.CanEquip)
				{
					_loc2_.startShine(5);
				}
				else if(EquipType.isStrengthStone(param1.sourceInfo))
				{
					_loc2_.startShine(0);
					_loc2_.startShine(1);
					_loc2_.startShine(2);
				}
				else if(param1.sourceInfo.Property1 == StoneType.LUCKY)
				{
					_loc2_.startShine(4);
				}
				else if(param1.sourceInfo.Property1 == StoneType.SOULSYMBOL)
				{
					_loc2_.startShine(3);
				}
			}
			else if(_loc5_ is StoreIIComposeBG)
			{
				_loc3_ = _loc5_ as StoreIIComposeBG;
				if(param1.sourceInfo.CanEquip)
				{
					_loc3_.startShine(1);
				}
				else if(param1.sourceInfo.Property1 == StoneType.COMPOSE)
				{
					_loc3_.startShine(2);
				}
				else if(param1.sourceInfo.Property1 == StoneType.LUCKY)
				{
					_loc3_.startShine(0);
				}
			}
			else if(_loc5_ is StoreIIFusionBG)
			{
				_loc4_ = _loc5_ as StoreIIFusionBG;
				if(param1.sourceInfo.Property1 == StoneType.FORMULA)
				{
					_loc4_.startShine(0);
				}
				else if(EquipType.isFusion(param1.sourceInfo))
				{
					_loc4_.startShine(1);
					_loc4_.startShine(2);
					_loc4_.startShine(3);
					_loc4_.startShine(4);
				}
			}
			else if(_loc5_ is StoreEmbedBG)
			{
				if(param1.sourceInfo.CanEquip)
				{
					(_loc5_ as StoreEmbedBG).startShine();
				}
				else
				{
					if(param1.sourceInfo.Property1 == "31" && param1.sourceInfo.Property2 == "1")
					{
						(_loc5_ as StoreEmbedBG).stoneStartShine(1,param1.sourceInfo as InventoryItemInfo);
					}
					if(param1.sourceInfo.Property1 == "31" && param1.sourceInfo.Property2 == "2")
					{
						(_loc5_ as StoreEmbedBG).stoneStartShine(2,param1.sourceInfo as InventoryItemInfo);
					}
					if(param1.sourceInfo.Property1 == "31" && param1.sourceInfo.Property2 == "3")
					{
						(_loc5_ as StoreEmbedBG).stoneStartShine(3,param1.sourceInfo as InventoryItemInfo);
					}
				}
				_loc5_ = null;
			}
		}
		
		private function stopShine(param1:StoreDargEvent) : void
		{
			if(this._storeview.currentPanel is StoreIIStrengthBG)
			{
				(this._storeview.currentPanel as StoreIIStrengthBG).stopShine();
			}
			else if(this._storeview.currentPanel is StoreIIComposeBG)
			{
				(this._storeview.currentPanel as StoreIIComposeBG).stopShine();
			}
			else if(this._storeview.currentPanel is StoreIIFusionBG)
			{
				(this._storeview.currentPanel as StoreIIFusionBG).stopShine();
			}
			else if(this._storeview.currentPanel is StoreIITransferBG)
			{
				(this._storeview.currentPanel as StoreIITransferBG).stopShine();
			}
			else if(this._storeview.currentPanel is StoreEmbedBG)
			{
				(this._storeview.currentPanel as StoreEmbedBG).stopShine();
			}
		}
		
		private function __showTip(param1:CrazyTankSocketEvent) : void
		{
			var _loc2_:InventoryItemInfo = null;
			this._tip.isDisplayerTip = true;
			var _loc3_:int = param1.pkg.readByte();
			var _loc4_:Boolean = param1.pkg.readBoolean();
			if(_loc3_ == 0)
			{
				TaskManager.checkHighLight();
				this._tip.showStrengthSuccess((this._storeview.currentPanel as StoreIIStrengthBG).getStrengthItemCellInfo(),_loc4_);
				if(_loc4_)
				{
					_loc2_ = (this._storeview.currentPanel as StoreIIStrengthBG).getStrengthItemCellInfo();
					this.appearHoleTips(_loc2_);
					this.checkHasStrengthLevelThree(_loc2_);
				}
			}
			else if(_loc3_ == 1)
			{
				this._tip.showFail();
			}
			else if(_loc3_ == 2)
			{
				this._tip.showFiveFail();
			}
			else if(_loc3_ == 3)
			{
				ConsortiaRateManager.instance.reset();
			}
		}
		
		private function checkHasStrengthLevelThree(param1:InventoryItemInfo) : void
		{
			if(PlayerManager.Instance.Self.Grade < 15 && this._model.checkEmbeded() && SharedManager.Instance.hasStrength3[PlayerManager.Instance.Self.ID] == undefined && param1.StrengthenLevel == 3)
			{
				this.matteGuideEmbed();
				SharedManager.Instance.hasStrength3[PlayerManager.Instance.Self.ID] = true;
				SharedManager.Instance.save();
			}
		}
		
		private function __showTipsIII(param1:CrazyTankSocketEvent) : void
		{
			this._tip.isDisplayerTip = true;
			var _loc2_:int = param1.pkg.readByte();
			if(_loc2_ == 0)
			{
				switch(param1.type)
				{
					case CrazyTankSocketEvent.ITEM_TRANSFER:
						this._tip.showSuccess(StoreTips.TRANSFER);
						if(this._storeview.currentPanel is StoreIITransferBG)
						{
							(this._storeview.currentPanel as StoreIITransferBG).clearTransferItemCell();
							break;
						}
						break;
					case CrazyTankSocketEvent.ITEM_EMBED:
						this._tip.showSuccess(StoreTips.EMBED);
						break;
					default:
						this._tip.showSuccess();
				}
			}
			else if(_loc2_ == 1)
			{
				this._tip.showFail();
			}
			else if(_loc2_ == 3)
			{
				ConsortiaRateManager.instance.reset();
			}
		}
		
		private function __openHoleComplete(param1:CrazyTankSocketEvent) : void
		{
			var _loc2_:StoreEmbedBG = null;
			this._tip.isDisplayerTip = true;
			var _loc3_:int = param1.pkg.readByte();
			var _loc4_:Boolean = param1.pkg.readBoolean();
			var _loc5_:int = param1.pkg.readInt();
			if(_loc3_ == 0)
			{
				_loc2_ = this._storeview.currentPanel as StoreEmbedBG;
				if(_loc4_)
				{
					SoundManager.instance.pauseMusic();
					SoundManager.instance.play("063",false,false);
					this._soundTimer.reset();
					this._soundTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__soundComplete);
					this._soundTimer.start();
					_loc2_.holeLvUp(_loc5_ - 1);
				}
			}
			else if(_loc3_ == 1)
			{
				this._tip.showFail();
			}
		}
		
		private function __soundComplete(param1:TimerEvent) : void
		{
			this._soundTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__soundComplete);
			SoundManager.instance.resumeMusic();
			SoundManager.instance.stop("063");
			SoundManager.instance.stop("064");
		}
		
		private function __showTipII(param1:CrazyTankSocketEvent) : void
		{
			this._tip.isDisplayerTip = false;
			if(param1.pkg.readBoolean() == 0)
			{
				this._tip.showFail();
			}
			else
			{
				this._tip.showSuccess();
			}
			StrengthDataManager.instance.fusionFinish();
		}
		
		private function appearHoleTips(param1:InventoryItemInfo) : void
		{
			SoundManager.instance.play("1001");
			this._storeview.shineEmbedBtn();
		}
		
		private function showHoleTip(param1:InventoryItemInfo) : void
		{
			if(param1.CategoryID == 1)
			{
				if(param1.StrengthenLevel == 3 || param1.StrengthenLevel == 9 || param1.StrengthenLevel == 12)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.hatOpenProperty"));
				}
				if(param1.StrengthenLevel == 6)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.hatOpenDefense"));
				}
			}
			if(param1.CategoryID == 5)
			{
				if(param1.StrengthenLevel == 3 || param1.StrengthenLevel == 9 || param1.StrengthenLevel == 12)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.clothOpenProperty"));
				}
				if(param1.StrengthenLevel == 6)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.clothOpenDefense"));
				}
			}
			if(param1.CategoryID == 7)
			{
				if(param1.StrengthenLevel == 3)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.weaponOpenAttack"));
				}
				if(param1.StrengthenLevel == 6 || param1.StrengthenLevel == 9 || param1.StrengthenLevel == 12)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.weaponOpenProperty"));
				}
			}
		}
		
		private function assetBtnClickHandler(param1:MouseEvent) : void
		{
			SoundManager.instance.play("008");
			this._consortiaBtnEffect.visible = false;
			ConsortionModelControl.Instance.alertManagerFrame();
		}
		
		protected function matteGuideEmbed() : void
		{
			this._guideEmbed = ComponentFactory.Instance.creat("asset.store.TutorialStepAsset");
			this._guideEmbed.gotoAndStop(1);
			LayerManager.Instance.addToLayer(this._guideEmbed,LayerManager.GAME_TOP_LAYER);
		}
		
		private function embedClickHandler(param1:StoreIIEvent) : void
		{
			if(this._guideEmbed)
			{
				this._guideEmbed.gotoAndStop(6);
			}
		}
		
		private function embedInfoChangeHandler(param1:StoreIIEvent) : void
		{
			var _loc2_:BaseAlerFrame = null;
			if(this._guideEmbed)
			{
				this._guideEmbed.gotoAndStop(11);
				param1.stopImmediatePropagation();
				_loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("store.states.embedTitle"),LanguageMgr.GetTranslation("tank.view.store.matteTips"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,true,LayerManager.ALPHA_BLOCKGOUND);
				_loc2_.info.showCancel = false;
				_loc2_.moveEnable = false;
				_loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
			}
		}
		
		private function _response(param1:FrameEvent) : void
		{
			SoundManager.instance.play("008");
			var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
			_loc2_.removeEventListener(FrameEvent.RESPONSE,this._response);
			if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
			{
				this.okFunction();
			}
			ObjectUtils.disposeObject(param1.target);
		}
		
		private function okFunction() : void
		{
			if(this._guideEmbed)
			{
				ObjectUtils.disposeObject(this._guideEmbed);
			}
			this._guideEmbed = null;
		}
		
		public function set type(param1:String) : void
		{
			this._consortiaManagerBtn.visible = this._consortiaBtnEffect.visible = PlayerManager.Instance.Self.ConsortiaID != 0 ? Boolean(Boolean(Boolean(true))) : Boolean(Boolean(Boolean(false)));
		}
		
		private function _changeConsortia(param1:Event) : void
		{
			this._consortiaManagerBtn.visible = this._consortiaBtnEffect.visible = PlayerManager.Instance.Self.ConsortiaID != 0 ? Boolean(Boolean(Boolean(true))) : Boolean(Boolean(Boolean(false)));
		}
		
		override public function set visible(param1:Boolean) : void
		{
			super.visible = param1;
			if(this._storeview)
			{
				if(visible)
				{
					this._storeview.refreshCurrentPanel();
				}
				else
				{
					this._storeview.deleteSomeDataTemp();
				}
			}
		}
		
		public function dispose() : void
		{
			this.removeEvent();
			if(this._storeview)
			{
				ObjectUtils.disposeObject(this._storeview);
			}
			this._storeview = null;
			if(this._tip)
			{
				ObjectUtils.disposeObject(this._tip);
			}
			this._tip = null;
			if(this._consortiaManagerBtn)
			{
				ObjectUtils.disposeObject(this._consortiaManagerBtn);
			}
			this._consortiaManagerBtn = null;
			if(this._consortiaBtnEffect)
			{
				ObjectUtils.disposeObject(this._consortiaBtnEffect);
			}
			this._consortiaBtnEffect = null;
			if(this._guideEmbed)
			{
				ObjectUtils.disposeObject(this._guideEmbed);
			}
			this._guideEmbed = null;
			if(this._storeBag)
			{
				ObjectUtils.disposeObject(this._storeBag);
			}
			this._storeBag = null;
			this._controller = null;
			this._model.currentPanel = StoreMainView.STRENGTH;
			this._model = null;
			ObjectUtils.disposeAllChildren(this);
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}
