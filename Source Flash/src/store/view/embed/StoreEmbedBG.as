package store.view.embed
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.events.StoreEmbedEvent;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.StoneCell;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.data.StoreModel;
   import store.events.EmbedBackoutEvent;
   import store.events.EmbedEvent;
   import store.events.StoreIIEvent;
   
   public class StoreEmbedBG extends Sprite implements IStoreViewBG
   {
      
      public static const EMBED_MONEY:Number = 2000;
      
      public static const EMBED_BACKOUT_MONEY:Number = 500;
      
      public static const FIVE:int = 5;
      
      public static const SIX:int = 6;
      
      public static const NEED_GOLD:int = 2000;
       
      
      private var _items:Array;
      
      private var _area:StoreDragInArea;
      
      private var _stoneCells:Vector.<EmbedStoneCell>;
      
      private var _embedItemCell:EmbedItemCell;
      
      private var _quick:QuickBuyFrame;
      
      private var _embedBackoutDownItem:BaseButton;
      
      private var _openFiveHoleBtn:MultipleButton;
      
      private var _openSixHoleBtn:MultipleButton;
      
      private var _embedStoneCell:EmbedStoneCell;
      
      private var _embedBackoutMouseIcon:ScaleFrameImage;
      
      private var _help:BaseButton;
      
      private var _embedBackoutBtn:EmbedBackoutButton;
      
      private var _bg:MutipleImage;
      
      private var _currentHolePlace:int;
      
      private var _templateID:int;
      
      private var _pointArray:Vector.<Point>;
      
      private var _drill:InventoryItemInfo;
      
      private var _hole5ExpBar:HoleExpBar;
      
      private var _hole6ExpBar:HoleExpBar;
      
      private var _stoneInfo:InventoryItemInfo;
      
      private var _openHoleNumber:int = 0;
      
      private var _drillPlace:int = 0;
      
      private var _itemPlace:int = 0;
      
      private var _drillID:int;
      
      private var _isEmbedBreak:Boolean = false;
      
      public function StoreEmbedBG()
      {
         super();
         this.init();
         this.initEvents();
      }
      
      public function holeLvUp(param1:int) : void
      {
         this._stoneCells[param1].holeLvUp();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:EmbedStoneCell = null;
         _loc1_ = 0;
         _loc2_ = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("store.EmbedBG");
         addChild(this._bg);
         this._help = ComponentFactory.Instance.creatComponentByStylename("store.StrengthNodeBtn");
         addChild(this._help);
         this._embedBackoutBtn = ComponentFactory.Instance.creatCustomObject("store.EmbedBackoutButton");
         addChild(this._embedBackoutBtn);
         this._embedBackoutDownItem = ComponentFactory.Instance.creatComponentByStylename("store.EmbedBackoutDownBtn");
         this._openFiveHoleBtn = ComponentFactory.Instance.creatComponentByStylename("store.EmbedOpenHoleFive");
         this._openSixHoleBtn = ComponentFactory.Instance.creatComponentByStylename("store.EmbedOpenHoleSix");
         this._openFiveHoleBtn.transparentEnable = this._openSixHoleBtn.transparentEnable = true;
         this._openFiveHoleBtn.visible = this._openSixHoleBtn.visible = false;
         addChild(this._openFiveHoleBtn);
         addChild(this._openSixHoleBtn);
         this._hole5ExpBar = ComponentFactory.Instance.creatCustomObject("store.embed.Hole5ExpBar");
         addChild(this._hole5ExpBar);
         this._hole6ExpBar = ComponentFactory.Instance.creatCustomObject("store.embed.Hole6ExpBar");
         addChild(this._hole6ExpBar);
         this._items = [];
         this._stoneCells = new Vector.<EmbedStoneCell>();
         this.getCellsPoint();
         this._embedItemCell = new EmbedItemCell(0);
         this._embedItemCell.x = this._pointArray[0].x;
         this._embedItemCell.y = this._pointArray[0].y;
         addChild(this._embedItemCell);
         this._items.push(this._embedItemCell);
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         _loc1_ = 1;
         while(_loc1_ < 7)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("store.EmbedStoneCell",[_loc1_,-1]);
            _loc2_.x = this._pointArray[_loc1_].x;
            _loc2_.y = this._pointArray[_loc1_].y;
            addChild(_loc2_);
            _loc2_.mouseChildren = false;
            _loc2_.addEventListener(EmbedEvent.EMBED,this.__embed);
            _loc2_.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT,this.__EmbedBackout);
            _loc2_.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OVER,this.__EmbedBackoutDownItemOver);
            _loc2_.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OUT,this.__EmbedBackoutDownItemOut);
            _loc2_.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_DOWN,this.__EmbedBackoutDownItemDown);
            this._stoneCells.push(_loc2_);
            _loc1_++;
         }
         this.hide();
      }
      
      private function initEvents() : void
      {
         this._embedItemCell.addEventListener(Event.CHANGE,this.__itemInfoChange);
         this._embedItemCell.addEventListener(StoreEmbedEvent.ItemChang,this.__itemChange);
         this._help.addEventListener(MouseEvent.CLICK,this.__openHelp);
         this._embedBackoutBtn.addEventListener(MouseEvent.CLICK,this.__embedBackoutBtnClick);
         this._openFiveHoleBtn.addEventListener(MouseEvent.CLICK,this._openFiveHoleClick);
         this._openSixHoleBtn.addEventListener(MouseEvent.CLICK,this._openSixHoleClick);
      }
      
      private function __itemChange(param1:StoreEmbedEvent) : void
      {
         if(this._stoneCells[FIVE - 1].hasDrill())
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,EmbedStoneCell.FivePlaceInStoreBag,BagInfo.PROPBAG,-1,this._stoneCells[FIVE - 1].itemInfo.Count,true);
         }
         if(this._stoneCells[SIX - 1].hasDrill())
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,EmbedStoneCell.SixPlaceInStoreBag,BagInfo.PROPBAG,-1,this._stoneCells[SIX - 1].itemInfo.Count,true);
         }
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("store.Embedpoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function __embedBackoutBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         this._embedBackoutBtn.mouseEnabled = false;
         this._embedBackoutBtn.isAction = true;
         this._embedBackoutMouseIcon = ComponentFactory.Instance.creatComponentByStylename("store.embedBackoutMouseIcon");
         this._embedBackoutMouseIcon.setFrame(1);
         DragManager.startDrag(this._embedBackoutBtn,this._embedBackoutBtn,this._embedBackoutMouseIcon,param1.stageX,param1.stageY,DragEffect.MOVE,false,true);
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._stoneCells.length)
         {
            this._stoneCells[_loc2_].close();
            this._openSixHoleBtn.visible = false;
            this._openFiveHoleBtn.visible = false;
            _loc2_++;
         }
         if(this._embedItemCell.info != null)
         {
            this.initHoleType();
            this.updateHoles();
            dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_INFORCHANGE));
         }
      }
      
      private function initHoleType() : void
      {
         var _loc1_:InventoryItemInfo = this._embedItemCell.itemInfo;
         var _loc2_:Array = _loc1_.Hole.split("|");
         var _loc3_:int = 0;
         while(_loc3_ < this._stoneCells.length)
         {
            this._stoneCells[_loc3_].StoneType = _loc2_[_loc3_].split(",")[1];
            _loc3_++;
         }
      }
      
      private function updateHoles() : void
      {
         var _loc1_:InventoryItemInfo = this._embedItemCell.itemInfo;
         var _loc2_:Array = _loc1_.Hole.split("|");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if((_loc1_.StrengthenLevel >= int(String(_loc2_[_loc3_]).split(",")[0]) || _loc1_["Hole" + (_loc3_ + 1)] >= 0) && _loc3_ < 4)
            {
               this._stoneCells[_loc3_].open();
               this._stoneCells[_loc3_].tipDerial = true;
               if(_loc1_["Hole" + (_loc3_ + 1)] != 0)
               {
                  this._stoneCells[_loc3_].info = ItemManager.Instance.getTemplateById(_loc1_["Hole" + (_loc3_ + 1)]);
                  this._stoneCells[_loc3_].tipDerial = false;
               }
            }
            else
            {
               this._stoneCells[_loc3_].close();
               this._stoneCells[_loc3_].tipDerial = false;
            }
            _loc3_++;
         }
         this.updateOpenFiveSixHole(_loc1_);
      }
      
      private function updateOpenFiveSixHole(param1:InventoryItemInfo) : void
      {
         param1 = this._embedItemCell.itemInfo;
         var _loc2_:Array = param1.Hole.split("|");
         if(param1.Hole5Level > 0 || param1.Hole5 > 0)
         {
            this._stoneCells[FIVE - 1].open();
            this._stoneCells[FIVE - 1].info = ItemManager.Instance.getTemplateById(param1.Hole5);
         }
         if(param1.Hole6Level > 0 || param1.Hole6 > 0)
         {
            this._stoneCells[SIX - 1].open();
            this._stoneCells[SIX - 1].info = ItemManager.Instance.getTemplateById(param1.Hole6);
         }
         this._hole5ExpBar.visible = this._openFiveHoleBtn.visible = param1.Hole5Level < StoreModel.getHoleMaxOpLv() && this._embedItemCell.info != null;
         this._hole6ExpBar.visible = this._openSixHoleBtn.visible = param1.Hole6Level < StoreModel.getHoleMaxOpLv() && this._embedItemCell.info != null;
      }
      
      private function confirmIsBindWhenOpenHole() : void
      {
         var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__confireIsBindWhenOpenHoleResponse);
      }
      
      private function __confireIsBindWhenOpenHoleResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confireIsBindWhenOpenHoleResponse);
         _loc2_.dispose();
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.sendOpenHole(this._itemPlace,this._openHoleNumber,this._drill.TemplateID);
         }
      }
      
      private function getDrillByLevel(param1:int) : InventoryItemInfo
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.PropBag.items;
         for each(_loc3_ in _loc2_)
         {
            if(EquipType.isDrill(_loc3_) && _loc3_.Level == param1 + 1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function _openFiveHoleClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:InventoryItemInfo = InventoryItemInfo(this._embedItemCell.info);
         if(_loc2_.Hole5Level >= StoreModel.getHoleMaxOpLv())
         {
            return;
         }
         this._drill = this.getDrillByLevel(InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole5Level);
         if(this._drill == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.Embed.OpenHole.NoDrill",InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole5Level + 1));
         }
         else
         {
            this._openHoleNumber = FIVE;
            if(!_loc2_.IsBinds && this._drill.IsBinds)
            {
               this.confirmIsBindWhenOpenHole();
            }
            else
            {
               this.sendOpenHole(this._itemPlace,this._openHoleNumber,this._drill.TemplateID);
            }
         }
      }
      
      private function _openSixHoleClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:InventoryItemInfo = InventoryItemInfo(this._embedItemCell.info);
         if(_loc2_.Hole6Level >= StoreModel.getHoleMaxOpLv())
         {
            return;
         }
         this._drill = this.getDrillByLevel(InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole6Level);
         if(this._drill == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.Embed.OpenHole.NoDrill",InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole6Level + 1));
         }
         else
         {
            this._openHoleNumber = SIX;
            if(!_loc2_.IsBinds && this._drill.IsBinds)
            {
               this.confirmIsBindWhenOpenHole();
            }
            else
            {
               this.sendOpenHole(this._itemPlace,this._openHoleNumber,this._drill.TemplateID);
            }
         }
      }
      
      public function openHoleSucces(param1:int, param2:int, param3:int) : void
      {
         SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,param1,param2,-1,param3,true);
      }
      
      private function _showAlert() : void
      {
         var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc1_.addEventListener(FrameEvent.RESPONSE,this._responseVI);
      }
      
      private function sendOpenHole(param1:int, param2:int, param3:int) : void
      {
         SocketManager.Instance.out.sendItemOpenFiveSixHole(param1,param2,param3);
         this._drill = null;
      }
      
      private function getOpenHoleStone() : InventoryItemInfo
      {
         var _loc1_:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.SKY_OPENHOLE_STONE);
         var _loc2_:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.GND_OPENHOLE_STONE);
         return _loc1_ != null ? _loc1_ : _loc2_;
      }
      
      private function _responseVI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseVI);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function dragDrop(param1:BagCell) : void
      {
         var _loc3_:StoreCell = null;
         var _loc4_:int = 0;
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
                  if(_loc3_.info == null)
                  {
                     if((_loc3_ as StoneCell).types.indexOf(_loc2_.Property1) > -1 && _loc2_.CategoryID == 11)
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1);
                        DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                        return;
                     }
                  }
               }
               else if(_loc3_ is EmbedItemCell)
               {
                  _loc4_ = 1;
                  while(_loc4_ < 7)
                  {
                     if(_loc2_.CategoryID == EquipType.HEAD || _loc2_.CategoryID == EquipType.CLOTH || _loc2_.CategoryID == EquipType.ARM)
                     {
                        this.__itemChange(null);
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,_loc3_.index,1);
                        DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                        return;
                     }
                     _loc4_++;
                  }
                  continue;
               }
            }
         }
      }
      
      private function __embed(param1:EmbedEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         param1.stopImmediatePropagation();
         this._currentHolePlace = param1.CellID;
         if(!this._embedItemCell.itemInfo.IsBinds && this._stoneCells[this._currentHolePlace - 1].itemInfo.IsBinds)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseIII);
         }
         else
         {
            this.__embed2();
         }
      }
      
      private function _responseIII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseIII);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendEmbed();
         }
         else
         {
            this.cancelEmbed1();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function cancelEmbed1() : void
      {
         this._stoneCells[this._currentHolePlace - 1].bagCell = null;
         this.updateHoles();
      }
      
      private function __embed2() : void
      {
         if(this._embedItemCell.itemInfo["Hole" + this._currentHolePlace] == 0)
         {
         }
         var _loc1_:EmbedAlertFrame = ComponentFactory.Instance.creatCustomObject("store.EmbedAlertFrame");
         _loc1_.show(ComponentFactory.Instance.creatBitmap("asset.store.embedAlert2"));
         _loc1_.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseII(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:EmbedAlertFrame = param1.currentTarget as EmbedAlertFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendEmbed();
         }
         else
         {
            this._stoneCells[this._currentHolePlace - 1].bagCell = null;
            this.updateHoles();
         }
      }
      
      private function __EmbedBackout(param1:EmbedBackoutEvent) : void
      {
         this._currentHolePlace = param1.CellID;
         this._templateID = param1.TemplateID;
         this.__EmbedBackoutFrame(param1);
      }
      
      private function __EmbedBackoutFrame(param1:Event) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(this._embedStoneCell && param1.type == MouseEvent.CLICK)
         {
            this._embedStoneCell.closeTip(param1 as MouseEvent);
         }
         var _loc2_:EmbedAlertFrame = ComponentFactory.Instance.creatCustomObject("store.EmbedAlertFrame");
         _loc2_.show(ComponentFactory.Instance.creatBitmap("asset.store.embedBackoutAlert"));
         _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
         if(this._embedBackoutMouseIcon)
         {
            ObjectUtils.disposeObject(this._embedBackoutMouseIcon);
            this._embedBackoutMouseIcon = null;
         }
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:EmbedAlertFrame = param1.currentTarget as EmbedAlertFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(param1.target);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendEmbedBackout();
         }
         else
         {
            this._stoneCells[this._currentHolePlace - 1].bagCell = null;
            this.updateHoles();
            stage.focus = this;
         }
      }
      
      private function __EmbedBackoutDownItemOver(param1:EmbedBackoutEvent) : void
      {
         param1.stopImmediatePropagation();
         this._currentHolePlace = param1.CellID;
         this._templateID = param1.TemplateID;
         if(!this._embedBackoutBtn.isAction && !contains(this._embedBackoutDownItem))
         {
            this._embedStoneCell = param1.target as EmbedStoneCell;
            this._embedBackoutDownItem.x = param1.target.x;
            this._embedBackoutDownItem.y = param1.target.y + param1.target.height + 8;
            addChild(this._embedBackoutDownItem);
            this._embedBackoutDownItem.addEventListener(MouseEvent.CLICK,this.__EmbedBackoutFrame);
            this._embedBackoutDownItem.addEventListener(MouseEvent.MOUSE_OVER,this.__EmbedShowTip);
            this._embedBackoutDownItem.addEventListener(MouseEvent.MOUSE_OUT,this.__EmbedBackoutDownItemOutGo);
         }
      }
      
      private function __EmbedShowTip(param1:MouseEvent) : void
      {
         if(this._embedStoneCell)
         {
            this._embedStoneCell.showTip(param1);
         }
      }
      
      private function __EmbedBackoutDownItemDown(param1:EmbedBackoutEvent) : void
      {
         if(this._embedBackoutMouseIcon)
         {
            this._embedBackoutMouseIcon.setFrame(2);
         }
      }
      
      private function __EmbedBackoutDownItemOut(param1:EmbedBackoutEvent) : void
      {
         if(this._embedBackoutDownItem && (mouseY >= this._embedBackoutDownItem.y && mouseY <= this._embedBackoutDownItem.y + this._embedBackoutDownItem.height && (mouseX >= this._embedBackoutDownItem.x && mouseX <= this._embedBackoutDownItem.x + this._embedBackoutDownItem.width)))
         {
            return;
         }
         this.__EmbedBackoutDownItemOutGo(param1);
      }
      
      private function __EmbedBackoutDownItemOutGo(param1:Event) : void
      {
         if(this._embedBackoutBtn != null && !this._embedBackoutBtn.isAction && this._embedBackoutDownItem && contains(this._embedBackoutDownItem))
         {
            if(this._embedStoneCell && param1 != null && param1.type == MouseEvent.MOUSE_OUT)
            {
               this._embedStoneCell.closeTip(param1 as MouseEvent);
            }
            this._embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OVER,this.__EmbedShowTip);
            this._embedBackoutDownItem.removeEventListener(MouseEvent.CLICK,this.__EmbedBackoutFrame);
            this._embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OUT,this.__EmbedBackoutDownItemOutGo);
            removeChild(this._embedBackoutDownItem);
         }
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         this._stoneCells[FIVE - 1].close();
         this._stoneCells[SIX - 1].close();
         this._embedItemCell.info = PlayerManager.Instance.Self.StoreBag.items[0];
         if(this._embedItemCell.info == null)
         {
            this._hole6ExpBar.visible = false;
            this._hole5ExpBar.visible = false;
         }
         if(this._embedItemCell.itemInfo && this._embedItemCell.itemInfo.Hole5Level >= 0)
         {
            this._hole5ExpBar.setProgress(this._embedItemCell.itemInfo.Hole5Exp,StoreModel.getHoleExpByLv(this._embedItemCell.itemInfo.Hole5Level));
            this._stoneCells[FIVE - 1].setHoleLv(this._embedItemCell.itemInfo.Hole5Level);
            this._stoneCells[FIVE - 1].setHoleExp(this._embedItemCell.itemInfo.Hole5Exp);
            this._openFiveHoleBtn.tipData = LanguageMgr.GetTranslation("store.openHole.OpenTipData",this._embedItemCell.itemInfo.Hole5Level,this._embedItemCell.itemInfo.Hole5Exp,StoreModel.getHoleExpByLv(this._embedItemCell.itemInfo.Hole5Level),this._embedItemCell.itemInfo.Hole5Level + 1);
            this._hole5ExpBar.tipData = this._embedItemCell.itemInfo.Hole5Level + LanguageMgr.GetTranslation("store.embem.HoleTip.Level") + this._embedItemCell.itemInfo.Hole5Exp + "/" + StoreModel.getHoleExpByLv(this._embedItemCell.itemInfo.Hole5Level);
         }
         else
         {
            this._stoneCells[FIVE - 1].setHoleLv(-1);
            this._stoneCells[FIVE - 1].setHoleExp(-1);
         }
         if(this._embedItemCell.itemInfo && this._embedItemCell.itemInfo.Hole6Level >= 0)
         {
            this._hole6ExpBar.setProgress(this._embedItemCell.itemInfo.Hole6Exp,StoreModel.getHoleExpByLv(this._embedItemCell.itemInfo.Hole6Level));
            this._stoneCells[SIX - 1].setHoleLv(this._embedItemCell.itemInfo.Hole6Level);
            this._stoneCells[SIX - 1].setHoleExp(this._embedItemCell.itemInfo.Hole6Exp);
            this._openSixHoleBtn.tipData = LanguageMgr.GetTranslation("store.openHole.OpenTipData",this._embedItemCell.itemInfo.Hole6Level,this._embedItemCell.itemInfo.Hole6Exp,StoreModel.getHoleExpByLv(this._embedItemCell.itemInfo.Hole6Level),this._embedItemCell.itemInfo.Hole6Level + 1);
            this._hole6ExpBar.tipData = this._embedItemCell.itemInfo.Hole6Level + LanguageMgr.GetTranslation("store.embem.HoleTip.Level") + this._embedItemCell.itemInfo.Hole6Exp + "/" + StoreModel.getHoleExpByLv(this._embedItemCell.itemInfo.Hole6Level);
         }
         else
         {
            this._stoneCells[SIX - 1].setHoleLv(-1);
            this._stoneCells[SIX - 1].setHoleExp(-1);
         }
      }
      
      public function sendEmbed() : void
      {
         var _loc1_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.Gold < NEED_GOLD)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc1_.moveEnable = false;
            _loc1_.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return;
         }
         SocketManager.Instance.out.sendItemEmbed(this._embedItemCell.itemInfo.BagType,this._embedItemCell.itemInfo.Place,this._currentHolePlace,this._stoneCells[this._currentHolePlace - 1].itemInfo.BagType,this._stoneCells[this._currentHolePlace - 1].itemInfo.Place);
      }
      
      private function _responseV(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFastPurchaseGold();
         }
         else
         {
            this.cancelFastPurchaseGold();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         this._quick = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
         this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         this._quick.itemID = EquipType.GOLD_BOX;
         this._quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
         this._quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK,this.__shortCutBuyMoneyOkHandler);
         this._quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_CANCEL,this.__shortCutBuyMoneyCancelHandler);
         this._quick.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
         LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function cancelQuickBuy() : void
      {
         this._stoneCells[this._currentHolePlace - 1].bagCell = null;
         this.updateHoles();
      }
      
      private function removeFromStageHandler(param1:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(param1:ShortcutBuyEvent) : void
      {
         param1.stopImmediatePropagation();
         this.__embed2();
      }
      
      private function __shortCutBuyMoneyOkHandler(param1:ShortcutBuyEvent) : void
      {
         param1.stopImmediatePropagation();
         this._stoneCells[this._currentHolePlace - 1].bagCell = null;
         this.updateHoles();
      }
      
      private function __shortCutBuyMoneyCancelHandler(param1:ShortcutBuyEvent) : void
      {
         param1.stopImmediatePropagation();
         this._stoneCells[this._currentHolePlace - 1].bagCell = null;
         this.updateHoles();
      }
      
      private function cancelFastPurchaseGold() : void
      {
         this._stoneCells[this._currentHolePlace - 1].bagCell = null;
         this.updateHoles();
      }
      
      public function sendEmbedBackout() : void
      {
         var _loc1_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.Money < EMBED_BACKOUT_MONEY)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            _loc1_.addEventListener(FrameEvent.RESPONSE,this._responseIV);
            return;
         }
         this.__EmbedBackoutDownItemOutGo(null);
         SocketManager.Instance.out.sendItemEmbedBackout(this._currentHolePlace,this._templateID);
      }
      
      private function _responseIV(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseIV);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         this.cancelEmbed1();
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function cancelEmbedBackout() : void
      {
      }
      
      private function removeEvents() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 7)
         {
            this._stoneCells[_loc1_ - 1].removeEventListener(EmbedEvent.EMBED,this.__embed);
            this._stoneCells[_loc1_ - 1].removeEventListener(EmbedBackoutEvent.EMBED_BACKOUT,this.__EmbedBackout);
            this._stoneCells[_loc1_ - 1].removeEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OVER,this.__EmbedBackoutDownItemOver);
            this._stoneCells[_loc1_ - 1].removeEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OUT,this.__EmbedBackoutDownItemOut);
            this._stoneCells[_loc1_ - 1].removeEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_DOWN,this.__EmbedBackoutDownItemDown);
            _loc1_++;
         }
         this._embedItemCell.removeEventListener(Event.CHANGE,this.__itemInfoChange);
         this._embedItemCell.removeEventListener(StoreEmbedEvent.ItemChang,this.__itemChange);
         this._help.removeEventListener(MouseEvent.CLICK,this.__openHelp);
         this._embedBackoutBtn.removeEventListener(MouseEvent.CLICK,this.__embedBackoutBtnClick);
         this._openFiveHoleBtn.removeEventListener(MouseEvent.CLICK,this._openFiveHoleClick);
         this._openSixHoleBtn.removeEventListener(MouseEvent.CLICK,this._openSixHoleClick);
      }
      
      public function updateData() : void
      {
      }
      
      public function get area() : Array
      {
         return this._items;
      }
      
      public function startShine() : void
      {
         this._embedItemCell.startShine();
      }
      
      public function stoneStartShine(param1:int, param2:InventoryItemInfo) : void
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         if(PlayerManager.Instance.Self.StoreBag.items[0] == null)
         {
            return;
         }
         var _loc3_:InventoryItemInfo = this._embedItemCell.itemInfo;
         var _loc4_:Array = _loc3_.Hole.split("|");
         var _loc5_:int = 0;
         while(_loc5_ < this._stoneCells.length)
         {
            _loc6_ = _loc3_["Hole" + (_loc5_ + 1)];
            if(_loc5_ < 4)
            {
               _loc7_ = String(_loc4_[_loc5_]);
               _loc8_ = _loc7_.split(",");
               if(_loc3_["Hole" + (_loc5_ + 1)] >= 0 && (this._stoneCells[_loc5_] as EmbedStoneCell).StoneType == param1)
               {
                  this._stoneCells[_loc5_].startShine();
               }
            }
            else if((this._stoneCells[_loc5_] as EmbedStoneCell).StoneType == param1 && _loc3_["Hole" + (_loc5_ + 1) + "Level"] > 0)
            {
               this._stoneCells[_loc5_].startShine();
            }
            _loc5_++;
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:EmbedStoneCell = null;
         this._embedItemCell.stopShine();
         for each(_loc1_ in this._stoneCells)
         {
            _loc1_.stopShine();
         }
      }
      
      public function show() : void
      {
         this.visible = true;
         this.refreshData(null);
      }
      
      public function hide() : void
      {
         this.visible = false;
         var _loc1_:int = 1;
         while(_loc1_ < 7)
         {
            this._stoneCells[_loc1_ - 1].close();
            _loc1_++;
         }
      }
      
      private function __openHelp(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:HelpPrompt = ComponentFactory.Instance.creat("store.embedHelp");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("store.helpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("tank.view.store.matteHelp.title");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._items = null;
         this._embedStoneCell = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._area)
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(this._embedItemCell)
         {
            ObjectUtils.disposeObject(this._embedItemCell);
         }
         this._embedItemCell = null;
         if(this._embedBackoutBtn)
         {
            ObjectUtils.disposeObject(this._embedBackoutBtn);
         }
         this._embedBackoutBtn = null;
         if(this._help)
         {
            ObjectUtils.disposeObject(this._help);
         }
         this._help = null;
         if(this._openFiveHoleBtn)
         {
            ObjectUtils.disposeObject(this._openFiveHoleBtn);
         }
         this._openFiveHoleBtn = null;
         if(this._openSixHoleBtn)
         {
            ObjectUtils.disposeObject(this._openSixHoleBtn);
         }
         this._openSixHoleBtn = null;
         if(this._hole5ExpBar)
         {
            ObjectUtils.disposeObject(this._hole5ExpBar);
         }
         this._hole5ExpBar = null;
         if(this._hole6ExpBar)
         {
            ObjectUtils.disposeObject(this._hole6ExpBar);
         }
         this._hole6ExpBar = null;
         if(this._embedBackoutDownItem)
         {
            this._embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OVER,this.__EmbedShowTip);
            this._embedBackoutDownItem.removeEventListener(MouseEvent.CLICK,this.__EmbedBackoutFrame);
            this._embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OUT,this.__EmbedBackoutDownItemOutGo);
            ObjectUtils.disposeObject(this._embedBackoutDownItem);
         }
         this._embedBackoutDownItem = null;
         if(this._embedBackoutMouseIcon)
         {
            ObjectUtils.disposeObject(this._embedBackoutMouseIcon);
         }
         this._embedBackoutMouseIcon = null;
         var _loc1_:int = 1;
         while(_loc1_ < 7)
         {
            ObjectUtils.disposeObject(this._stoneCells[_loc1_ - 1]);
            this._stoneCells[_loc1_ - 1] = null;
            _loc1_++;
         }
         this._stoneCells = null;
         this._pointArray = null;
         if(this._quick)
         {
            this._quick.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
            this._quick.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK,this.__shortCutBuyMoneyOkHandler);
            this._quick.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_CANCEL,this.__shortCutBuyMoneyCancelHandler);
            this._quick.removeEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
            if(this._quick.parent)
            {
               this._quick.parent.removeChild(this._quick);
            }
         }
         this._quick = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
