package ddt.view.caddyII
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class CaddyBagView extends Sprite implements Disposeable
   {
      
      public static const NUMBER:int = 5;
      
      public static const SUM_NUMBER:int = 30;
      
      public static const NULL_CELL_POINT:String = "send_nullCell_poing";
      
      public static const GET_GOODSINFO:String = "caddy_get_goodsinfo";
       
      
      private var _bg:Scale9CornerImage;
      
      private var _bagBG:ScaleBitmapImage;
      
      private var _list:SimpleTileList;
      
      protected var _sellAllBtn:BaseButton;
      
      private var _openAll:SimpleBitmapButton;
      
      protected var _node:Bitmap;
      
      private var _selectPlace:int = 0;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _items:Vector.<CaddyCell>;
      
      public function CaddyBagView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      protected function initView() : void
      {
         var _loc2_:CaddyCell = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.LeftBG");
         addChild(this._bg);
         this._bagBG = ComponentFactory.Instance.creatComponentByStylename("caddy.bagBG");
         addChild(this._bagBG);
         this._list = ComponentFactory.Instance.creatCustomObject("caddy.SimpleTileList",[NUMBER]);
         addChild(this._list);
         this._items = new Vector.<CaddyCell>();
         this._list.beginChanges();
         var _loc1_:uint = 0;
         while(_loc1_ < SUM_NUMBER)
         {
            _loc2_ = new CaddyCell(_loc1_);
            this._items.push(_loc2_);
            _loc2_.addEventListener(CellEvent.ITEM_CLICK,this.__itemClick);
            this._list.addChild(_loc2_);
            _loc1_++;
         }
         this._list.commitChanges();
         if(CaddyModel.instance.type == CaddyModel.MYSTICAL_CARDBOX || CaddyModel.instance.type == CaddyModel.MY_CARDBOX || CaddyModel.instance.type == CaddyModel.CARD_CARTON)
         {
            this._openAll = ComponentFactory.Instance.creatComponentByStylename("CaddyCardBoxBag.openAllBtn");
            addChild(this._openAll);
         }
         else
         {
            this._sellAllBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.sellAllBtn");
            addChild(this._sellAllBtn);
         }
         this._node = ComponentFactory.Instance.creatBitmap("asset.caddy.NodeBagAsset");
         addChild(this._node);
      }
      
      protected function initEvents() : void
      {
         if(this._sellAllBtn)
         {
            this._sellAllBtn.addEventListener(MouseEvent.CLICK,this._sellAll);
         }
         if(this._openAll)
         {
            this._openAll.addEventListener(MouseEvent.CLICK,this.__openAllHandler);
         }
         CaddyModel.instance.bagInfo.addEventListener(BagEvent.UPDATE,this._update);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeBadLuckNumber);
      }
      
      protected function __openAllHandler(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(CaddyModel.instance.bagInfo.itemNumber > 0)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.opennAll"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseIV);
         }
      }
      
      private function _responseIV(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendOpenAll();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      protected function removeEvents() : void
      {
         if(this._sellAllBtn)
         {
            this._sellAllBtn.removeEventListener(MouseEvent.CLICK,this._sellAll);
         }
         if(this._openAll)
         {
            this._openAll.removeEventListener(MouseEvent.CLICK,this.__openAllHandler);
         }
         CaddyModel.instance.bagInfo.removeEventListener(BagEvent.UPDATE,this._update);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeBadLuckNumber);
      }
      
      private function __changeBadLuckNumber(param1:PlayerPropertyEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:CaddyEvent = null;
         if(param1.changedProperties["BadLuckNumber"])
         {
            if(PlayerManager.Instance.Self.badLuckNumber == 0)
            {
               return;
            }
            _loc2_ = new InventoryItemInfo();
            _loc2_.TemplateID = EquipType.BADLUCK_STONE;
            ItemManager.fill(_loc2_);
            _loc3_ = new CaddyEvent(GET_GOODSINFO);
            _loc3_.info = this._selectedGoodsInfo = _loc2_;
            dispatchEvent(_loc3_);
         }
      }
      
      private function _sellAll(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(CaddyModel.instance.bagInfo.itemNumber > 0)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.sellAllNode") + this.getSellAllPriceString(),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
         }
      }
      
      public function getSellAllPriceString() : String
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         for each(_loc3_ in CaddyModel.instance.bagInfo.items)
         {
            if(_loc3_.ReclaimType == 1)
            {
               _loc1_ += _loc3_.ReclaimValue;
            }
            else if(_loc3_.ReclaimType == 2)
            {
               _loc2_ += _loc3_.ReclaimValue;
            }
         }
         return (_loc1_ > 0 ? _loc1_ + LanguageMgr.GetTranslation("tank.hotSpring.gold") : "") + (_loc1_ > 0 && _loc2_ > 0 ? "," : "") + (_loc2_ > 0 ? _loc2_ + LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken") : "");
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendSellAll();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function _update(param1:BagEvent) : void
      {
         var _loc3_:* = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:CaddyEvent = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for(_loc3_ in _loc2_)
         {
            _loc4_ = CaddyModel.instance.bagInfo.getItemAt(int(_loc3_));
            if(_loc4_)
            {
               this._selectedGoodsInfo = _loc4_;
               this._selectPlace = _loc4_.Place;
               _loc5_ = new CaddyEvent(GET_GOODSINFO);
               _loc5_.info = this._selectedGoodsInfo;
               dispatchEvent(_loc5_);
            }
            else
            {
               this._items[_loc3_].info = null;
            }
         }
      }
      
      public function __itemClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:CaddyCell = param1.data as CaddyCell;
         var _loc3_:int = (_loc2_.info as InventoryItemInfo).Count;
         var _loc4_:int = this._getBagType(_loc2_.info as InventoryItemInfo);
         SocketManager.Instance.out.sendMoveGoods(BagInfo.CADDYBAG,_loc2_.place,_loc4_,-1,_loc3_);
      }
      
      private function _getBagType(param1:InventoryItemInfo) : int
      {
         var _loc2_:int = 0;
         switch(param1.CategoryID)
         {
            case EquipType.FRIGHTPROP:
            case EquipType.UNFRIGHTPROP:
            case EquipType.TASK:
            case EquipType.PET_EGG:
            case EquipType.FOOD:
            case EquipType.VEGETABLE:
               _loc2_ = BagInfo.PROPBAG;
               break;
            case EquipType.SEED:
            case EquipType.MANURE:
               _loc2_ = BagInfo.FARM;
            default:
               _loc2_ = BagInfo.EQUIPBAG;
         }
         return _loc2_;
      }
      
      public function findCell() : void
      {
         var _loc1_:Point = null;
         if(this._selectedGoodsInfo.TemplateID == EquipType.BADLUCK_STONE)
         {
            _loc1_ = localToGlobal(new Point(685,285));
         }
         else
         {
            _loc1_ = localToGlobal(new Point(this._items[this._selectPlace].x,this._items[this._selectPlace].y));
         }
         var _loc2_:CaddyEvent = new CaddyEvent(NULL_CELL_POINT);
         _loc2_.point = _loc1_;
         dispatchEvent(_loc2_);
      }
      
      public function addCell() : void
      {
         if(this._selectedGoodsInfo.TemplateID != EquipType.BADLUCK_STONE)
         {
            this._items[this._selectPlace].info = this._selectedGoodsInfo;
         }
      }
      
      public function checkCell() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            if(this._items[_loc1_].info != null)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function get sellBtn() : BaseButton
      {
         if(this._sellAllBtn)
         {
            return this._sellAllBtn;
         }
         if(this._openAll)
         {
            return this._openAll;
         }
         return null;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._bagBG)
         {
            ObjectUtils.disposeObject(this._bagBG);
         }
         this._bagBG = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._sellAllBtn)
         {
            ObjectUtils.disposeObject(this._sellAllBtn);
         }
         this._sellAllBtn = null;
         if(this._node)
         {
            ObjectUtils.disposeObject(this._node);
         }
         this._node = null;
         if(this._openAll)
         {
            ObjectUtils.disposeObject(this._openAll);
         }
         this._openAll = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            ObjectUtils.disposeObject(this._items[_loc1_]);
            _loc1_++;
         }
         this._items = null;
         this._selectedGoodsInfo = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
