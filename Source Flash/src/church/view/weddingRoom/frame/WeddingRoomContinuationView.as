package church.view.weddingRoom.frame
{
   import church.controller.ChurchRoomController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WeddingRoomContinuationView extends BaseAlerFrame
   {
      
      private static var _roomMoney:Array = ServerConfigManager.instance.findInfoByName(ServerConfigManager.MARRT_ROOM_CREATE_MONET).Value.split(",");
       
      
      private var _bg:Bitmap;
      
      private var _controller:ChurchRoomController;
      
      private var _alertInfo:AlertInfo;
      
      private var _roomContinuationTime1SelectedBtn:SelectedButton;
      
      private var _roomContinuationTime2SelectedBtn:SelectedButton;
      
      private var _roomContinuationTime3SelectedBtn:SelectedButton;
      
      private var _roomContinuationTimeGroup:SelectedButtonGroup;
      
      private var _alert:BaseAlerFrame;
      
      public function WeddingRoomContinuationView()
      {
         super();
         this.initialize();
      }
      
      public function get controller() : ChurchRoomController
      {
         return this._controller;
      }
      
      public function set controller(param1:ChurchRoomController) : void
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
         this._alertInfo = new AlertInfo("",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.room.continuationRoomFrameBgAsset");
         addToContent(this._bg);
         this._roomContinuationTime1SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomContinuationTime1SelectedBtn");
         addToContent(this._roomContinuationTime1SelectedBtn);
         this._roomContinuationTime2SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomContinuationTime2SelectedBtn");
         addToContent(this._roomContinuationTime2SelectedBtn);
         this._roomContinuationTime3SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomContinuationTime3SelectedBtn");
         addToContent(this._roomContinuationTime3SelectedBtn);
         this._roomContinuationTimeGroup = new SelectedButtonGroup(false);
         this._roomContinuationTimeGroup.addSelectItem(this._roomContinuationTime1SelectedBtn);
         this._roomContinuationTimeGroup.addSelectItem(this._roomContinuationTime2SelectedBtn);
         this._roomContinuationTimeGroup.addSelectItem(this._roomContinuationTime3SelectedBtn);
         this._roomContinuationTimeGroup.selectIndex = 0;
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._roomContinuationTime1SelectedBtn.addEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._roomContinuationTime2SelectedBtn.addEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._roomContinuationTime3SelectedBtn.addEventListener(MouseEvent.CLICK,this.onBtnClick);
      }
      
      private function onBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
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
         if(this.checkMoney() && ChurchManager.instance.currentRoom)
         {
            this._controller.roomContinuation(this._roomContinuationTimeGroup.selectIndex + 2);
         }
         this.dispose();
      }
      
      private function checkMoney() : Boolean
      {
         var _loc1_:Array = _roomMoney;
         if(PlayerManager.Instance.Self.Money < _loc1_[this._roomContinuationTimeGroup.selectIndex])
         {
            LeavePageManager.showFillFrame();
            this.dispose();
            return false;
         }
         return true;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeView() : void
      {
         this._alertInfo = null;
         if(this._alert)
         {
            if(this._alert.parent)
            {
               this._alert.parent.removeChild(this._alert);
            }
            this._alert.dispose();
         }
         this._alert = null;
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
         if(this._roomContinuationTime1SelectedBtn)
         {
            if(this._roomContinuationTime1SelectedBtn.parent)
            {
               this._roomContinuationTime1SelectedBtn.parent.removeChild(this._roomContinuationTime1SelectedBtn);
            }
            this._roomContinuationTime1SelectedBtn.dispose();
         }
         this._roomContinuationTime1SelectedBtn = null;
         if(this._roomContinuationTime2SelectedBtn)
         {
            if(this._roomContinuationTime2SelectedBtn.parent)
            {
               this._roomContinuationTime2SelectedBtn.parent.removeChild(this._roomContinuationTime2SelectedBtn);
            }
            this._roomContinuationTime2SelectedBtn.dispose();
         }
         this._roomContinuationTime2SelectedBtn = null;
         if(this._roomContinuationTime3SelectedBtn)
         {
            if(this._roomContinuationTime3SelectedBtn.parent)
            {
               this._roomContinuationTime3SelectedBtn.parent.removeChild(this._roomContinuationTime3SelectedBtn);
            }
            this._roomContinuationTime3SelectedBtn.dispose();
         }
         this._roomContinuationTime3SelectedBtn = null;
         if(this._roomContinuationTimeGroup)
         {
            this._roomContinuationTimeGroup.dispose();
         }
         this._roomContinuationTimeGroup = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(this._roomContinuationTime1SelectedBtn)
         {
            this._roomContinuationTime1SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         }
         if(this._roomContinuationTime2SelectedBtn)
         {
            this._roomContinuationTime2SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         }
         if(this._roomContinuationTime3SelectedBtn)
         {
            this._roomContinuationTime3SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this.removeView();
      }
   }
}
