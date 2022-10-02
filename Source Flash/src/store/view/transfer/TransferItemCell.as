package store.view.transfer
{
   import bagAndInfo.cell.DragEffect;
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
   
   public class TransferItemCell extends StoreCell
   {
       
      
      private var _categoryID:Number = -1;
      
      private var _isComposeStrength:Boolean;
      
      private var _refinery:int = -1;
      
      public function TransferItemCell(param1:int)
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.store.EquipCellBG");
         _loc2_.addChild(_loc3_);
         super(_loc2_,param1);
         this._isComposeStrength = false;
      }
      
      public function set Refinery(param1:int) : void
      {
         this._refinery = param1;
      }
      
      public function get Refinery() : int
      {
         return this._refinery;
      }
      
      public function set isComposeStrength(param1:Boolean) : void
      {
         this._isComposeStrength = param1;
      }
      
      public function set categoryId(param1:Number) : void
      {
         this._categoryID = param1;
      }
      
      private function checkComposeStrengthen() : Boolean
      {
         if(itemInfo.StrengthenLevel > 0)
         {
            return true;
         }
         if(itemInfo.AttackCompose > 0)
         {
            return true;
         }
         if(itemInfo.DefendCompose > 0)
         {
            return true;
         }
         if(itemInfo.LuckCompose > 0)
         {
            return true;
         }
         if(itemInfo.AgilityCompose > 0)
         {
            return true;
         }
         return false;
      }
      
      public function set index(param1:int) : void
      {
         _index = param1;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(!_loc2_.CanCompose && !_loc2_.CanStrengthen && !_loc2_.isCanLatentEnergy)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.object"));
               return;
            }
            if(_loc2_.Level != 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.object"));
               return;
            }
            if(this._isComposeStrength)
            {
               if(!this.checkComposeStrengthen())
               {
                  return;
               }
            }
            if(this._categoryID > 0)
            {
               if(_loc2_.CategoryID != this._categoryID)
               {
                  if(_loc2_.CanEquip == 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.current"));
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                  return;
               }
            }
            if(_loc2_.CanEquip)
            {
               SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,index,1);
               DragManager.acceptDrag(this,DragEffect.NONE);
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.current"));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
