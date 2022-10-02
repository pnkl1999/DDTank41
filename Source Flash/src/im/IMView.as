package im
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.PlayerPortraitView;
   import ddt.view.common.LevelIcon;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import road7th.utils.StringHelper;
   import socialContact.SocialContactManager;
   import vip.VipController;
   
   public class IMView extends Frame
   {
      
      public static var IS_SHOW_SUB:Boolean;
      
      private static const ALL_STATE:Array = [new PlayerState(PlayerState.ONLINE,PlayerState.MANUAL),new PlayerState(PlayerState.AWAY,PlayerState.MANUAL),new PlayerState(PlayerState.BUSY,PlayerState.MANUAL),new PlayerState(PlayerState.NO_DISTRUB,PlayerState.MANUAL),new PlayerState(PlayerState.SHOPPING,PlayerState.MANUAL)];
      
      public static const FRIEND_LIST:int = 0;
      
      public static const CMFRIEND_LIST:int = 2;
      
      public static const CONSORTIA_LIST:int = 1;
      
      public static const LIKEFRIEND_LIST:int = 3;
       
      
      private var _CMSelectedBtn:SelectedButton;
      
      private var _IMSelectedBtn:SelectedButton;
      
      private var _likePersonSelectedBtn:SelectedButton;
      
      private var _addBlackFrame:AddBlackFrame;
      
      private var _addBleak:BaseButton;
      
      private var _addFriend:BaseButton;
      
      private var _myAcademyBtn:BaseButton;
      
      private var _inviteBtn:TextButton;
      
      private var _addFriendFrame:AddFriendFrame;
      
      private var _bg:MovieImage;
      
      private var _consortiaListBtn:SelectedButton;
      
      private var _levelIcon:LevelIcon;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _currentListType:int;
      
      private var _friendList:IMListView;
      
      private var _consortiaList:ConsortiaListView;
      
      private var _CMfriendList:CMFriendList;
      
      private var _likeFriendList:LikeFriendListView;
      
      private var _listContent:Sprite;
      
      private var _selfName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _playerPortrait:PlayerPortraitView;
      
      private var _imLookupView:IMLookupView;
      
      private var _stateSelectBtn:StateIconButton;
      
      private var _stateList:DropList;
      
      private var _replyInput:AutoReplyInput;
      
      private var _state:FilterFrameText;
      
      public function IMView()
      {
         super();
         super.init();
         this.initContent();
         this.initEvent();
      }
      
      private function initContent() : void
      {
         var _loc1_:Point = null;
         titleText = LanguageMgr.GetTranslation("tank.game.ToolStripView.friend");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("IM.BGMovieImage");
         addToContent(this._bg);
         this._selfName = ComponentFactory.Instance.creatComponentByStylename("IM.IMList.selfName");
         this._selfName.text = PlayerManager.Instance.Self.NickName;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(138,PlayerManager.Instance.Self.typeVIP);
            this._vipName.textSize = 18;
            this._vipName.x = this._selfName.x;
            this._vipName.y = this._selfName.y;
            this._vipName.text = this._selfName.text;
            addToContent(this._vipName);
         }
         else
         {
            addToContent(this._selfName);
         }
         this._IMSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.IMSelectedBtn");
         this._IMSelectedBtn.transparentEnable = true;
         addToContent(this._IMSelectedBtn);
         if(PathManager.CommnuntyMicroBlog())
         {
            this._CMSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.MBSelectedBtn");
            this._CMSelectedBtn.transparentEnable = true;
            addToContent(this._CMSelectedBtn);
            if(SharedManager.Instance.isCommunity && PathManager.CommunityExist())
            {
               this._CMSelectedBtn.visible = true;
            }
            else
            {
               this._CMSelectedBtn.visible = false;
            }
         }
         else
         {
            this._CMSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.CMSelectedBtn");
            this._CMSelectedBtn.transparentEnable = true;
            if(SharedManager.Instance.isCommunity && PathManager.CommunityExist())
            {
               addToContent(this._CMSelectedBtn);
            }
            else
            {
               this._CMSelectedBtn.visible = false;
            }
         }
         this._consortiaListBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.consortiaListBtn");
         this._consortiaListBtn.transparentEnable = true;
         addToContent(this._consortiaListBtn);
         this._likePersonSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.LikeSelectedBtn");
         if(!(SharedManager.Instance.isCommunity && PathManager.CommunityExist()))
         {
            this._likePersonSelectedBtn.x = this._CMSelectedBtn.x;
         }
         addToContent(this._likePersonSelectedBtn);
         this._selectedButtonGroup = new SelectedButtonGroup();
         this._selectedButtonGroup.addSelectItem(this._IMSelectedBtn);
         this._selectedButtonGroup.addSelectItem(this._consortiaListBtn);
         this._selectedButtonGroup.addSelectItem(this._CMSelectedBtn);
         this._selectedButtonGroup.addSelectItem(this._likePersonSelectedBtn);
         this._selectedButtonGroup.selectIndex = 0;
         this._addFriend = ComponentFactory.Instance.creatComponentByStylename("IM.AddFriendBtn");
         this._addFriend.tipData = LanguageMgr.GetTranslation("tank.view.im.AddFriendFrame.add");
         addToContent(this._addFriend);
         this._addBleak = ComponentFactory.Instance.creatComponentByStylename("IM.AddBleakBtn");
         this._addBleak.tipData = LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.btnText");
         addToContent(this._addBleak);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("IM.imView.LevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         addToContent(this._levelIcon);
         this._listContent = new Sprite();
         addToContent(this._listContent);
         this._imLookupView = new IMLookupView();
         _loc1_ = ComponentFactory.Instance.creatCustomObject("IM.IMView.IMLookupViewPos");
         this._imLookupView.x = _loc1_.x;
         this._imLookupView.y = _loc1_.y;
         addToContent(this._imLookupView);
         this._myAcademyBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.myAcademyBtn");
         this._myAcademyBtn.tipData = LanguageMgr.GetTranslation("im.IMView.myAcademyBtnTips");
         addToContent(this._myAcademyBtn);
         this._stateSelectBtn = ComponentFactory.Instance.creatCustomObject("IM.stateIconButton");
         addToContent(this._stateSelectBtn);
         this._stateList = ComponentFactory.Instance.creatComponentByStylename("IMView.stateList");
         this._stateList.targetDisplay = this._stateSelectBtn;
         this._stateList.showLength = 5;
         this._state = ComponentFactory.Instance.creatComponentByStylename("IM.stateIconBtn.stateNameTxt");
         this._state.text = "[" + PlayerManager.Instance.Self.playerState.convertToString() + "]";
         addToContent(this._state);
         this._replyInput = ComponentFactory.Instance.creatCustomObject("im.autoReplyInput");
         addToContent(this._replyInput);
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         this._levelIcon.setInfo(_loc2_.Grade,_loc2_.Repute,_loc2_.WinCount,_loc2_.TotalCount,_loc2_.FightPower,_loc2_.Offer,true,false);
         this.showFigure();
         this._currentListType = 0;
         this.setListType();
         this.__onStateChange(new PlayerPropertyEvent("*",new Dictionary()));
      }
      
      private function __CMBtnClick(param1:MouseEvent) : void
      {
         IMController.Instance.createConsortiaLoader();
         IMController.Instance.addEventListener(Event.COMPLETE,this.__CMFriendLoadComplete);
         SoundManager.instance.play("008");
      }
      
      private function __CMFriendLoadComplete(param1:Event) : void
      {
         IMController.Instance.removeEventListener(Event.COMPLETE,this.__CMFriendLoadComplete);
         this._currentListType = CMFRIEND_LIST;
         this.setListType();
      }
      
      private function __IMBtnClick(param1:MouseEvent) : void
      {
         this._currentListType = FRIEND_LIST;
         this.setListType();
         SoundManager.instance.play("008");
      }
      
      private function __inviteBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLVariables = null;
         var _loc4_:URLLoader = null;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo"));
         SoundManager.instance.play("008");
         if(!StringHelper.isNullOrEmpty(PathManager.CommunityInvite()))
         {
            _loc2_ = new URLRequest(PathManager.CommunityInvite());
            _loc3_ = new URLVariables();
            _loc3_["fuid"] = String(PlayerManager.Instance.Self.LoginName);
            _loc3_["fnick"] = PlayerManager.Instance.Self.NickName;
            _loc3_["tuid"] = this._CMfriendList.currentCMFInfo.UserName;
            _loc3_["serverid"] = String(ServerManager.Instance.AgentID);
            _loc3_["rnd"] = Math.random();
            _loc2_.data = _loc3_;
            _loc4_ = new URLLoader(_loc2_);
            _loc4_.load(_loc2_);
         }
      }
      
      private function __consortiaListBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.ConsortiaID <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.infoText"));
            this._selectedButtonGroup.selectIndex = this._currentListType;
            return;
         }
         this._currentListType = CONSORTIA_LIST;
         this.setListType();
      }
      
      private function __likeBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentListType = LIKEFRIEND_LIST;
         this.setListType();
      }
      
      private function __addBleakBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._addFriendFrame && this._addFriendFrame.parent)
         {
            this._addFriendFrame.dispose();
            this._addFriendFrame = null;
         }
         if(this._addBlackFrame && this._addBlackFrame.parent)
         {
            this._addBlackFrame.dispose();
            this._addBlackFrame = null;
            return;
         }
         this._addBlackFrame = ComponentFactory.Instance.creat("AddBlackFrame");
         LayerManager.Instance.addToLayer(this._addBlackFrame,LayerManager.GAME_DYNAMIC_LAYER);
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = false;
         }
         if(StateManager.currentStateType == StateType.FIGHTING)
         {
            ComponentSetting.SEND_USELOG_ID(127);
         }
      }
      
      private function __myAcademyClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade >= AcademyManager.TARGET_PLAYER_MIN_LEVEL)
         {
            if(PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.NONE_STATE)
            {
               AcademyManager.Instance.myAcademy();
            }
            else
            {
               AcademyFrameManager.Instance.showAcademyPreviewFrame();
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.academyInfo"));
         }
      }
      
      private function _socialContactBtClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocialContactManager.Instance.showView();
      }
      
      private function __addFriendBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currentListType == FRIEND_LIST || this._currentListType == CONSORTIA_LIST || this._currentListType == LIKEFRIEND_LIST)
         {
            if(this._addBlackFrame && this._addBlackFrame.parent)
            {
               this._addBlackFrame.dispose();
               this._addBlackFrame = null;
            }
            if(this._addFriendFrame && this._addFriendFrame.parent)
            {
               this._addFriendFrame.dispose();
               this._addFriendFrame = null;
               return;
            }
            this._addFriendFrame = ComponentFactory.Instance.creat("AddFriendFrame");
            LayerManager.Instance.addToLayer(this._addFriendFrame,LayerManager.GAME_DYNAMIC_LAYER);
         }
         else if(this._CMfriendList && this._CMfriendList.currentCMFInfo && this._CMfriendList.currentCMFInfo.IsExist)
         {
            IMController.Instance.addFriend(this._CMfriendList.currentCMFInfo.NickName);
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = false;
         }
         if(StateManager.currentStateType == StateType.FIGHTING)
         {
            ComponentSetting.SEND_USELOG_ID(126);
         }
      }
      
      private function showFigure() : void
      {
         var _loc1_:PlayerInfo = PlayerManager.Instance.Self;
         this._playerPortrait = ComponentFactory.Instance.creatCustomObject("im.PlayerPortrait",["right"]);
         this._playerPortrait.info = _loc1_;
         addToContent(this._playerPortrait);
      }
      
      private function setListType() : void
      {
         if(this._friendList && this._friendList.parent)
         {
            this._friendList.parent.removeChild(this._friendList);
            this._friendList.dispose();
            this._friendList = null;
         }
         if(this._consortiaList && this._consortiaList.parent)
         {
            this._consortiaList.parent.removeChild(this._consortiaList);
            this._consortiaList.dispose();
            this._consortiaList = null;
         }
         if(this._CMfriendList && this._CMfriendList.parent)
         {
            this._CMfriendList.parent.removeChild(this._CMfriendList);
            this._CMfriendList.dispose();
            this._CMfriendList = null;
         }
         if(this._likeFriendList && this._likeFriendList.parent)
         {
            this._likeFriendList.parent.removeChild(this._likeFriendList);
            this._likeFriendList.dispose();
            this._likeFriendList = null;
         }
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("IM.IMList.listPos");
         switch(this._currentListType)
         {
            case 0:
               this._friendList = new IMListView();
               this._friendList.y = _loc1_.x;
               this._listContent.addChild(this._friendList);
               this._addBleak.visible = true;
               this._addFriend.visible = true;
               this._myAcademyBtn.visible = true;
               this._imLookupView.listType = FRIEND_LIST;
               break;
            case 1:
               this._consortiaList = new ConsortiaListView();
               this._consortiaList.y = _loc1_.x;
               this._listContent.addChild(this._consortiaList);
               this._addBleak.visible = true;
               this._addFriend.visible = true;
               this._myAcademyBtn.visible = true;
               this._imLookupView.listType = FRIEND_LIST;
               break;
            case 2:
               this._CMfriendList = new CMFriendList();
               this._CMfriendList.y = _loc1_.y;
               if(this._listContent)
               {
                  this._listContent.addChild(this._CMfriendList);
               }
               this._addFriend.visible = false;
               this._addBleak.visible = false;
               this._myAcademyBtn.visible = false;
               this._imLookupView.listType = CMFRIEND_LIST;
               break;
            case LIKEFRIEND_LIST:
               this._likeFriendList = new LikeFriendListView();
               this._likeFriendList.y = _loc1_.x;
               if(this._listContent)
               {
                  this._listContent.addChild(this._likeFriendList);
               }
               this._addBleak.visible = true;
               this._addFriend.visible = true;
               this._myAcademyBtn.visible = true;
               this._imLookupView.listType = LIKEFRIEND_LIST;
         }
         if(AcademyManager.Instance.isFighting())
         {
            if(this._myAcademyBtn)
            {
               this._myAcademyBtn.visible = false;
            }
         }
      }
      
      private function initEvent() : void
      {
         this._IMSelectedBtn.addEventListener(MouseEvent.CLICK,this.__IMBtnClick);
         this._CMSelectedBtn.addEventListener(MouseEvent.CLICK,this.__CMBtnClick);
         this._consortiaListBtn.addEventListener(MouseEvent.CLICK,this.__consortiaListBtnClick);
         this._likePersonSelectedBtn.addEventListener(MouseEvent.CLICK,this.__likeBtnClick);
         this._addFriend.addEventListener(MouseEvent.CLICK,this.__addFriendBtnClick);
         this._addBleak.addEventListener(MouseEvent.CLICK,this.__addBleakBtnClick);
         if(this._myAcademyBtn)
         {
            this._myAcademyBtn.addEventListener(MouseEvent.CLICK,this.__myAcademyClick);
         }
         this._stateSelectBtn.addEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onStateChange);
      }
      
      private function __giftClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW);
      }
      
      private function __onStateChange(param1:PlayerPropertyEvent) : void
      {
         if(PlayerManager.Instance.Self.playerState.StateID == 1)
         {
            this._replyInput.visible = false;
         }
         else
         {
            this._replyInput.visible = true;
         }
         if(param1.changedProperties["State"])
         {
            this._state.text = "[" + PlayerManager.Instance.Self.playerState.convertToString() + "]";
            this._stateSelectBtn.setFrame(PlayerManager.Instance.Self.playerState.StateID);
         }
      }
      
      private function __hideStateList(param1:MouseEvent) : void
      {
         if(this._stateList.parent)
         {
            this._stateList.parent.removeChild(this._stateList);
         }
      }
      
      private function __stateSelectClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(this._stateList.parent == null)
         {
            addToContent(this._stateList);
         }
         this._stateList.dataList = ALL_STATE;
      }
      
      private function removeEvent() : void
      {
         this._IMSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__IMBtnClick);
         this._CMSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__CMBtnClick);
         this._consortiaListBtn.removeEventListener(MouseEvent.CLICK,this.__consortiaListBtnClick);
         this._likePersonSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__likeBtnClick);
         this._addFriend.removeEventListener(MouseEvent.CLICK,this.__addFriendBtnClick);
         this._addBleak.removeEventListener(MouseEvent.CLICK,this.__addBleakBtnClick);
         IMController.Instance.removeEventListener(Event.COMPLETE,this.__CMFriendLoadComplete);
         if(this._myAcademyBtn)
         {
            this._myAcademyBtn.removeEventListener(MouseEvent.CLICK,this.__myAcademyClick);
         }
         this._stateSelectBtn.removeEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onStateChange);
      }
      
      override public function dispose() : void
      {
         IMController.Instance.isShow = false;
         this.removeEvent();
         if(this._bg && this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
            this._bg.dispose();
            this._bg = null;
         }
         if(this._listContent && this._listContent.parent)
         {
            this._listContent.parent.removeChild(this._listContent);
            this._listContent = null;
         }
         if(this._selfName && this._selfName.parent)
         {
            this._selfName.parent.removeChild(this._selfName);
            this._selfName.dispose();
            this._selfName = null;
         }
         if(this._levelIcon && this._levelIcon.parent)
         {
            this._levelIcon.parent.removeChild(this._levelIcon);
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(this._consortiaListBtn && this._consortiaListBtn.parent)
         {
            this._consortiaListBtn.parent.removeChild(this._consortiaListBtn);
            this._consortiaListBtn.dispose();
            this._consortiaListBtn = null;
         }
         if(this._likePersonSelectedBtn)
         {
            ObjectUtils.disposeObject(this._likePersonSelectedBtn);
         }
         this._likePersonSelectedBtn = null;
         if(this._addFriend && this._addFriend.parent)
         {
            this._addFriend.parent.removeChild(this._addFriend);
            this._addFriend.dispose();
            this._addFriend = null;
         }
         if(this._addBleak && this._addBleak.parent)
         {
            this._addBleak.parent.removeChild(this._addBleak);
            this._addBleak.dispose();
            this._addBleak = null;
         }
         if(this._IMSelectedBtn && this._IMSelectedBtn.parent)
         {
            this._IMSelectedBtn.parent.removeChild(this._IMSelectedBtn);
            this._IMSelectedBtn.dispose();
            this._IMSelectedBtn = null;
         }
         if(this._CMSelectedBtn && this._CMSelectedBtn.parent)
         {
            this._CMSelectedBtn.parent.removeChild(this._CMSelectedBtn);
            this._CMSelectedBtn.dispose();
            this._CMSelectedBtn = null;
         }
         if(this._imLookupView && this._imLookupView.parent)
         {
            this._imLookupView.parent.removeChild(this._imLookupView);
            this._imLookupView.dispose();
            this._imLookupView = null;
         }
         if(this._friendList && this._friendList.parent)
         {
            this._friendList.parent.removeChild(this._friendList);
            this._friendList.dispose();
            this._friendList = null;
         }
         if(this._consortiaList && this._consortiaList.parent)
         {
            this._consortiaList.parent.removeChild(this._consortiaList);
            this._consortiaList.dispose();
            this._consortiaList = null;
         }
         if(this._CMfriendList && this._CMfriendList.parent)
         {
            this._CMfriendList.parent.removeChild(this._CMfriendList);
            this._CMfriendList.dispose();
            this._CMfriendList = null;
         }
         if(this._addFriendFrame)
         {
            this._addFriendFrame.dispose();
            this._addFriendFrame = null;
         }
         if(this._addBlackFrame)
         {
            this._addBlackFrame.dispose();
            this._addBlackFrame = null;
         }
         if(this._myAcademyBtn)
         {
            this._myAcademyBtn.dispose();
            this._myAcademyBtn = null;
         }
         if(this._stateList)
         {
            this._stateList.dispose();
            this._stateList = null;
         }
         if(this._stateSelectBtn)
         {
            this._stateSelectBtn.dispose();
            this._stateSelectBtn = null;
         }
         if(this._likeFriendList)
         {
            this._likeFriendList.dispose();
            this._likeFriendList = null;
         }
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         this._selectedButtonGroup.dispose();
         this._selectedButtonGroup = null;
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
