package latentEnergy
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.DisplayObject;
   
   public class LatentEnergyEquipCell extends BagCell
   {
       
      
      private var _latentEnergyItemId:int;
      
      public function LatentEnergyEquipCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      public function set latentEnergyItemId(param1:int) : void
      {
         this._latentEnergyItemId = param1;
         if(_tipData && _tipData is GoodTipInfo)
         {
            (_tipData as GoodTipInfo).latentEnergyItemId = this._latentEnergyItemId;
         }
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         if(_tipData && _tipData is GoodTipInfo)
         {
            (_tipData as GoodTipInfo).latentEnergyItemId = this._latentEnergyItemId;
         }
      }
      
      override public function get tipStyle() : String
      {
         return "latentEnergy.LatentEnergyPreTip";
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
         LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      private function equipMoveHandler(param1:LatentEnergyEvent) : void
      {
         var _loc2_:LatentEnergyEvent = null;
         if(info == param1.info)
         {
            return;
         }
         if(info)
         {
            _loc2_ = new LatentEnergyEvent(LatentEnergyManager.EQUIP_MOVE2);
            _loc2_.info = info as InventoryItemInfo;
            _loc2_.moveType = 3;
            LatentEnergyManager.instance.dispatchEvent(_loc2_);
         }
         this.info = param1.info;
      }
      
      private function equipMoveHandler2(param1:LatentEnergyEvent) : void
      {
         if(info != param1.info || param1.moveType != 2)
         {
            return;
         }
         this.info = null;
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!info)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc2_:LatentEnergyEvent = new LatentEnergyEvent(LatentEnergyManager.EQUIP_MOVE2);
         _loc2_.info = info as InventoryItemInfo;
         _loc2_.moveType = 2;
         LatentEnergyManager.instance.dispatchEvent(_loc2_);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         dragStart();
      }
      
      public function clearInfo() : void
      {
         var _loc1_:LatentEnergyEvent = null;
         if(info)
         {
            _loc1_ = new LatentEnergyEvent(LatentEnergyManager.EQUIP_MOVE2);
            _loc1_.info = info as InventoryItemInfo;
            _loc1_.moveType = 2;
            LatentEnergyManager.instance.dispatchEvent(_loc1_);
         }
      }
   }
}
