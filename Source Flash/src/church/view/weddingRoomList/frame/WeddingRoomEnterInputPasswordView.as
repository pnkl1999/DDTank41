package church.view.weddingRoomList.frame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class WeddingRoomEnterInputPasswordView extends BaseAlerFrame
   {
       
      
      private var _churchRoomInfo:ChurchRoomInfo;
      
      private var _alertInfo:AlertInfo;
      
      private var _passwordLabel:FilterFrameText;
      
      private var _txtPassword:TextInput;
      
      public function WeddingRoomEnterInputPasswordView()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      public function set churchRoomInfo(param1:ChurchRoomInfo) : void
      {
         this._churchRoomInfo = param1;
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this.enterEnable = true;
         this._passwordLabel = ComponentFactory.Instance.creat("church.main.roomEnterRoomPasswordLabelAsset");
         this._passwordLabel.text = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIPassInput.write1");
         addToContent(this._passwordLabel);
         this._txtPassword = ComponentFactory.Instance.creat("church.main.roomEnterRoomPasswordTextAsset");
         this._txtPassword.displayAsPassword = true;
         this._txtPassword.maxChars = 6;
         this._txtPassword.setFocus();
         addToContent(this._txtPassword);
      }
      
      private function removeView() : void
      {
         this._alertInfo = null;
         if(this._passwordLabel)
         {
            if(this._passwordLabel.parent)
            {
               this._passwordLabel.parent.removeChild(this._passwordLabel);
            }
            this._passwordLabel.dispose();
         }
         this._passwordLabel = null;
         if(this._txtPassword)
         {
            if(this._txtPassword.parent)
            {
               this._txtPassword.parent.removeChild(this._txtPassword);
            }
            this._txtPassword.dispose();
         }
         this._txtPassword = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._txtPassword.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._txtPassword.addEventListener(Event.CHANGE,this.onTxtPasswordChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._txtPassword.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._txtPassword.removeEventListener(Event.CHANGE,this.onTxtPasswordChange);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.enterRoomConfirm();
         }
      }
      
      private function onTxtPasswordChange(param1:Event) : void
      {
         if(this._txtPassword.text != "")
         {
            submitButtonEnable = true;
         }
         else
         {
            submitButtonEnable = false;
         }
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
               this.enterRoomConfirm();
         }
      }
      
      private function enterRoomConfirm() : void
      {
         submitButtonEnable = false;
         SoundManager.instance.play("008");
         if(this._txtPassword.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIPassInput.write"));
            return;
         }
         SocketManager.Instance.out.sendEnterRoom(this._churchRoomInfo.id,this._txtPassword.text);
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._txtPassword.setFocus();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}
