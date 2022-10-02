package store.view.exalt
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.view.tips.GoodTipInfo;
   import store.view.strength.LaterEquipmentView;
   import store.view.strength.StrengthTips;
   import store.view.strength.manager.ItemStrengthenGoodsInfoManager;
   import store.view.strength.vo.ItemStrengthenGoodsInfo;
   
   public class ExaltTips extends StrengthTips
   {
       
      
      public function ExaltTips()
      {
         super();
      }
      
      override protected function laterEquipment(param1:GoodTipInfo) : void
      {
         var _loc5_:ItemStrengthenGoodsInfo = null;
         var _loc6_:ItemTemplateInfo = null;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:GoodTipInfo = null;
         var _loc4_:InventoryItemInfo = null;
         if(param1)
         {
            _loc4_ = param1.itemInfo as InventoryItemInfo;
         }
         if(_loc4_ && _loc4_.StrengthenLevel < 15)
         {
            _loc3_ = new GoodTipInfo();
            _loc2_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc2_,_loc4_);
            _loc2_.StrengthenLevel += 1;
            _loc5_ = ItemStrengthenGoodsInfoManager.findItemStrengthenGoodsInfo(_loc2_.TemplateID,_loc2_.StrengthenLevel);
            if(_loc5_)
            {
               _loc2_.TemplateID = _loc5_.GainEquip;
               _loc6_ = ItemManager.Instance.getTemplateById(_loc2_.TemplateID);
               if(_loc6_)
               {
                  _loc2_.Attack = _loc6_.Attack;
                  _loc2_.Defence = _loc6_.Defence;
                  _loc2_.Agility = _loc6_.Agility;
                  _loc2_.Luck = _loc6_.Luck;
               }
            }
            _loc3_.itemInfo = _loc2_;
            if(!_laterEquipmentView)
            {
               _laterEquipmentView = new LaterEquipmentView();
            }
            _laterEquipmentView.x = _tipbackgound.x + _tipbackgound.width + 35;
            if(!this.contains(_laterEquipmentView))
            {
               addChild(_laterEquipmentView);
            }
            _laterEquipmentView.tipData = _loc3_;
         }
         else
         {
            if(_laterEquipmentView)
            {
               ObjectUtils.disposeObject(_laterEquipmentView);
            }
            _laterEquipmentView = null;
         }
      }
   }
}
