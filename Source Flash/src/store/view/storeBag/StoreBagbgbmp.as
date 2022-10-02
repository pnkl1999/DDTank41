package store.view.storeBag
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class StoreBagbgbmp extends Sprite implements IBagDrag
   {
       
      
      private var bg:Scale9CornerImage;
      
      public function StoreBagbgbmp()
      {
         super();
         this.bg = ComponentFactory.Instance.creat("store.bagScaleBGAsset");
         addChild(this.bg);
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         if(param1.data is InventoryItemInfo)
         {
            _loc2_ = param1.data as InventoryItemInfo;
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      public function dragStop(param1:DragEffect) : void
      {
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function dispose() : void
      {
         if(this.bg)
         {
            ObjectUtils.disposeObject(this.bg);
         }
         this.bg = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
