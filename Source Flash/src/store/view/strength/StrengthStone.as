package store.view.strength
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
   import store.StoneCell;
   
   public class StrengthStone extends StoneCell
   {
       
      
      private var _stoneType:String = "";
      
      private var _itemType:int = -1;
      
      private var _aler:StrengthSelectNumAlertFrame;
      
      public function StrengthStone(param1:Array, param2:int)
      {
         super(param1,param2);
      }
      
      public function set itemType(param1:int) : void
      {
         this._itemType = param1;
      }
      
      public function get itemType() : int
      {
         return this._itemType;
      }
      
      public function get stoneType() : String
      {
         return this._stoneType;
      }
      
      public function set stoneType(param1:String) : void
      {
         this._stoneType = param1;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_.BagType == BagInfo.STOREBAG && info != null)
         {
            return;
         }
         if(_types.indexOf(_loc2_.Property1) == -1)
         {
            return;
         }
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(this._stoneType == "" || this._stoneType == _loc2_.Property1)
            {
               this._stoneType = _loc2_.Property1;
               if(_loc2_.Count == 1)
               {
                  SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,BagInfo.STOREBAG,index,1);
               }
               else
               {
                  this.showNumAlert(_loc2_,index);
               }
               DragManager.acceptDrag(this,DragEffect.NONE);
               this.reset();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
            }
         }
      }
      
      private function showNumAlert(param1:InventoryItemInfo, param2:int) : void
      {
         if(this._stoneType == "35" || this._stoneType == "2")
         {
            this._aler = ComponentFactory.Instance.creat("ddtstore.StrengthSelectNumAlertFrame");
            this._aler.addExeFunction(this.sellFunction,this.notSellFunction);
            this._aler.goodsinfo = param1;
            this._aler.index = param2;
            this._aler.show(param1.Count);
         }
         else if(this._stoneType == "45")
         {
            this._aler = ComponentFactory.Instance.creat("store.view.exalt.exaltSelectNumAlertFrame");
            this._aler.addExeFunction(this.sellFunction,this.notSellFunction);
            this._aler.goodsinfo = param1;
            this._aler.index = param2;
            this._aler.show(param1.Count);
         }
      }
      
      private function sellFunction(param1:int, param2:InventoryItemInfo, param3:int) : void
      {
         SocketManager.Instance.out.sendMoveGoods(param2.BagType,param2.Place,BagInfo.STOREBAG,param3,param1,true);
         if(this._aler)
         {
            this._aler.dispose();
         }
         if(this._aler && this._aler.parent)
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function notSellFunction() : void
      {
         if(this._aler)
         {
            this._aler.dispose();
         }
         if(this._aler && this._aler.parent)
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function reset() : void
      {
         this._stoneType = "";
         this._itemType = -1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
