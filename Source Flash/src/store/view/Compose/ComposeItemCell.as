package store.view.Compose
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import store.StoreCell;
   
   public class ComposeItemCell extends StoreCell
   {
      
      public static const COMPOSE_TOP:int = 50;
       
      
      public function ComposeItemCell(param1:int)
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.store.EquipCellBG");
         _loc2_.addChild(_loc3_);
         super(_loc2_,param1);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(!_loc2_.CanCompose)
         {
            return;
         }
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
            }
            else
            {
               if(_loc2_.AgilityCompose == COMPOSE_TOP && _loc2_.DefendCompose == COMPOSE_TOP && _loc2_.AttackCompose == COMPOSE_TOP && _loc2_.LuckCompose == COMPOSE_TOP)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.ComposeItemCell.up"));
                  return;
               }
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,index,1);
               param1.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
