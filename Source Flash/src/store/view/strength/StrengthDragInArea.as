package store.view.strength
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import store.StoreDragInArea;
   
   public class StrengthDragInArea extends StoreDragInArea
   {
       
      
      private var _hasStone:Boolean = false;
      
      private var _hasItem:Boolean = false;
      
      private var _stonePlace:int = -1;
      
      private var _effect:DragEffect;
      
      public function StrengthDragInArea(param1:Array)
      {
         super(param1);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         this._effect = param1;
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
               DragManager.acceptDrag(this);
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < 5)
               {
                  if(_loc3_ == 0 || _loc3_ == 3 || _loc3_ == 4)
                  {
                     if(_cells[_loc3_].itemInfo != null)
                     {
                        this._hasStone = true;
                        this._stonePlace = _loc3_;
                        break;
                     }
                  }
                  _loc3_++;
               }
               if(_cells[2].itemInfo != null)
               {
                  this._hasItem = true;
               }
               if(_loc2_.CanEquip)
               {
                  if(!this._hasStone)
                  {
                     _cells[2].dragDrop(param1);
                  }
                  else if(_loc2_.RefineryLevel > 0 && _cells[this._stonePlace].itemInfo.Property1 == "35" || _loc2_.RefineryLevel == 0 && _cells[this._stonePlace].itemInfo.Property1 == StoneType.STRENGTH)
                  {
                     _cells[2].dragDrop(param1);
                     this.reset();
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
                  }
               }
               else if(_cells[2].itemInfo.RefineryLevel > 0 && _loc2_.Property1 == "35" || _cells[2].itemInfo.RefineryLevel == 0 && _loc2_.Property1 == StoneType.STRENGTH)
               {
                  if(!this._hasStone)
                  {
                     this.findCellAndDrop();
                     this.reset();
                  }
                  else if(_cells[this._stonePlace].itemInfo.Property1 == _loc2_.Property1)
                  {
                     this.findCellAndDrop();
                     this.reset();
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                  }
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
               }
            }
         }
      }
      
      private function findCellAndDrop() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(_loc1_ == 0 || _loc1_ == 3 || _loc1_ == 4)
            {
               if(_cells[_loc1_].itemInfo == null)
               {
                  _cells[_loc1_].dragDrop(this._effect);
                  this.reset();
                  return;
               }
            }
            _loc1_++;
         }
         _cells[0].dragDrop(this._effect);
         this.reset();
      }
      
      private function reset() : void
      {
         this._hasStone = false;
         this._hasItem = false;
         this._stonePlace = -1;
         this._effect = null;
      }
      
      override public function dispose() : void
      {
         this.reset();
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
