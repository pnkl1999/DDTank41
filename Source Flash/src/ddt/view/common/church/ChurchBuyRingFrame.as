package ddt.view.common.church
{
   import baglocked.BagLockedGetFrame;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class ChurchBuyRingFrame extends BaseAlerFrame
   {
       
      
      private var _bg:Bitmap;
      
      private var _ringInfo:ShopItemInfo;
      
      private var _alertInfo:AlertInfo;
      
      private var _spouseID:int;
      
      private var _proposeStr:String;
      
      private var _useBugle:Boolean;
      
      public function ChurchBuyRingFrame()
      {
         super();
         this.initialize();
      }
      
      public function get useBugle() : Boolean
      {
         return this._useBugle;
      }
      
      public function set useBugle(param1:Boolean) : void
      {
         this._useBugle = param1;
      }
      
      public function get proposeStr() : String
      {
         return this._proposeStr;
      }
      
      public function set proposeStr(param1:String) : void
      {
         this._proposeStr = param1;
      }
      
      public function get spouseID() : int
      {
         return this._spouseID;
      }
      
      public function set spouseID(param1:int) : void
      {
         this._spouseID = param1;
      }
      
      private function initialize() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this.escEnable = true;
         this._alertInfo = new AlertInfo();
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.ProposeBuyRingAsset");
         addToContent(this._bg);
         this._ringInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(11103);
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function confirmSubmit() : void
      {
         if(PathManager.solveChurchEnable())
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               new BagLockedGetFrame().show();
               return;
            }
            if(this._ringInfo && PlayerManager.Instance.Self.Money < this._ringInfo.getItemPrice(1).moneyValue)
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               SocketManager.Instance.out.sendPropose(this._spouseID,this._proposeStr,this._useBugle);
            }
         }
         this.dispose();
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               this.confirmSubmit();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._ringInfo = null;
         this._alertInfo = null;
         if(this._bg)
         {
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.bitmapData.dispose();
            this._bg.bitmapData = null;
         }
         this._bg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}
