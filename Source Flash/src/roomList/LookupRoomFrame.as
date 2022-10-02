package roomList
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.IMEManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class LookupRoomFrame extends BaseAlerFrame implements Disposeable
   {
       
      
      private var _idInputText:TextInput;
      
      private var _passInputText:TextInput;
      
      private var _passBGII:Bitmap;
      
      private var _explainText:Image;
      
      private var _explainTextII:Bitmap;
      
      private var _checkBox:SelectedCheckButton;
      
      public function LookupRoomFrame()
      {
         super();
         this.initContainer();
         this.initEvent();
      }
      
      private function initContainer() : void
      {
         this.escEnable = true;
         this.enterEnable = true;
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIFindRoomPanel.search");
         info = _loc1_;
         this._idInputText = ComponentFactory.Instance.creat("roomList.RoomList.IDTextinput");
         this._idInputText.text = "";
         this._idInputText.textField.restrict = "0-9";
         this._idInputText.textField.wordWrap = false;
         this._idInputText.textField.autoSize = "none";
         this._idInputText.textField.width = 135;
         addToContent(this._idInputText);
         this._passInputText = ComponentFactory.Instance.creat("roomList.RoomList.passTextinput");
         this._passInputText.text = "";
         this._passInputText.textField.restrict = "0-9 A-Z a-z";
         this._passInputText.textField.wordWrap = false;
         this._passInputText.textField.width = 135;
         this._passInputText.displayAsPassword = true;
         addToContent(this._passInputText);
         this._explainText = ComponentFactory.Instance.creatComponentByStylename("roomList.LookUpView.Pass");
         this._explainText.buttonMode = true;
         addToContent(this._explainText);
         this._explainTextII = ComponentFactory.Instance.creatBitmap("asset.roomList.inputID");
         addToContent(this._explainTextII);
         this._passBGII = ComponentFactory.Instance.creatBitmap("asset.roomList.gray");
         addToContent(this._passBGII);
         this._checkBox = ComponentFactory.Instance.creat("roomList.pvpRoomList.checkBoxBtn");
         addToContent(this._checkBox);
      }
      
      private function initEvent() : void
      {
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._explainText.addEventListener(MouseEvent.CLICK,this.__explainText);
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         addEventListener(Event.ADDED_TO_STAGE,this.__addStage);
         this._idInputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__onkeyDown);
         this._passInputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__onkeyDown);
      }
      
      private function __onkeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            SoundManager.instance.play("008");
            this.submit();
         }
      }
      
      private function __explainText(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._checkBox.selected = !this._checkBox.selected;
         this._passBGII.visible = !this._checkBox.selected;
         this._passInputText.visible = this._checkBox.selected;
         this._passInputText.text = "";
         if(this._checkBox.selected)
         {
            this._passInputText.setFocus();
         }
         else
         {
            this._idInputText.setFocus();
         }
      }
      
      private function __addStage(param1:Event) : void
      {
         IMEManager.disable();
         if(this._idInputText)
         {
            this._idInputText.setFocus();
         }
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.hide();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.submit();
         }
      }
      
      protected function submit() : void
      {
         if(stage)
         {
            if(this._idInputText.text == "")
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIFindRoomPanel.id"));
               return;
            }
            if(StateManager.currentStateType == StateType.DUNGEON_LIST)
            {
               SocketManager.Instance.out.sendGameLogin(2,-1,int(this._idInputText.text),this._passInputText.text);
            }
            else
            {
               SocketManager.Instance.out.sendGameLogin(1,-1,int(this._idInputText.text),this._passInputText.text);
            }
         }
         this.hide();
      }
      
      protected function hide() : void
      {
         this.dispose();
      }
      
      private function __checkBoxClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._passBGII.visible = !this._checkBox.selected;
         this._passInputText.visible = this._checkBox.selected;
         this._passInputText.text = "";
         if(this._checkBox.selected)
         {
            this._passInputText.setFocus();
         }
         else
         {
            this._idInputText.setFocus();
         }
      }
      
      override public function dispose() : void
      {
         this._checkBox.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._explainText.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addStage);
         this._idInputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onkeyDown);
         this._passInputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onkeyDown);
         this._checkBox.dispose();
         this._idInputText.dispose();
         this._passInputText.dispose();
         super.dispose();
      }
   }
}
