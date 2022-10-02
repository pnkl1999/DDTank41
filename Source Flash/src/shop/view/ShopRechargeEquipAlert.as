package shop.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ShopRechargeEquipAlert extends Sprite
   {
       
      
      private var _girl:Bitmap;
      
      private var _description:Bitmap;
      
      private var _frame:BaseAlerFrame;
      
      public function ShopRechargeEquipAlert()
      {
         super();
         this._girl = ComponentFactory.Instance.creatBitmap("asset.trainer.welcome.npc");
         this._description = ComponentFactory.Instance.creatBitmap("asset.shop.ShopRechargeEquipDescription");
         this._frame = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewAlert");
         var _loc1_:AlertInfo = new AlertInfo("",LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.xu"),LanguageMgr.GetTranslation("cancel"));
         this._girl.scaleX = -1;
         _loc1_.autoButtonGape = false;
         _loc1_.buttonGape = 50;
         _loc1_.customPos = ComponentFactory.Instance.creatCustomObject("shop.RechargeEquipAlertButtonPos");
         this._frame.info = _loc1_;
         this._frame.moveEnable = false;
         this._frame.addToContent(this._girl);
         this._frame.addToContent(this._description);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         var _loc2_:ShopRechargeEquipView = null;
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               _loc2_ = new ShopRechargeEquipView();
               LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               this.dispose();
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
               InventoryItemInfo.startTimer();
               this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this._frame.dispose();
         this._girl = null;
         this._description = null;
         this._frame = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
