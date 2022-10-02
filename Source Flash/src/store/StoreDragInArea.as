package store
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class StoreDragInArea extends Sprite implements IAcceptDrag
   {
      
      public static const RECTWIDTH:int = 340;
      
      public static const RECTHEIGHT:int = 360;
       
      
      protected var _cells:Array;
      
      public function StoreDragInArea(param1:Array)
      {
         super();
         this._cells = param1;
         this.init();
      }
      
      private function init() : void
      {
         graphics.beginFill(255,0);
         graphics.drawRect(0,0,RECTWIDTH,RECTHEIGHT);
         graphics.endFill();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_.BagType == BagInfo.STOREBAG)
         {
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            return;
         }
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
               _loc3_ = false;
               _loc4_ = 0;
               while(_loc4_ < this._cells.length)
               {
                  if(this._cells[_loc4_].info == null)
                  {
                     this._cells[_loc4_].dragDrop(param1);
                     if(param1.target)
                     {
                        break;
                     }
                  }
                  else if(this._cells[_loc4_].info == _loc2_)
                  {
                     _loc3_ = true;
                  }
                  _loc4_++;
               }
               if(param1.target == null)
               {
                  if(!_loc3_)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.type"));
                  }
                  DragManager.acceptDrag(this);
               }
            }
         }
      }
      
      public function dispose() : void
      {
         this._cells = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
