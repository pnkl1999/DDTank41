package store.view.exalt
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import store.HelpFrame;
   import store.IStoreViewBG;
   import store.StoneCell;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.StrengthDataManager;
   import store.data.StoreEquipExperience;
   import store.events.StoreIIEvent;
   import store.forge.wishBead.WishBeadBagListView;
   import store.view.strength.StrengthStone;
   
   public class StoreExaltBG extends Sprite implements IStoreViewBG
   {
      
      public static const INTERVAL:int = 1400;
       
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _exaltBtn:BaseButton;
      
      private var _progressBar:StoreExaltProgressBar;
      
      private var _equipmentCellBg:Image;
      
      private var _goodCellBg:Bitmap;
      
      private var _equipmentCellText:FilterFrameText;
      
      private var _rockText:FilterFrameText;
      
      private var _pointArray:Vector.<Point>;
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _quick:QuickBuyFrame;
      
      private var _continuous:SelectedCheckButton;
      
      private var _timer:Timer;
      
      private var _helpBtn:BaseButton;
      
      private var _movieI:MovieClip;
      
      private var _movieII:MovieClip;
      
      private var _luckyText:FilterFrameText;
      
      private var _bagList:WishBeadBagListView;
      
      private var _proBagList:WishBeadBagListView;
      
      private var _equipBagInfo:BagInfo;
      
      private var _bg:Bitmap;
      
      private var _lastExaltTime:int = 0;
      
      private var _aler:ExaltSelectNumAlertFrame;
      
      public function StoreExaltBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:StoreCell = null;
         _loc1_ = 0;
         _loc2_ = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.wishBead.leftViewBg");
         this._buyBtn = UICreatShortcut.creatAndAdd("ddt.store.view.exalt.buyBtn",this);
         this._exaltBtn = UICreatShortcut.creatAndAdd("ddt.store.view.exalt.exaltBtn",this);
         this._progressBar = UICreatShortcut.creatAndAdd("store.view.exalt.storeExaltProgressBar",this);
         this._progressBar.progress(0,0);
         this._helpBtn = UICreatShortcut.creatAndAdd("ddtstore.HelpButton",this);
         this._continuous = UICreatShortcut.creatAndAdd("ddt.store.view.exalt.SelectedCheckButton",this);
         this._continuous.selected = false;
         this._bagList = new WishBeadBagListView(BagInfo.EQUIPBAG,7,21);
         PositionUtils.setPos(this._bagList,"wishBeadMainView.bagListPos");
         this.refreshBagList();
         this._proBagList = new WishBeadBagListView(BagInfo.PROPBAG,7,21);
         PositionUtils.setPos(this._proBagList,"wishBeadMainView.proBagListPos");
         this._proBagList.setData(ExaltManager.instance.getWishBeadItemData());
         this._equipmentCellBg = UICreatShortcut.creatAndAdd("ddtstore.StoreIIStrengthBG.stoneCellBg",this);
         PositionUtils.setPos(this._equipmentCellBg,"ddtstore.StoreIIStrengthBG.EquipmentCellBgPos");
         this._equipmentCellText = UICreatShortcut.creatTextAndAdd("ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellText",LanguageMgr.GetTranslation("store.Strength.StrengthenCurrentEquipmentCellText"),this);
         PositionUtils.setPos(this._equipmentCellText,"ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellTextPos");
         this._goodCellBg = UICreatShortcut.creatAndAdd("asset.ddtstore.GoodPanel",this);
         PositionUtils.setPos(this._goodCellBg,"ddtstore.StoreIIStrengthBG.StrengthCellBg1Point");
         this._rockText = UICreatShortcut.creatTextAndAdd("ddtstore.StoreIIStrengthBG.GoodCellText",LanguageMgr.GetTranslation("store.Strength.GoodPanelText.StoreExaltRock"),this);
         PositionUtils.setPos(this._rockText,"ddtstore.StoreIIStrengthBG.StrengthStoneText1Point");
         this.getCellsPoint();
         this._items = new Array();
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         _loc1_ = 0;
         while(_loc1_ < this._pointArray.length)
         {
            switch(_loc1_)
            {
               case 0:
                  _loc2_ = new StrengthStone([StoneType.EXALT,StoneType.EXALT_1],_loc1_);
                  break;
               case 1:
                  _loc2_ = new ExaltItemCell(_loc1_);
                  break;
            }
            _loc2_.addEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[_loc1_] = _loc2_;
            _loc2_.x = this._pointArray[_loc1_].x;
            _loc2_.y = this._pointArray[_loc1_].y;
            addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function refreshBagList() : void
      {
         this._equipBagInfo = ExaltManager.instance.getCanWishBeadData();
         this._bagList.setData(this._equipBagInfo);
      }
      
      private function initEvent() : void
      {
         this._exaltBtn.addEventListener(MouseEvent.CLICK,this.__onExaltClick);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__onBuyClick);
         this._continuous.addEventListener(MouseEvent.CLICK,this.__continuousClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpClick);
         StrengthDataManager.instance.addEventListener(StoreIIEvent.EXALT_FINISH,this.__exaltFinish);
         StrengthDataManager.instance.addEventListener(StoreIIEvent.EXALT_FAIL,this.__exaltFail);
         this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE_Exalt,this.__updateStoreBag);
      }
      
      private function __updateStoreBag(param1:BagEvent) : void
      {
         this.refreshData(param1.changedSlots);
      }
      
      private function cellClickHandler(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BagCell = param1.data as BagCell;
         _loc2_.dragStart();
      }
      
      protected function __cellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:String = "";
         if(param1.target == this._proBagList)
         {
            _loc2_ = ExaltManager.ITEM_MOVE;
         }
         else
         {
            _loc2_ = ExaltManager.EQUIP_MOVE;
         }
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[_loc1_].dispose();
            _loc1_++;
         }
         this._exaltBtn.removeEventListener(MouseEvent.CLICK,this.__onExaltClick);
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyClick);
         this._continuous.removeEventListener(MouseEvent.CLICK,this.__continuousClick);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpClick);
         StrengthDataManager.instance.removeEventListener(StoreIIEvent.EXALT_FINISH,this.__exaltFinish);
         StrengthDataManager.instance.removeEventListener(StoreIIEvent.EXALT_FAIL,this.__exaltFail);
         PlayerManager.Instance.Self.StoreBag.removeEventListener(BagEvent.UPDATE_Exalt,this.__updateStoreBag);
      }
      
      protected function __exaltFinish(param1:StoreIIEvent) : void
      {
         this.showSuccessMovie();
      }
      
      protected function __exaltFail(param1:StoreIIEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         ObjectUtils.disposeObject(this._luckyText);
         this._luckyText = null;
         this._luckyText = ComponentFactory.Instance.creatComponentByStylename("ddt.store.view.exalt.luckyText");
         this._luckyText.text = LanguageMgr.GetTranslation("store.view.exalt.luckyTips",int(param1.data));
         var _loc2_:int = this._luckyText.width;
         _loc3_ = this._luckyText.height;
         _loc4_ = this._luckyText.y;
         this._luckyText.width /= 2;
         this._luckyText.height /= 2;
         this._luckyText.alpha = 0.5;
         TweenMax.fromTo(this._luckyText,2,{
            "y":_loc4_ - 30,
            "alpha":1,
            "width":_loc2_,
            "height":_loc3_
         },{
            "y":_loc4_ - 60,
            "alpha":0,
            "width":0,
            "height":0,
            "onComplete":this.onComplete
         });
         addChild(this._luckyText);
         SoundManager.instance.play("171");
         if(this._continuous.selected)
         {
            setTimeout(this.sendExalt,1000);
         }
      }
      
      private function onComplete() : void
      {
         ObjectUtils.disposeObject(this._luckyText);
         this._luckyText = null;
      }
      
      protected function __helpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:MovieClip = ComponentFactory.Instance.creatCustomObject("store.view.exalt.HelpBG");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         _loc3_.height = 482;
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.StoreExaltBG.say");
         _loc3_.setButtonPos(165,439);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      protected function __frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:Disposeable = param1.target as Disposeable;
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      protected function __continuousClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._continuous.selected)
         {
            this.disposeTimer();
         }
      }
      
      private function disposeTimer() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onRepeatCount);
            this._timer = null;
            this._exaltBtn.enable = true;
         }
      }
      
      protected function __onRepeatCount(param1:TimerEvent) : void
      {
         if(this._items)
         {
            if(this.isExalt() && this.equipisAdapt(this._items[1].info))
            {
               this.sendExalt();
            }
            else
            {
               this.disposeTimer();
            }
         }
      }
      
      protected function __onBuyClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.buyRock();
      }
      
      protected function __onExaltClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:int = getTimer();
         if(_loc2_ - this._lastExaltTime > INTERVAL)
         {
            this._lastExaltTime = _loc2_;
            this.sendExalt();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
         }
      }
      
      private function sendContinuousExalt() : void
      {
         if(this.isExalt())
         {
            if(this._continuous.selected)
            {
               this._timer = new Timer(INTERVAL);
               this._timer.addEventListener(TimerEvent.TIMER,this.__onRepeatCount);
               this._timer.start();
               this._exaltBtn.enable = false;
            }
            else
            {
               this.disposeTimer();
            }
         }
      }
      
      private function sendExalt() : void
      {
         if(this.isExalt())
         {
            SocketManager.Instance.out.sendItemExalt();
            this.showExaltMovie();
         }
      }
      
      private function isExalt() : Boolean
      {
         if(this._items == null)
         {
            return false;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return false;
         }
         if(this._items == null)
         {
            return false;
         }
         if(StrengthStone(this._items[0]).itemInfo == null || ExaltItemCell(this._items[1]).itemInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warning"));
            return false;
         }
         if(this._items[1].info && this._items[1].info.StrengthenLevel >= 15)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warningI"));
            return false;
         }
         if(int(this._items[0].info.Property3) != 0)
         {
            if(this._items[1].info.StrengthenLevel - 11 == int(this._items[0].info.Property3))
            {
               return true;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warningII"));
            return false;
         }
         return true;
      }
      
      private function getCellsPoint() : void
      {
         this._pointArray = new Vector.<Point>();
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("store.view.exalt.StoreExaltBG.point0");
         this._pointArray.push(_loc1_);
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("store.view.exalt.StoreExaltBG.point1");
         this._pointArray.push(_loc2_);
      }
      
      protected function __itemInfoChange(param1:Event) : void
      {
         var _loc3_:ExaltItemCell = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         if(param1.currentTarget is ExaltItemCell)
         {
            _loc3_ = param1.currentTarget as ExaltItemCell;
            _loc4_ = _loc3_.info as InventoryItemInfo;
            if(_loc4_)
            {
               if(ExaltItemCell(this._items[1]).actionState)
               {
                  ExaltItemCell(this._items[1]).actionState = false;
               }
               _loc2_ = StoreEquipExperience.expericence[_loc4_.StrengthenLevel + 1];
               if(_loc2_ == 0)
               {
                  this._progressBar.progress(0,0);
               }
               else
               {
                  this._progressBar.progress(_loc4_.StrengthenExp,_loc2_);
               }
            }
            else
            {
               this._progressBar.progress(0,0);
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function showSuccessMovie() : void
      {
         if(this._movieI)
         {
            this._movieI.stop();
         }
         ObjectUtils.disposeObject(this._movieI);
         this._movieI = null;
         this._movieI = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.movieI",this);
         this._movieI.gotoAndPlay(1);
         this._movieI.addFrameScript(this._movieI.totalFrames - 1,this.disposeSuccessMovie);
      }
      
      private function showExaltMovie() : void
      {
         if(this._movieII)
         {
            this._movieII.stop();
         }
         else
         {
            this._movieII = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.movieII",this);
         }
         this._movieII.gotoAndPlay(1);
         this._movieII.addFrameScript(this._movieII.totalFrames - 1,this.disposeExaltMovie);
      }
      
      private function disposeExaltMovie() : void
      {
         if(this._movieII)
         {
            this._movieII.stop();
         }
         ObjectUtils.disposeObject(this._movieII);
         this._movieII = null;
      }
      
      private function disposeSuccessMovie() : void
      {
         if(this._movieI)
         {
            this._movieI.stop();
         }
         ObjectUtils.disposeObject(this._movieI);
         this._movieI = null;
      }
      
      private function buyRock() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._quick = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
         this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         this._quick.itemID = EquipType.EXALT_ROCK;
         LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dragDrop(param1:BagCell) : void
      {
         var _loc3_:StoreCell = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.info == _loc2_)
            {
               _loc3_.info = null;
               param1.locked = false;
               return;
            }
         }
         for each(_loc3_ in this._items)
         {
            if(_loc3_)
            {
               if(_loc3_ is StoneCell)
               {
                  if((_loc3_ as StoneCell).types.indexOf(_loc2_.Property1) > -1 && _loc2_.CategoryID == 11)
                  {
                     if(this.isAdaptToStone(_loc2_))
                     {
                        if(_loc2_.Count == 1)
                        {
                           SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1,true);
                        }
                        else
                        {
                           this.showNumAlert(_loc2_,_loc3_.index);
                        }
                        return;
                     }
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                  }
               }
               else if(_loc3_ is ExaltItemCell)
               {
                  if(_loc2_.getRemainDate() <= 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                  }
                  else if(param1.info.CanStrengthen && this.equipisAdapt(_loc2_))
                  {
                     SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1);
                     ExaltItemCell(this._items[1]).actionState = true;
                     return;
                  }
               }
            }
         }
         if(EquipType.isExaltStone(_loc2_))
         {
            for each(_loc3_ in this._items)
            {
               if(_loc3_ is StoneCell && (_loc3_ as StoneCell).types.indexOf(_loc2_.Property1) > -1 && _loc2_.CategoryID == 11)
               {
                  if(this.isAdaptToStone(_loc2_))
                  {
                     if(_loc2_.Count == 1)
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1,true);
                     }
                     else
                     {
                        this.showNumAlert(_loc2_,_loc3_.index);
                     }
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
               }
            }
         }
      }
      
      private function showNumAlert(param1:InventoryItemInfo, param2:int) : void
      {
         this._aler = ComponentFactory.Instance.creat("store.view.exalt.exaltSelectNumAlertFrame");
         this._aler.addExeFunction(this.sellFunction,this.notSellFunction);
         this._aler.goodsinfo = param1;
         this._aler.index = param2;
         this._aler.show(param1.Count);
      }
      
      private function sellFunction(param1:int, param2:InventoryItemInfo, param3:int) : void
      {
         SocketManager.Instance.out.sendMoveGoods(param2.BagType,param2.Place,BagInfo.STOREBAG,param3,param1,true);
         if(this._aler)
         {
            this._aler.dispose();
         }
         if(this._aler && this._aler.parent)
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function notSellFunction() : void
      {
         if(this._aler)
         {
            this._aler.dispose();
         }
         if(this._aler && this._aler.parent)
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function isAdaptToStone(param1:InventoryItemInfo) : Boolean
      {
         if(this._items[0].info != null && this._items[0].info.Property1 != param1.Property1)
         {
            return false;
         }
         return true;
      }
      
      private function equipisAdapt(param1:InventoryItemInfo) : Boolean
      {
         if(param1.StrengthenLevel >= 15)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warningI"));
            return false;
         }
         return true;
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1)
         {
            _loc3_ = int(_loc2_);
            if(this._items.hasOwnProperty(_loc3_))
            {
               this._items[_loc3_].info = PlayerManager.Instance.Self.StoreBag.items[_loc3_];
            }
         }
      }
      
      public function updateData() : void
      {
         if(PlayerManager.Instance.Self.StoreBag.items[0] && this.isAdaptToStone(PlayerManager.Instance.Self.StoreBag.items[0]))
         {
            this._items[0].info = PlayerManager.Instance.Self.StoreBag.items[0];
         }
         else
         {
            this._items[0].info = null;
         }
         if(PlayerManager.Instance.Self.StoreBag.items[1] && EquipType.isStrengthStone(PlayerManager.Instance.Self.StoreBag.items[1]))
         {
            this._items[1].info = PlayerManager.Instance.Self.StoreBag.items[1];
         }
         else
         {
            this._items[1].info = null;
         }
      }
      
      public function hide() : void
      {
         this.visible = false;
         this._items[0].info = null;
         this._items[1].info = null;
         this.disposeTimer();
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function dispose() : void
      {
         this.disposeTimer();
         this.removeEvent();
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._exaltBtn);
         this._exaltBtn = null;
         ObjectUtils.disposeObject(this._progressBar);
         this._progressBar = null;
         ObjectUtils.disposeObject(this._equipmentCellBg);
         this._equipmentCellBg = null;
         ObjectUtils.disposeObject(this._goodCellBg);
         this._goodCellBg = null;
         ObjectUtils.disposeObject(this._equipmentCellText);
         this._equipmentCellText = null;
         ObjectUtils.disposeObject(this._rockText);
         this._rockText = null;
         ObjectUtils.disposeObject(this._area);
         this._area = null;
         ObjectUtils.disposeObject(this._quick);
         this._quick = null;
         ObjectUtils.disposeObject(this._continuous);
         this._continuous = null;
         this._items = null;
      }
   }
}
