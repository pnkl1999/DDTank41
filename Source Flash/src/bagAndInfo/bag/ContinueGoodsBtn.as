package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import ddt.data.EquipType;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.goods.AddPricePanel;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ContinueGoodsBtn extends SimpleBitmapButton implements IDragable
   {
       
      
      public var _isContinueGoods:Boolean;
      
      public function ContinueGoodsBtn()
      {
         super();
         this._isContinueGoods = false;
         this.addEvt();
      }
      
      private function addEvt() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.clickthis);
      }
      
      private function removeEvt() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.clickthis);
      }
      
      private function clickthis(param1:MouseEvent) : void
      {
         var _loc2_:Bitmap = null;
         SoundManager.instance.play("008");
         if(this._isContinueGoods == false)
         {
            this._isContinueGoods = true;
            _loc2_ = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.continueIconAsset");
            DragManager.startDrag(this,this,_loc2_,param1.stageX,param1.stageY,DragEffect.MOVE,false);
         }
         else
         {
            this._isContinueGoods = false;
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         var _loc2_:BagCell = null;
         _loc2_ = null;
         if(this._isContinueGoods && param1.target is BagCell)
         {
            _loc2_ = param1.target as BagCell;
            _loc2_.locked = false;
            this._isContinueGoods = false;
            if(ShopManager.Instance.canAddPrice(_loc2_.itemInfo.TemplateID) && _loc2_.itemInfo.getRemainDate() != int.MAX_VALUE && !EquipType.isProp(_loc2_.itemInfo))
            {
               AddPricePanel.Instance.setInfo(_loc2_.itemInfo,false);
               AddPricePanel.Instance.show();
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.cantAddPrice"));
            return;
         }
         this._isContinueGoods = false;
      }
      
      public function get isContinueGoods() : Boolean
      {
         return this._isContinueGoods;
      }
   }
}
