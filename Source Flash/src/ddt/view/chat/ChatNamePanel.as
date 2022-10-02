package ddt.view.chat
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Image;
   import ddt.manager.ChatManager;
   import flash.events.MouseEvent;
   import im.IMController;
   
   public class ChatNamePanel extends ChatBasePanel
   {
       
      
      public var playerName:String;
      
      private var _bg:Image;
      
      private var _blackListBtn:IconButton;
      
      private var _viewInfoBtn:IconButton;
      
      private var _addFriendBtn:IconButton;
      
      private var _privateChat:IconButton;
      
      private var _btnContainer:VBox;
      
      public function ChatNamePanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         this._btnContainer = ComponentFactory.Instance.creatComponentByStylename("chat.NamePanelList");
         this._blackListBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemBlackList");
         this._viewInfoBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemInfo");
         this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemMakeFriend");
         this._privateChat = ComponentFactory.Instance.creatComponentByStylename("chat.ItemPrivateChat");
         this._bg.width = 110;
         this._bg.height = 90;
         addChild(this._bg);
         addChild(this._btnContainer);
         this._btnContainer.addChild(this._blackListBtn);
         this._btnContainer.addChild(this._viewInfoBtn);
         this._btnContainer.addChild(this._addFriendBtn);
         this._btnContainer.addChild(this._privateChat);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._blackListBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._viewInfoBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._addFriendBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._privateChat.addEventListener(MouseEvent.CLICK,this.__onBtnClicked);
      }
      
      public function get getHeight() : int
      {
         return this._bg.height;
      }
      
      private function __onBtnClicked(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this._blackListBtn:
               IMController.Instance.addBlackList(this.playerName);
               break;
            case this._viewInfoBtn:
               PlayerInfoViewControl.viewByNickName(this.playerName);
               PlayerInfoViewControl.isOpenFromBag = false;
               break;
            case this._addFriendBtn:
               IMController.Instance.addFriend(this.playerName);
               break;
            case this._privateChat:
               ChatManager.Instance.privateChatTo(this.playerName);
         }
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._blackListBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._viewInfoBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._addFriendBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._privateChat.removeEventListener(MouseEvent.CLICK,this.__onBtnClicked);
      }
   }
}
