package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import ddt.data.EquipType;
   import ddt.interfaces.ICell;
   import ddt.interfaces.IDragable;
   import ddt.manager.ChatManager;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   
   public class SellGoodsBtn extends SimpleBitmapButton implements IDragable
   {
      
      public static const StopSell:String = "stopsell";
       
      
      public var isActive:Boolean = false;
      
      private var sellFrame:SellGoodsFrame;
      
      private var lightingFilter:ColorMatrixFilter;
      
      private var _dragTarget:BagCell;
      
      public function SellGoodsBtn()
      {
         super();
         this.init();
      }
      
      override protected function init() : void
      {
         buttonMode = true;
         super.init();
      }
      
      public function dragStart(param1:Number, param2:Number) : void
      {
         this.isActive = true;
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.sellIconAsset");
         DragManager.startDrag(this,this,_loc3_,param1,param2,DragEffect.MOVE,false);
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         var _loc2_:BagCell = null;
         this.isActive = false;
         if(PlayerManager.Instance.Self.bagLocked && param1.target is ICell)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(param1.action == DragEffect.MOVE && param1.target is ICell)
         {
            _loc2_ = param1.target as BagCell;
            if(_loc2_ && _loc2_.info)
            {
               if(EquipType.isValuableEquip(_loc2_.info))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip"));
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip"));
                  _loc2_.locked = false;
                  dispatchEvent(new Event(StopSell));
               }
               else if(EquipType.isPetSpeciallFood(_loc2_.info))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
                  _loc2_.locked = false;
                  dispatchEvent(new Event(StopSell));
               }
               else if(_loc2_.info.CategoryID == 34)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
                  _loc2_.locked = false;
                  dispatchEvent(new Event(StopSell));
               }
               else
               {
                  this._dragTarget = _loc2_;
                  SoundManager.instance.play("008");
                  if(this.sellFrame == null)
                  {
                     this.sellFrame = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame");
                     this.sellFrame.itemInfo = this._dragTarget.itemInfo;
                     this.sellFrame.addEventListener(SellGoodsFrame.CANCEL,this.cancelBack);
                     this.sellFrame.addEventListener(SellGoodsFrame.OK,this.confirmBack);
                  }
                  LayerManager.Instance.addToLayer(this.sellFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               }
            }
            else
            {
               dispatchEvent(new Event(StopSell));
            }
         }
         else
         {
            dispatchEvent(new Event(StopSell));
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function getDragData() : Object
      {
         return this;
      }
      
      private function confirmBack(param1:Event) : void
      {
         if(stage)
         {
            this.dragStart(stage.mouseX,stage.mouseY);
         }
         this.__disposeSellFrame();
      }
      
      private function setUpLintingFilter() : void
      {
         var _loc1_:Array = new Array();
         _loc1_ = _loc1_.concat([1,0,0,0,25]);
         _loc1_ = _loc1_.concat([0,1,0,0,25]);
         _loc1_ = _loc1_.concat([0,0,1,0,25]);
         _loc1_ = _loc1_.concat([0,0,0,1,0]);
         this.lightingFilter = new ColorMatrixFilter(_loc1_);
      }
      
      override public function dispose() : void
      {
         if(this._dragTarget)
         {
            this._dragTarget.locked = false;
         }
         PlayerManager.Instance.Self.Bag.unLockAll();
         this.__disposeSellFrame();
         super.dispose();
      }
      
      private function __disposeSellFrame() : void
      {
         if(this.sellFrame)
         {
            this.sellFrame.removeEventListener(SellGoodsFrame.CANCEL,this.cancelBack);
            this.sellFrame.removeEventListener(SellGoodsFrame.OK,this.confirmBack);
            this.sellFrame.dispose();
         }
         this.sellFrame = null;
      }
      
      private function cancelBack(param1:Event) : void
      {
         if(this._dragTarget)
         {
            this._dragTarget.locked = false;
         }
         if(stage)
         {
            this.dragStart(stage.mouseX,stage.mouseY);
         }
         this.__disposeSellFrame();
      }
   }
}
