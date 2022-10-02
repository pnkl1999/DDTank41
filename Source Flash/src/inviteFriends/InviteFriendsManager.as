package inviteFriends
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import inviteFriends.data.InviteFriendPackageType;
   import inviteFriends.view.InviteFriendsMainView;
   import overSeasCommunity.OverSeasCommunController;
   import road7th.comm.PackageIn;
   
   public class InviteFriendsManager extends EventDispatcher
   {
      
      private static var _instance:InviteFriendsManager;
       
      
      private var _inviteFriendsBtn:MovieClip;
      
      private var loadComplete:Boolean = false;
      
      private var _inviteFriendsMainView:InviteFriendsMainView;
      
      public var myInviteNum:String = "1223344";
      
      public var nowInviteNum:int;
      
      public var successNum:int;
      
      public var lastFB_Time:Date;
      
      public var successRewardNum1:int;
      
      public var successRewardNum2:int;
      
      public var successRewardNum3:int;
      
      public var successRewardNum4:int;
      
      public function InviteFriendsManager()
      {
         super();
      }
      
      public static function get Instance() : InviteFriendsManager
      {
         if(_instance == null)
         {
            _instance = new InviteFriendsManager();
         }
         return _instance;
      }
      
      public function get inviteFriendsBtn() : MovieClip
      {
         return this._inviteFriendsBtn;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INVITEFRIEND,this.pkgHandler);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         switch(_loc3_)
         {
            case InviteFriendPackageType.INVITE_FRIEND_LOGIN:
               this.login(_loc2_);
               break;
            case InviteFriendPackageType.INVITE_FRIEND_OPENVIEW:
               this.showInviteMainView(_loc2_);
               break;
            case InviteFriendPackageType.INVITE_FRIEND_FRIENDREWARD:
               break;
            case InviteFriendPackageType.INVITE_FRIEND_GETREWARD:
               this.gerRewrd(_loc2_);
               break;
            case InviteFriendPackageType.INVITE_FRIEND_FLUSHFRIENDNUM:
               this.showRewardSuccess(_loc2_);
               break;
            case InviteFriendPackageType.INVITE_FRIEND_FBCLICK:
               this.fbclick(_loc2_);
         }
      }
      
      private function fbclick(param1:PackageIn) : void
      {
         this.lastFB_Time = param1.readDate();
         this._inviteFriendsMainView.changeFbStateByTime(this.lastFB_Time);
      }
      
      private function gerRewrd(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         var _loc3_:Boolean = param1.readBoolean();
         this.successRewardNum1 = param1.readInt();
         this.successRewardNum2 = param1.readInt();
         this.successRewardNum3 = param1.readInt();
         this.successRewardNum4 = param1.readInt();
         if(_loc3_)
         {
            this._inviteFriendsMainView.changeItemState(this.successRewardNum1,this.successRewardNum2,this.successRewardNum3,this.successRewardNum4);
         }
      }
      
      private function showRewardSuccess(param1:PackageIn) : void
      {
         this.successNum = param1.readInt();
         if(this.successNum >= 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("inviteFriends.inviteFriendsRewardSuccess"));
            this._inviteFriendsMainView.showRewardBnt();
         }
      }
      
      private function login(param1:PackageIn) : void
      {
         this.myInviteNum = param1.readUTF();
         this.successNum = param1.readInt();
         this.lastFB_Time = param1.readDate();
         this.successRewardNum1 = param1.readInt();
         this.successRewardNum2 = param1.readInt();
         this.successRewardNum3 = param1.readInt();
         this.successRewardNum4 = param1.readInt();
         OverSeasCommunController.instance().serverID = param1.readInt();
      }
      
      private function showInviteMainView(param1:PackageIn) : void
      {
         param1.readInt();
         param1.readInt();
         this.nowInviteNum = param1.readInt();
         if(this.loadComplete)
         {
            this.showInviteFriendsMainView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.INVITEFRIENDS);
         }
      }
      
      public function showButton() : void
      {
         this._inviteFriendsBtn = ComponentFactory.Instance.creat("asset.inviteFriends.inviteFriendsBtnMc");
         this._inviteFriendsBtn.buttonMode = true;
         PositionUtils.setPos(this._inviteFriendsBtn,"inviteFriends.inviteFriendsBtnMcPos");
         this._inviteFriendsBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         if(this.successRewardNum1 == 1 || this.successRewardNum2 == 1 || this.successRewardNum3 == 1 || this.successRewardNum4 == 1)
         {
            this._inviteFriendsBtn.gotoAndStop("shine");
         }
         else
         {
            this._inviteFriendsBtn.gotoAndStop("normal");
         }
         LayerManager.Instance.addToLayer(this._inviteFriendsBtn,LayerManager.GAME_DYNAMIC_LAYER,false,0,false);
      }
      
      private function showInviteFriendsMainView() : void
      {
         this._inviteFriendsMainView = ComponentFactory.Instance.creatComponentByStylename("inviteFriends.inviteFriendsFrame");
         LayerManager.Instance.addToLayer(this._inviteFriendsMainView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __onBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.enterInviteFriendView();
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.INVITEFRIENDS)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __completeShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.INVITEFRIENDS)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleSmallLoading.Instance.hide();
            this.loadComplete = true;
            this.showInviteFriendsMainView();
         }
      }
   }
}
