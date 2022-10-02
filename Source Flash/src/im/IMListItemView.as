package im
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.events.CellEvent;
   import ddt.interfaces.IAcceptDrag;
   import ddt.interfaces.IDragable;
   import ddt.manager.ChatManager;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import im.info.CustomInfo;
   import vip.VipController;
   
   public class IMListItemView extends Sprite implements IListCell, Disposeable, IDragable, IAcceptDrag
   {
      
      public static var MAX_CHAR:int = 7;
      
      public static const FRIEND_ITEM:int = 0;
      
      public static const TITLE_ITEM:int = 1;
       
      
      private var _titleBG:ScaleFrameImage;
      
      private var _friendBG:ScaleFrameImage;
      
      private var _triangle:ScaleFrameImage;
      
      private var _state:ScaleFrameImage;
      
      private var _isSelected:Boolean;
      
      private var _type:int;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexMoive:MovieClip;
      
      private var _sexIcon:SexIcon;
      
      private var _masterIcon:ScaleFrameImage;
      
      private var _nameText:FilterFrameText;
      
      private var _titleText:FilterFrameText;
      
      private var _numText:FilterFrameText;
      
      private var _info:FriendListPlayer;
      
      private var _myColorMatrix_filter:ColorMatrixFilter;
      
      private var _privateChatBtn:SimpleBitmapButton;
      
      private var _snsInviteBtn:SimpleBitmapButton;
      
      private var _deleteBtn:SimpleBitmapButton;
      
      private var _vipName:GradientText;
      
      private var _colorMatrixSp:Sprite;
      
      private var _CMFIcon:Image;
      
      private var _iconBitmap:Bitmap;
      
      private var _stateoldx:int;
      
      private var _city:ScaleFrameImage;
      
      private var _customInput:TextInput;
      
      private var _hasDouble:Boolean = false;
      
      public function IMListItemView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._myColorMatrix_filter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
         this._colorMatrixSp = new Sprite();
         this._titleBG = ComponentFactory.Instance.creat("IM.item.titleItemBg");
         this._titleBG.setFrame(1);
         addChild(this._titleBG);
         this._triangle = ComponentFactory.Instance.creat("IM.item.triangle");
         this._triangle.setFrame(1);
         addChild(this._triangle);
         addChild(this._colorMatrixSp);
         this._titleText = ComponentFactory.Instance.creat("IM.item.title");
         this._titleText.text = "";
         this._colorMatrixSp.addChild(this._titleText);
         this._numText = ComponentFactory.Instance.creat("IM.item.title");
         this._numText.text = "";
         this._numText.x = this._titleText.x + this._titleText.width;
         this._colorMatrixSp.addChild(this._numText);
         this._friendBG = ComponentFactory.Instance.creat("IM.item.FriendItemBg");
         this._friendBG.setFrame(1);
         this._colorMatrixSp.addChild(this._friendBG);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("IM.item.levelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         this._colorMatrixSp.addChild(this._levelIcon);
         this._sexMoive = ClassUtils.CreatInstance("asset.IM.sexMoive") as MovieClip;
         this._colorMatrixSp.addChild(this._sexMoive);
         PositionUtils.setPos(this._sexMoive,"IM.IMListPlayerItemCell.sexIconPos");
         this._sexIcon = new SexIcon(false);
         this._sexMoive.content.addChild(this._sexIcon);
         this._masterIcon = ComponentFactory.Instance.creatComponentByStylename("core.im.masterRelationIcon");
         this._masterIcon.visible = false;
         this._sexMoive.content.addChild(this._masterIcon);
         this._city = ComponentFactory.Instance.creatComponentByStylename("core.im.CityIcon");
         this._sexMoive.content.addChild(this._city);
         this._sexMoive.gotoAndStop(1);
         this._nameText = ComponentFactory.Instance.creat("IM.item.name");
         this._nameText.text = "";
         this._privateChatBtn = ComponentFactory.Instance.creat("IM.friendItem.privateChatBtn");
         this._privateChatBtn.tipData = LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private");
         this._privateChatBtn.visible = false;
         this._colorMatrixSp.addChild(this._privateChatBtn);
         this._snsInviteBtn = ComponentFactory.Instance.creatComponentByStylename("IM.friendItem.snsInviteBtn");
         this._snsInviteBtn.tipData = LanguageMgr.GetTranslation("ddt.view.SnsFrame.snsInviteBtnTipData");
         this._snsInviteBtn.visible = false;
         addChild(this._snsInviteBtn);
         this._deleteBtn = ComponentFactory.Instance.creat("IM.friendItem.deleteBtn");
         this._deleteBtn.tipData = LanguageMgr.GetTranslation("tank.view.im.IMFriendItem.delete");
         this._deleteBtn.visible = false;
         addChild(this._deleteBtn);
         this._state = ComponentFactory.Instance.creat("IM.item.FriendState");
         this._state.setFrame(1);
         this._stateoldx = this._state.x;
         addChild(this._state);
         if(PathManager.CommunityExist() && IMController.Instance.icon && IMController.Instance.icon.bitmapData)
         {
            this._iconBitmap = new Bitmap(IMController.Instance.icon.bitmapData);
            this._CMFIcon = new Image();
            this._CMFIcon.addChild(this._iconBitmap);
            this._CMFIcon.tipStyle = "ddt.view.tips.OneLineTip";
            this._CMFIcon.tipDirctions = "0,4,5";
            this._CMFIcon.tipData = LanguageMgr.GetTranslation("community");
            PositionUtils.setPos(this._CMFIcon,"IM.friendItem.CMFIconPos");
            addChild(this._CMFIcon);
            this._CMFIcon.visible = false;
         }
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         this._privateChatBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__privateChatBtnClick);
         this._snsInviteBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__snsInviteBtnClick);
         this._deleteBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__deleteBtnClick);
         addEventListener(InteractiveEvent.CLICK,this.__itemClick);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickhandler);
         IMController.Instance.addEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewMessage);
         IMController.Instance.addEventListener(IMController.ALERT_MESSAGE,this.__alertMessage);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__itemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__itemOut);
         removeEventListener(InteractiveEvent.CLICK,this.__itemClick);
         this._privateChatBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__privateChatBtnClick);
         this._snsInviteBtn.removeEventListener(MouseEvent.CLICK,this.__snsInviteBtnClick);
         this._deleteBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__deleteBtnClick);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickhandler);
         IMController.Instance.removeEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewMessage);
         IMController.Instance.removeEventListener(IMController.ALERT_MESSAGE,this.__alertMessage);
      }
      
      protected function __alertMessage(param1:Event) : void
      {
         if(this._info && this._info.type == 1 && this._info.ID == IMController.Instance.changeID)
         {
            this._sexMoive.gotoAndStop(1);
         }
      }
      
      protected function __hasNewMessage(param1:Event) : void
      {
         if(this._info && this._info.type == 1 && this._info.ID == IMController.Instance.changeID)
         {
            this._sexMoive.gotoAndPlay(1);
         }
      }
      
      protected function __doubleClickhandler(param1:InteractiveEvent) : void
      {
         if(this._info.type == 0 && this._info.titleType >= 10)
         {
            this.createCustomInput();
            this._hasDouble = true;
         }
         if(this._info.type == 1 && this._info.Relation != 1)
         {
            IMController.Instance.alertPrivateFrame(this._info.ID);
         }
      }
      
      protected function __customInputHandler(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      private function __deleteBtnClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(this._info.type == 0)
         {
            IMController.Instance.deleteGroup(this._info.titleType,this._info.titleText);
         }
         else if(IMController.Instance.titleType != 1 && IMController.Instance.titleType != 2)
         {
            IMController.Instance.deleteFriend(this._info.ID);
         }
         else if(IMController.Instance.titleType == 1)
         {
            IMController.Instance.deleteFriend(this._info.ID,true);
         }
         else
         {
            IMController.Instance.deleteRecentContacts(this._info.ID);
         }
      }
      
      private function __privateChatBtnClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         ChatManager.Instance.privateChatTo(this._info.NickName,this._info.ID,this._info);
         ChatManager.Instance.setFocus();
      }
      
      protected function __snsInviteBtnClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         var _loc2_:InviteDialogFrame = ComponentFactory.Instance.creatComponentByStylename("InviteDialogFrame");
         _loc2_.setInfo(this._info.UserName);
         var _loc3_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.view.SnsFrame.snsInviteBtnTipData"));
         _loc3_.showCancel = false;
         _loc2_.info = _loc3_;
         _loc2_.setText(LanguageMgr.GetTranslation("ddt.view.SnsFrame.inputTextText"));
         _loc2_.show();
      }
      
      private function __itemClick(param1:InteractiveEvent) : void
      {
         if(!(param1.target is SimpleBitmapButton) && this._info.type == 1 && this._info.Relation != 1)
         {
            SoundManager.instance.play("008");
            PlayerTipManager.show(this._info,localToGlobal(new Point(0,0)).y);
            this._deleteBtn.visible = false;
            this._privateChatBtn.visible = false;
            this._snsInviteBtn.visible = false;
            if(this._CMFIcon)
            {
               this._CMFIcon.visible = false;
            }
         }
         if(this._info.titleType == 3)
         {
            this._triangle.visible = false;
            this._numText.visible = false;
            this._titleText.visible = false;
            this.createCustomInput();
         }
      }
      
      private function createCustomInput() : void
      {
         if(this._customInput == null)
         {
            this._customInput = ComponentFactory.Instance.creatComponentByStylename("IM.item.customInput");
            this._customInput.maxChars = MAX_CHAR;
            addChild(this._customInput);
            this._customInput.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
            this._customInput.addEventListener(MouseEvent.CLICK,this.__customInputHandler);
            this._customInput.addEventListener(FocusEvent.FOCUS_OUT,this.__fucksOutHandler);
         }
         this._customInput.setFocus();
      }
      
      private function __itemOver(param1:MouseEvent) : void
      {
         if(!this._info.titleIsSelected)
         {
            this._titleBG.setFrame(2);
            this._friendBG.setFrame(2);
         }
         if(this._info.type == 1)
         {
            this._deleteBtn.visible = true;
            if(this._info.Relation == 1)
            {
               this._privateChatBtn.visible = false;
               this._snsInviteBtn.visible = false;
            }
            else if(PathManager.CommunityExist())
            {
               if(this._info.playerState.StateID == 0 && this._info.type != 0)
               {
                  this._privateChatBtn.visible = false;
                  if(PathManager.CommunityFriendInvitedOnlineSwitch())
                  {
                     this._snsInviteBtn.visible = true;
                  }
                  else
                  {
                     this._snsInviteBtn.visible = false;
                  }
               }
               else
               {
                  if(!this._state.visible)
                  {
                     this._privateChatBtn.visible = true;
                  }
                  this._snsInviteBtn.visible = false;
               }
               if(this._CMFIcon && this._info.BBSFriends && this._state.visible)
               {
                  this._CMFIcon.visible = true;
               }
            }
            else if(!this._state.visible)
            {
               this._privateChatBtn.visible = true;
            }
         }
         else if(this._info.type == 0)
         {
            if(this._info.titleType >= 10)
            {
               this._deleteBtn.visible = true;
            }
         }
      }
      
      private function __itemOut(param1:MouseEvent) : void
      {
         if(!this._info.titleIsSelected)
         {
            this._titleBG.setFrame(1);
            this._friendBG.setFrame(1);
         }
         this._deleteBtn.visible = false;
         this._privateChatBtn.visible = false;
         this._snsInviteBtn.visible = false;
         if(this._CMFIcon && this._info.BBSFriends)
         {
            this._CMFIcon.visible = false;
         }
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      private function update() : void
      {
         this.clearCustomInput();
         if(this._info.type == 0)
         {
            this.updateTilte();
         }
         else if(this._info.type == 1)
         {
            this.updateItem();
         }
         else
         {
            this.updateBtn();
         }
         this.updateItemState();
      }
      
      private function updateTilte() : void
      {
         DisplayUtils.removeDisplay(this._nameText,this._vipName);
         PositionUtils.setPos(this._deleteBtn,"ListItemView.titleDeletePos");
         this._sexMoive.visible = false;
         this._sexMoive.gotoAndStop(1);
         this._titleText.visible = this._numText.visible = this._triangle.visible = true;
         this._state.visible = this._friendBG.visible = this._levelIcon.visible = this._sexIcon.visible = false;
         this._privateChatBtn.visible = this._city.visible = false;
         this._deleteBtn.visible = this._snsInviteBtn.visible = this._masterIcon.visible = false;
         this._titleBG.visible = true;
         this._titleBG.setFrame(!!this._info.titleIsSelected ? int(int(1)) : int(int(3)));
         this._titleText.x = 20;
         this._titleText.text = this._info.titleText;
         this._numText.text = this._info.titleNumText;
         this._numText.x = this._titleText.x + this._titleText.width;
         this.filters = null;
      }
      
      private function clearCustomInput() : void
      {
         if(this._customInput)
         {
            this._customInput.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
            this._customInput.removeEventListener(MouseEvent.CLICK,this.__customInputHandler);
            this._customInput.removeEventListener(FocusEvent.FOCUS_OUT,this.__fucksOutHandler);
            ObjectUtils.disposeObject(this._customInput);
         }
         this._customInput = null;
      }
      
      protected function __fucksOutHandler(param1:FocusEvent) : void
      {
         var _loc2_:Vector.<CustomInfo> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._customInput)
         {
            this._info.titleIsSelected = false;
            if(this._hasDouble)
            {
               if(this._customInput.text != "" && !PlayerManager.Instance.checkHasGroupName(this._customInput.text))
               {
                  SocketManager.Instance.out.sendCustomFriends(3,this._info.titleType,this._customInput.text);
                  this._hasDouble = false;
               }
            }
            else
            {
               this._titleText.visible = true;
               if(this._customInput.text != "" && !PlayerManager.Instance.checkHasGroupName(this._customInput.text))
               {
                  _loc2_ = PlayerManager.Instance.customList;
                  if(_loc2_.length >= PlayerManager.CUSTOM_MAX + 2)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.MaxCustom"));
                  }
                  else
                  {
                     _loc3_ = 10;
                     _loc4_ = 1;
                     while(_loc4_ < _loc2_.length - 1)
                     {
                        if(_loc2_[_loc4_].ID != 9 + _loc4_)
                        {
                           _loc3_ = 9 + _loc4_;
                           break;
                        }
                        if(_loc4_ == _loc2_.length - 2)
                        {
                           _loc3_ = 10 + _loc4_;
                        }
                        _loc4_++;
                     }
                     SocketManager.Instance.out.sendCustomFriends(1,_loc3_,this._customInput.text);
                  }
               }
            }
            this.clearCustomInput();
         }
      }
      
      protected function __keyDownHandler(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            SoundManager.instance.play("008");
            this.__fucksOutHandler(null);
         }
      }
      
      private function updateBtn() : void
      {
         this._titleBG.visible = this._titleText.visible = this._numText.visible = this._triangle.visible = false;
         this._state.visible = this._friendBG.visible = this._levelIcon.visible = this._sexIcon.visible = this._privateChatBtn.visible = this._deleteBtn.visible = this._snsInviteBtn.visible = this._masterIcon.visible = false;
         DisplayUtils.removeDisplay(this._nameText,this._vipName);
      }
      
      private function updateItem() : void
      {
         this._sexMoive.visible = true;
         if(IMController.Instance.checkHasNew(this._info.ID))
         {
            this._sexMoive.gotoAndPlay(1);
         }
         else
         {
            this._sexMoive.gotoAndStop(1);
         }
         PositionUtils.setPos(this._deleteBtn,"ListItemView.ItemDeletePos");
         this._state.visible = this._friendBG.visible = this._levelIcon.visible = this._sexIcon.visible = this._city.visible = true;
         this._masterIcon.visible = PlayerManager.Instance.Self.isMyApprent(this._info.ID) || PlayerManager.Instance.Self.isMyMaster(this._info.ID);
         this._city.visible = !this._masterIcon.visible && this._info.isSameCity;
         this._sexIcon.visible = !this._masterIcon.visible && !this._city.visible;
         if(this._info.isSameCity && this._info.playerState.StateID != PlayerState.OFFLINE)
         {
            if(this._info.Sex)
            {
               this._city.setFrame(1);
            }
            else
            {
               this._city.setFrame(2);
            }
         }
         else
         {
            this._city.visible = false;
         }
         if(PlayerManager.Instance.Self.isMyMaster(this._info.ID))
         {
            if(this._info.Sex)
            {
               this._masterIcon.setFrame(1);
            }
            else
            {
               this._masterIcon.setFrame(2);
            }
         }
         else if(this._info.Sex)
         {
            this._masterIcon.setFrame(3);
         }
         else
         {
            this._masterIcon.setFrame(4);
         }
         switch(this._info.playerState.StateID)
         {
            case 0:
            case 1:
               this._state.visible = false;
               break;
            case 2:
               this._state.setFrame(1);
               break;
            case 3:
               this._state.setFrame(2);
               break;
            case 4:
               this._state.setFrame(4);
               break;
            case 5:
               this._state.setFrame(3);
         }
         this._titleBG.visible = this._titleText.visible = this._numText.visible = this._triangle.visible = false;
         this._friendBG.setFrame(1);
         this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true);
         this._sexIcon.x = this._levelIcon.x + this._levelIcon.width + 2;
         this._sexIcon.setSex(this._info.Sex);
         this._masterIcon.x = this._sexIcon.x;
         this._nameText.x = this._sexIcon.x + this._sexIcon.width + 2;
         this._nameText.text = this._info.NickName;
         if(this._info.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(129,this._info.typeVIP);
            this._vipName.x = this._nameText.x;
            this._vipName.y = this._nameText.y;
            this._vipName.text = this._nameText.text;
            this._colorMatrixSp.addChild(this._vipName);
            DisplayUtils.removeDisplay(this._nameText);
         }
         else
         {
            this._colorMatrixSp.addChild(this._nameText);
            DisplayUtils.removeDisplay(this._vipName);
         }
         if(this._info.playerState.StateID == 0 && this._info.type != 0)
         {
            this._colorMatrixSp.filters = [this._myColorMatrix_filter];
         }
         else
         {
            this._colorMatrixSp.filters = null;
         }
         if(this._info.Relation == 1)
         {
            this.buttonMode = false;
            this._colorMatrixSp.filters = [this._myColorMatrix_filter];
         }
         this._state.x = this._nameText.x + this._nameText.width + this._stateoldx;
         if(this._state.visible)
         {
            this._privateChatBtn.visible = false;
         }
         this.updateMasetrIcon();
      }
      
      private function updateMasetrIcon() : void
      {
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
      }
      
      private function updateItemState() : void
      {
         if(this._info.titleIsSelected)
         {
            this.setItemSelectedState(true);
         }
         else
         {
            this.setItemSelectedState(false);
         }
      }
      
      private function setItemSelectedState(param1:Boolean) : void
      {
         if(param1)
         {
            this._triangle.setFrame(2);
            this._titleBG.setFrame(3);
            this._friendBG.setFrame(3);
         }
         else
         {
            this._triangle.setFrame(1);
            this._titleBG.setFrame(1);
            this._friendBG.setFrame(1);
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         var _loc5_:Boolean = false;
         var _loc2_:IMListItemView = param1.target as IMListItemView;
         var _loc3_:FriendListPlayer = param1.data as FriendListPlayer;
         var _loc4_:FriendListPlayer = _loc2_.getCellValue() as FriendListPlayer;
         if(_loc2_ && _loc4_.type == 0 && (_loc4_.titleType >= 10 || _loc4_.titleType == 0))
         {
            if(_loc3_.Relation == 1)
            {
               IMController.Instance.addFriend(_loc3_.NickName);
            }
            else
            {
               _loc5_ = PlayerManager.Instance.hasInFriendList(_loc3_.ID);
               if(_loc5_ || !_loc5_ && !IMController.Instance.isMaxFriend())
               {
                  SocketManager.Instance.out.sendAddFriend(_loc3_.NickName,_loc4_.titleType);
               }
            }
         }
         param1.action = DragEffect.NONE;
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         if(this._info.type == 0)
         {
            DragManager.acceptDrag(this,DragEffect.NONE);
         }
      }
      
      public function dragStart() : void
      {
         if(this._info && this._info.type == 1)
         {
            DragManager.startDrag(this,this._info,this.createImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,true,false,false,false);
            dispatchEvent(new CellEvent(CellEvent.DRAGSTART));
         }
      }
      
      private function createImg() : DisplayObject
      {
         var _loc1_:Bitmap = new Bitmap(new BitmapData(width,height,false,0),"auto",true);
         _loc1_.bitmapData.draw(this._colorMatrixSp);
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._colorMatrixSp)
         {
            if(this._colorMatrixSp.parent)
            {
               this._colorMatrixSp.parent.removeChild(this._colorMatrixSp);
            }
            this._colorMatrixSp = null;
            this._myColorMatrix_filter = null;
         }
         if(this._city)
         {
            ObjectUtils.disposeObject(this._city);
            this._city = null;
         }
         if(this._titleBG)
         {
            this._titleBG.dispose();
            this._titleBG = null;
         }
         if(this._friendBG)
         {
            this._friendBG.dispose();
            this._friendBG = null;
         }
         if(this._triangle)
         {
            this._triangle.dispose();
            this._triangle = null;
         }
         if(this._levelIcon)
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(this._sexIcon)
         {
            this._sexIcon.dispose();
            this._sexIcon = null;
         }
         if(this._masterIcon)
         {
            this._masterIcon.dispose();
            this._masterIcon = null;
         }
         if(this._nameText)
         {
            this._nameText.dispose();
            this._nameText = null;
         }
         if(this._titleText)
         {
            this._titleText.dispose();
            this._titleText = null;
         }
         if(this._numText)
         {
            this._numText.dispose();
            this._numText = null;
         }
         if(this._privateChatBtn)
         {
            this._privateChatBtn.dispose();
            this._privateChatBtn = null;
         }
         if(this._snsInviteBtn)
         {
            this._snsInviteBtn.dispose();
            this._snsInviteBtn = null;
         }
         if(this._deleteBtn)
         {
            this._deleteBtn.dispose();
            this._deleteBtn = null;
         }
         if(this._CMFIcon)
         {
            this._CMFIcon.dispose();
            this._CMFIcon = null;
         }
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
         }
         if(this._state)
         {
            ObjectUtils.disposeObject(this._state);
            this._state = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
