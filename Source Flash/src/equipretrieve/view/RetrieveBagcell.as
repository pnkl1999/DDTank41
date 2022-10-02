package equipretrieve.view
{
   import bagAndInfo.bag.BreakGoodsBtn;
   import bagAndInfo.bag.SellGoodsBtn;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import equipretrieve.RetrieveModel;
   import flash.display.Sprite;
   
   public class RetrieveBagcell extends BagCell
   {
       
      
      public function RetrieveBagcell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Sprite = null)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Object = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            param1.action = DragEffect.NONE;
            super.dragStop(param1);
            return;
         }
         if(param1.data is InventoryItemInfo)
         {
            _loc2_ = param1.data as InventoryItemInfo;
            if(locked)
            {
               if(_loc2_ == this.info)
               {
                  this.locked = false;
                  DragManager.acceptDrag(this);
               }
               else
               {
                  DragManager.acceptDrag(this,DragEffect.NONE);
               }
            }
            else
            {
               if(_bagType == 11 || _loc2_.BagType == 11)
               {
                  if(param1.action == DragEffect.SPLIT)
                  {
                     param1.action = DragEffect.NONE;
                  }
                  else if(_bagType != 11)
                  {
                     SocketManager.Instance.out.sendMoveGoods(BagInfo.CONSORTIA,_loc2_.Place,_bagType,place,_loc2_.Count);
                     param1.action = DragEffect.NONE;
                  }
                  else if(_bagType == _loc2_.BagType)
                  {
                     if(place >= PlayerManager.Instance.Self.consortiaInfo.StoreLevel * 10)
                     {
                        param1.action = DragEffect.NONE;
                     }
                     else
                     {
                        SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_loc2_.BagType,place,_loc2_.Count);
                     }
                  }
                  else if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel < 1)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick"));
                     param1.action = DragEffect.NONE;
                  }
                  else
                  {
                     SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_bagType,place,_loc2_.Count);
                     param1.action = DragEffect.NONE;
                  }
               }
               else if(_loc2_.BagType == _bagType)
               {
                  SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_loc2_.BagType,place,-1);
                  param1.action = DragEffect.NONE;
               }
               else if(_loc2_.BagType != _bagType)
               {
                  _loc3_ = RetrieveModel.Instance.getSaveCells(_loc2_.Place);
                  SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,_loc3_.BagType,_loc3_.Place,_loc2_.Count);
                  param1.action = DragEffect.NONE;
               }
               DragManager.acceptDrag(this);
            }
         }
         else if(param1.data is SellGoodsBtn)
         {
            if(!locked && _info && this._bagType != 11)
            {
               locked = true;
               DragManager.acceptDrag(this);
            }
         }
         else if(param1.data is BreakGoodsBtn)
         {
            if(!locked && _info)
            {
               DragManager.acceptDrag(this);
            }
         }
         _loc2_ = null;
      }
      
      private function get itemBagType() : int
      {
         if(info && (info.CategoryID == 10 || info.CategoryID == 11 || info.CategoryID == 12))
         {
            return BagInfo.PROPBAG;
         }
         return BagInfo.EQUIPBAG;
      }
   }
}
