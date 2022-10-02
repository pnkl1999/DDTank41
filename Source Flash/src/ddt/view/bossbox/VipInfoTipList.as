package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   
   public class VipInfoTipList extends Sprite implements Disposeable
   {
       
      
      private var _goodsList:Array;
      
      private var _list:SimpleTileList;
      
      private var _cells:Vector.<BoxVipTipsInfoCell>;
      
      private var _currentCell:BoxVipTipsInfoCell;
      
      public function VipInfoTipList()
      {
         super();
         this.initList();
      }
      
      public function get currentCell() : BoxVipTipsInfoCell
      {
         return this._currentCell;
      }
      
      protected function initList() : void
      {
         this._list = new SimpleTileList(2);
      }
      
      public function showForVipAward(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:BoxVipTipsInfoCell = null;
         if(!param1 || param1.length < 1)
         {
            return;
         }
         this._goodsList = param1;
         this._cells = new Vector.<BoxVipTipsInfoCell>();
         this._list.dispose();
         this._list = new SimpleTileList(this._goodsList.length);
         this._list.vSpace = 12;
         this._list.hSpace = 120;
         this._list.beginChanges();
         _loc2_ = 0;
         while(_loc2_ < this._goodsList.length)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("bossbox.BoxVipTipsInfoCell");
            _loc3_.info = this._goodsList[_loc2_] as ItemTemplateInfo;
            _loc3_.itemName = (this._goodsList[_loc2_] as ItemTemplateInfo).Name;
            _loc3_.isSelect = this.isCanSelect(_loc2_);
            if(this.isCanSelect(_loc2_))
            {
               this._currentCell = _loc3_;
            }
            this._list.addChild(_loc3_);
            this._cells.push(_loc3_);
            _loc2_++;
         }
         this._list.commitChanges();
         addChild(this._list);
      }
      
      private function isCanSelect(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         switch(param1)
         {
            case 0:
               _loc2_ = true;
               break;
            case 1:
               _loc2_ = false;
         }
         return _loc2_;
      }
      
      private function __cellClick(param1:CellEvent) : void
      {
         this._currentCell = param1.data as BoxVipTipsInfoCell;
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc1_:BoxVipTipsInfoCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.dispose();
         }
         this._cells.splice(0,this._cells.length);
         this._cells = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
