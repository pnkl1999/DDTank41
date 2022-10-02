package inviteFriends.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import daily.DailyManager;
   import ddt.DDT;
   import ddt.data.DaylyGiveInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import inviteFriends.InviteFriendsManager;
   import overSeasCommunity.OverSeasCommunController;
   
   public class InviteFriendsMainView extends Frame
   {
       
      
      private var _mainBg:Bitmap;
      
      private var _clipBnt:BaseButton;
      
      private var _fbBnt:BaseButton;
      
      private var _myInviteText:FilterFrameText;
      
      private var _inviteFriendsNowTxt:FilterFrameText;
      
      private var _rewardItem1:InviteFriendItem;
      
      private var _rewardItem2:InviteFriendItem;
      
      private var _rewardItem3:InviteFriendItem;
      
      private var _rewardItem4:InviteFriendItem;
      
      private var _okBnt:BaseButton;
      
      private var _okBnt2:BaseButton;
      
      private var _friendRewardTitle:FilterFrameText;
      
      private var _friendRewardList:HBox;
      
      private var _name:FilterFrameText;
      
      public function InviteFriendsMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("inviteFriends.inviteFriendsMainTitle");
         this._mainBg = ComponentFactory.Instance.creat("inviteFriends.inviteFriendsMainBg");
         addToContent(this._mainBg);
         this._clipBnt = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainView.clipBnt");
         this._fbBnt = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainView.fbBnt");
         this._myInviteText = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainView.myInviteTxt");
         this._myInviteText.text = InviteFriendsManager.Instance.myInviteNum;
         this._inviteFriendsNowTxt = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainFrame.nowInvite");
         this._inviteFriendsNowTxt.text = LanguageMgr.GetTranslation("inviteFriends.inviteFriendsMainFrame.nowInviteTxt",InviteFriendsManager.Instance.nowInviteNum);
         this.initReward();
         this.initFriendReward();
         this._okBnt = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.MainView.okBnt");
         this._okBnt2 = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.MainView.okBnt2");
         if(InviteFriendsManager.Instance.successNum == 0)
         {
            addToContent(this._okBnt);
         }
         else
         {
            addToContent(this._okBnt2);
            this._okBnt2.enable = false;
         }
         this._friendRewardTitle = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainFrame.friendRewardTitle");
         this._friendRewardTitle.text = LanguageMgr.GetTranslation("inviteFriends.inviteFriendsMainFrame.friendRewardTitle");
         addToContent(this._friendRewardTitle);
         this._name = ComponentFactory.Instance.creat("inviteFriends.inviteFriendHereText");
         this._name.maxChars = 20;
         this._name.text = LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardHere");
         addToContent(this._name);
         addToContent(this._clipBnt);
         addToContent(this._fbBnt);
         addToContent(this._myInviteText);
         addToContent(this._inviteFriendsNowTxt);
         this.changeFbStateByTime(InviteFriendsManager.Instance.lastFB_Time);
         if(!DDT.IsFBLoader)
         {
            this._fbBnt.enable = false;
         }
         else
         {
            this._fbBnt.enable = true;
         }
      }
      
      public function showRewardBnt() : void
      {
         if(InviteFriendsManager.Instance.successNum != 0)
         {
            if(this._okBnt)
            {
               this._okBnt.visible = false;
            }
            addToContent(this._okBnt2);
            this._okBnt2.enable = false;
         }
      }
      
      public function changeFbStateByTime(param1:Date) : void
      {
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:String = _loc2_.toDateString();
         var _loc4_:String = _loc2_.toLocaleTimeString();
         var _loc5_:String = param1.toDateString();
         var _loc6_:String = param1.toLocaleTimeString();
         if(_loc5_ == _loc3_)
         {
            this._fbBnt.enable = false;
         }
         else if(!DDT.IsFBLoader)
         {
            this._fbBnt.enable = false;
         }
         else
         {
            this._fbBnt.enable = true;
         }
      }
      
      private function initFriendReward() : void
      {
         this._friendRewardList = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsMainView.friendRewardHBox");
         addToContent(this._friendRewardList);
         this.setFriendRewardList(DailyManager.list200);
      }
      
      public function setFriendRewardList(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ItemTemplateInfo = null;
         var _loc4_:FriendInviteFriendItemCell = null;
         var _loc5_:DaylyGiveInfo = null;
         if(param1.length == 0)
         {
            return;
         }
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            _loc5_ = param1[_loc6_] as DaylyGiveInfo;
            _loc2_ = _loc5_.TemplateID;
            _loc3_ = ItemManager.Instance.getTemplateById(_loc2_);
            _loc4_ = new FriendInviteFriendItemCell(0,_loc3_);
            _loc4_.count = _loc5_.Count;
            _loc4_.updateCount();
            _loc4_.mouseOverEffBoolean = false;
            this._friendRewardList.addChild(_loc4_);
            _loc6_++;
         }
      }
      
      private function initReward() : void
      {
         this._rewardItem1 = new InviteFriendItem();
         this._rewardItem1.id = 1;
         this._rewardItem1.setTitle(LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardTitle1"));
         this._rewardItem1.setRewardList(DailyManager.list201);
         PositionUtils.setPos(this._rewardItem1,"inviteFriends.rewardItemPos1");
         addToContent(this._rewardItem1);
         this._rewardItem2 = new InviteFriendItem();
         this._rewardItem2.id = 3;
         this._rewardItem2.setTitle(LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardTitle2"));
         this._rewardItem2.setRewardList(DailyManager.list203);
         PositionUtils.setPos(this._rewardItem2,"inviteFriends.rewardItemPos2");
         addToContent(this._rewardItem2);
         this._rewardItem3 = new InviteFriendItem();
         this._rewardItem3.id = 5;
         this._rewardItem3.setTitle(LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardTitle3"));
         this._rewardItem3.setRewardList(DailyManager.list205);
         PositionUtils.setPos(this._rewardItem3,"inviteFriends.rewardItemPos3");
         addToContent(this._rewardItem3);
         this._rewardItem4 = new InviteFriendItem();
         this._rewardItem4.id = 10;
         this._rewardItem4.setTitle(LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardTitle4"));
         this._rewardItem4.setRewardList(DailyManager.list210);
         PositionUtils.setPos(this._rewardItem4,"inviteFriends.rewardItemPos4");
         addToContent(this._rewardItem4);
         this.changeRewardItemState(InviteFriendsManager.Instance.nowInviteNum);
         this.changeItemState(InviteFriendsManager.Instance.successRewardNum1,InviteFriendsManager.Instance.successRewardNum2,InviteFriendsManager.Instance.successRewardNum3,InviteFriendsManager.Instance.successRewardNum4);
      }
      
      public function changeItemState(param1:int, param2:int, param3:int, param4:int) : void
      {
         if(param1 == 0)
         {
            this._rewardItem1.changeRewardBnt(false);
         }
         else
         {
            this._rewardItem1.changeRewardBnt(true);
         }
         if(param2 == 0)
         {
            this._rewardItem2.changeRewardBnt(false);
         }
         else
         {
            this._rewardItem2.changeRewardBnt(true);
         }
         if(param3 == 0)
         {
            this._rewardItem3.changeRewardBnt(false);
         }
         else
         {
            this._rewardItem3.changeRewardBnt(true);
         }
         if(param4 == 0)
         {
            this._rewardItem4.changeRewardBnt(false);
         }
         else
         {
            this._rewardItem4.changeRewardBnt(true);
         }
      }
      
      private function changeRewardItemState(param1:int) : void
      {
         if(param1 <= 0)
         {
            this._rewardItem1.visibleRewardBnt(false);
            this._rewardItem2.visibleRewardBnt(false);
            this._rewardItem3.visibleRewardBnt(false);
            this._rewardItem4.visibleRewardBnt(false);
         }
         else if(param1 >= 1 && param1 < 3)
         {
            this._rewardItem1.visibleRewardBnt(true);
            this._rewardItem2.visibleRewardBnt(false);
            this._rewardItem3.visibleRewardBnt(false);
            this._rewardItem4.visibleRewardBnt(false);
         }
         else if(param1 >= 3 && param1 < 5)
         {
            this._rewardItem1.visibleRewardBnt(true);
            this._rewardItem2.visibleRewardBnt(true);
            this._rewardItem3.visibleRewardBnt(false);
            this._rewardItem4.visibleRewardBnt(false);
         }
         else if(param1 >= 5 && param1 < 10)
         {
            this._rewardItem1.visibleRewardBnt(true);
            this._rewardItem2.visibleRewardBnt(true);
            this._rewardItem3.visibleRewardBnt(true);
            this._rewardItem4.visibleRewardBnt(false);
         }
         else if(param1 >= 10)
         {
            this._rewardItem1.visibleRewardBnt(true);
            this._rewardItem2.visibleRewardBnt(true);
            this._rewardItem3.visibleRewardBnt(true);
            this._rewardItem4.visibleRewardBnt(true);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._clipBnt.addEventListener(MouseEvent.CLICK,this._clipBntclick);
         this._okBnt.addEventListener(MouseEvent.CLICK,this.__friendInviteOk);
         this._name.addEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.addEventListener(Event.CHANGE,this._nameChange);
         this._fbBnt.addEventListener(MouseEvent.CLICK,this.__fbClick);
      }
      
      private function __fbClick(param1:MouseEvent) : void
      {
         OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("InviteFriendsMainView.FbClick.sendMsg",this._myInviteText.text));
         SocketManager.Instance.out.inviteFriendFBBntClick();
      }
      
      private function __friendInviteOk(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(InviteFriendsManager.Instance.successNum == 0)
         {
            _loc2_ = this._name.text;
            SocketManager.Instance.out.inviteFriendOkClick(_loc2_);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardAlready"));
         }
      }
      
      private function _clipBntclick(param1:MouseEvent) : void
      {
         var _loc2_:String = InviteFriendsManager.Instance.myInviteNum;
         Clipboard.generalClipboard.clear();
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,_loc2_);
      }
      
      private function _nameChange(param1:Event) : void
      {
         if(this._name.text.indexOf(LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardHere")) > -1)
         {
            this._name.text = this._name.text.replace(LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardHere"),"");
         }
      }
      
      private function _clickName(param1:MouseEvent) : void
      {
         if(this._name.text == LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardHere"))
         {
            this._name.text = "";
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._name.removeEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.removeEventListener(Event.CHANGE,this._nameChange);
         this._clipBnt.removeEventListener(MouseEvent.CLICK,this._clipBntclick);
         this._okBnt.removeEventListener(MouseEvent.CLICK,this.__friendInviteOk);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         while(numChildren)
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}
