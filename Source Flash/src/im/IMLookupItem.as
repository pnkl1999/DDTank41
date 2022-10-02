package im
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.CMFriendInfo;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SoundManager;
   import ddt.view.common.SexIcon;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class IMLookupItem extends Sprite implements Disposeable
   {
      
      public static const OUT:int = 1;
      
      public static const OVER:int = 2;
       
      
      private var _info:Object;
      
      private var _sex_icon:SexIcon;
      
      private var _selected:Boolean;
      
      private var _bg:ScaleFrameImage;
      
      private var _name:FilterFrameText;
      
      private var _privateChatBtn:SimpleBitmapButton;
      
      private var _deleteBtn:SimpleBitmapButton;
      
      private var _addFriendBtn:BaseButton;
      
      private var _inviteBtn:BaseButton;
      
      public function IMLookupItem(param1:Object)
      {
         this._info = param1;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.IMLookupItemBg");
         this._bg.setFrame(OUT);
         addChild(this._bg);
         this._sex_icon = new SexIcon();
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("IM.IMLookup.SexPos");
         this._sex_icon.x = _loc1_.x;
         this._sex_icon.y = _loc1_.y;
         addChild(this._sex_icon);
         if(this.info is CMFriendInfo)
         {
            this._sex_icon.setSex(this._info.sex);
         }
         else
         {
            this._sex_icon.setSex(this._info.Sex);
         }
         this._name = ComponentFactory.Instance.creatComponentByStylename("IM.IMLookup.IMLookupItemName");
         if(this.info is CMFriendInfo)
         {
            this._name.text = this.info.NickName == "" ? this.info.OtherName : this.info.NickName;
         }
         else
         {
            this._name.text = this.info.NickName;
         }
         addChild(this._name);
         if(!(this.info is CMFriendInfo))
         {
            this._deleteBtn = ComponentFactory.Instance.creat("IM.LookItem.deleteBtn");
            this._deleteBtn.tipData = LanguageMgr.GetTranslation("tank.view.im.IMFriendItem.delete");
            addChild(this._deleteBtn);
            this._privateChatBtn = ComponentFactory.Instance.creat("IM.LookItem.privateChatBtn");
            this._privateChatBtn.tipData = LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private");
            addChild(this._privateChatBtn);
         }
         else if(this.info.IsExist)
         {
            this._addFriendBtn = ComponentFactory.Instance.creat("IM.IMLookupItem.addFriendBtn");
            this._addFriendBtn.tipData = LanguageMgr.GetTranslation("tank.view.im.IMFriendList.addFriend");
            addChild(this._addFriendBtn);
            this._privateChatBtn = ComponentFactory.Instance.creat("IM.LookItem.privateChatBtn");
            this._privateChatBtn.tipData = LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private");
            addChild(this._privateChatBtn);
         }
         else
         {
            this._inviteBtn = ComponentFactory.Instance.creat("IM.IMLookupItem.inviteBtn");
            this._inviteBtn.tipData = LanguageMgr.GetTranslation("im.IMView.inviteBtnText");
            addChild(this._inviteBtn);
         }
      }
      
      public function styleForJustName() : void
      {
         this._privateChatBtn.visible = false;
         this._deleteBtn.visible = false;
         this._sex_icon.visible = false;
         this._name.x = 15;
         this._bg.width = 131;
         this._bg.removeEventListener(InteractiveEvent.CLICK,this.__bgClick);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         this._bg.addEventListener(InteractiveEvent.CLICK,this.__bgClick);
         this._bg.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__privateChatClick);
         DoubleClickManager.Instance.enableDoubleClick(this._bg);
         if(this._privateChatBtn)
         {
            this._privateChatBtn.addEventListener(MouseEvent.CLICK,this.__privateChatBtnClick);
         }
         if(this._deleteBtn)
         {
            this._deleteBtn.addEventListener(MouseEvent.CLICK,this._deleteBtnClick);
         }
         if(this._inviteBtn)
         {
            this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__invite);
         }
         if(this._addFriendBtn)
         {
            this._addFriendBtn.addEventListener(MouseEvent.CLICK,this.__addFriend);
         }
      }
      
      private function __addFriend(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.addFriend(this.info.NickName);
      }
      
      private function __invite(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:InviteDialogFrame = ComponentFactory.Instance.creatComponentByStylename("InviteDialogFrame");
         _loc2_.setInfo(this._info.UserName);
         _loc2_.show();
      }
      
      private function __bgClick(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.info is PlayerInfo)
         {
            PlayerTipManager.show(this.info as PlayerInfo,localToGlobal(new Point(0,0)).y);
         }
         if(this.info is ConsortiaPlayerInfo)
         {
            PlayerTipManager.show(this.info as ConsortiaPlayerInfo,localToGlobal(new Point(0,0)).y);
         }
      }
      
      private function _deleteBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!(this.info is CMFriendInfo) && IMController.Instance.testAlikeName(this.info.NickName))
         {
            IMController.Instance.deleteRecentContacts(this.info.ID);
            return;
         }
         if(this.info is PlayerInfo)
         {
            if(PlayerManager.Instance.friendList[this.info.ID])
            {
               IMController.Instance.deleteFriend(this.info.ID);
            }
            else
            {
               IMController.Instance.deleteFriend(this.info.ID,true);
            }
            return;
         }
         if(this.info is CMFriendInfo)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMLookupItem.CMFriendInfo"));
            return;
         }
         if(this.info is ConsortiaPlayerInfo && IMController.Instance.testIdentical(this.info.ID) != -1)
         {
            IMController.Instance.deleteRecentContacts(this.info.ID);
            return;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMLookupItem.ConsortiaPlayerInfo"));
      }
      
      private function __privateChatClick(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.info is PlayerInfo || this.info is ConsortiaPlayerInfo)
         {
            ChatManager.Instance.privateChatTo(this.info.NickName,this.info.ID);
            ChatManager.Instance.setFocus();
         }
      }
      
      private function __privateChatBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.info is PlayerInfo || this.info is ConsortiaPlayerInfo)
         {
            ChatManager.Instance.privateChatTo(this.info.NickName,this.info.ID);
            ChatManager.Instance.setFocus();
         }
         else if(this.info is CMFriendInfo && this.info.IsExist)
         {
            ChatManager.Instance.privateChatTo(this.info.NickName,this.info.UserId);
            ChatManager.Instance.setFocus();
         }
      }
      
      private function __itemOut(param1:MouseEvent) : void
      {
         this._bg.setFrame(OUT);
      }
      
      private function __itemOver(param1:MouseEvent) : void
      {
         this._bg.setFrame(OVER);
      }
      
      public function get info() : Object
      {
         return this._info;
      }
      
      public function get text() : String
      {
         return this._info.NickName;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         if(this._privateChatBtn)
         {
            this._privateChatBtn.removeEventListener(MouseEvent.CLICK,this.__privateChatBtnClick);
         }
         if(this._deleteBtn)
         {
            this._deleteBtn.removeEventListener(MouseEvent.CLICK,this._deleteBtnClick);
         }
         if(this._inviteBtn)
         {
            this._inviteBtn.removeEventListener(MouseEvent.CLICK,this.__invite);
         }
         if(this._addFriendBtn)
         {
            this._addFriendBtn.removeEventListener(MouseEvent.CLICK,this.__addFriend);
         }
         if(this._deleteBtn)
         {
            this._deleteBtn.removeEventListener(MouseEvent.CLICK,this._deleteBtnClick);
         }
         this._bg.removeEventListener(InteractiveEvent.CLICK,this.__bgClick);
         this._bg.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__privateChatClick);
         DoubleClickManager.Instance.disableDoubleClick(this._bg);
         if(this._sex_icon && this._sex_icon.parent)
         {
            this._sex_icon.parent.removeChild(this._sex_icon);
            this._sex_icon.dispose();
            this._sex_icon = null;
         }
         if(this._bg && this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
            this._bg.dispose();
            this._bg = null;
         }
         if(this._name && this._name.parent)
         {
            this._name.parent.removeChild(this._name);
            this._name.dispose();
            this._name = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
