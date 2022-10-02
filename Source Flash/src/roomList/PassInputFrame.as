package roomList
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class PassInputFrame extends BaseAlerFrame implements Disposeable
   {
       
      
      private var _passInputText:TextInput;
      
      private var _explainText:Bitmap;
      
      private var _ID:int;
      
      public function PassInputFrame()
      {
         super();
         this.initContainer();
         this.initEvent();
      }
      
      private function initContainer() : void
      {
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         info = _loc1_;
         this._passInputText = ComponentFactory.Instance.creat("roomList.passInputFrame.passTextinput");
         this._passInputText.text = "";
         this._passInputText.textField.restrict = "0-9 A-Z a-z";
         this._passInputText.displayAsPassword = true;
         addToContent(this._passInputText);
         this._explainText = ComponentFactory.Instance.creatBitmap("asset.roomList.inputPass");
         addToContent(this._explainText);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         addEventListener(Event.ADDED_TO_STAGE,this.__addStage);
         this._passInputText.addEventListener(Event.CHANGE,this.__input);
         this._passInputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__KeyDown);
      }
      
      private function __KeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.submit();
         }
      }
      
      private function __addStage(param1:Event) : void
      {
         if(this._passInputText)
         {
            submitButtonEnable = false;
            this._passInputText.setFocus();
         }
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.hide();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submit();
         }
      }
      
      private function submit() : void
      {
         SoundManager.instance.play("008");
         if(this._passInputText.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIPassInput.write"));
            return;
         }
         if(StateManager.currentStateType == StateType.ROOM_LIST)
         {
            SocketManager.Instance.out.sendGameLogin(1,-1,this._ID,this._passInputText.text);
         }
         else
         {
            SocketManager.Instance.out.sendGameLogin(2,-1,this._ID,this._passInputText.text);
         }
         this.hide();
      }
      
      public function get ID() : int
      {
         return this._ID;
      }
      
      public function set ID(param1:int) : void
      {
         this._ID = param1;
      }
      
      private function hide() : void
      {
         this.dispose();
      }
      
      private function __input(param1:Event) : void
      {
         if(this._passInputText.text != "")
         {
            submitButtonEnable = true;
         }
         else
         {
            submitButtonEnable = false;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._passInputText.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
