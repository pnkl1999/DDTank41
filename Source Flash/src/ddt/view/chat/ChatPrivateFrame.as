package ddt.view.chat
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class ChatPrivateFrame extends BaseAlerFrame
   {
       
      
      private var _friendList:Array;
      
      private var _comBox:ComboBox;
      
      private var _textField:TextField;
      
      public function ChatPrivateFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc4_:FriendListPlayer = null;
         super.init();
         addEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         this._comBox = ComponentFactory.Instance.creat("chat.FriendListCombo");
         this._textField = ComponentFactory.Instance.creatCustomObject("chat.PrivateFrameComboText");
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrameText");
         _loc1_.text = LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.nick");
         var _loc2_:VectorListModel = this._comBox.listPanel.vectorListModel;
         this._friendList = PlayerManager.Instance.onlineFriendList;
         this._comBox.snapItemHeight = this._friendList.length < 4;
         this._comBox.selctedPropName = "text";
         this._comBox.beginChanges();
         var _loc3_:uint = 0;
         while(_loc3_ < this._friendList.length)
         {
            _loc4_ = this._friendList[_loc3_] as FriendListPlayer;
            _loc2_.append(_loc4_.NickName);
            _loc3_++;
         }
         this._comBox.listPanel.list.updateListView();
         this._comBox.commitChanges();
         this._comBox.textField = this._textField;
         this._textField.maxChars = 15;
         this._textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._comBox.button.addEventListener(MouseEvent.CLICK,this.__playSound);
         this._comBox.addEventListener(InteractiveEvent.STATE_CHANGED,this.__comChange);
         addToContent(_loc1_);
         addToContent(this._comBox);
         addToContent(this._comBox.textField);
      }
      
      private function __setFocus(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         StageReferance.stage.focus = this._comBox.textField;
      }
      
      private function __comChange(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __keyDownHandler(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
         }
      }
      
      private function __playSound(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         setChildIndex(_container,numChildren - 1);
      }
      
      public function get currentFriend() : String
      {
         return this._textField.text;
      }
      
      override public function dispose() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         if(ChatManager.Instance.input.inputField.privateChatName == "")
         {
            ChatManager.Instance.inputChannel = ChatInputView.CURRENT;
         }
         this._friendList = null;
         this._textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._comBox.button.removeEventListener(MouseEvent.CLICK,this.__playSound);
         this._comBox.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__comChange);
         this._comBox.dispose();
         this._comBox = null;
         this._textField = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
