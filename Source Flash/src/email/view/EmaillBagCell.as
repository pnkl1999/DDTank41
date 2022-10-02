package email.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.events.MouseEvent;
   
   public class EmaillBagCell extends LinkedBagCell
   {
       
      
      public function EmaillBagCell()
      {
         super(null);
         _bg.alpha = 0;
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(info && effect.action == DragEffect.MOVE)
         {
            effect.action = DragEffect.NONE;
            if(info.IsBinds)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.isBinds"));
            }
            else if(info.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.RemainDate"));
            }
            else
            {
               bagCell = effect.source as BagCell;
               effect.action = DragEffect.LINK;
            }
            DragManager.acceptDrag(this);
         }
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
         buttonMode = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
