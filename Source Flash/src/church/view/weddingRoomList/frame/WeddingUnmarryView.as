package church.view.weddingRoomList.frame
{
   import baglocked.BaglockedManager;
   import church.controller.ChurchRoomListController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class WeddingUnmarryView extends BaseAlerFrame
   {
       
      
      private var _controller:ChurchRoomListController;
      
      private var _alertInfo:AlertInfo;
      
      private var _text1:FilterFrameText;
      
      private var _text2:FilterFrameText;
      
      private var _text3:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _titleBg:Bitmap;
      
      private var _needMoney:int;
      
      public function WeddingUnmarryView()
      {
         super();
         this.initialize();
      }
      
      public function set controller(param1:ChurchRoomListController) : void
      {
         this._controller = param1;
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.moveEnable = false;
         this.escEnable = true;
         info = this._alertInfo;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.UnmarryAsset");
         addToContent(this._bg);
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.church.divorceTitleAsset");
         addToContent(this._titleBg);
         this._text1 = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT1");
         addToContent(this._text1);
         this._text2 = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT2");
         addToContent(this._text2);
         this._text3 = ComponentFactory.Instance.creatComponentByStylename("church.view.weddingRoomList.WeddingUnmarryViewT3");
         this._text3.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.note");
         addToContent(this._text3);
      }
      
      public function setText(param1:String = "", param2:String = "") : void
      {
         this._text1.htmlText = param1;
         this._text2.htmlText = param2;
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(this._text1)
         {
            this._text1.dispose();
         }
         this._text1 = null;
         if(this._text2)
         {
            this._text2.dispose();
         }
         this._text2 = null;
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.confirmSubmit();
         }
      }
      
      private function confirmSubmit() : void
      {
         if(PlayerManager.Instance.Self.Money < this._needMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._controller.unmarry();
         this.dispose();
      }
      
      private function _responseV(param1:FrameEvent) : void
      {
         var _loc2_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _loc2_.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function show(param1:int) : void
      {
         this._needMoney = param1;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}
