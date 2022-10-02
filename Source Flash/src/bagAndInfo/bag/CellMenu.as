package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CellMenu extends Sprite
   {
      
      public static const ADDPRICE:String = "addprice";
      
      public static const MOVE:String = "move";
      
      public static const OPEN_CellMenu:String = "open_CellMenu";
      
      public static const USE:String = "use";
      
      public static const OPEN_BATCH:String = "open_batch";
      
      private static var _instance:CellMenu;
       
      
      private var _bg:Bitmap;
      
      private var _bg2:Bitmap;
      
      private var _cell:BagCell;
      
      private var _addpriceitem:BaseButton;
      
      private var _moveitem:BaseButton;
      
      private var _openitem:BaseButton;
      
      private var _useitem:BaseButton;
      
      private var _openBatchItem:BaseButton;
      
      private var _list:Sprite;
      
      public function CellMenu(param1:SingletonFoce)
      {
         super();
         this.init();
      }
      
      public static function get instance() : CellMenu
      {
         if(_instance == null)
         {
            _instance = new CellMenu(new SingletonFoce());
         }
         return _instance;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cellMenu.CellMenuBGAsset");
         this._bg2 = ComponentFactory.Instance.creatBitmap("bagAndInfo.cellMenu.CellMenuBG2Asset");
         addChild(this._bg);
         addChild(this._bg2);
         this._list = new Sprite();
         this._list.x = 5;
         this._list.y = 5;
         addChild(this._list);
         graphics.beginFill(0,0);
         graphics.drawRect(-3000,-3000,6000,6000);
         graphics.endFill();
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         this._addpriceitem = ComponentFactory.Instance.creatComponentByStylename("addPriceBtn");
         this._moveitem = ComponentFactory.Instance.creatComponentByStylename("moveGoodsBtn");
         this._openitem = ComponentFactory.Instance.creatComponentByStylename("openGoodsBtn");
         this._useitem = ComponentFactory.Instance.creatComponentByStylename("useGoodsBtn");
         this._openBatchItem = ComponentFactory.Instance.creatComponentByStylename("openBatchGoodsBtn");
         this._moveitem.y = 27;
         this._addpriceitem.addEventListener(MouseEvent.CLICK,this.__addpriceClick);
         this._moveitem.addEventListener(MouseEvent.CLICK,this.__moveClick);
         this._openitem.addEventListener(MouseEvent.CLICK,this.__openClick);
         this._useitem.addEventListener(MouseEvent.CLICK,this.__useClick);
         this._openBatchItem.addEventListener(MouseEvent.CLICK,this.__openBatchClick);
      }
      
      public function get cell() : BagCell
      {
         return this._cell;
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         this.hide();
         SoundManager.instance.play("008");
      }
      
      private function __addpriceClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         dispatchEvent(new Event(ADDPRICE));
         this.hide();
      }
      
      private function __moveClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         dispatchEvent(new Event(MOVE));
         this.hide();
      }
      
      private function __openClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         dispatchEvent(new Event(OPEN_CellMenu));
         this.hide();
      }
      
      private function __useClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(USE));
         this.hide();
      }
      
      private function __openBatchClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(OPEN_BATCH));
         this.hide();
      }
      
      public function show(param1:BagCell, param2:int, param3:int) : void
      {
         var _loc4_:ItemTemplateInfo = null;
         this._cell = param1;
         if(this._cell == null)
         {
            return;
         }
         _loc4_ = this._cell.info;
         if(_loc4_ == null)
         {
            return;
         }
         this._bg.visible = true;
         this._bg2.visible = false;
         this._openitem.x = 0;
         this._openitem.y = 0;
         this._moveitem.x = 0;
         this._moveitem.y = 27;
         if(InventoryItemInfo(_loc4_).getRemainDate() <= 0)
         {
            this._list.addChild(this._addpriceitem);
         }
         else if(EquipType.isCardBox(_loc4_) || EquipType.isPackage(_loc4_))
         {
            this._list.addChild(this._openitem);
            if(EquipType.isCanBatchHandler(_loc4_ as InventoryItemInfo))
            {
               this._list.addChild(this._openBatchItem);
               this._bg.visible = false;
               this._bg2.visible = true;
               this._openitem.x = -2;
               this._openitem.y = -2;
               this._openBatchItem.x = -2;
               this._openBatchItem.y = 27;
               this._moveitem.x = -2;
               this._moveitem.y = 56;
            }
         }
         else if(EquipType.isPetEgg(_loc4_))
         {
            this._list.addChild(this._openitem);
         }
         else if(EquipType.canBeUsed(_loc4_))
         {
            this._list.addChild(this._useitem);
            if(EquipType.isCard(_loc4_) && EquipType.isCanBatchHandler(_loc4_ as InventoryItemInfo))
            {
               this._list.addChild(this._openBatchItem);
               this._bg.visible = false;
               this._bg2.visible = true;
               this._useitem.x = -2;
               this._useitem.y = -2;
               this._openBatchItem.x = -2;
               this._openBatchItem.y = 27;
               this._moveitem.x = -2;
               this._moveitem.y = 56;
            }
         }
         this._list.addChild(this._moveitem);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
         this.x = param2;
         this.y = param3;
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._list.numChildren)
         {
            this._list.removeChildAt(_loc1_);
            _loc1_++;
         }
         this._cell = null;
      }
      
      public function get showed() : Boolean
      {
         return stage != null;
      }
   }
}

class SingletonFoce
{
    
   
   function SingletonFoce()
   {
      super();
   }
}
