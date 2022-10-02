package email.view
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.LevelIcon;
   import email.data.EmailInfo;
   import email.data.EmailInfoOfSended;
   import email.data.EmailState;
   import email.data.EmailType;
   import email.manager.MailManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import im.IMController;
   import road7th.data.DictionaryData;
   import socialContact.friendBirthday.FriendBirthdayManager;
   
   public class ReadingView extends Frame
   {
       
      
      private var _info:EmailInfo;
      
      private var _readOnly:Boolean;
      
      private var _isCanReply:Boolean;
      
      private var _readViewBg:MovieClip;
      
      private var _prompt:Bitmap;
      
      private var _sender:FilterFrameText;
      
      private var _topic:FilterFrameText;
      
      private var _content:TextArea;
      
      private var _personalImgBg:MovieImage;
      
      private var _leftTopBtnGroup:SelectedButtonGroup;
      
      private var _emailListButton:SelectedButton;
      
      private var _noReadButton:SelectedButton;
      
      private var _sendedButton:SelectedButton;
      
      private var _leftPageBtn:BaseButton;
      
      private var _rightPageBtn:BaseButton;
      
      private var _pageTxt:FilterFrameText;
      
      private var _selectAllBtn:BaseButton;
      
      private var _deleteBtn:BaseButton;
      
      private var _reciveMailBtn:BaseButton;
      
      private var _reBack_btn:TextButton;
      
      private var _reply_btn:TextButton;
      
      private var _close_btn:TextButton;
      
      private var _write_btn:TextButton;
      
      private var _help_btn:BaseButton;
      
      private var _helpPage:Frame;
      
      private var _helpPageCloseBtn:TextButton;
      
      private var _diamonds:Array;
      
      private var _list:EmailListView;
      
      private var _diamondHBox:HBox;
      
      private var _addFriend:BaseButton;
      
      private var _titleTop:ScaleFrameImage;
      
      private var _rebackGiftBtn:BaseButton;
      
      private var _presentGiftBtn:BaseButton;
      
      private var _playerview:RoomCharacter;
      
      private var _levelIcon:LevelIcon;
      
      private var _tempInfo:PlayerInfo;
      
      private const _PRESENTGIFT:int = 16;
      
      public function ReadingView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._readViewBg = ClassUtils.CreatInstance("asset.email.readViewBg");
         PositionUtils.setPos(this._readViewBg,"readingViewBG.pos");
         addToContent(this._readViewBg);
         this.addLeftTopBtnGroup();
         this._leftPageBtn = ComponentFactory.Instance.creat("email.leftPageBtn");
         addToContent(this._leftPageBtn);
         this._leftPageBtn.enable = false;
         this._rightPageBtn = ComponentFactory.Instance.creat("email.rightPageBtn");
         addToContent(this._rightPageBtn);
         this._rightPageBtn.enable = false;
         this._pageTxt = ComponentFactory.Instance.creat("email.pageTxt");
         this._pageTxt.text = "1/1";
         addToContent(this._pageTxt);
         this._selectAllBtn = ComponentFactory.Instance.creat("email.selectAllBtn");
         addToContent(this._selectAllBtn);
         this._deleteBtn = ComponentFactory.Instance.creat("email.deleteBtn");
         addToContent(this._deleteBtn);
         this._reciveMailBtn = ComponentFactory.Instance.creat("email.reciveMailBtn");
         addToContent(this._reciveMailBtn);
         this._titleTop = ComponentFactory.Instance.creatComponentByStylename("email.titleTopAsset");
         addToContent(this._titleTop);
         this._titleTop.setFrame(1);
         this._prompt = ComponentFactory.Instance.creatBitmap("asset.email.prompt");
         addToContent(this._prompt);
         this._prompt.visible = false;
         this._sender = ComponentFactory.Instance.creat("email.senderTxt");
         this._sender.maxChars = 36;
         addToContent(this._sender);
         this._topic = ComponentFactory.Instance.creat("email.topicTxt");
         this._topic.maxChars = 22;
         addToContent(this._topic);
         this._content = ComponentFactory.Instance.creatComponentByStylename("email.content");
         addToContent(this._content);
         this._diamondHBox = ComponentFactory.Instance.creat("emial.diamondHbox");
         addToContent(this._diamondHBox);
         this._diamonds = new Array();
         for(var i:uint = 0; i < 5; i++)
         {
            this._diamonds[i] = new DiamondOfReading();
            this._diamonds[i].index = i;
            this._diamondHBox.addChild(this._diamonds[i]);
         }
         this._diamondHBox.refreshChildPos();
         this._reBack_btn = ComponentFactory.Instance.creat("email.reBackBtn");
         this._reBack_btn.text = LanguageMgr.GetTranslation("reBack_btn.label");
         addToContent(this._reBack_btn);
         this._reply_btn = ComponentFactory.Instance.creat("email.replyBtn");
         this._reply_btn.text = LanguageMgr.GetTranslation("reply_btn.label");
         addToContent(this._reply_btn);
         this._write_btn = ComponentFactory.Instance.creat("email.writeBtn");
         this._write_btn.text = LanguageMgr.GetTranslation("write_btn.label");
         addToContent(this._write_btn);
         this._close_btn = ComponentFactory.Instance.creat("email.closeBtn");
         addToContent(this._close_btn);
         this._close_btn.text = LanguageMgr.GetTranslation("cancel");
         this._help_btn = ComponentFactory.Instance.creat("email.helpPageBtn");
         addToContent(this._help_btn);
         this._list = ComponentFactory.Instance.creat("email.emailListView");
         addToContent(this._list);
         this.isCanReply = false;
         this._personalImgBg = ComponentFactory.Instance.creat("emial.personalImgBg");
         addToContent(this._personalImgBg);
         this._personalImgBg.visible = false;
         this._addFriend = ComponentFactory.Instance.creatComponentByStylename("email.addFriendBtn");
         this._addFriend.enable = false;
         addToContent(this._addFriend);
         this._rebackGiftBtn = ComponentFactory.Instance.creatComponentByStylename("email.rebackGiftBtn");
         addToContent(this._rebackGiftBtn);
         this._rebackGiftBtn.visible = false;
         this._presentGiftBtn = ComponentFactory.Instance.creatComponentByStylename("email.giveGiftBtn");
         addToContent(this._presentGiftBtn);
         this._presentGiftBtn.visible = false;
      }
      
      private function addLeftTopBtnGroup() : void
      {
         this._leftTopBtnGroup = new SelectedButtonGroup();
         this._emailListButton = ComponentFactory.Instance.creat("emailListBtn");
         this._leftTopBtnGroup.addSelectItem(this._emailListButton);
         addToContent(this._emailListButton);
         this._noReadButton = ComponentFactory.Instance.creat("noReadBtn");
         this._leftTopBtnGroup.addSelectItem(this._noReadButton);
         addToContent(this._noReadButton);
         this._sendedButton = ComponentFactory.Instance.creat("sendedBtn");
         this._leftTopBtnGroup.addSelectItem(this._sendedButton);
         addToContent(this._sendedButton);
         this._leftTopBtnGroup.selectIndex = 0;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._emailListButton.addEventListener(MouseEvent.CLICK,this.__selectMailTypeListener);
         this._noReadButton.addEventListener(MouseEvent.CLICK,this.__selectMailTypeListener);
         this._sendedButton.addEventListener(MouseEvent.CLICK,this.__selectMailTypeListener);
         this._leftPageBtn.addEventListener(MouseEvent.CLICK,this.__lastPage);
         this._rightPageBtn.addEventListener(MouseEvent.CLICK,this.__nextPage);
         this._selectAllBtn.addEventListener(MouseEvent.CLICK,this.__selectAllListener);
         this._deleteBtn.addEventListener(MouseEvent.CLICK,this.__deleteSelectListener);
         this._reciveMailBtn.addEventListener(MouseEvent.CLICK,this.__receiveExListener);
         this._reBack_btn.addEventListener(MouseEvent.CLICK,this.__backEmail);
         this._reply_btn.addEventListener(MouseEvent.CLICK,this.__reply);
         this._close_btn.addEventListener(MouseEvent.CLICK,this.__close);
         this._write_btn.addEventListener(MouseEvent.CLICK,this.__write);
         this._help_btn.addEventListener(MouseEvent.CLICK,this.__help);
         this._addFriend.addEventListener(MouseEvent.CLICK,this.__addFriend);
         this._rebackGiftBtn.addEventListener(MouseEvent.CLICK,this.__rebackGift);
         this._presentGiftBtn.addEventListener(MouseEvent.CLICK,this._clickPresent);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._emailListButton.removeEventListener(MouseEvent.CLICK,this.__selectMailTypeListener);
         this._noReadButton.removeEventListener(MouseEvent.CLICK,this.__selectMailTypeListener);
         this._sendedButton.removeEventListener(MouseEvent.CLICK,this.__selectMailTypeListener);
         this._leftPageBtn.removeEventListener(MouseEvent.CLICK,this.__lastPage);
         this._rightPageBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__nextPage);
         this._selectAllBtn.removeEventListener(MouseEvent.CLICK,this.__selectAllListener);
         this._deleteBtn.removeEventListener(MouseEvent.CLICK,this.__deleteSelectListener);
         this._reciveMailBtn.removeEventListener(MouseEvent.CLICK,this.__receiveExListener);
         this._reBack_btn.removeEventListener(MouseEvent.CLICK,this.__backEmail);
         this._reply_btn.removeEventListener(MouseEvent.CLICK,this.__reply);
         this._close_btn.removeEventListener(MouseEvent.CLICK,this.__close);
         this._write_btn.removeEventListener(MouseEvent.CLICK,this.__write);
         this._help_btn.removeEventListener(MouseEvent.CLICK,this.__help);
         this._addFriend.removeEventListener(MouseEvent.CLICK,this.__addFriend);
         this._rebackGiftBtn.removeEventListener(MouseEvent.CLICK,this.__rebackGift);
         this._presentGiftBtn.removeEventListener(MouseEvent.CLICK,this._clickPresent);
         if(this._helpPageCloseBtn)
         {
            this._helpPageCloseBtn.removeEventListener(MouseEvent.CLICK,this.__helpPageClose);
            this._helpPage.removeEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
         }
      }
      
      public function set info(value:EmailInfo) : void
      {
         this._info = value;
         if(this._info is EmailInfoOfSended)
         {
            this.updateSended();
            return;
         }
         this.update();
         if(this._info && (this._info.Type == 1 || this._info.Type == 101 || this._info.Type == 10))
         {
            IMController.Instance.saveRecentContactsID(this._info.SenderID);
         }
      }
      
      private function updateSended() : void
      {
         this._prompt.visible = false;
         var tempInfo:EmailInfoOfSended = this._info as EmailInfoOfSended;
         if(tempInfo.Type == EmailType.CONSORTION_EMAIL)
         {
            this._sender.text = LanguageMgr.GetTranslation("tank.view.common.ConsortiaIcon.self");
         }
         else
         {
            this._sender.text = !!Boolean(tempInfo) ? tempInfo.Receiver : "";
         }
         this._topic.text = !!Boolean(tempInfo) ? tempInfo.Title : "";
         this._content.text = !!Boolean(tempInfo) ? tempInfo.Content : "";
         this._content.textField.text += "\n" + tempInfo.AnnexRemark;
         this._list.updateInfo(this._info);
      }
      
      private function update() : void
      {
         var diamond:DiamondOfReading = null;
         if(this._info && (this._info.Type == 0 || this._info.Type == 6 || this._info.Type == 1 || this._info.Type == 7 || this._info.Type == 10 || this._info.Type > 100 || this._info.Type == 59))
         {
            if(this._info.Sender != PlayerManager.Instance.Self.NickName)
            {
               this._addFriend.enable = true;
            }
            this._prompt.visible = true;
         }
         else
         {
            this._prompt.visible = false;
            this._addFriend.enable = false;
         }
         this._sender.text = !!Boolean(this._info) ? this._info.Sender : "";
         this._topic.text = !!Boolean(this._info) ? this._info.Title : "";
         this._content.text = !!Boolean(this._info) ? this._info.Content : "";
         this._personalImgBg.visible = false;
         this.clearPersonalImage();
         if(this._info)
         {
            this.prepareShow();
            this._deleteBtn.enable = this._info.Type != 13;
         }
         for each(diamond in this._diamonds)
         {
            diamond.info = this._info;
         }
         this._list.updateInfo(this._info);
         this.upRebackGift();
         this._upPresentGift();
      }
      
      private function upRebackGift() : void
      {
         if(this._info)
         {
            if(this._info.MailType == 1 && this._info.Type != EmailType.GIFT_GUIDE && this._info.Type != EmailType.MYSELF_BRITHDAY)
            {
               this._rebackGiftBtn.visible = true;
               if(PlayerManager.Instance.Self.Grade >= 16)
               {
                  this._rebackGiftBtn.enable = true;
               }
               else
               {
                  this._rebackGiftBtn.enable = false;
               }
            }
            else
            {
               this._rebackGiftBtn.visible = false;
            }
         }
         else
         {
            this._rebackGiftBtn.visible = false;
         }
      }
      
      private function _upPresentGift() : void
      {
         if(this._info && this._info.MailType == 0 && this._info.Type == EmailType.FRIEND_BRITHDAY)
         {
            this._presentGiftBtn.visible = true;
         }
         else
         {
            this._presentGiftBtn.visible = false;
         }
         if(PlayerManager.Instance.Self.Grade >= this._PRESENTGIFT)
         {
            this._presentGiftBtn.enable = true;
         }
         else
         {
            this._presentGiftBtn.enable = false;
         }
      }
      
      private function clearPersonalImage() : void
      {
         this._tempInfo = null;
         if(this._playerview)
         {
            this._playerview.dispose();
            this._playerview = null;
         }
         if(this._levelIcon)
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
      }
      
      private function prepareShow() : void
      {
         this._tempInfo = PlayerManager.Instance.findPlayer(this._info.UserID,PlayerManager.Instance.Self.ZoneID);
         if(this._info.Money > 0 && this._info.UserID != PlayerManager.Instance.Self.ID && this._info.UserID != 0)
         {
            this._personalImgBg.visible = true;
            if(!PlayerManager.Instance.hasInFriendList(this._info.UserID) && !PlayerManager.Instance.hasInClubPlays(this._info.UserID) && !PlayerManager.Instance.hasInMailTempList(this._info.UserID))
            {
               SocketManager.Instance.out.sendItemEquip(this._info.UserID);
               this._tempInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.showPersonal);
               return;
            }
            this.showBegain();
         }
         else
         {
            this._personalImgBg.visible = false;
         }
      }
      
      private function showPersonal(e:PlayerPropertyEvent) : void
      {
         var tempList:DictionaryData = new DictionaryData();
         this._tempInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.showPersonal);
         tempList[this._info.UserID] = this._tempInfo;
         PlayerManager.Instance.mailTempList = tempList;
         this.showBegain();
      }
      
      private function showBegain() : void
      {
         this._tempInfo.WeaponID = int(this._tempInfo.Style.split(",")[EquipType.ARM - 1].split("|")[0]);
         this._playerview = CharactoryFactory.createCharacter(this._tempInfo,"room") as RoomCharacter;
         this._playerview.showGun = true;
         this._playerview.setShowLight(true,null);
         this._playerview.show(true,-1);
         this._playerview.stopAnimation();
         this.showComplete();
      }
      
      private function showComplete() : void
      {
         var playerviewMask:Sprite = null;
         playerviewMask = null;
         var playerviewMaskPos:Point = null;
         playerviewMask = null;
         PositionUtils.setPos(this._playerview,"email.playerviewPos");
         playerviewMask = new Sprite();
         playerviewMask.graphics.beginFill(0);
         playerviewMask.graphics.drawRect(0,0,124,140);
         playerviewMask.graphics.endFill();
         playerviewMaskPos = ComponentFactory.Instance.creatCustomObject("email.playerviewMaskPos");
         playerviewMask.x = playerviewMaskPos.x;
         playerviewMask.y = playerviewMaskPos.y;
         this._playerview.mask = playerviewMask;
         addToContent(playerviewMask);
         addToContent(this._playerview);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("email.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         this._levelIcon.setInfo(this._tempInfo.Grade,this._tempInfo.Repute,this._tempInfo.WinCount,this._tempInfo.TotalCount,this._tempInfo.FightPower,this._tempInfo.Offer,false);
         this._levelIcon.mouseEnabled = false;
         this._levelIcon.mouseChildren = false;
         this._levelIcon.buttonMode = false;
         addToContent(this._levelIcon);
      }
      
      public function setListView(array:Array, totalPage:int, currentPage:int, isSendedMail:Boolean = false) : void
      {
         this._list.update(array,isSendedMail);
         this._pageTxt.text = currentPage.toString() + "/" + totalPage.toString();
         this._leftPageBtn.enable = currentPage == 0 || currentPage == 1 ? Boolean(Boolean(Boolean(false))) : Boolean(Boolean(Boolean(true)));
         this._rightPageBtn.enable = currentPage == totalPage ? Boolean(Boolean(Boolean(false))) : Boolean(Boolean(Boolean(true)));
      }
      
      public function switchBtnsVisible(value:Boolean) : void
      {
         this._selectAllBtn.visible = value;
         this._deleteBtn.visible = value;
         this._reciveMailBtn.visible = value;
      }
      
      private function btnSound() : void
      {
         SoundManager.instance.play("043");
      }
      
      public function set readOnly(value:Boolean) : void
      {
         for(var i:uint = 0; i < 5; i++)
         {
            (this._diamonds[i] as DiamondOfReading).readOnly = value;
            (this._diamonds[i] as DiamondOfReading).visible = !value;
         }
      }
      
	  internal function set isCanReply(value:Boolean) : void
      {
         if(this._info is EmailInfoOfSended)
         {
            return;
         }
         this._reply_btn.enable = value;
         if(this._info)
         {
            if(this._info.Type > 100 && this._info.Money > 0)
            {
               this._reBack_btn.enable = true;
            }
            else
            {
               this._reBack_btn.enable = false;
            }
         }
         else
         {
            this._reBack_btn.enable = false;
         }
      }
      
      private function closeWin() : void
      {
         MailManager.Instance.hide();
      }
      
      public function personalHide() : void
      {
      }
      
      private function createHelpPage() : void
      {
         this._helpPage = ComponentFactory.Instance.creat("email.helpPageFrame");
         this._helpPage.escEnable = true;
         this._helpPage.titleText = LanguageMgr.GetTranslation("tank.view.emailII.ReadingView.useHelp");
         LayerManager.Instance.addToLayer(this._helpPage,LayerManager.GAME_TOP_LAYER,true);
         this._helpPageCloseBtn = ComponentFactory.Instance.creat("email.helpPageCloseBtn");
         this._helpPageCloseBtn.text = LanguageMgr.GetTranslation("close");
         this._helpPage.addToContent(this._helpPageCloseBtn);
         this._helpPageCloseBtn.addEventListener(MouseEvent.CLICK,this.__helpPageClose);
         var word:Bitmap = ComponentFactory.Instance.creatBitmap("asset.email.helpPageWord");
         this._helpPage.addToContent(word);
         this._helpPage.visible = false;
         this._helpPage.addEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
      }
      
      private function __helpResponseHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this._helpPage.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(this._readViewBg)
         {
            ObjectUtils.disposeObject(this._readViewBg);
         }
         this._readViewBg = null;
         if(this._prompt)
         {
            ObjectUtils.disposeObject(this._prompt);
         }
         this._prompt = null;
         if(this._sender)
         {
            ObjectUtils.disposeObject(this._sender);
         }
         this._sender = null;
         if(this._topic)
         {
            ObjectUtils.disposeObject(this._topic);
         }
         this._topic = null;
         if(this._personalImgBg)
         {
            ObjectUtils.disposeObject(this._personalImgBg);
         }
         this._personalImgBg = null;
         if(this._leftTopBtnGroup)
         {
            ObjectUtils.disposeObject(this._leftTopBtnGroup);
         }
         this._leftTopBtnGroup = null;
         if(this._emailListButton)
         {
            ObjectUtils.disposeObject(this._emailListButton);
         }
         this._emailListButton = null;
         if(this._noReadButton)
         {
            ObjectUtils.disposeObject(this._noReadButton);
         }
         this._noReadButton = null;
         if(this._sendedButton)
         {
            ObjectUtils.disposeObject(this._sendedButton);
         }
         this._sendedButton = null;
         if(this._leftPageBtn)
         {
            ObjectUtils.disposeObject(this._leftPageBtn);
         }
         this._leftPageBtn = null;
         if(this._rightPageBtn)
         {
            ObjectUtils.disposeObject(this._rightPageBtn);
         }
         this._rightPageBtn = null;
         if(this._pageTxt)
         {
            ObjectUtils.disposeObject(this._pageTxt);
         }
         this._pageTxt = null;
         if(this._selectAllBtn)
         {
            ObjectUtils.disposeObject(this._selectAllBtn);
         }
         this._selectAllBtn = null;
         if(this._deleteBtn)
         {
            ObjectUtils.disposeObject(this._deleteBtn);
         }
         this._deleteBtn = null;
         if(this._reciveMailBtn)
         {
            ObjectUtils.disposeObject(this._reciveMailBtn);
         }
         this._reciveMailBtn = null;
         if(this._reBack_btn)
         {
            ObjectUtils.disposeObject(this._reBack_btn);
         }
         this._reBack_btn = null;
         if(this._reply_btn)
         {
            ObjectUtils.disposeObject(this._reply_btn);
         }
         this._reply_btn = null;
         if(this._close_btn)
         {
            ObjectUtils.disposeObject(this._close_btn);
         }
         this._close_btn = null;
         if(this._write_btn)
         {
            ObjectUtils.disposeObject(this._write_btn);
         }
         this._write_btn = null;
         if(this._help_btn)
         {
            ObjectUtils.disposeObject(this._help_btn);
         }
         this._help_btn = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._diamondHBox)
         {
            ObjectUtils.disposeObject(this._diamondHBox);
         }
         this._diamondHBox = null;
         if(this._titleTop)
         {
            ObjectUtils.disposeObject(this._titleTop);
         }
         this._titleTop = null;
         if(this._rebackGiftBtn)
         {
            ObjectUtils.disposeObject(this._rebackGiftBtn);
         }
         this._rebackGiftBtn = null;
         if(this._presentGiftBtn)
         {
            ObjectUtils.disposeObject(this._presentGiftBtn);
         }
         this._presentGiftBtn = null;
         if(this._addFriend)
         {
            ObjectUtils.disposeObject(this._addFriend);
         }
         this._addFriend = null;
         this._info = null;
         this._diamonds = null;
         this.helpPageDispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function helpPageDispose() : void
      {
         if(this._helpPage)
         {
            if(this._helpPageCloseBtn)
            {
               ObjectUtils.disposeObject(this._helpPageCloseBtn);
            }
            this._helpPageCloseBtn = null;
            this._helpPage.dispose();
            if(this._helpPage && this._helpPage.parent)
            {
               this._helpPage.parent.removeChild(this._helpPage);
            }
            this._helpPage = null;
         }
      }
      
      private function __selectMailTypeListener(e:MouseEvent) : void
      {
         this._personalImgBg.visible = false;
         this.btnSound();
         if(e.currentTarget == this._emailListButton)
         {
            this._titleTop.setFrame(1);
            MailManager.Instance.changeType(EmailState.ALL);
         }
         else if(e.currentTarget == this._noReadButton)
         {
            this._titleTop.setFrame(1);
            MailManager.Instance.changeType(EmailState.NOREAD);
         }
         else
         {
            this._titleTop.setFrame(2);
            MailManager.Instance.changeType(EmailState.SENDED);
         }
      }
      
      private function __lastPage(event:MouseEvent) : void
      {
         SoundManager.instance.play("045");
         MailManager.Instance.setPage(true,this._list.canChangePage());
         MailManager.Instance.changeSelected(null);
      }
      
      private function __nextPage(event:MouseEvent) : void
      {
         SoundManager.instance.play("045");
         MailManager.Instance.setPage(false,this._list.canChangePage());
         MailManager.Instance.changeSelected(null);
      }
      
      private function __selectAllListener(e:MouseEvent) : void
      {
         this.btnSound();
         this._list.switchSeleted();
      }
      
      private function __deleteSelectListener(e:MouseEvent) : void
      {
         var i:int = 0;
         var alertFrame:BaseAlerFrame = null;
         this.btnSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var arr:Array = this._list.getSelectedMails();
         if(arr.length > 0)
         {
            for(i = 0; i < arr.length; i++)
            {
               if(arr[i].hasAnnexs() || arr[i].Money != 0)
               {
                  alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.delectEmail"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  alertFrame.addEventListener(FrameEvent.RESPONSE,this.__simpleAlertResponse);
                  KeyboardShortcutsManager.Instance.prohibitNewHandMail(false);
                  break;
               }
               if(i == arr.length - 1)
               {
                  this.ok();
               }
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.ReadingView.deleteSelectListener"));
         }
      }
      
      private function __simpleAlertResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__simpleAlertResponse);
         ObjectUtils.disposeObject(frame);
         if(frame.parent)
         {
            frame.parent.removeChild(frame);
         }
         if(event.responseCode == FrameEvent.CANCEL_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK)
         {
            this.cancel();
         }
         else if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.ok();
         }
         KeyboardShortcutsManager.Instance.prohibitNewHandMail(true);
      }
      
      private function cancel() : void
      {
         this.btnSound();
      }
      
      private function ok() : void
      {
         this.btnSound();
         this._personalImgBg.visible = false;
         var arr:Array = this._list.getSelectedMails();
         for(var i:uint = 0; i < arr.length; i++)
         {
            MailManager.Instance.deleteEmail(arr[i]);
            MailManager.Instance.removeMail(arr[i]);
            MailManager.Instance.changeSelected(null);
         }
      }
      
      private function __receiveExListener(e:MouseEvent) : void
      {
         var i:uint = 0;
         var emailInfo:EmailInfo = null;
         var str:String = null;
         var startTime:Date = null;
         var str2:String = null;
         var startTime2:Date = null;
         this.btnSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var arr:Array = this._list.getSelectedMails();
         if(arr.length > 0 || this._info)
         {
            if(arr.length > 0)
            {
               for(i = 0; i < arr.length; i++)
               {
                  if(!((arr[i] as EmailInfo).Type > 100 && (arr[i] as EmailInfo).Money > 0))
                  {
                     emailInfo = arr[i] as EmailInfo;
                     if(!emailInfo.IsRead)
                     {
                        str = emailInfo.SendTime;
                        startTime = new Date(Number(str.substr(0,4)),Number(str.substr(5,2)) - 1,Number(str.substr(8,2)),Number(str.substr(11,2)),Number(str.substr(14,2)),Number(str.substr(17,2)));
                        emailInfo.ValidDate = 72 + (TimeManager.Instance.Now().time - startTime.time) / (60 * 60 * 1000);
                     }
                     MailManager.Instance.getAnnexToBag(arr[i],0);
                  }
               }
            }
            if(this._info)
            {
               if(this._info.Type > 100 && this._info.Money > 0)
               {
                  if(this._info.Money > 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.email.readingEmail.payEmail"));
                  }
                  return;
               }
               if(!this._info.IsRead)
               {
                  str2 = this._info.SendTime;
                  startTime2 = new Date(Number(str2.substr(0,4)),Number(str2.substr(5,2)) - 1,Number(str2.substr(8,2)),Number(str2.substr(11,2)),Number(str2.substr(14,2)),Number(str2.substr(17,2)));
                  this._info.ValidDate = 72 + (TimeManager.Instance.Now().time - startTime2.time) / (60 * 60 * 1000);
               }
               MailManager.Instance.getAnnexToBag(this._info,0);
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.ReadingView.deleteSelectListener"));
         }
      }
      
      private function __backEmail(e:MouseEvent) : void
      {
         this.btnSound();
         MailManager.Instance.untreadEmail(this._info.ID);
      }
      
      private function __reply(event:MouseEvent) : void
      {
         this.btnSound();
         MailManager.Instance.changeState(EmailState.REPLY);
      }
      
      private function __close(event:MouseEvent) : void
      {
         this.btnSound();
         this.closeWin();
      }
      
      private function __write(event:MouseEvent) : void
      {
         this.btnSound();
         if(this._helpPage)
         {
            this._helpPage.visible = false;
         }
         MailManager.Instance.changeState(EmailState.WRITE);
      }
      
      private function __addFriend(event:MouseEvent) : void
      {
         if(this._info)
         {
            IMController.Instance.addFriend(this._info.Sender);
         }
         SoundManager.instance.play("008");
      }
      
      private function __help(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         if(!this._helpPage)
         {
            this.createHelpPage();
         }
         StageReferance.stage.focus = this._helpPage;
         this._helpPage.visible = !!this._helpPage.visible ? Boolean(Boolean(Boolean(false))) : Boolean(Boolean(Boolean(true)));
      }
      
      private function __helpPageClose(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpPage.visible = false;
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK)
         {
            this.btnSound();
            this.closeWin();
         }
      }
      
      protected function __rebackGift(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         SoundManager.instance.play("008");
         BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW,this._sender.text);
         MailManager.Instance.hide();
      }
      
      private function _clickPresent(e:MouseEvent) : void
      {
         var str:String = this._info.Content;
         str = str.substring(str.search(/\[/) + 1,str.search("]"));
         FriendBirthdayManager.Instance.friendName = str;
         e.stopImmediatePropagation();
         SoundManager.instance.play("008");
         BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW,str);
         MailManager.Instance.hide();
      }
   }
}
