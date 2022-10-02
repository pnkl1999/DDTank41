package store.view.storeBag
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import store.events.StoreBagEvent;
   import store.events.UpdateItemEvent;
   
   public class StoreBagListView extends Sprite implements Disposeable
   {
      
      private static var cellNum:int = 70;
      
      public static const SMALLGRID:int = 21;
       
      
      private var _list:SimpleTileList;
      
      protected var panel:ScrollPanel;
      
      protected var _cells:DictionaryData;
      
      protected var _bagdata:DictionaryData;
      
      protected var _controller:StoreBagController;
      
      protected var _bagType:int;
      
      private var beginGridNumber:int;
      
      public function StoreBagListView()
      {
         super();
      }
      
      public function setup(param1:int, param2:StoreBagController, param3:int) : void
      {
         this._bagType = param1;
         this._controller = param2;
         this.beginGridNumber = param3;
         this.init();
      }
      
      private function init() : void
      {
         this.createPanel();
         this._list = new SimpleTileList(7);
         this._list.vSpace = 0;
         this._list.hSpace = 0;
         this.panel.setView(this._list);
         this.panel.invalidateViewport();
         this.createCells();
      }
      
      protected function createPanel() : void
      {
         this.panel = ComponentFactory.Instance.creat("store.bagEquipScrollPanel");
         addChild(this.panel);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.ON;
      }
      
      protected function createCells() : void
      {
         this._cells = new DictionaryData();
      }
      
      private function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         param1.stopImmediatePropagation();
         if((param1.currentTarget as BagCell).info != null)
         {
            if((param1.currentTarget as BagCell).info != null)
            {
               dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,param1.currentTarget,true));
               SoundManager.instance.play("008");
            }
         }
      }
      
      private function __clickHandler(param1:InteractiveEvent) : void
      {
         if(param1.currentTarget)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,param1.currentTarget));
         }
      }
      
      protected function __cellChanged(param1:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function __cellClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      public function getCellByPlace(param1:int) : BagCell
      {
         return this._cells[param1];
      }
      
      public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         if(param2 == null)
         {
            if(this._cells && this._cells[String(param1)])
            {
               this._cells[String(param1)].info = null;
            }
            return;
         }
         if(param2.Count == 0)
         {
            if(this._cells && this._cells[String(param1)])
            {
               this._cells[String(param1)].info = null;
            }
         }
         else if(this._cells[String(param1)])
         {
            this._cells[String(param1)].info = param2;
         }
         else
         {
            this._appendCell(param1);
            this._cells[String(param1)].info = param2;
         }
      }
      
      public function setData(param1:DictionaryData) : void
      {
         var _loc2_:* = null;
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener(DictionaryEvent.ADD,this.__addGoods);
            this._bagdata.removeEventListener(StoreBagEvent.REMOVE,this.__removeGoods);
            this._bagdata.removeEventListener(UpdateItemEvent.UPDATEITEMEVENT,this.__updateGoods);
         }
         this._bagdata = param1;
         this.addGrid(param1);
         if(param1)
         {
            for(_loc2_ in param1)
            {
               if(this._cells[_loc2_] != null)
               {
                  this._cells[_loc2_].info = param1[_loc2_];
               }
            }
         }
         this._bagdata.addEventListener(DictionaryEvent.ADD,this.__addGoods);
         this._bagdata.addEventListener(StoreBagEvent.REMOVE,this.__removeGoods);
         this._bagdata.addEventListener(UpdateItemEvent.UPDATEITEMEVENT,this.__updateGoods);
         this.updateScrollBar();
      }
      
      private function addGrid(param1:DictionaryData) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         this._cells.clear();
         this._list.disposeAllChildren();
         var _loc2_:int = 0;
         for(_loc3_ in param1)
         {
            _loc2_++;
         }
         _loc4_ = (int((_loc2_ - 1) / 7) + 1) * 7;
         _loc4_ = _loc4_ < this.beginGridNumber ? int(int(this.beginGridNumber)) : int(int(_loc4_));
         this._list.beginChanges();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            this.createCell(_loc5_);
            _loc5_++;
         }
         this._list.commitChanges();
         this.invalidatePanel();
      }
      
      private function createCell(param1:int) : void
      {
         var _loc2_:StoreBagCell = new StoreBagCell(param1);
         _loc2_.bagType = this._bagType;
         _loc2_.tipDirctions = "7,5,2,6,4,1";
         _loc2_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         _loc2_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(_loc2_);
         _loc2_.addEventListener(MouseEvent.CLICK,this.__cellClick);
         _loc2_.addEventListener(CellEvent.LOCK_CHANGED,this.__cellChanged);
         this._cells.add(_loc2_.place,_loc2_);
         this._list.addChild(_loc2_);
      }
      
      private function _appendCell(param1:int) : void
      {
         var _loc2_:int = param1;
         while(_loc2_ < param1 + 7)
         {
            this.createCell(_loc2_);
            _loc2_++;
         }
      }
      
      private function updateScrollBar(param1:Boolean = true) : void
      {
      }
      
      protected function __addGoods(param1:DictionaryEvent) : void
      {
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         var _loc3_:int = 0;
         while(_loc3_ < 70)
         {
            if(this._bagdata[_loc3_] == _loc2_)
            {
               this.setCellInfo(_loc3_,_loc2_);
               break;
            }
            _loc3_++;
         }
         this.updateScrollBar();
      }
      
      private function checkShouldAutoLink(param1:InventoryItemInfo) : Boolean
      {
         if(this._controller.model.NeedAutoLink <= 0)
         {
            return false;
         }
         if(param1.TemplateID == EquipType.LUCKY || param1.TemplateID == EquipType.SYMBLE || param1.TemplateID == EquipType.STRENGTH_STONE4 || param1.StrengthenLevel >= 10)
         {
            return true;
         }
         return false;
      }
      
      protected function __removeGoods(param1:StoreBagEvent) : void
      {
         this._cells[param1.pos].info = null;
         this.updateScrollBar(false);
      }
      
      private function __updateGoods(param1:UpdateItemEvent) : void
      {
         this._cells[param1.pos].info = param1.item as InventoryItemInfo;
         this.updateScrollBar(false);
      }
      
      public function getCellByPos(param1:int) : BagCell
      {
         return this._cells[param1];
      }
      
      private function invalidatePanel() : void
      {
         this.panel.invalidateViewport();
      }
      
      public function dispose() : void
      {
         var _loc1_:BagCell = null;
         this._controller = null;
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener(DictionaryEvent.ADD,this.__addGoods);
            this._bagdata.removeEventListener(StoreBagEvent.REMOVE,this.__removeGoods);
            this._bagdata.removeEventListener(UpdateItemEvent.UPDATEITEMEVENT,this.__updateGoods);
            this._bagdata = null;
         }
         for each(_loc1_ in this._cells)
         {
            _loc1_.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc1_.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc1_);
            _loc1_.addEventListener(MouseEvent.CLICK,this.__cellClick);
            _loc1_.removeEventListener(CellEvent.LOCK_CHANGED,this.__cellChanged);
            ObjectUtils.disposeObject(_loc1_);
         }
         this._cells.clear();
         DoubleClickManager.Instance.clearTarget();
         this._list.disposeAllChildren();
         this._list = null;
         this._cells = null;
         if(this.panel)
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
