package store.fineStore.view.pageBringUp
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   
   public class FineBringUpUpgradeTip extends GoodTip
   {
       
      
      private var _upgradeBeadTip:GoodTip;
      
      public function FineBringUpUpgradeTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
      }
      
      override public function set tipData(param1:Object) : void
      {
         super.tipData = param1;
         this.bringUpUpgradeTip(param1 as GoodTipInfo);
      }
      
      override public function showTip(param1:ItemTemplateInfo, param2:Boolean = false) : void
      {
         super.showTip(param1,param2);
      }
      
      private function bringUpUpgradeTip(param1:GoodTipInfo) : void
      {
         var _loc3_:Image = null;
         var _loc4_:Bitmap = null;
         var _loc2_:ItemTemplateInfo = null;
         _loc3_ = null;
         _loc4_ = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc6_:GoodTipInfo = null;
         var _loc7_:InventoryItemInfo = null;
         if(param1)
         {
            _loc7_ = param1.itemInfo as InventoryItemInfo;
         }
         if(_loc7_ && _loc7_.FusionType != 0)
         {
            _loc6_ = new GoodTipInfo();
            _loc5_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc5_,_loc7_);
            _loc2_ = ItemManager.Instance.getTemplateById(_loc7_.FusionType);
            _loc5_.TemplateID = _loc2_.TemplateID;
            _loc5_.Name = _loc2_.Name;
            _loc5_.Attack = _loc2_.Attack;
            _loc5_.Defence = _loc2_.Defence;
            _loc5_.Agility = _loc2_.Agility;
            _loc5_.Luck = _loc2_.Luck;
            _loc5_.FusionType = _loc2_.FusionType;
            _loc5_.curExp = int(_loc2_.Property2);
            if(_loc2_.FusionType == 0)
            {
               _loc5_.Property2 = "0";
            }
            else
            {
               _loc5_.Property2 = ItemManager.Instance.getTemplateById(_loc2_.FusionType).Property2;
            }
            _loc6_.itemInfo = _loc5_;
            _loc6_.beadName = ItemManager.Instance.getTemplateById(_loc5_.TemplateID).Name;
            if(!this._upgradeBeadTip)
            {
               this._upgradeBeadTip = new GoodTip();
            }
            this._upgradeBeadTip.tipData = _loc6_;
            _loc3_ = ComponentFactory.Instance.creat("ddtstore.strengthTips.strengthenImageBG");
            this._upgradeBeadTip.tipbackgound = _loc3_;
            _loc3_.width += 10;
            _loc3_.height += 10;
            _loc3_.x -= 5;
            _loc3_.y -= 5;
            this._upgradeBeadTip.x = _tipbackgound.x + _tipbackgound.width + 8;
            if(!this.contains(this._upgradeBeadTip))
            {
               addChild(this._upgradeBeadTip);
            }
            _loc4_ = ComponentFactory.Instance.creatBitmap("asset.ddtstore.rightArrows");
            _loc4_.x = 190;
            _loc4_.y = 90;
            addChild(_loc4_);
         }
         else
         {
            if(this._upgradeBeadTip)
            {
               ObjectUtils.disposeObject(this._upgradeBeadTip);
            }
            this._upgradeBeadTip = null;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._upgradeBeadTip)
         {
            ObjectUtils.disposeObject(this._upgradeBeadTip);
         }
         this._upgradeBeadTip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
