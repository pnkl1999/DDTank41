package shop.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ShopRechargeEquipServer extends Sprite implements Disposeable
   {
       
      
      private var _girl:Bitmap;
      
      private var _description:Bitmap;
      
      private var _frame:BaseAlerFrame;
      
      public function ShopRechargeEquipServer()
      {
         super();
         this._girl = ComponentFactory.Instance.creatBitmap("asset.trainer.welcome.npc");
         this._description = ComponentFactory.Instance.creatBitmap("asset.shop.ShopRechargeServerDescription");
         this._frame = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewServer");
         var _loc1_:AlertInfo = new AlertInfo("",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation(""));
         this._girl.scaleX = -1;
         _loc1_.autoButtonGape = false;
         _loc1_.buttonGape = 50;
         _loc1_.customPos = ComponentFactory.Instance.creatCustomObject("shop.RechargeEquipServerButtonPos");
         this._frame.info = _loc1_;
         this._frame.moveEnable = false;
         this._frame.addToContent(this._girl);
         this._frame.addToContent(this._description);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
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
