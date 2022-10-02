package im
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.view.chat.ChatEvent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class AddFriendFrame extends BaseAlerFrame implements Disposeable
   {
      
      public static const MAX_CHAES:int = 14;
       
      
      protected var _inputText:FilterFrameText;
      
      protected var _explainText:FilterFrameText;
      
      protected var _hintText:FilterFrameText;
      
      protected var _alertInfo:AlertInfo;
      
      protected var _name:String;
      
      public function AddFriendFrame()
      {
         super();
         this.initContainer();
         this.initEvent();
      }
      
      protected function initContainer() : void
      {
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("tank.view.im.AddFriendFrame.add");
         this._alertInfo.enterEnable = true;
         this._alertInfo.escEnable = true;
         this._alertInfo.submitEnabled = false;
         info = this._alertInfo;
         this._inputText = ComponentFactory.Instance.creat("textinput");
         this._inputText.maxChars = MAX_CHAES;
         addToContent(this._inputText);
         this._explainText = ComponentFactory.Instance.creat("IM.TextStyle");
         this._explainText.text = LanguageMgr.GetTranslation("tank.view.im.AddFriendFrame.name");
         addToContent(this._explainText);
         this._hintText = ComponentFactory.Instance.creat("IM.TextStyleII");
         this._hintText.text = LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.chat");
         addToContent(this._hintText);
         this._name = "";
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._inputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__fieldKeyDown);
         this._inputText.addEventListener(Event.CHANGE,this.__inputTextChange);
         ChatManager.Instance.output.contentField.addEventListener(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,this.__onNameClick);
      }
      
      private function __inputTextChange(param1:Event = null) : void
      {
         if(this._inputText.text != "")
         {
            submitButtonEnable = true;
         }
         else
         {
            submitButtonEnable = false;
         }
         this._name = this._inputText.text;
      }
      
      private function __onNameClick(param1:ChatEvent) : void
      {
         this._inputText.text = String(param1.data);
         this.__inputTextChange(null);
      }
      
      protected function __fieldKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this._name == "" || this._name == null)
            {
               return;
            }
            this.submit();
            SoundManager.instance.play("008");
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.hide();
            SoundManager.instance.play("008");
         }
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.hide();
               SoundManager.instance.play("008");
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SoundManager.instance.play("008");
               this.submit();
         }
      }
      
      protected function submit() : void
      {
         if(this._name == "" || this._name == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IMControl.addNullFriend"));
            return;
         }
         this.hide();
         IMController.Instance.addFriend(this._name);
      }
      
      protected function hide() : void
      {
         this.dispose();
      }
      
      private function __setFocus(param1:Event) : void
      {
         IMView.IS_SHOW_SUB = true;
         this._inputText.setFocus();
      }
      
      override public function dispose() : void
      {
         if(this._inputText)
         {
            this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__fieldKeyDown);
         }
         ChatManager.Instance.output.contentField.removeEventListener(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,this.__onNameClick);
         super.dispose();
         removeEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         if(this._inputText)
         {
            this._inputText.dispose();
            this._inputText = null;
         }
         if(this._explainText)
         {
            this._explainText.dispose();
            this._explainText = null;
         }
         if(this._hintText)
         {
            this._hintText.dispose();
            this._hintText = null;
         }
         this._alertInfo = null;
         IMView.IS_SHOW_SUB = false;
      }
   }
}
