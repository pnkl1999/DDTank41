package store.fineStore.view.pageBringUp
{
   import bagAndInfo.cell.LockableBagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import latentEnergy.LatentEnergyEvent;
   import latentEnergy.LatentEnergyManager;
   import store.FineBringUpController;
   
   public class FineBringUpCell extends LockableBagCell
   {
       
      
      private var _observer:IObserver;
      
      private var _text:FilterFrameText;
      
      private var _latentEnergyItemId:int;
      
      private var _lastLevel:int;
      
      public function FineBringUpCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         var _loc6_:Shape = new Shape();
         _loc6_.graphics.beginFill(0,0);
         _loc6_.graphics.drawRect(0,0,65,65);
         _loc6_.graphics.endFill();
         var _loc7_:Bitmap = new Bitmap(new BitmapData(65,65));
         _loc7_.bitmapData.draw(_loc6_);
         param4 = _loc7_;
         param4.alpha = 0;
         super(param1,param2,param3,param4,param5);
         this._text = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.reworkname.Text1");
         this._text.x = 6;
         this._text.y = 21;
         this._text.text = LanguageMgr.GetTranslation("FineBringUpCell.textCell");
         addChild(this._text);
         lockDisplayObject = ComponentFactory.Instance.creatBitmap("asset.store.bringup.lock");
         PositionUtils.setPos(lockDisplayObject,"storeBringUp.leftCellLockPos");
         param5 = false;
      }
      
      public function get lastLevel() : int
      {
         return this._lastLevel;
      }
      
      public function set latentEnergyItemId(param1:int) : void
      {
         this._latentEnergyItemId = param1;
         if(_tipData && _tipData is GoodTipInfo)
         {
            (_tipData as GoodTipInfo).latentEnergyItemId = this._latentEnergyItemId;
         }
      }
      
      override public function get tipStyle() : String
      {
         return "store.fineStore.view.pageBringUp.FineBringUpUpgradeTip";
      }
      
      public function register(param1:IObserver) : void
      {
         this._observer = param1;
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         param1 && (this._lastLevel = int(param1.Property1));
         if(_tipData && _tipData is GoodTipInfo)
         {
            (_tipData as GoodTipInfo).latentEnergyItemId = this._latentEnergyItemId;
         }
         if(param1 != null)
         {
            FineBringUpController.getInstance().showNewHandTip();
         }
         this._observer && this._observer.update(param1);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
         FineBringUpController.getInstance().addEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         FineBringUpController.getInstance().addEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
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
            FineBringUpController.getInstance().dispatchEvent(_loc2_);
         }
         this.info = param1.info;
      }
      
      private function equipMoveHandler2(param1:LatentEnergyEvent) : void
      {
         if(info != param1.info || param1.moveType != 2)
         {
            return;
         }
         SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,0,BagInfo.EQUIPBAG,-1);
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
         FineBringUpController.getInstance().dispatchEvent(_loc2_);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         FineBringUpController.getInstance().removeEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         FineBringUpController.getInstance().removeEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
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
            FineBringUpController.getInstance().dispatchEvent(_loc1_);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._observer = null;
         if(_bg != null)
         {
            ObjectUtils.disposeObject(_bg);
            _bg = null;
         }
         if(this._text != null)
         {
            ObjectUtils.disposeObject(this._text);
            this._text = null;
         }
      }
   }
}
