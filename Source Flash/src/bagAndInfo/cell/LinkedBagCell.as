package bagAndInfo.cell
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.interfaces.IDragable;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class LinkedBagCell extends BagCell
   {
       
      
      protected var _bagCell:BagCell;
      
      public var DoubleClickEnabled:Boolean = true;
      
      public function LinkedBagCell(param1:Sprite)
      {
         super(0,null,true,param1);
      }
      
      override protected function init() : void
      {
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
         super.init();
      }
      
      private function __clickHandler(param1:InteractiveEvent) : void
      {
         if(_info && !locked && stage && allowDrag)
         {
            SoundManager.instance.play("008");
         }
         dragStart();
      }
      
      public function get bagCell() : BagCell
      {
         return this._bagCell;
      }
      
      public function set bagCell(param1:BagCell) : void
      {
         if(this._bagCell)
         {
            this._bagCell.removeEventListener(Event.CHANGE,this.__changed);
            if(this._bagCell.itemInfo && this._bagCell.itemInfo.BagType == 0)
            {
               PlayerManager.Instance.Self.Bag.unlockItem(this._bagCell.itemInfo);
            }
            else if(this._bagCell.itemInfo)
            {
               PlayerManager.Instance.Self.PropBag.unlockItem(this._bagCell.itemInfo);
            }
            this._bagCell.locked = false;
            info = null;
         }
         this._bagCell = param1;
         if(this._bagCell)
         {
            this._bagCell.addEventListener(Event.CHANGE,this.__changed);
            this.info = this._bagCell.info;
         }
      }
      
      override public function get place() : int
      {
         if(this._bagCell)
         {
            return this._bagCell.itemInfo.Place;
         }
         return -1;
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!this.DoubleClickEnabled)
         {
            return;
         }
         if((param1.currentTarget as BagCell).info != null)
         {
            if((param1.currentTarget as BagCell).info != null)
            {
               dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this,true));
            }
         }
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         if(this._bagCell)
         {
            if(param1.action != DragEffect.NONE || param1.target)
            {
               this._bagCell.dragStop(param1);
               this._bagCell.removeEventListener(Event.CHANGE,this.__changed);
               this._bagCell = null;
               info = null;
            }
            else
            {
               this.locked = false;
            }
         }
      }
      
      private function __changed(param1:Event) : void
      {
         this.info = this._bagCell == null ? null : this._bagCell.info;
         if(this._bagCell == null || this._bagCell.info == null)
         {
            this.clearLinkCell();
         }
         else
         {
            this._bagCell.locked = true;
         }
      }
      
      override public function getSource() : IDragable
      {
         return this._bagCell;
      }
      
      public function clearLinkCell() : void
      {
         if(this._bagCell)
         {
            this._bagCell.removeEventListener(Event.CHANGE,this.__changed);
            if(this._bagCell.itemInfo && this._bagCell.itemInfo.lock)
            {
               if(this._bagCell.itemInfo && this._bagCell.itemInfo.BagType == 0)
               {
                  PlayerManager.Instance.Self.Bag.unlockItem(this._bagCell.itemInfo);
               }
               else
               {
                  PlayerManager.Instance.Self.PropBag.unlockItem(this._bagCell.itemInfo);
               }
            }
            this._bagCell.locked = false;
         }
         this.bagCell = null;
      }
      
      override public function set locked(param1:Boolean) : void
      {
      }
      
      override public function dispose() : void
      {
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         this.clearLinkCell();
         if(info is InventoryItemInfo)
         {
            info["lock"] = false;
         }
         super.dispose();
         this.bagCell = null;
      }
   }
}
