package petsBag.view.item
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import petsBag.view.ShowPet;
   
   public class PetEquipItem extends Sprite
   {
       
      
      private var _back:Bitmap;
      
      private var _cell:BagCell;
      
      public var id:int;
      
      private var _shiner:ShineObject;
      
      public function PetEquipItem(param1:int)
      {
         super();
         this.initView(param1);
      }
      
      private function initView(param1:int) : void
      {
         this._back = ComponentFactory.Instance.creat("assets.petsBag.equip" + String(param1));
         addChild(this._back);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         addEventListener(InteractiveEvent.CLICK,this.onClick);
         DoubleClickManager.Instance.enableDoubleClick(this);
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.petBagSystem.cellShine"));
         this._shiner.x = -5;
         this._shiner.y = -4;
         this._shiner.width = 48;
         this._shiner.height = 48;
         addChild(this._shiner);
         this._shiner.mouseEnabled = false;
         this._shiner.mouseChildren = false;
      }
      
      public function shinePlay() : void
      {
         this._shiner.shine();
      }
      
      public function shineStop() : void
      {
         this._shiner.stopShine();
      }
      
      private function onClick(param1:InteractiveEvent) : void
      {
         if(this._cell)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this._cell));
         }
      }
      
      protected function onDoubleClick(param1:InteractiveEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._cell)
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this));
         }
      }
      
      public function initBagCell(param1:InventoryItemInfo) : void
      {
         this.clearBagCell();
         ShowPet.isPetEquip = true;
         this._cell = new BagCell(0,param1);
         this._cell.allowDrag = true;
         addChild(this._cell);
      }
      
      public function clearBagCell() : void
      {
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         this.clearBagCell();
         if(this._back)
         {
            ObjectUtils.disposeObject(this._back);
         }
      }
   }
}
