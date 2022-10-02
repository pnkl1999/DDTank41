package latentEnergy
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   
   public class LatentEnergyPreTip extends GoodTip
   {
       
      
      private var _rightArrow:Bitmap;
      
      private var _laterGoodTip:GoodTip;
      
      public function LatentEnergyPreTip()
      {
         super();
      }
      
      override public function set tipData(param1:Object) : void
      {
         super.tipData = param1;
         if(!param1)
         {
            return;
         }
         var _loc2_:GoodTipInfo = this.getPreGoodTipInfo(param1 as GoodTipInfo);
         if(!_loc2_)
         {
            return;
         }
         if(!this._rightArrow)
         {
            this._rightArrow = ComponentFactory.Instance.creatBitmap("asset.latentEnergy.rightArrows");
            this._rightArrow.x = this.width - 10;
            this._rightArrow.y = (this.height - this._rightArrow.height) / 2;
         }
         if(!this._laterGoodTip)
         {
            this._laterGoodTip = new GoodTip();
            this._laterGoodTip.x = _tipbackgound.x + _tipbackgound.width + 35;
         }
         addChild(this._laterGoodTip);
         this._laterGoodTip.tipData = _loc2_;
         addChild(this._rightArrow);
         _width = this._laterGoodTip.x + this._laterGoodTip.width;
         _height = this._laterGoodTip.height;
      }
      
      protected function getPreGoodTipInfo(param1:GoodTipInfo) : GoodTipInfo
      {
         var _loc7_:Date = null;
         var _loc2_:InventoryItemInfo = param1.itemInfo as InventoryItemInfo;
         var _loc3_:GoodTipInfo = new GoodTipInfo();
         var _loc4_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc4_,_loc2_);
         _loc4_.gemstoneList = _loc2_.gemstoneList;
         _loc4_.IsBinds = true;
         var _loc5_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.latentEnergyItemId);
         if(!_loc5_)
         {
            return null;
         }
         var _loc6_:String = _loc5_.Property3;
         _loc4_.latentEnergyCurStr = _loc6_ + "," + _loc6_ + "," + _loc6_ + "," + _loc6_;
         if(_loc2_.isHasLatentEnergy)
         {
            _loc4_.latentEnergyEndTime = _loc2_.latentEnergyEndTime;
         }
         else
         {
            _loc7_ = new Date(TimeManager.Instance.Now().getTime() + int(_loc5_.Property4) * TimeManager.DAY_TICKS - TimeManager.HOUR_TICKS);
            _loc4_.latentEnergyEndTime = _loc7_;
         }
         _loc3_.itemInfo = _loc4_;
         return _loc3_;
      }
   }
}
