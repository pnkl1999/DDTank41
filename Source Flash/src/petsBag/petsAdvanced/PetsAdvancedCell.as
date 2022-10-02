package petsBag.petsAdvanced
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class PetsAdvancedCell extends Sprite implements Disposeable
   {
       
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _bagCell:BagCell;
      
      private var _count:int;
      
      public function PetsAdvancedCell()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:InventoryItemInfo = new InventoryItemInfo();
         switch(PetsAdvancedManager.Instance.currentViewType)
         {
            case 1:
               _loc1_.TemplateID = 11162;
               break;
            case 2:
               _loc1_.TemplateID = 11163;
               break;
            case 4:
               _loc1_.TemplateID = 201567;
         }
         _loc1_ = ItemManager.fill(_loc1_);
         _loc1_.BindType = 4;
         this._bagCell = new BagCell(0,null,false,null,false);
         this._bagCell.info = _loc1_;
         this._bagCell.PicPos = new Point(9,9);
         this._bagCell.setBgVisible(false);
         this._bagCell.setContentSize(42,42);
         this.updateCount();
         addChild(this._bagCell);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.buybtn");
         addChild(this._buyBtn);
         this._buyBtn.visible = false;
      }
      
      public function getExpOfBagcell() : int
      {
         return int(this._bagCell.info.Property2);
      }
      
      public function getTempleteId() : int
      {
         return this._bagCell.info.TemplateID;
      }
      
      public function getPropName() : String
      {
         return this._bagCell.info.Name;
      }
      
      public function getCount() : int
      {
         return this._count;
      }
      
      public function updateCount() : void
      {
         var _loc1_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG);
         this._count = _loc1_.getItemCountByTemplateId(this._bagCell.info.TemplateID);
         this._bagCell.setCount(this._count);
         this._bagCell.refreshTbxPos();
      }
      
      private function addEvent() : void
      {
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyHandler);
         addEventListener(MouseEvent.ROLL_OVER,this.__overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__updateBag);
      }
      
      protected function __updateBag(param1:BagEvent) : void
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc2_:BagInfo = param1.target as BagInfo;
         var _loc3_:Dictionary = param1.changedSlots;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc2_.getItemAt(_loc4_.Place);
            if(_loc5_ && (_loc5_.TemplateID == 11162 || _loc5_.TemplateID == 11163 || _loc5_.TemplateID == 201567))
            {
               this.updateCount();
            }
         }
      }
      
      protected function __outHandler(param1:MouseEvent) : void
      {
         this._buyBtn.visible = false;
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         this._buyBtn.visible = true;
      }
      
      protected function __buyHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:QuickBuyFrame = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
         _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc2_.itemID = this._bagCell.info.TemplateID;
         _loc2_.recordLastBuyCount = true;
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__buyHandler);
         removeEventListener(MouseEvent.ROLL_OVER,this.__overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateBag);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(this.numChildren)
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
