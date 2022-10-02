package store.view.fusion
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.events.Event;
   import store.events.StoreIIEvent;
   
   public class AccessoryFrameII extends Frame
   {
       
      
      private var _list:SimpleTileList;
      
      private var _bg:Shape;
      
      private var _items:Array;
      
      private var _area:AccessoryDragInArea;
      
      public function AccessoryFrameII()
      {
         super();
         this.initII();
      }
      
      private function initII() : void
      {
         titleText = LanguageMgr.GetTranslation("store.view.fusion.AccessoryFrame.add");
         this._bg = new Shape();
         this._bg.graphics.lineStyle(1,16777215);
         this._bg.graphics.beginFill(7760227,1);
         this._bg.graphics.drawRect(0,0,224,172);
         this._bg.graphics.endFill();
         addToContent(this._bg);
         this._list = new SimpleTileList(3);
         addToContent(this._list);
         this._items = new Array();
         this.initList();
      }
      
      private function initList() : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:AccessoryItemCell = null;
         this.clearList();
         var _loc1_:int = 5;
         while(_loc1_ < 11)
         {
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.store.FusionGoodsiBG");
            _loc3_ = new AccessoryItemCell(_loc1_);
            _loc3_.addEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items.push(_loc3_);
            this._list.addChild(_loc2_);
            _loc1_++;
         }
         this._area = new AccessoryDragInArea(this._items);
         this._list.parent.addChildAt(this._area,0);
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.ITEM_CLICK));
      }
      
      public function clearList() : void
      {
         var _loc2_:AccessoryItemCell = null;
         this._list.disposeAllChildren();
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            _loc2_ = this._items[_loc1_] as AccessoryItemCell;
            _loc2_.removeEventListener(Event.CHANGE,this.__itemInfoChange);
            _loc2_.dispose();
            _loc1_++;
         }
         this._items = new Array();
      }
      
      public function get isBinds() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            if(this._items[_loc1_] && this._items[_loc1_].info && this._items[_loc1_].info.IsBinds)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function setItemInfo(param1:int, param2:ItemTemplateInfo) : void
      {
         this._items[param1 - 5].info = param2;
      }
      
      public function listEmpty() : void
      {
         var _loc2_:AccessoryItemCell = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            _loc2_ = this._items[_loc1_] as AccessoryItemCell;
            _loc1_++;
         }
      }
      
      public function show() : void
      {
      }
      
      public function hide() : void
      {
      }
      
      public function getCount() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            if(this._items[_loc2_] != null && this._items[_loc2_].info != null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function containsItem(param1:InventoryItemInfo) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            if(this._items[_loc2_] != null && this._items[_loc2_].itemInfo == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function getAllAccessory() : Array
      {
         var _loc3_:Array = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            if(this._items[_loc2_] != null && this._items[_loc2_].info != null)
            {
               _loc3_ = new Array();
               _loc3_.push(this._items[_loc2_].info.BagType);
               _loc3_.push(this._items[_loc2_].place);
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         this.clearList();
         if(this._area)
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
