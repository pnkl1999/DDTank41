package bagAndInfo.bag
{
   import bagAndInfo.ReworkName.ReworkNameConsortia;
   import bagAndInfo.ReworkName.ReworkNameFrame;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.changeSex.ChangeSexAlertFrame;
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import changeColor.ChangeColorController;
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.OutMainListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatBugleInputFrame;
   import ddt.view.goods.AddPricePanel;
   import ddt.view.tips.OneLineTip;
   import equipretrieve.RetrieveController;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.media.SoundTransform;
   import flash.ui.Mouse;
   import petsBag.controller.PetBagController;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.DateUtils;
   import texpSystem.controller.TexpManager;
   import trainer.controller.NewHandQueue;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import consortion.view.selfConsortia.ConsortionBankBagView;
   
   [Event(name="sellstart")]
   [Event(name="sellstop")]
   public class BagView extends Sprite
   {
      
      public static var isFlag:Boolean = false;
      
      public static const FIRST_GET_CARD:String = "firstGetCard";
      
      public static const TABCHANGE:String = "tabChange";
      
      public static const EQUIP:int = 0;
      
      public static const PROP:int = 1;
      
      public static const CARD:int = 2;
      
      public static const CONSORTION:int = 3;
      
      public static const PET:int = 5;
      
      public static var isShowCardBag:Boolean = false;
      
      private static const UseColorShellLevel:int = 10;
       
      
      private var _index:int = 0;
      
      private const STATE_SELL:uint = 1;
      
      protected var _bgShape:Shape;
      
      protected var _bgShapeII:Shape;
      
      private var state:uint = 0;
      
      private var _info:SelfInfo;
      
      protected var _equiplist:BagEquipListView;
      
      protected var _proplist:BagListView;
      
      protected var _petlist:PetBagListView;
      
      protected var _sellBtn:SellGoodsBtn;
      
      protected var _continueBtn:ContinueGoodsBtn;
      
      protected var _lists:Array;
      
      protected var _currentList:BagListView;
      
      protected var _breakBtn:BreakGoodsBtn;
      
      protected var _keySetBtn:SimpleBitmapButton;
      
      private var _keySetFrame:KeySetFrame;
      
      private var _chatBugleInputFrame:ChatBugleInputFrame;
      
      protected var _bagType:int;
      
      protected var _settedLockBtn:SimpleBitmapButton;
      
      protected var _settingLockBtn:SimpleBitmapButton;
      
      private var _bagLocked:Boolean;
      
      protected var _sortBagBtn:SimpleBitmapButton;
      
      protected var _trieveBtn:SimpleBitmapButton;
      
      private var _trieveBtnSprite:Sprite;
      
      private var _trieveBtnTip:OneLineTip;
      
      private var _self:SelfInfo;
      
      protected var _goldText:FilterFrameText;
      
      protected var _moneyText:FilterFrameText;
      
      protected var _giftText:FilterFrameText;
      
      protected var _medalField:FilterFrameText;
      
      protected var _goldButton:RichesButton;
      
      protected var _giftButton:RichesButton;
      
      protected var _moneyButton:RichesButton;
      
      protected var _medalButton:RichesButton;
      
      protected var _bg:MutipleImage;
      
      protected var _tabBtn1:Sprite;
      
      protected var _tabBtn2:Sprite;
      
      protected var _equipBtn:SelectedButton;
      
      protected var _propBtn:SelectedButton;
      
      protected var _cardBtn:SelectedButton;
      
      protected var _btnGroup:SelectedButtonGroup;
      
      protected var _goodsNumInfoBg:Bitmap;
      
      protected var _goodsNumInfoText:FilterFrameText;
      
      protected var _goodsNumTotalText:FilterFrameText;
      
      private var _changeColorController:ChangeColorController;
      
      private var _reworknameView:ReworkNameFrame;
      
      private var _consortaiReworkName:ReworkNameConsortia;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      private var _openBagLock:Boolean = false;
      
      private const _TRIEVENEEDLEVEL:int = 16;
      
      private var _bagList:OutMainListPanel;
      
      private var _isScreenFood:Boolean = false;
      
      private var _isPetBag:Boolean;
      
      private var _petbagBg:Bitmap;
      
      private var _petbagText:FilterFrameText;
      
      private var _flag:Boolean = false;
      
      private var _bagLockControl:BagLockedController;
      
      private var temInfo:InventoryItemInfo;
      
      private var _currentCell:BagCell;
      
      private var _tmpCell:BagCell;
      
      private var getNewCardMovie:MovieClip;
      
      private var _soundControl:SoundTransform;
      
      protected var _equipBagPage:int = 1;
      
      public function BagView(param1:Boolean = false)
      {
         this._self = PlayerManager.Instance.Self;
         super();
         this._isPetBag = param1;
         this.init();
         this.initEvent();
      }
      
      public function get bagType() : int
      {
         return this._bagType;
      }
      
      protected function init() : void
      {
         this.initBackGround();
         this.initBagList();
         this.initMoneyTexts();
         this.initButtons();
         this.initTabButtons();
         this.initGoodsNumInfo();
         this.set_breakBtn_enable();
         this.set_text_location();
         this.set_btn_location();
         this.setBagType(EQUIP);
         this._keySetFrame = ComponentFactory.Instance.creatComponentByStylename("keySetFrame");
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            this.userGuide();
         }
      }
      
      private function userGuide() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.BAGVIEW_WEAPON) && !TaskManager.isAchieved(TaskManager.getQuestByID(537)))
         {
            MainToolBar.Instance.addEventListener("SHOW_ARROW_BAGVIEW",this.showArrowBagView);
            NewHandQueue.Instance.push(new Step(1,this.expWeaponTip,this.preWeaponTip,this.finStoneTip));
         }
      }
      
      private function showArrowBagView(param1:Event) : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.BAG_WEAPON_BACK,-90,"trainer.BagViewWeaponArrowBackPos");
      }
      
      private function expWeaponTip() : void
      {
      }
      
      private function preWeaponTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.BAG_WEAPON,180,"trainer.BagViewWeaponArrowPos","asset.trainer.txtWeaponTip","trainer.BagViewWeaponTipPos");
         isFlag = true;
      }
      
      private function finStoneTip() : void
      {
         this.disposeUserGuide();
      }
      
      private function disposeUserGuide() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.BAG_WEAPON);
      }
      
      protected function initBackGround() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bagBGAsset");
         addChild(this._bg);
         if(this._isPetBag)
         {
            this._petbagBg = ComponentFactory.Instance.creatBitmap("assets.petsBag.bgView");
            addChild(this._petbagBg);
            this._petbagText = ComponentFactory.Instance.creatComponentByStylename("assets.petsBag.petbagText");
            this._petbagText.text = LanguageMgr.GetTranslation("assets.petsBag.petbagTextLG");
            addChild(this._petbagText);
         }
         this._bgShape = new Shape();
         this._bgShape.graphics.beginFill(15262671,1);
         this._bgShape.graphics.drawRoundRect(0,0,327,328,2,2);
         this._bgShape.graphics.endFill();
         this._bgShape.x = 11;
         this._bgShape.y = 50;
         addChild(this._bgShape);
         this._bgShapeII = new Shape();
         this._bgShapeII.graphics.beginFill(4658695,1);
         this._bgShapeII.graphics.drawRoundRect(0,0,333,331,2,2);
         this._bgShapeII.graphics.endFill();
         this._bgShapeII.x = 7;
         this._bgShapeII.y = 47;
         addChild(this._bgShapeII);
         this._bgShapeII.visible = false;
      }
      
      protected function initBagList() : void
      {
         this._equiplist = new BagEquipListView(0,31,79,7,this._equipBagPage);
         this._proplist = new BagProListView(1,0,48);
         this._petlist = new PetBagListView(1);
         PositionUtils.setPos(this._petlist,"bagAndInfo.bagView.petBag.pos18");
         this._equiplist.x = this._proplist.x = 14;
         this._equiplist.y = this._proplist.y = 54;
         this._equiplist.width = this._proplist.width = this._petlist.width = 330;
         this._equiplist.height = this._proplist.height = this._petlist.height = 320;
         this._proplist.visible = false;
         this._petlist.visible = false;
         this._lists = [this._equiplist,this._proplist,this._petlist];
         this._currentList = this._equiplist;
         addChild(this._equiplist);
         addChild(this._proplist);
         addChild(this._petlist);
      }
      
      private function initMoneyTexts() : void
      {
         this._moneyText = ComponentFactory.Instance.creatComponentByStylename("BagMoneyInfoText");
         this._goldText = ComponentFactory.Instance.creatComponentByStylename("BagGoldInfoText");
         this._giftText = ComponentFactory.Instance.creatComponentByStylename("BagGiftInfoText");
         this._medalField = ComponentFactory.Instance.creatComponentByStylename("BagMedalInfoText");
         addChild(this._goldText);
         addChild(this._moneyText);
         addChild(this._giftText);
         addChild(this._medalField);
         this._goldButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.GoldButton");
         this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         addChild(this._goldButton);
         this._giftButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.GiftButton");
         this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections");
         addChild(this._giftButton);
         this._moneyButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.MoneyButton");
         this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
         addChild(this._moneyButton);
         this._medalButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.MedalButton");
         this._medalButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MedalDirections");
         addChild(this._medalButton);
      }
      
      protected function initButtons() : void
      {
         this._sellBtn = ComponentFactory.Instance.creatComponentByStylename("bagSellButton");
         addChild(this._sellBtn);
         this._continueBtn = ComponentFactory.Instance.creatComponentByStylename("bagContinueButton");
         addChild(this._continueBtn);
         this._breakBtn = ComponentFactory.Instance.creatComponentByStylename("bagBreakButton");
         addChild(this._breakBtn);
         this._keySetBtn = ComponentFactory.Instance.creatComponentByStylename("bagKeySetButton");
         addChild(this._keySetBtn);
         this._keySetBtn.enable = this._isSkillCanUse();
         this._settingLockBtn = ComponentFactory.Instance.creatComponentByStylename("bagSetPWDButton");
         this._settingLockBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.BagLockedSetFrame.titleText");
         addChild(this._settingLockBtn);
         this._settedLockBtn = ComponentFactory.Instance.creatComponentByStylename("bagSettedPWDButton");
         this._settedLockBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.BagLockedSetFrame.titleText");
         addChild(this._settedLockBtn);
         this._sortBagBtn = ComponentFactory.Instance.creatComponentByStylename("sortBagButton");
         this._sortBagBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagFinishingBtn");
         addChild(this._sortBagBtn);
         this._trieveBtnSprite = new Sprite();
         this._trieveBtn = ComponentFactory.Instance.creatComponentByStylename("trieveButton");
         this._trieveBtnSprite.addChild(this._trieveBtn);
         addChild(this._trieveBtnSprite);
         this._trieveBtnTip = new OneLineTip();
         this._trieveBtnTip.visible = false;
         if(PlayerManager.Instance.Self.Grade < this._TRIEVENEEDLEVEL)
         {
            this._trieveBtn.enable = false;
            this._trieveBtnTip.tipData = LanguageMgr.GetTranslation("tank.view.equipretrieve.needsixteen");
         }
         else
         {
            this._trieveBtn.enable = true;
            this._trieveBtn.tipData = LanguageMgr.GetTranslation("tank.view.equipretrieve.tip");
         }
      }
      
      public function set sortBagEnable(param1:Boolean) : void
      {
         this._sortBagBtn.enable = param1;
      }
      
      public function set breakBtnEnable(param1:Boolean) : void
      {
         this._breakBtn.enable = param1;
      }
      
      public function set trieveBtnEnable(param1:Boolean) : void
      {
         this._trieveBtn.enable = param1;
      }
      
      public function set sortBagFilter(param1:Array) : void
      {
         this._sortBagBtn.filters = param1;
      }
      
      public function set breakBtnFilter(param1:Array) : void
      {
         this._breakBtn.filters = param1;
      }
      
      public function set isScreenFood(param1:Boolean) : void
      {
         this._isScreenFood = param1;
      }
      
      protected function initTabButtons() : void
      {
         this._equipBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.equipBtn");
         this._propBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.propBtn");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("bagView.cardBtn");
         addChild(this._equipBtn);
         addChild(this._propBtn);
         addChild(this._cardBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._equipBtn);
         this._btnGroup.addSelectItem(this._propBtn);
         this._btnGroup.addSelectItem(this._cardBtn);
         this._btnGroup.selectIndex = 0;
      }
      
      private function initGoodsNumInfo() : void
      {
         this._goodsNumInfoText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumText");
         this._goodsNumTotalText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumTotalText");
         this._goodsNumTotalText.text = "/ " + String(BagInfo.MAXPROPCOUNT + 1);
      }
      
      public function hideForConsortia() : void
      {
         removeChild(this._goodsNumInfoText);
         removeChild(this._goodsNumTotalText);
         removeChild(this._settingLockBtn);
         removeChild(this._settedLockBtn);
         removeChild(this._sortBagBtn);
         this._trieveBtnSprite.removeChild(this._trieveBtn);
         removeChild(this._trieveBtnSprite);
      }
      
      private function updateView() : void
      {
         this.updateMoney();
         this.updateBagList();
         this.updateLockState();
      }
      
      protected function updateBagList() : void
      {
         if(this._info)
         {
            this._equiplist.setData(this._info.Bag);
            if(this._isScreenFood)
            {
               this._petlist.setData(this._info.PropBag);
            }
            else
            {
               this._proplist.setData(this._info.PropBag);
            }
         }
         else
         {
            this._equiplist.setData(null);
            this._proplist.setData(null);
            this._petlist.setData(null);
         }
      }
      
      protected function updateLockState() : void
      {
         if(this._flag)
         {
            return;
         }
         this._settingLockBtn.visible = !this._info.bagLocked;
         this._settedLockBtn.visible = this._info.bagLocked;
      }
      
      private function __clearHandler(param1:BagEvent) : void
      {
         this.updateLockState();
      }
      
      public function set sorGoodsEnabel(param1:Boolean) : void
      {
         this._sortBagBtn.enable = param1;
      }
      
      protected function initEvent() : void
      {
         this._sellBtn.addEventListener(MouseEvent.CLICK,this.__sellClick);
         this._breakBtn.addEventListener(MouseEvent.CLICK,this.__breakClick);
         this._equiplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equiplist.addEventListener(Event.CHANGE,this.__listChange);
         this._proplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         if(this._petlist)
         {
            this._petlist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         this._btnGroup.addEventListener(Event.CHANGE,this.__tabClick);
         CellMenu.instance.addEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.addEventListener(CellMenu.MOVE,this.__cellMove);
         if(!hasEventListener(CellMenu.OPEN_CellMenu))
         {
            CellMenu.instance.addEventListener(CellMenu.OPEN_CellMenu,this.__cellOpen);
         }
         CellMenu.instance.addEventListener(CellMenu.USE,this.__cellUse);
         CellMenu.instance.addEventListener(CellMenu.OPEN_BATCH,this.__cellOpenBatch);
         this._keySetBtn.addEventListener(MouseEvent.CLICK,this.__keySetFrameClick);
         this._settingLockBtn.addEventListener(MouseEvent.CLICK,this.__openSettingLock);
         this._settedLockBtn.addEventListener(MouseEvent.CLICK,this.__openModifyLock);
         this._sortBagBtn.addEventListener(MouseEvent.CLICK,this.__sortBagClick);
         this._trieveBtn.addEventListener(MouseEvent.CLICK,this.___trieveBtnClick);
         this._trieveBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.___trieveBtnOver);
         this._trieveBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.___trieveBtnOut);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,this.__useColorShell);
         this.adjustEvent();
      }
      
      protected function adjustEvent() : void
      {
      }
      
      protected function __useColorShell(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            SoundManager.instance.play("063");
         }
      }
      
      protected function removeEvents() : void
      {
         this._sellBtn.removeEventListener(MouseEvent.CLICK,this.__sellClick);
         this._breakBtn.removeEventListener(MouseEvent.CLICK,this.__breakClick);
         this._equiplist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._equiplist.removeEventListener(Event.CHANGE,this.__listChange);
         this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._proplist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         this._proplist.removeEventListener(Event.CHANGE,this.__listChange);
         if(this._petlist)
         {
            this._petlist.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         }
         this._btnGroup.addEventListener(Event.CHANGE,this.__tabClick);
         this._sortBagBtn.removeEventListener(MouseEvent.CLICK,this.__sortBagClick);
         this._trieveBtn.removeEventListener(MouseEvent.CLICK,this.___trieveBtnClick);
         this._trieveBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.___trieveBtnOver);
         this._trieveBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.___trieveBtnOut);
         CellMenu.instance.removeEventListener(CellMenu.ADDPRICE,this.__cellAddPrice);
         CellMenu.instance.removeEventListener(CellMenu.MOVE,this.__cellMove);
         CellMenu.instance.removeEventListener(CellMenu.OPEN_CellMenu,this.__cellOpen);
         CellMenu.instance.removeEventListener(CellMenu.USE,this.__cellUse);
         CellMenu.instance.removeEventListener(CellMenu.OPEN_BATCH,this.__cellOpenBatch);
         this._settingLockBtn.removeEventListener(MouseEvent.CLICK,this.__openSettingLock);
         this._settedLockBtn.removeEventListener(MouseEvent.CLICK,this.__openModifyLock);
         this._keySetBtn.removeEventListener(MouseEvent.CLICK,this.__keySetFrameClick);
         PlayerManager.Instance.Self.removeEventListener(BagEvent.CLEAR,this.__clearHandler);
         PlayerManager.Instance.Self.removeEventListener(BagEvent.AFTERDEL,this.__clearHandler);
         PlayerManager.Instance.Self.removeEventListener(BagEvent.CHANGEPSW,this.__clearHandler);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.ADD,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this.__upData);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.REMOVE,this.__remove);
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            this._info.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
         }
         if(this._bagLockControl)
         {
            this._bagLockControl.addEventListener(Event.COMPLETE,this.__onLockComplete);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,this.__useColorShell);
      }
      
      protected function __tabClick(param1:Event) : void
      {
         SoundManager.instance.play("008");
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               if(this._bagType == EQUIP)
               {
                  return;
               }
               this.setBagType(EQUIP);
               break;
            case 1:
               if(this._bagType == PROP || this._bagType == PET)
               {
                  return;
               }
               this.setBagType(!!this._isScreenFood ? int(int(PET)) : int(int(PROP)));
               break;
            case 2:
               if(PlayerManager.Instance.Self.Grade < 20)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.openCardBtn.text"));
                  this._btnGroup.selectIndex = this._bagType;
                  return;
               }
               if(this._bagType == CARD)
               {
                  return;
               }
               this.createCard();
               break;
         }
      }
      
      private function createCard() : void
      {
         if(!isShowCardBag)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CARD_SYSTEM);
         }
         else
         {
            if(this._bagList == null)
            {
               this._bagList = ComponentFactory.Instance.creatComponentByStylename("cardSyste.cardBagList");
               addChild(this._bagList);
               this._bagList.vectorListModel.appendAll(CardControl.Instance.model.getBagListData());
               DragManager.ListenWheelEvent(this._bagList.onMouseWheel);
               DragManager.changeCardState(CardControl.Instance.setSignLockedCardNone);
               PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.ADD,this.__upData);
               PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this.__upData);
               PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.REMOVE,this.__remove);
            }
            this.setBagType(CARD);
         }
      }
      
      private function __onUIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CARD_SYSTEM)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            isShowCardBag = true;
            this.createCard();
         }
      }
      
      private function __onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CARD_SYSTEM)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __upData(param1:DictionaryEvent) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc2_:CardInfo = param1.data as CardInfo;
         var _loc3_:int = _loc2_.Place % 4 == 0 ? int(int(_loc2_.Place / 4 - 2)) : int(int(_loc2_.Place / 4 - 1));
         var _loc4_:int = _loc2_.Place % 4 == 0 ? int(int(4)) : int(int(_loc2_.Place % 4));
         if(this._bagList.vectorListModel.elements[_loc3_] == null)
         {
            _loc5_ = new Array();
            _loc5_[0] = _loc3_ + 1;
            _loc5_[_loc4_] = _loc2_;
            this._bagList.vectorListModel.append(_loc5_);
         }
         else
         {
            _loc6_ = this._bagList.vectorListModel.elements[_loc3_] as Array;
            _loc6_[_loc4_] = _loc2_;
            this._bagList.vectorListModel.replaceAt(_loc3_,_loc6_);
         }
      }
      
      private function __remove(param1:DictionaryEvent) : void
      {
         var _loc2_:CardInfo = param1.data as CardInfo;
         var _loc3_:int = _loc2_.Place % 4 == 0 ? int(int(_loc2_.Place / 4 - 2)) : int(int(_loc2_.Place / 4 - 1));
         var _loc4_:int = _loc2_.Place % 4 == 0 ? int(int(4)) : int(int(_loc2_.Place % 4));
         var _loc5_:Array = this._bagList.vectorListModel.elements[_loc3_] as Array;
         _loc5_[_loc4_] = null;
         this._bagList.vectorListModel.replaceAt(_loc3_,_loc5_);
      }
      
      public function setBagType(param1:int) : void
      {
         if(this._bagType == param1)
         {
            return;
         }
         this._bagType = param1;
         dispatchEvent(new Event(TABCHANGE));
         if(param1 == PET)
         {
            this._btnGroup.selectIndex = 1;
         }
         else
         {
            this._btnGroup.selectIndex = param1;
         }
         this._bgShape.visible = this._bagType == EQUIP || this._bagType == PROP || this._bagType == PET;
         this._equiplist.visible = this._bagType == EQUIP;
         this._proplist.visible = this._bagType == PROP;
         if(this._bagList)
         {
            this._bagList.visible = this._bgShapeII.visible = this._bagType == CARD;
         }
         this.set_breakBtn_enable();
         this._sellBtn.enable = this._breakBtn.enable = this._continueBtn.enable = this._bagType != CARD;
         if(this._petlist)
         {
            this._petlist.visible = this._bagType == PET;
         }
      }
      
      public function enableOrdisableSB(param1:Boolean) : void
      {
         if(this._tabBtn1)
         {
            this._tabBtn1.visible = param1;
         }
         if(this._tabBtn2)
         {
            this._tabBtn2.visible = param1;
         }
      }
      
      public function setBtnY() : void
      {
         if(this._continueBtn)
         {
            this._continueBtn.y = 400;
         }
         if(this._sellBtn)
         {
            this._sellBtn.y = 400;
         }
      }
      
      public function enableDressSelectedBtn(param1:Boolean) : void
      {
         this._flag = true;
         if(this._cardBtn)
         {
            this._cardBtn.visible = param1;
         }
         if(this._trieveBtnSprite)
         {
            this._trieveBtnSprite.visible = param1;
         }
         if(this._settedLockBtn)
         {
            this._settedLockBtn.visible = param1;
         }
         if(this._settingLockBtn)
         {
            this._settingLockBtn.visible = param1;
         }
         if(this._sortBagBtn)
         {
            this._sortBagBtn.visible = param1;
         }
         if(this._keySetBtn)
         {
            this._keySetBtn.visible = param1;
         }
         if(this._breakBtn)
         {
            this._breakBtn.visible = param1;
         }
      }
      
      public function deleteButtonForPet() : void
      {
      }
      
      public function isNeedCard(param1:Boolean) : void
      {
         this._cardBtn.enable = param1;
      }
      
      protected function set_breakBtn_enable() : void
      {
      }
      
      protected function set_text_location() : void
      {
      }
      
      protected function set_btn_location() : void
      {
      }
      
      private function __onBagUpdateEQUIPBAG(param1:BagEvent) : void
      {
         this.setBagCountShow(BagInfo.EQUIPBAG);
      }
      
      private function __onBagUpdatePROPBAG(param1:BagEvent) : void
      {
         if(this.bagType != 21 && !this._isScreenFood && this.bagType != 2)
         {
            this.setBagCountShow(BagInfo.PROPBAG);
         }
      }
      
      private function __openSettingLock(param1:MouseEvent) : void
      {
         if(this._openBagLock)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(!this._bagLockControl)
         {
            this._bagLockControl = new BagLockedController();
         }
         this._openBagLock = true;
         this._bagLockControl.show();
         this._bagLockControl.addEventListener(Event.COMPLETE,this.__onLockComplete);
         SharedManager.Instance.setBagLocked = true;
         SharedManager.Instance.save();
      }
      
      private function __openModifyLock(param1:MouseEvent) : void
      {
         if(this._openBagLock)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(!this._bagLockControl)
         {
            this._bagLockControl = new BagLockedController();
         }
         this._bagLockControl.show();
         this._openBagLock = true;
         this._bagLockControl.addEventListener(Event.COMPLETE,this.__onLockComplete);
         SharedManager.Instance.setBagLocked = true;
         SharedManager.Instance.save();
      }
      
      private function __onLockComplete(param1:Event) : void
      {
         this._bagLockControl.removeEventListener(Event.COMPLETE,this.__onLockComplete);
         this._openBagLock = false;
      }
      
      protected function ___trieveBtnClick(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade < this._TRIEVENEEDLEVEL)
         {
            this._trieveBtn.setFrame(4);
            return;
         }
         SoundManager.instance.play("008");
         RetrieveController.Instance.start();
         RetrieveController.Instance.isBagOpen = true;
      }
      
      private function ___trieveBtnOver(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(PlayerManager.Instance.Self.Grade < this._TRIEVENEEDLEVEL)
         {
            this._trieveBtnTip.visible = true;
            LayerManager.Instance.addToLayer(this._trieveBtnTip,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this._trieveBtn.localToGlobal(new Point(0,0));
            this._trieveBtnTip.x = _loc2_.x;
            this._trieveBtnTip.y = _loc2_.y - this._trieveBtn.height;
         }
      }
      
      private function ___trieveBtnOut(param1:MouseEvent) : void
      {
         this._trieveBtnTip.visible = false;
      }
      
      protected function __sortBagClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = this._bagType == CARD ? LanguageMgr.GetTranslation("bagAndInfo.bag.sortBagClick.isSegistration2") : LanguageMgr.GetTranslation("bagAndInfo.bag.sortBagClick.isSegistration");
         AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         _loc2_.dispose();
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),0,48,true);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               PlayerManager.Instance.Self.PropBag.sortBag(this._bagType,PlayerManager.Instance.Self.getBag(this._bagType),0,48,false);
         }
      }
      
      private function __keySetFrameClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         if(this._keySetFrame.visible)
         {
            this._keySetFrame.close();
         }
         else
         {
            this._keySetFrame.show();
         }
      }
      
      private function __onKeySetComplete(param1:Event) : void
      {
         this._keySetFrame.removeEventListener(Event.COMPLETE,this.__onKeySetComplete);
      }
      
      public function closeKeySetFrame() : void
      {
         if(this._keySetFrame.visible)
         {
            this._keySetFrame.close();
         }
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.MONEY] || param1.changedProperties[PlayerInfo.GOLD] || param1.changedProperties[PlayerInfo.MEDAL] || param1.changedProperties[PlayerInfo.GIFT])
         {
            this.updateMoney();
         }
         else if(param1.changedProperties["bagLocked"])
         {
            this._bagLocked = this._info.bagLocked;
            this.updateLockState();
         }
         if(param1.changedProperties["Grade"])
         {
            if(PlayerManager.Instance.Self.Grade >= this._TRIEVENEEDLEVEL)
            {
               this._trieveBtn.enable = true;
               this._trieveBtn.setFrame(1);
               this._trieveBtnTip.visible = false;
               this._trieveBtn.tipData = LanguageMgr.GetTranslation("tank.view.equipretrieve.tip");
            }
         }
      }
      
      private function updateMoney() : void
      {
         if(this._info)
         {
            this._goldText.text = String(this._info.Gold);
            this._moneyText.text = String(this._info.Money);
            this._giftText.text = String(this._info.Gift);
            this._medalField.text = String(this._info.medal);
         }
         else
         {
            this._goldText.text = this._moneyText.text = this._giftText.text = "";
         }
      }
      
      protected function __listChange(param1:Event) : void
      {
         this.setBagType(BagInfo.EQUIPBAG);
      }
      
      private function __sellClick(param1:MouseEvent) : void
      {
         if(!(this.state & this.STATE_SELL))
         {
            this.state |= this.STATE_SELL;
            SoundManager.instance.play("008");
            this._sellBtn.dragStart(param1.stageX,param1.stageY);
            this._sellBtn.addEventListener(SellGoodsBtn.StopSell,this.__stopSell);
            dispatchEvent(new Event("sellstart"));
            stage.addEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
            param1.stopImmediatePropagation();
         }
         else
         {
            this.state = ~this.STATE_SELL & this.state;
            this._sellBtn.stopDrag();
         }
      }
      
      private function __stopSell(param1:Event) : void
      {
         this.state = ~this.STATE_SELL & this.state;
         this._sellBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         dispatchEvent(new Event("sellstop"));
         if(stage)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
         }
      }
      
      private function __onStageClick_SellBtn(param1:Event) : void
      {
         this.state = ~this.STATE_SELL & this.state;
         dispatchEvent(new Event("sellstop"));
         if(stage)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__onStageClick_SellBtn);
         }
      }
      
      private function __breakClick(param1:MouseEvent) : void
      {
         if(this._breakBtn.enable)
         {
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
            }
            else
            {
               this._breakBtn.dragStart(param1.stageX,param1.stageY);
            }
         }
      }
      
      public function resetMouse() : void
      {
         this.state = ~this.STATE_SELL & this.state;
         LayerManager.Instance.clearnStageDynamic();
         Mouse.show();
         this._breakBtn.stopDrag();
      }
      
      private function isOnlyGivingGoods(param1:InventoryItemInfo) : Boolean
      {
         return param1.IsBinds == false && EquipType.isPackage(param1) && param1.Property2 == "10";
      }
      
      protected function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Point = null;
         if(!this._sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.data as BagCell;
            if(_loc2_)
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               if(!this.isOnlyGivingGoods(_loc3_) && (_loc3_.getRemainDate() <= 0 && !EquipType.isProp(_loc3_) || EquipType.isPackage(_loc3_) || _loc3_.getRemainDate() <= 0 && _loc3_.TemplateID == 10200 || EquipType.canBeUsed(_loc3_)))
               {
                  _loc4_ = localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  CellMenu.instance.show(_loc2_,_loc4_.x + 35,_loc4_.y + 77);
               }
               else
               {
                  _loc2_.dragStart();
               }
            }
         }
      }
      
      public function set cellDoubleClickEnable(param1:Boolean) : void
      {
         if(param1)
         {
            this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
         else
         {
            this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         }
      }
      
      protected function __cellDoubleClick(param1:CellEvent) : void
      {
         var _loc6_:BaseAlerFrame = null;
         var _loc7_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:BagCell = param1.data as BagCell;
         var _loc3_:InventoryItemInfo = _loc2_.info as InventoryItemInfo;
         var _loc4_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc3_.TemplateID);
         var _loc5_:int = !!PlayerManager.Instance.Self.Sex ? int(int(1)) : int(int(2));
         if(_loc3_.getRemainDate() <= 0)
         {
            return;
         }
         if(_loc4_.NeedSex != _loc5_ && _loc4_.NeedSex != 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.object"));
            return;
         }
         if(!_loc2_.locked)
         {
            if((_loc2_.info.BindType == 1 || _loc2_.info.BindType == 2 || _loc2_.info.BindType == 3) && _loc2_.itemInfo.IsBinds == false)
            {
               _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc6_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               this.temInfo = _loc3_;
            }
            else
            {
               SoundManager.instance.play("008");
               if(PlayerManager.Instance.Self.canEquip(_loc3_))
               {
                  if(_loc3_.CategoryID == 50 || _loc3_.CategoryID == 51 || _loc3_.CategoryID == 52)
                  {
                     if(PetBagController.instance().view && PetBagController.instance().view.parent)
                     {
                        if(!PetBagController.instance().petModel.currentPetInfo)
                        {
                           MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petEquipNo"));
                           return;
                        }
                        SocketManager.Instance.out.addPetEquip(_loc2_.place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
                     }
                     return;
                  }
                  _loc7_ = PlayerManager.Instance.getDressEquipPlace(_loc3_);
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,_loc7_,_loc3_.Count);
               }
            }
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendDefy();
         }
      }
      
      private function sendDefy() : void
      {
         var _loc1_:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.canEquip(this.temInfo))
         {
            if(this.temInfo.CategoryID == 50 || this.temInfo.CategoryID == 51 || this.temInfo.CategoryID == 52)
            {
               if(PetBagController.instance().view && PetBagController.instance().view.parent)
               {
                  if(!PetBagController.instance().petModel.currentPetInfo)
                  {
                     return;
                  }
                  SocketManager.Instance.out.addPetEquip(this.temInfo.Place,PetBagController.instance().petModel.currentPetInfo.Place,BagInfo.EQUIPBAG);
               }
               return;
            }
            _loc1_ = PlayerManager.Instance.getDressEquipPlace(this.temInfo);
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,_loc1_,this.temInfo.Count);
         }
      }
      
      private function __cellAddPrice(param1:Event) : void
      {
         var _loc2_:BagCell = CellMenu.instance.cell;
         if(_loc2_)
         {
            if(ShopManager.Instance.canAddPrice(_loc2_.itemInfo.TemplateID))
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               AddPricePanel.Instance.setInfo(_loc2_.itemInfo,false);
               AddPricePanel.Instance.show();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.cantAddPrice"));
            }
         }
      }
      
      private function __cellMove(param1:Event) : void
      {
         var _loc2_:BagCell = CellMenu.instance.cell;
         if(_loc2_)
         {
            _loc2_.dragStart();
         }
      }
      
      protected function __cellOpenBatch(param1:Event) : void
      {
         var _loc3_:OpenBatchView = null;
         var _loc2_:BagCell = CellMenu.instance.cell as BagCell;
         if(_loc2_ != null && _loc2_.itemInfo != null)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("bag.OpenBatchView");
            _loc3_.item = _loc2_.itemInfo;
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function __cellOpen(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         param1.stopPropagation();
         var _loc2_:BagCell = CellMenu.instance.cell as BagCell;
         this._currentCell = _loc2_;
         if(_loc2_ != null && _loc2_.itemInfo != null)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc3_ = !!PlayerManager.Instance.Self.Sex ? Number(Number(1)) : Number(Number(2));
            if(_loc2_.info.NeedSex != 0 && _loc3_ != _loc2_.info.NeedSex)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.sexErr"));
               return;
            }
            if(PlayerManager.Instance.Self.Grade >= _loc2_.info.NeedLevel)
            {
               if(_loc2_.info.TemplateID == EquipType.VIP_COIN && !PlayerManager.Instance.Self.IsVIP)
               {
                  param1.stopImmediatePropagation();
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipIcon.notVip"));
               }
               else if(_loc2_.info.TemplateID == EquipType.ROULETTE_BOX)
               {
                  RouletteManager.instance.useRouletteBox(_loc2_);
               }
               else if(_loc2_.info.TemplateID == EquipType.SURPRISE_ROULETTE_BOX)
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useSurpriseRoulette(_loc2_);
               }
               else if(EquipType.isCaddy(_loc2_.info))
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useCaddy(_loc2_);
               }
               else if(EquipType.isBeadNeedOpen(_loc2_.info))
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useBead(_loc2_.info.TemplateID);
               }
               else if(EquipType.isOfferPackage(_loc2_.info))
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useOfferPack(_loc2_);
               }
               else if(EquipType.isTimeBox(_loc2_.info))
               {
                  _loc4_ = DateUtils.getDateByStr(InventoryItemInfo(_loc2_.info).BeginDate);
                  _loc5_ = int(_loc2_.info.Property3) * 60 - (TimeManager.Instance.Now().getTime() - _loc4_.getTime()) / 1000;
                  if(_loc5_ <= 0)
                  {
                     SocketManager.Instance.out.sendItemOpenUp(_loc2_.itemInfo.BagType,_loc2_["place"]);
                  }
                  else
                  {
                     _loc6_ = _loc5_ / 3600;
                     _loc7_ = _loc5_ % 3600 / 60;
                     _loc7_ = _loc7_ > 0 ? int(int(_loc7_)) : int(int(1));
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.userGuild.boxTip",_loc6_,_loc7_));
                  }
               }
               else if(_loc2_.info.CategoryID == EquipType.CARDBOX)
               {
                  param1.stopImmediatePropagation();
                  RouletteManager.instance.useCard(_loc2_);
               }
               else if(_loc2_.info.TemplateID == EquipType.MY_CARDBOX)
               {
                  RouletteManager.instance.useBead(_loc2_.info.TemplateID);
               }
               else if(EquipType.PET_EGG == _loc2_.info.CategoryID)
               {
                  SocketManager.Instance.out.sendAddPet(_loc2_.itemInfo.Place,_loc2_.itemInfo.BagType);
               }
               else
               {
                  SocketManager.Instance.out.sendItemOpenUp(_loc2_.itemInfo.BagType,_loc2_["place"]);
               }
            }
            else if(_loc2_.info.CategoryID == EquipType.CARDBOX)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.bagView.openCardBox.level"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.level"));
            }
         }
      }
      
      private function __cellUse(param1:Event) : void
      {
         var _loc3_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:BagCell = CellMenu.instance.cell as BagCell;
         if(!_loc2_ || _loc2_.info == null)
         {
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.WISHBEAD_ATTACK || _loc2_.info.TemplateID == EquipType.WISHBEAD_DEFENSE || _loc2_.info.TemplateID == EquipType.WISHBEAD_AGILE)
         {
            BagStore.instance.show(BagStore.FORGE_STORE,1);
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.REWORK_NAME)
         {
            this.startReworkName(_loc2_.bagType,_loc2_.place);
            return;
         }
         if(_loc2_.info.CategoryID == 11 && _loc2_.info.Property1 == "5" && _loc2_.info.Property2 != "0")
         {
            this.showChatBugleInputFrame(_loc2_.info.TemplateID);
            return;
         }
         if(_loc2_.info.CategoryID == EquipType.TEXP_TASK)
         {
            if(PlayerManager.Instance.Self.Grade < 10)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.noGrade"));
               return;
            }
            if(TexpManager.Instance.getLv(TexpManager.Instance.getExp(int(_loc2_.info.Property1))) >= PlayerManager.Instance.Self.Grade + 5)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.lvToplimit"));
               return;
            }
            if(TaskManager.texpQuests.length > 0)
            {
               this._tmpCell = _loc2_;
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("texpSystem.view.TexpView.refreshTaskTip"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.__texpResponse);
               return;
            }
            SocketManager.Instance.out.sendTexp(-1,_loc2_.info.TemplateID,_loc2_.place);
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.CONSORTIA_REWORK_NAME)
         {
            if(PlayerManager.Instance.Self.ConsortiaID == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert1"));
               return;
            }
            if(PlayerManager.Instance.Self.NickName != PlayerManager.Instance.Self.consortiaInfo.ChairmanName)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert2"));
               return;
            }
            this.startupConsortiaReworkName(_loc2_.bagType,_loc2_.place);
            return;
         }
         if(_loc2_.info.TemplateID == EquipType.CHANGE_SEX)
         {
            this.startupChangeSex(_loc2_.bagType,_loc2_.place);
            return;
         }
         if(_loc2_.info.CategoryID == EquipType.TITLE_CARD)
         {
            SocketManager.Instance.out.sendNewTitleCard(_loc2_.itemInfo.Place,_loc2_.itemInfo.BagType);
         }
         if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 37)
         {
            if(!PlayerManager.Instance.Self.Bag.getItemAt(6))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.bagAndInfo.ColorShell.NoWeapon"));
               return;
            }
            if(PlayerManager.Instance.Self.Bag.getItemAt(6).StrengthenLevel >= 10)
            {
               SocketManager.Instance.out.sendUseChangeColorShell(_loc2_.bagType,_loc2_.place);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bagAndInfo.bag.UnableUseColorShell"));
         }
         if(_loc2_.info.TemplateID == EquipType.COLORCARD)
         {
            if(!this._changeColorController)
            {
               this._changeColorController = new ChangeColorController();
            }
            this._changeColorController.changeColorModel.place = _loc2_.place;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHANGECOLOR);
         }
         else if(_loc2_.info.TemplateID != EquipType.TRANSFER_PROP)
         {
            if(_loc2_.info.CategoryID == 11 && (int(_loc2_.info.Property1) == 27 || int(_loc2_.info.Property1) == 29))
            {
               if(this._self.Grade < 25)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.openTxt",25));
                  return;
               }
            }
            else
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               if(_loc2_.info.CategoryID == 11 && int(_loc2_.info.Property1) == 100)
               {
                  this.useProp(_loc2_.itemInfo);
               }
               else
               {
                  this.useCard(_loc2_.itemInfo);
               }
            }
         }
		 else if(_loc2_.info.TemplateID == EquipType.GEMSTONE)
		 {
			 if(PlayerManager.Instance.Self.Grade < 30)
			 {
				 MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gemstone.limitLevel.tipTxt"));
				 return;
			 }
			 if(this is ConsortionBankBagView)
			 {
				 BagStore.instance.isFromConsortionBankFrame = true;
			 }
			 else
			 {
				 BagStore.instance.isFromBagFrame = true;
			 }
			 BagStore.instance.show(BagStore.FORGE_STORE,3);
		 }
      }
      
      private function __texpResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__texpResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < 100)
            {
               LeavePageManager.showFillFrame();
               this._tmpCell = null;
               return;
            }
            SocketManager.Instance.out.sendTexp(-1,this._tmpCell.info.TemplateID,this._tmpCell.place);
            this._tmpCell = null;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
      }
      
      private function __changeColorProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHANGECOLOR)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __changeColorComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHANGECOLOR)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__changeColorProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__changeColorComplete);
            UIModuleSmallLoading.Instance.hide();
            this._changeColorController.show();
         }
      }
      
      private function useCard(param1:InventoryItemInfo) : void
      {
         if(param1.TemplateID == EquipType.FREE_PROP_CARD || param1.TemplateID == EquipType.DOUBLE_EXP_CARD || param1.TemplateID == EquipType.DOUBLE_GESTE_CARD || param1.TemplateID == EquipType.PREVENT_KICK || param1.TemplateID.toString().substring(0,3) == "119" || param1.TemplateID == EquipType.VIPCARD)
         {
            if(this._self.Grade < 3 && (param1.TemplateID == EquipType.VIPCARD || param1.TemplateID == EquipType.VIPCARD_TEST))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
               return;
            }
            SocketManager.Instance.out.sendUseCard(param1.BagType,param1.Place,[param1.TemplateID],param1.PayType);
         }
      }
      
      private function useProp(param1:InventoryItemInfo) : void
      {
         if(!param1)
         {
            return;
         }
         SocketManager.Instance.out.sendUseProp(param1.BagType,param1.Place,[param1.TemplateID],param1.PayType);
      }
      
      private function createBreakWin(param1:BagCell) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BreakGoodsView = ComponentFactory.Instance.creatComponentByStylename("breakGoodsView");
      }
      
      public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         this._currentList.setCellInfo(param1,param2);
      }
      
      public function dispose() : void
      {
         this._flag = false;
         this.removeEvents();
         this.resetMouse();
         NewHandContainer.Instance.clearArrowByID(ArrowType.BAG_WEAPON_BACK);
         isFlag = false;
         this._changeColorController = null;
         if(this._bagLockControl)
         {
            this._bagLockControl.close();
         }
         this._bagLockControl = null;
         this._info = null;
         this._lists = null;
         this._tmpCell = null;
         this._self.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
         this._self.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
         this._sellBtn.removeEventListener(MouseEvent.CLICK,this.__sellClick);
         this._sellBtn.removeEventListener(SellGoodsBtn.StopSell,this.__stopSell);
         this._breakBtn.removeEventListener(MouseEvent.CLICK,this.__breakClick);
         if(this._goodsNumInfoBg)
         {
            ObjectUtils.disposeObject(this._goodsNumInfoBg);
         }
         this._goodsNumInfoBg = null;
         if(this._goodsNumInfoText)
         {
            ObjectUtils.disposeObject(this._goodsNumInfoText);
         }
         this._goodsNumInfoText = null;
         if(this._goodsNumTotalText)
         {
            ObjectUtils.disposeObject(this._goodsNumTotalText);
         }
         this._goodsNumTotalText = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._petlist)
         {
            ObjectUtils.disposeObject(this._petlist);
         }
         this._petlist = null;
         if(this._goldText)
         {
            ObjectUtils.disposeObject(this._goldText);
         }
         this._goldText = null;
         if(this._moneyText)
         {
            ObjectUtils.disposeObject(this._moneyText);
         }
         this._moneyText = null;
         if(this._giftText)
         {
            ObjectUtils.disposeObject(this._giftText);
         }
         this._giftText = null;
         if(this._medalField)
         {
            ObjectUtils.disposeObject(this._medalField);
         }
         this._medalField = null;
         if(this._sortBagBtn)
         {
            ObjectUtils.disposeObject(this._sortBagBtn);
         }
         this._sortBagBtn = null;
         if(this._trieveBtn)
         {
            ObjectUtils.disposeObject(this._trieveBtn);
         }
         this._trieveBtn = null;
         if(this._settingLockBtn)
         {
            ObjectUtils.disposeObject(this._settingLockBtn);
         }
         this._settingLockBtn = null;
         if(this._settedLockBtn)
         {
            ObjectUtils.disposeObject(this._settedLockBtn);
         }
         this._settedLockBtn = null;
         if(this._keySetFrame)
         {
            ObjectUtils.disposeObject(this._keySetFrame);
         }
         this._keySetFrame = null;
         if(this._keySetBtn)
         {
            ObjectUtils.disposeObject(this._keySetBtn);
         }
         this._keySetBtn = null;
         if(this._breakBtn)
         {
            ObjectUtils.disposeObject(this._breakBtn);
         }
         this._breakBtn = null;
         if(this._currentList)
         {
            ObjectUtils.disposeObject(this._currentList);
         }
         this._currentList = null;
         if(this._sellBtn)
         {
            ObjectUtils.disposeObject(this._sellBtn);
         }
         this._sellBtn = null;
         if(this._proplist)
         {
            ObjectUtils.disposeObject(this._proplist);
         }
         this._proplist = null;
         if(this._equiplist)
         {
            ObjectUtils.disposeObject(this._equiplist);
         }
         this._equiplist = null;
         if(this._bgShape)
         {
            ObjectUtils.disposeObject(this._bgShape);
         }
         this._bgShape = null;
         if(this._goldButton)
         {
            ObjectUtils.disposeObject(this._goldButton);
         }
         this._goldButton = null;
         if(this._giftButton)
         {
            ObjectUtils.disposeObject(this._giftButton);
         }
         this._giftButton = null;
         if(this._moneyButton)
         {
            ObjectUtils.disposeObject(this._moneyButton);
         }
         this._moneyButton = null;
         if(this._medalButton)
         {
            ObjectUtils.disposeObject(this._medalButton);
         }
         this._medalButton = null;
         if(this._trieveBtnSprite)
         {
            ObjectUtils.disposeObject(this._trieveBtnSprite);
         }
         this._trieveBtnSprite = null;
         if(this._trieveBtnTip)
         {
            ObjectUtils.disposeObject(this._trieveBtnTip);
         }
         this._trieveBtnTip = null;
         if(this._continueBtn)
         {
            ObjectUtils.disposeObject(this._continueBtn);
         }
         this._continueBtn = null;
         if(this._chatBugleInputFrame)
         {
            ObjectUtils.disposeObject(this._chatBugleInputFrame);
         }
         this._chatBugleInputFrame = null;
         if(this._bgShapeII)
         {
            ObjectUtils.disposeObject(this._bgShapeII);
         }
         this._bgShapeII = null;
         if(this._bagList)
         {
            ObjectUtils.disposeObject(this._bagList);
         }
         this._bagList = null;
         if(this._equipBtn)
         {
            ObjectUtils.disposeObject(this._equipBtn);
         }
         this._equipBtn = null;
         if(this._propBtn)
         {
            ObjectUtils.disposeObject(this._propBtn);
         }
         this._propBtn = null;
         if(this._cardBtn)
         {
            ObjectUtils.disposeObject(this._cardBtn);
         }
         this._cardBtn = null;
         if(this._reworknameView)
         {
            this.shutdownReworkName();
         }
         if(this._consortaiReworkName)
         {
            this.shutdownConsortiaReworkName();
         }
         if(CellMenu.instance.showed)
         {
            CellMenu.instance.hide();
         }
         AddPricePanel.Instance.close();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function setBagCountShow(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GlowFilter = null;
         var _loc4_:uint = 0;
         switch(param1)
         {
            case BagInfo.EQUIPBAG:
               _loc2_ = PlayerManager.Instance.Self.getBag(param1).itemBgNumber(this._equiplist._startIndex,this._equiplist._stopIndex);
               if(_loc2_ >= 49)
               {
                  _loc4_ = 16711680;
                  _loc3_ = new GlowFilter(16777215,0.5,3,3,10);
               }
               else
               {
                  _loc4_ = 1310468;
                  _loc3_ = new GlowFilter(876032,0.5,3,3,10);
               }
               break;
            case BagInfo.PROPBAG:
               _loc2_ = PlayerManager.Instance.Self.getBag(param1).itemBgNumber(0,BagInfo.MAXPROPCOUNT);
               if(_loc2_ >= BagInfo.MAXPROPCOUNT + 1)
               {
                  _loc4_ = 16711680;
                  _loc3_ = new GlowFilter(16777215,0.5,3,3,10);
               }
               else
               {
                  _loc4_ = 1310468;
                  _loc3_ = new GlowFilter(876032,0.5,3,3,10);
               }
         }
         this._goodsNumInfoText.textColor = _loc4_;
         this._goodsNumInfoText.filters = [_loc3_];
         this._goodsNumInfoText.text = _loc2_.toString();
         this.setBagType(param1);
      }
      
      public function get info() : SelfInfo
      {
         return this._info;
      }
      
      public function set info(param1:SelfInfo) : void
      {
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            this._info.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.CLEAR,this.__clearHandler);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.AFTERDEL,this.__clearHandler);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.CHANGEPSW,this.__clearHandler);
         }
         this._info = param1;
         if(this._info)
         {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
            this._info.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdateEQUIPBAG);
            this._info.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdatePROPBAG);
            PlayerManager.Instance.Self.addEventListener(BagEvent.CLEAR,this.__clearHandler);
            PlayerManager.Instance.Self.addEventListener(BagEvent.AFTERDEL,this.__clearHandler);
            PlayerManager.Instance.Self.addEventListener(BagEvent.CHANGEPSW,this.__clearHandler);
         }
         this.updateView();
      }
      
	  private function startReworkName(param1:int, param2:int) : void
	  {
		  this._reworknameView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameFrame");
		  LayerManager.Instance.addToLayer(this._reworknameView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
		  this._reworknameView.initialize(param1,param2);
		  this._reworknameView.addEventListener(Event.COMPLETE,this.__onRenameComplete);
	  }
      
	  private function shutdownReworkName() : void
	  {
		  this._reworknameView.removeEventListener(Event.COMPLETE,this.__onRenameComplete);
		  ObjectUtils.disposeObject(this._reworknameView);
		  this._reworknameView = null;
	  }
      
      private function __onRenameComplete(param1:Event) : void
      {
         this.shutdownReworkName();
      }
      
      private function startupConsortiaReworkName(param1:int, param2:int) : void
      {
         this._consortaiReworkName = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameConsortia");
         LayerManager.Instance.addToLayer(this._consortaiReworkName,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._consortaiReworkName.initialize(param1,param2);
         this._consortaiReworkName.addEventListener(Event.COMPLETE,this.__onConsortiaRenameComplete);
      }
      
      private function shutdownConsortiaReworkName() : void
      {
         this._consortaiReworkName.removeEventListener(Event.COMPLETE,this.__onConsortiaRenameComplete);
         ObjectUtils.disposeObject(this._consortaiReworkName);
         this._consortaiReworkName = null;
      }
      
      private function showChatBugleInputFrame(param1:int) : void
      {
         if(this._chatBugleInputFrame == null)
         {
            this._chatBugleInputFrame = ComponentFactory.Instance.creat("chat.BugleInputFrame");
         }
         this._chatBugleInputFrame.templateID = param1;
         LayerManager.Instance.addToLayer(this._chatBugleInputFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __onConsortiaRenameComplete(param1:Event) : void
      {
         this.shutdownConsortiaReworkName();
      }
      
      public function hide() : void
      {
         if(this._reworknameView)
         {
            this.shutdownReworkName();
         }
         if(this._consortaiReworkName)
         {
            this.shutdownConsortiaReworkName();
         }
         this.closeKeySetFrame();
      }
      
      private function judgeAndPlayCardMovie() : void
      {
         var _loc3_:CardInfo = null;
         var _loc4_:Sprite = null;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:BaseCell = null;
         var _loc7_:GradientText = null;
         var _loc1_:ItemTemplateInfo = this._currentCell.info;
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.TemplateID == int(_loc1_.Property5))
            {
               return;
            }
         }
         SocketManager.Instance.out.sendFirstGetCards();
         dispatchEvent(new Event(FIRST_GET_CARD,true));
         this.getNewCardMovie = ClassUtils.CreatInstance("asset.getNecCard.movie") as MovieClip;
         PositionUtils.setPos(this.getNewCardMovie,"BagView.NewCardMovie.Pos");
         _loc4_ = new Sprite();
         _loc4_.graphics.beginFill(16777215,0);
         _loc4_.graphics.drawRect(0,0,113,156);
         _loc4_.graphics.endFill();
         _loc5_ = ItemManager.Instance.getTemplateById(int(_loc1_.Property5));
         _loc6_ = new BaseCell(_loc4_,_loc5_);
         this.getNewCardMovie["card"].addChild(_loc6_);
         _loc7_ = ComponentFactory.Instance.creatComponentByStylename("getNewCardMovie.text");
         _loc7_.text = LanguageMgr.GetTranslation("ddt.cardSystem.getNewCard.name",_loc5_.Name);
         _loc7_.x -= (_loc7_.textWidth - _loc6_.width) / 6;
         this.getNewCardMovie["word"].addChild(_loc7_);
         LayerManager.Instance.addToLayer(this.getNewCardMovie,LayerManager.STAGE_TOP_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
         this.getNewCardMovie.gotoAndPlay(1);
         this.getNewCardMovie.addEventListener(Event.COMPLETE,this.__showOver);
         this._soundControl = new SoundTransform();
         if(SoundManager.instance.allowSound)
         {
            this._soundControl.volume = 1;
         }
         else
         {
            this._soundControl.volume = 0;
         }
         this.getNewCardMovie.soundTransform = this._soundControl;
      }
      
      private function __showOver(param1:Event) : void
      {
         this.getNewCardMovie.removeEventListener(Event.COMPLETE,this.__showOver);
         this._soundControl.volume = 0;
         this.getNewCardMovie.soundTransform = this._soundControl;
         this._soundControl = null;
         ObjectUtils.disposeObject(this.getNewCardMovie);
         this.getNewCardMovie = null;
      }
      
      protected function _isSkillCanUse() : Boolean
      {
         var _loc1_:Boolean = false;
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_TEN_PERSENT) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THREE_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TWO_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THIRTY_OPEN))
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function startupChangeSex(param1:int, param2:int) : void
      {
         var _loc3_:ChangeSexAlertFrame = ComponentFactory.Instance.creat("bagAndInfo.bag.changeSexAlert");
         _loc3_.bagType = param1;
         _loc3_.place = param2;
         _loc3_.info = this.getAlertInfo("tank.view.bagII.changeSexAlert",true);
         _loc3_.addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,_loc3_.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
         StageReferance.stage.focus = _loc3_;
      }
      
      private function getAlertInfo(param1:String, param2:Boolean = false) : AlertInfo
      {
         var _loc3_:AlertInfo = new AlertInfo();
         _loc3_.autoDispose = true;
         _loc3_.showSubmit = true;
         _loc3_.showCancel = param2;
         _loc3_.enterEnable = true;
         _loc3_.escEnable = true;
         _loc3_.moveEnable = false;
         _loc3_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc3_.data = LanguageMgr.GetTranslation(param1);
         return _loc3_;
      }
      
      private function __onAlertSizeChanged(param1:ComponentEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(_loc2_.info.frameCenter)
         {
            _loc2_.x = (StageReferance.stageWidth - _loc2_.width) / 2;
            _loc2_.y = (StageReferance.stageHeight - _loc2_.height) / 2;
         }
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ChangeSexAlertFrame = ChangeSexAlertFrame(param1.currentTarget);
         _loc2_.removeEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.sendChangeSex(_loc2_.bagType,_loc2_.place);
         }
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      private function __changeSexHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:SimpleAlert = null;
         SocketManager.Instance.socket.close();
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            _loc3_ = ComponentFactory.Instance.creat("sellGoodsAlert");
            _loc3_.info = this.getAlertInfo("tank.view.bagII.changeSexAlert.success",false);
            _loc3_.addEventListener(ComponentEvent.PROPERTIES_CHANGED,this.__onAlertSizeChanged);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onSuccessAlertResponse);
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,_loc3_.info.frameCenter,LayerManager.BLCAK_BLOCKGOUND);
            StageReferance.stage.focus = _loc3_;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.changeSexAlert.failed"));
         }
      }
      
      private function __onSuccessAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         ExternalInterface.call("WindowReturn");
      }
   }
}
