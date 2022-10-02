package im
{
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.CMFriendInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.DesktopManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.LoaderContext;
   import road7th.utils.StringHelper;
   
   public class CMFriendItem extends Sprite implements Disposeable
   {
       
      
      private var _info:CMFriendInfo;
      
      private var _bg:ScaleFrameImage;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _nameText:FilterFrameText;
      
      private var _CMNameText:FilterFrameText;
      
      private var _iconBg:Bitmap;
      
      private var _iconLight:Bitmap;
      
      private var _loader:DisplayLoader;
      
      private var _icon:Bitmap;
      
      private var _iconSprite:Sprite;
      
      private var _isSelected:Boolean;
      
      private var _privateChatBtn:BaseButton;
      
      private var _addFriendBtn:BaseButton;
      
      private var _inviteBtn:BaseButton;
      
      private var _load:Loader;
      
      private var _loaderContext:LoaderContext;
      
      public function CMFriendItem()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc1_:Point = null;
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,235,44);
         this.graphics.endFill();
         this.buttonMode = true;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("im.item.CMFriendListBG");
         this._bg.setFrame(1);
         addChild(this._bg);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("IM.CMFriendListItem.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         this._levelIcon.setInfo(15,20,20,20,20,20,false);
         this._sexIcon = new SexIcon();
         _loc1_ = ComponentFactory.Instance.creatCustomObject("IM.CMFriendListItem.sexIconPos");
         this._sexIcon.x = _loc1_.x;
         this._sexIcon.y = _loc1_.y;
         addChild(this._sexIcon);
         this._loaderContext = new LoaderContext(true);
         this._CMNameText = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendListItem.name");
         addChild(this._CMNameText);
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("IM.CMFriendListItem.CMname");
         addChild(this._nameText);
         this._iconBg = ComponentFactory.Instance.creatBitmap("asset.IM.Noname");
         addChild(this._iconBg);
         this._iconLight = ComponentFactory.Instance.creatBitmap("asset.IM.iconLight");
         addChild(this._iconLight);
         this._iconSprite = new Sprite();
         this._iconSprite.graphics.beginFill(0,0);
         this._iconSprite.graphics.drawRect(this._iconBg.x,this._iconBg.y,this._iconBg.width,this._iconBg.height);
         this._iconSprite.graphics.endFill();
         addChild(this._iconSprite);
         this._privateChatBtn = ComponentFactory.Instance.creat("IM.CMFriendListItem.privateChatBtn");
         this._privateChatBtn.tipData = LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private");
         this._privateChatBtn.visible = false;
         addChild(this._privateChatBtn);
         this._addFriendBtn = ComponentFactory.Instance.creat("IM.CMFriendListItem.addFriendBtn");
         this._addFriendBtn.tipData = LanguageMgr.GetTranslation("tank.view.im.IMFriendList.addFriend");
         this._addFriendBtn.visible = false;
         addChild(this._addFriendBtn);
         this._inviteBtn = ComponentFactory.Instance.creat("IM.CMFriendListItem.inviteBtn");
         this._inviteBtn.tipData = LanguageMgr.GetTranslation("im.IMView.inviteBtnText");
         this._inviteBtn.visible = false;
         addChild(this._inviteBtn);
         this._load = new Loader();
         this._load.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__loadCompleteHandler);
         this._load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.__loadIoErrorHandler);
      }
      
      private function __loadIoErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      private function __loadCompleteHandler(param1:Event) : void
      {
         ObjectUtils.disposeObject(this._icon);
         if(!this._load.content)
         {
            return;
         }
         this._icon = this._load.content as Bitmap;
         this._icon.scaleX = 35 / this._icon.width;
         this._icon.scaleY = 35 / this._icon.height;
         this._icon.x = this._iconBg.x;
         this._icon.y = this._iconBg.y;
         addChild(this._icon);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function loadIcon() : void
      {
         var _loc1_:URLRequest = new URLRequest(this._info.Photo);
         this._load.load(_loc1_,this._loaderContext);
      }
      
      private function __complete(param1:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         var _loc2_:DisplayLoader = param1.target as DisplayLoader;
         ObjectUtils.disposeObject(this._icon);
         if(_loc2_.isSuccess)
         {
            this._icon = _loc2_.content as Bitmap;
            this._icon.scaleX = 35 / this._icon.width;
            this._icon.scaleY = 35 / this._icon.height;
            this._icon.x = this._iconBg.x;
            this._icon.y = this._iconBg.y;
            addChild(this._icon);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function initEvent() : void
      {
         this._privateChatBtn.addEventListener(MouseEvent.CLICK,this.__privateChat);
         this._addFriendBtn.addEventListener(MouseEvent.CLICK,this.__addFriend);
         this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__invite);
         if(PathManager.CommnuntyMicroBlog() && PathManager.CommnuntySinaSecondMicroBlog())
         {
            this._iconSprite.addEventListener(MouseEvent.CLICK,this._iconClick);
         }
      }
      
      private function __invite(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:InviteDialogFrame = ComponentFactory.Instance.creatComponentByStylename("InviteDialogFrame");
         _loc2_.setInfo(this._info.UserName);
         _loc2_.show();
      }
      
      private function __addFriend(param1:MouseEvent) : void
      {
         IMController.Instance.addFriend(this._info.NickName);
      }
      
      private function __privateChat(param1:MouseEvent) : void
      {
         ChatManager.Instance.privateChatTo(this._info.NickName);
      }
      
      private function _iconClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(!(PathManager.CommnuntyMicroBlog() && PathManager.CommnuntySinaSecondMicroBlog()))
         {
            return;
         }
         SoundManager.instance.play("008");
         dispatchEvent(new Event(Event.CHANGE));
         if(StringHelper.isNullOrEmpty(this._info.PersonWeb))
         {
            return;
         }
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            _loc2_ = "function redict () {window.open(\"" + this._info.PersonWeb + "\", \"_blank\")}";
            ExternalInterface.call(_loc2_);
         }
         else
         {
            navigateToURL(new URLRequest(encodeURI(this._info.PersonWeb)),"_blank");
         }
      }
      
      private function __itemOver(param1:MouseEvent) : void
      {
         this._bg.setFrame(2);
         if(this._info && this._info.IsExist)
         {
            this._privateChatBtn.visible = true;
            this._addFriendBtn.visible = true;
            this._inviteBtn.visible = false;
         }
         else
         {
            this._privateChatBtn.visible = false;
            this._addFriendBtn.visible = false;
            if(PathManager.CommunityFriendInvitedSwitch())
            {
               this._inviteBtn.visible = true;
            }
            else
            {
               this._inviteBtn.visible = false;
            }
         }
      }
      
      private function __itemOut(param1:MouseEvent) : void
      {
         if(this._info && !this._info.isSelected)
         {
            this._bg.setFrame(1);
         }
         this._privateChatBtn.visible = false;
         this._addFriendBtn.visible = false;
         this._inviteBtn.visible = false;
      }
      
      public function itemOver() : void
      {
         this._bg.setFrame(2);
         if(this._info && this._info.IsExist)
         {
            this._privateChatBtn.visible = true;
            this._addFriendBtn.visible = true;
            this._inviteBtn.visible = false;
         }
         else
         {
            this._privateChatBtn.visible = false;
            this._addFriendBtn.visible = false;
            if(PathManager.CommunityFriendInvitedSwitch())
            {
               this._inviteBtn.visible = true;
            }
            else
            {
               this._inviteBtn.visible = false;
            }
         }
      }
      
      public function itemOut() : void
      {
         if(this._info && !this._info.isSelected)
         {
            this._bg.setFrame(1);
         }
         this._privateChatBtn.visible = false;
         this._addFriendBtn.visible = false;
         this._inviteBtn.visible = false;
      }
      
      private function update() : void
      {
         if(this._info && this._info.IsExist)
         {
            this._sexIcon.visible = this._levelIcon.visible = this._nameText.visible = this._CMNameText.visible = true;
            this._nameText.text = this._info.NickName;
            this._CMNameText.text = this._info.OtherName;
            this._CMNameText.y = 2;
            this._levelIcon.setInfo(this._info.level,0,0,0,0,0,false);
            this._sexIcon.setSex(this._info.sex);
         }
         else
         {
            this._sexIcon.visible = this._levelIcon.visible = this._nameText.visible = false;
            this._CMNameText.text = this._info.OtherName;
            this._CMNameText.y = 15;
         }
         this.loadIcon();
         if(this._info && this._info.isSelected)
         {
            this._bg.setFrame(2);
         }
         else
         {
            this._bg.setFrame(1);
         }
      }
      
      public function set info(param1:CMFriendInfo) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function get info() : CMFriendInfo
      {
         return this._info;
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         this._privateChatBtn.removeEventListener(MouseEvent.CLICK,this.__privateChat);
         this._addFriendBtn.removeEventListener(MouseEvent.CLICK,this.__addFriend);
         this._inviteBtn.removeEventListener(MouseEvent.CLICK,this.__invite);
         if(this._load && this._load.contentLoaderInfo)
         {
            this._load.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.__loadCompleteHandler);
            this._load.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.__loadIoErrorHandler);
         }
         this._load = null;
         this._loaderContext = null;
         if(this._addFriendBtn)
         {
            this._addFriendBtn.dispose();
            this._addFriendBtn = null;
         }
         if(this._privateChatBtn)
         {
            this._privateChatBtn.dispose();
            this._privateChatBtn = null;
         }
         if(this._inviteBtn)
         {
            this._inviteBtn.dispose();
            this._inviteBtn = null;
         }
         if(this._bg && this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
            this._bg.dispose();
            this._bg = null;
         }
         if(this._levelIcon && this._levelIcon.parent)
         {
            this._levelIcon.parent.removeChild(this._levelIcon);
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(this._sexIcon && this._sexIcon.parent)
         {
            this._sexIcon.parent.removeChild(this._sexIcon);
            this._sexIcon.dispose();
            this._sexIcon = null;
         }
         if(this._nameText && this._nameText.parent)
         {
            this._nameText.parent.removeChild(this._nameText);
            this._nameText.dispose();
            this._nameText = null;
         }
         if(this._CMNameText && this._CMNameText.parent)
         {
            this._CMNameText.parent.removeChild(this._CMNameText);
            this._CMNameText.dispose();
            this._CMNameText = null;
         }
         if(this._iconBg && this._iconBg.bitmapData)
         {
            this._iconBg.bitmapData.dispose();
            this._iconBg = null;
         }
         if(this._iconLight && this._iconLight.bitmapData)
         {
            this._iconLight.bitmapData.dispose();
            this._iconLight = null;
         }
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         this._loader = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
