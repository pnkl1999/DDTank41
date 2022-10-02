package store.fineStore.view
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import ddt.view.tips.GoodTipInfo;
   import store.equipGhost.EquipGhostManager;
   import store.view.strength.LaterEquipmentView;
   import store.view.strength.StrengthTips;
   
   public class GhostTips extends StrengthTips
   {
       
      
      public function GhostTips()
      {
         super();
      }
      
      private function clearNextTip() : void
      {
         if(_laterEquipmentView)
         {
            ObjectUtils.disposeObject(_laterEquipmentView);
         }
         _laterEquipmentView = null;
      }
      
      override protected function laterEquipment(param1:GoodTipInfo) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:InventoryItemInfo = null;
         if(param1)
         {
            _loc7_ = param1.itemInfo as InventoryItemInfo;
         }
         if(_loc7_ == null)
         {
            this.clearNextTip();
         }
         else
         {
            _loc2_ = uint(0);
            if(_loc3_ = PlayerManager.Instance.Self.getGhostDataByCategoryID(_loc7_.CategoryID))
            {
               _loc2_ = uint(_loc3_.level);
            }
            _loc4_ = uint(EquipGhostManager.getInstance().model.topLvDic[_loc7_.CategoryID]);
            if(_loc2_ >= _loc4_)
            {
               this.clearNextTip();
            }
            else
            {
               _loc5_ = new GoodTipInfo();
               _loc6_ = new InventoryItemInfo();
               ObjectUtils.copyProperties(_loc6_,_loc7_);
               _loc5_.ghostLv = _loc2_ + 1;
               _loc5_.itemInfo = _loc6_;
               if(!_laterEquipmentView)
               {
                  _laterEquipmentView = new LaterEquipmentView();
               }
               _laterEquipmentView.x = _tipbackgound.x + _tipbackgound.width + 35;
               if(!this.contains(_laterEquipmentView))
               {
                  addChild(_laterEquipmentView);
               }
               _laterEquipmentView.tipData = _loc5_;
            }
         }
      }
   }
}
