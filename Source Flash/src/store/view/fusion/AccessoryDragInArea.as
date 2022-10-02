package store.view.fusion
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
   
   public class AccessoryDragInArea extends Sprite implements IAcceptDrag
   {
       
      
      private var _cells:Array;
      
      public function AccessoryDragInArea(param1:Array)
      {
         super();
         this._cells = param1;
         graphics.beginFill(255,0);
         graphics.drawRect(-40,-40,280,230);
         graphics.endFill();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
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
               _loc4_ = false;
               _loc5_ = 0;
               while(_loc5_ < this._cells.length)
               {
                  if(this._cells[_loc5_].info == null)
                  {
                     _loc3_ = true;
                     this._cells[_loc5_].dragDrop(param1);
                     if(param1.target)
                     {
                        break;
                     }
                  }
                  else if(this._cells[_loc5_].info == _loc2_)
                  {
                     _loc4_ = true;
                  }
                  _loc5_++;
               }
               if(param1.target == null)
               {
                  if(!_loc4_)
                  {
                     if(_loc3_)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.type"));
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.more"));
                     }
                  }
                  DragManager.acceptDrag(this);
               }
            }
         }
      }
   }
}
