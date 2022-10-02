package ddt.manager
{
   import baglocked.BaglockedManager;
   import church.events.WeddingRoomEvent;
   import church.view.weddingRoom.frame.WeddingRoomGiftFrameView;
   import com.pickgliss.action.AlertAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.action.FrameShowAction;
   import ddt.constants.CacheConsts;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import ddt.view.common.church.ChurchDialogueAgreePropose;
   import ddt.view.common.church.ChurchDialogueRejectPropose;
   import ddt.view.common.church.ChurchDialogueUnmarried;
   import ddt.view.common.church.ChurchInviteFrame;
   import ddt.view.common.church.ChurchMarryApplySuccess;
   import ddt.view.common.church.ChurchProposeFrame;
   import ddt.view.common.church.ChurchProposeResponseFrame;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   import road7th.utils.StringHelper;
   import luckStar.manager.LuckStarManager;
   
   public class ChurchManager extends EventDispatcher
   {
      
      private static const WEDDING_SCENE:Boolean = false;
      
      private static const MOON_SCENE:Boolean = true;
      
      public static const CIVIL_PLAYER_INFO_MODIFY:String = "civilplayerinfomodify";
      
      public static const CIVIL_SELFINFO_CHANGE:String = "civilselfinfochange";
      
      public static const SUBMIT_REFUND:String = "submitRefund";
      
      private static var _instance:ChurchManager;
       
      
      private var _currentScene:Boolean = false;
      
      private var _churchDialogueUnmarried:ChurchDialogueUnmarried;
      
      private var _churchProposeFrame:ChurchProposeFrame;
      
      private var _proposeResposeFrame:ChurchProposeResponseFrame;
      
      private var _churchMarryApplySuccess:ChurchMarryApplySuccess;
      
      private var _alertMarried:BaseAlerFrame;
      
      public var _weddingSuccessfulComplete:Boolean;
      
      public var _selfRoom:ChurchRoomInfo;
      
      private var _currentRoom:ChurchRoomInfo;
      
      private var _mapLoader01:BaseLoader;
      
      private var _mapLoader02:BaseLoader;
      
      private var _isRemoveLoading:Boolean = true;
      
      private var _weddingRoomGiftFrameView:WeddingRoomGiftFrameView;
      
      private var marryApplyList:Array;
      
      private var _churchDialogueAgreePropose:ChurchDialogueAgreePropose;
      
      private var _churchDialogueRejectPropose:ChurchDialogueRejectPropose;
      
      public function ChurchManager()
      {
         this.marryApplyList = new Array();
         super();
      }
      
      public static function get instance() : ChurchManager
      {
         if(!_instance)
         {
            _instance = new ChurchManager();
         }
         return _instance;
      }
      
      public function get currentScene() : Boolean
      {
         return this._currentScene;
      }
      
      public function set currentScene(param1:Boolean) : void
      {
         if(this._currentScene == param1)
         {
            return;
         }
         this._currentScene = param1;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.SCENE_CHANGE,this._currentScene));
      }
      
      public function get selfRoom() : ChurchRoomInfo
      {
         return this._selfRoom;
      }
      
      public function set selfRoom(param1:ChurchRoomInfo) : void
      {
         this._selfRoom = param1;
      }
      
      public function set currentRoom(param1:ChurchRoomInfo) : void
      {
         if(this._currentRoom == param1)
         {
            return;
         }
         this._currentRoom = param1;
         this.onChurchRoomInfoChange();
      }
      
      public function get currentRoom() : ChurchRoomInfo
      {
         return this._currentRoom;
      }
      
      private function onChurchRoomInfoChange() : void
      {
         if(this._currentRoom != null)
         {
            this.loadMap();
         }
      }
      
      public function loadMap() : void
      {
         this._mapLoader01 = LoaderManager.Instance.creatLoader(PathManager.solveChurchSceneSourcePath("Map01"),BaseLoader.MODULE_LOADER);
         this._mapLoader01.addEventListener(LoaderEvent.COMPLETE,this.onMapSrcLoadedComplete);
         LoaderManager.Instance.startLoad(this._mapLoader01);
         this._mapLoader02 = LoaderManager.Instance.creatLoader(PathManager.solveChurchSceneSourcePath("Map02"),BaseLoader.MODULE_LOADER);
         this._mapLoader02.addEventListener(LoaderEvent.COMPLETE,this.onMapSrcLoadedComplete);
         LoaderManager.Instance.startLoad(this._mapLoader02);
      }
      
      protected function onMapSrcLoadedComplete(param1:LoaderEvent = null) : void
      {
         if(this._mapLoader01.isSuccess && this._mapLoader02.isSuccess)
         {
            this.tryLoginScene();
         }
      }
      
      public function tryLoginScene() : void
      {
         if(StateManager.getState(StateType.CHURCH_ROOM) == null)
         {
            this._isRemoveLoading = false;
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingIsClose);
         }
         StateManager.setState(StateType.CHURCH_ROOM);
      }
      
      private function __loadingIsClose(param1:Event) : void
      {
         this._isRemoveLoading = true;
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsClose);
         SocketManager.Instance.out.sendExitRoom();
      }
      
      public function removeLoadingEvent() : void
      {
         if(!this._isRemoveLoading)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsClose);
         }
      }
      
      public function closeRefundView() : void
      {
         if(this._weddingRoomGiftFrameView)
         {
            if(this._weddingRoomGiftFrameView.parent)
            {
               this._weddingRoomGiftFrameView.parent.removeChild(this._weddingRoomGiftFrameView);
            }
            this._weddingRoomGiftFrameView.removeEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameView.dispose();
            this._weddingRoomGiftFrameView = null;
         }
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_LOGIN,this.__roomLogin);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_STATE,this.__updateSelfRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,this.__removePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_STATUS,this.__showPropose);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_APPLY,this.__marryApply);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_APPLY_REPLY,this.__marryApplyReply);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIVORCE_APPLY,this.__divorceApply);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INVITE,this.__churchInvite);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYPROP_GET,this.__marryPropGet);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AMARRYINFO_REFRESH,this.__upCivilPlayerView);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYINFO_GET,this.__getMarryInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRYROOMSENDGIFT,this.__showGiftView);
         this.addEventListener(ChurchManager.SUBMIT_REFUND,this.__onSubmitRefund);
      }
      
      private function __onSubmitRefund(param1:Event) : void
      {
         SocketManager.Instance.out.refund();
      }
      
      private function __upCivilPlayerView(param1:CrazyTankSocketEvent) : void
      {
         PlayerManager.Instance.Self.MarryInfoID = param1.pkg.readInt();
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            PlayerManager.Instance.Self.ID = param1.pkg.readInt();
            PlayerManager.Instance.Self.IsPublishEquit = param1.pkg.readBoolean();
            PlayerManager.Instance.Self.Introduction = param1.pkg.readUTF();
         }
         dispatchEvent(new Event(CIVIL_PLAYER_INFO_MODIFY));
      }
      
      private function __getMarryInfo(param1:CrazyTankSocketEvent) : void
      {
         PlayerManager.Instance.Self.Introduction = param1.pkg.readUTF();
         PlayerManager.Instance.Self.IsPublishEquit = param1.pkg.readBoolean();
         dispatchEvent(new Event(CIVIL_SELFINFO_CHANGE));
      }
      
      public function __showPropose(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         if(_loc3_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.married"));
         }
         else if(PlayerManager.Instance.Self.IsMarried)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.youMarried"));
         }
         else
         {
            this._churchProposeFrame = ComponentFactory.Instance.creat("common.church.ChurchProposeFrame");
            this._churchProposeFrame.addEventListener(Event.CLOSE,this.churchProposeFrameClose);
            this._churchProposeFrame.spouseID = _loc2_;
            this._churchProposeFrame.show();
         }
      }
      
      private function __showGiftView(param1:CrazyTankSocketEvent) : void
      {
         param1.pkg.readByte();
         var _loc2_:int = param1.pkg.readInt();
         if(this._weddingRoomGiftFrameView)
         {
            if(this._weddingRoomGiftFrameView.parent)
            {
               this._weddingRoomGiftFrameView.parent.removeChild(this._weddingRoomGiftFrameView);
            }
            this._weddingRoomGiftFrameView.removeEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameView.dispose();
            this._weddingRoomGiftFrameView = null;
         }
         else
         {
            this._weddingRoomGiftFrameView = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomGiftFrameView");
            this._weddingRoomGiftFrameView.addEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameView.txtMoney = _loc2_.toString();
            this._weddingRoomGiftFrameView.show();
         }
      }
      
      private function closeRoomGift(param1:Event = null) : void
      {
         if(this._weddingRoomGiftFrameView)
         {
            this._weddingRoomGiftFrameView.removeEventListener(Event.CLOSE,this.closeRoomGift);
            if(this._weddingRoomGiftFrameView.parent)
            {
               this._weddingRoomGiftFrameView.parent.removeChild(this._weddingRoomGiftFrameView);
            }
            this._weddingRoomGiftFrameView.dispose();
         }
         this._weddingRoomGiftFrameView = null;
      }
      
      private function churchProposeFrameClose(param1:Event) : void
      {
         if(this._churchProposeFrame)
         {
            this._churchProposeFrame.removeEventListener(Event.CLOSE,this.churchProposeFrameClose);
            if(this._churchProposeFrame.parent)
            {
               this._churchProposeFrame.parent.removeChild(this._churchProposeFrame);
            }
         }
         this._churchProposeFrame = null;
      }
      
      private function __marryApply(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:String = param1.pkg.readUTF();
         var _loc5_:int = param1.pkg.readInt();
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            this._churchMarryApplySuccess = ComponentFactory.Instance.creat("common.church.ChurchMarryApplySuccess");
            this._churchMarryApplySuccess.addEventListener(Event.CLOSE,this.churchMarryApplySuccessClose);
            this._churchMarryApplySuccess.show();
            return;
         }
         if(this.checkMarryApplyList(_loc5_))
         {
            return;
         }
         this.marryApplyList.push(_loc5_);
         SoundManager.instance.play("018");
         this._proposeResposeFrame = ComponentFactory.Instance.creat("common.church.ChurchProposeResponseFrame");
         this._proposeResposeFrame.addEventListener(Event.CLOSE,this.ProposeResposeFrameClose);
         this._proposeResposeFrame.spouseID = _loc2_;
         this._proposeResposeFrame.spouseName = _loc3_;
         this._proposeResposeFrame.answerId = _loc5_;
         this._proposeResposeFrame.love = _loc4_;
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(this._proposeResposeFrame,LayerManager.GAME_UI_LAYER,LayerManager.BLCAK_BLOCKGOUND));
         }
         else
         {
            this._proposeResposeFrame.show();
         }
      }
      
      private function checkMarryApplyList(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.marryApplyList.length)
         {
            if(param1 == this.marryApplyList[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function churchMarryApplySuccessClose(param1:Event) : void
      {
         if(this._churchMarryApplySuccess)
         {
            this._churchMarryApplySuccess.removeEventListener(Event.CLOSE,this.churchMarryApplySuccessClose);
            if(this._churchMarryApplySuccess.parent)
            {
               this._churchMarryApplySuccess.parent.removeChild(this._churchMarryApplySuccess);
            }
            this._churchMarryApplySuccess.dispose();
         }
         this._churchMarryApplySuccess = null;
      }
      
      private function ProposeResposeFrameClose(param1:Event) : void
      {
         if(this._proposeResposeFrame)
         {
            this._proposeResposeFrame.removeEventListener(Event.CLOSE,this.ProposeResposeFrameClose);
            if(this._proposeResposeFrame.parent)
            {
               this._proposeResposeFrame.parent.removeChild(this._proposeResposeFrame);
            }
            this._proposeResposeFrame.dispose();
         }
         this._proposeResposeFrame = null;
      }
      
      private function __marryApplyReply(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:ChatData = null;
         var _loc7_:String = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         var _loc4_:String = param1.pkg.readUTF();
         var _loc5_:Boolean = param1.pkg.readBoolean();
         if(_loc3_)
         {
            PlayerManager.Instance.Self.IsMarried = true;
            PlayerManager.Instance.Self.SpouseID = _loc2_;
            PlayerManager.Instance.Self.SpouseName = _loc4_;
            TaskManager.onMarriaged();
            TaskManager.requestCanAcceptTask();
            if(PathManager.solveExternalInterfaceEnabel())
            {
               ExternalInterfaceManager.sendToAgent(7,PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName,ServerManager.Instance.zoneName,-1,"",_loc4_);
            }
         }
         if(_loc5_)
         {
            _loc6_ = new ChatData();
            _loc7_ = "";
            if(_loc3_)
            {
               _loc6_.channel = ChatInputView.SYS_NOTICE;
               _loc7_ = "<" + _loc4_ + ">" + LanguageMgr.GetTranslation("tank.manager.PlayerManager.isApplicant");
               this._churchDialogueAgreePropose = ComponentFactory.Instance.creat("common.church.ChurchDialogueAgreePropose");
               this._churchDialogueAgreePropose.msgInfo = _loc4_;
               this._churchDialogueAgreePropose.addEventListener(Event.CLOSE,this.churchDialogueAgreeProposeClose);
               if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
               {
                  CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new FrameShowAction(this._churchDialogueAgreePropose));
               }
               else
               {
                  this._churchDialogueAgreePropose.show();
               }
            }
            else
            {
               _loc6_.channel = ChatInputView.SYS_TIP;
               _loc7_ = "<" + _loc4_ + ">" + LanguageMgr.GetTranslation("tank.manager.PlayerManager.refuseMarry");
               if(this._churchDialogueRejectPropose)
               {
                  this._churchDialogueRejectPropose.dispose();
               }
               this._churchDialogueRejectPropose = ComponentFactory.Instance.creat("common.church.ChurchDialogueRejectPropose");
               this._churchDialogueRejectPropose.msgInfo = _loc4_;
               this._churchDialogueRejectPropose.addEventListener(Event.CLOSE,this.churchDialogueRejectProposeClose);
               if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
               {
                  CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(this._churchDialogueRejectPropose,LayerManager.GAME_DYNAMIC_LAYER,LayerManager.BLCAK_BLOCKGOUND,"018",true));
               }
               else
               {
                  this._churchDialogueRejectPropose.show();
               }
            }
            _loc6_.msg = StringHelper.rePlaceHtmlTextField(_loc7_);
            ChatManager.Instance.chat(_loc6_);
         }
         else if(_loc3_)
         {
            this._alertMarried = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("tank.manager.PlayerManager.youAndOtherMarried",_loc4_),LanguageMgr.GetTranslation("ok"),"",false,false,false,0,CacheConsts.ALERT_IN_FIGHT);
            this._alertMarried.addEventListener(FrameEvent.RESPONSE,this.marriedResponse);
         }
      }
      
      private function marriedResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._alertMarried)
               {
                  if(this._alertMarried.parent)
                  {
                     this._alertMarried.parent.removeChild(this._alertMarried);
                  }
                  this._alertMarried.dispose();
               }
               this._alertMarried = null;
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function churchDialogueRejectProposeClose(param1:Event) : void
      {
         if(this._churchDialogueRejectPropose)
         {
            this._churchDialogueRejectPropose.removeEventListener(Event.CLOSE,this.churchDialogueRejectProposeClose);
            if(this._churchDialogueRejectPropose.parent)
            {
               this._churchDialogueRejectPropose.parent.removeChild(this._churchDialogueRejectPropose);
            }
            this._churchDialogueRejectPropose.dispose();
         }
         this._churchDialogueRejectPropose = null;
      }
      
      private function churchDialogueAgreeProposeClose(param1:Event) : void
      {
         if(this._churchDialogueAgreePropose)
         {
            this._churchDialogueAgreePropose.removeEventListener(Event.CLOSE,this.churchDialogueAgreeProposeClose);
            if(this._churchDialogueAgreePropose.parent)
            {
               this._churchDialogueAgreePropose.parent.removeChild(this._churchDialogueAgreePropose);
            }
            this._churchDialogueAgreePropose.dispose();
         }
         this._churchDialogueAgreePropose = null;
      }
      
      private function __divorceApply(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         if(!_loc2_)
         {
            return;
         }
         PlayerManager.Instance.Self.IsMarried = false;
         PlayerManager.Instance.Self.SpouseID = 0;
         PlayerManager.Instance.Self.SpouseName = "";
         ChurchManager.instance.selfRoom = null;
         if(!_loc3_)
         {
            SoundManager.instance.play("018");
            this._churchDialogueUnmarried = ComponentFactory.Instance.creat("ddt.common.church.ChurchDialogueUnmarried");
            if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
            {
               CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(this._churchDialogueUnmarried,LayerManager.GAME_DYNAMIC_LAYER,LayerManager.BLCAK_BLOCKGOUND));
            }
            else
            {
               this._churchDialogueUnmarried.show();
            }
            this._churchDialogueUnmarried.addEventListener(Event.CLOSE,this.churchDialogueUnmarriedClose);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.divorce"));
         }
         if(StateManager.currentStateType == StateType.CHURCH_ROOM && (this.currentRoom.brideID == PlayerManager.Instance.Self.ID || this.currentRoom.createID == PlayerManager.Instance.Self.ID))
         {
            StateManager.setState(StateType.CHURCH_ROOM_LIST);
         }
      }
      
      private function churchDialogueUnmarriedClose(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._churchDialogueUnmarried)
         {
            this._churchDialogueUnmarried.removeEventListener(Event.CLOSE,this.churchDialogueUnmarriedClose);
            if(this._churchDialogueUnmarried.parent)
            {
               this._churchDialogueUnmarried.parent.removeChild(this._churchDialogueUnmarried);
            }
            this._churchDialogueUnmarried.dispose();
         }
         this._churchDialogueUnmarried = null;
      }
      
      private function __churchInvite(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:Object = null;
         var _loc4_:ChurchInviteFrame = null;
         if(InviteManager.Instance.enabled)
         {
            _loc2_ = param1.pkg;
            _loc3_ = new Object();
            _loc3_["inviteID"] = _loc2_.readInt();
            _loc3_["inviteName"] = _loc2_.readUTF();
            _loc3_["IsVip"] = _loc2_.readBoolean();
            _loc3_["VIPLevel"] = _loc2_.readInt();
            _loc3_["roomID"] = _loc2_.readInt();
            _loc3_["roomName"] = _loc2_.readUTF();
            _loc3_["pwd"] = _loc2_.readUTF();
            _loc3_["sceneIndex"] = _loc2_.readInt();
			if(LuckStarManager.Instance.openState)
			{
				return;
			}
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("common.church.ChurchInviteFrame");
            _loc4_.msgInfo = _loc3_;
            _loc4_.show();
            SoundManager.instance.play("018");
         }
      }
      
      private function __marryPropGet(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:ChurchRoomInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         PlayerManager.Instance.Self.IsMarried = _loc2_.readBoolean();
         PlayerManager.Instance.Self.SpouseID = _loc2_.readInt();
         PlayerManager.Instance.Self.SpouseName = _loc2_.readUTF();
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            if(!ChurchManager.instance.selfRoom)
            {
               _loc6_ = new ChurchRoomInfo();
               _loc6_.id = _loc4_;
               ChurchManager.instance.selfRoom = _loc6_;
            }
         }
         else
         {
            ChurchManager.instance.selfRoom = null;
         }
      }
      
      private function __roomLogin(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:ChurchRoomInfo = new ChurchRoomInfo();
         _loc4_.id = _loc2_.readInt();
         _loc4_.roomName = _loc2_.readUTF();
         _loc4_.mapID = _loc2_.readInt();
         _loc4_.valideTimes = _loc2_.readInt();
         _loc4_.currentNum = _loc2_.readInt();
         _loc4_.createID = _loc2_.readInt();
         _loc4_.createName = _loc2_.readUTF();
         _loc4_.groomID = _loc2_.readInt();
         _loc4_.groomName = _loc2_.readUTF();
         _loc4_.brideID = _loc2_.readInt();
         _loc4_.brideName = _loc2_.readUTF();
         _loc4_.creactTime = _loc2_.readDate();
         _loc4_.isStarted = _loc2_.readBoolean();
         var _loc5_:int = _loc2_.readByte();
         if(_loc5_ == 1)
         {
            _loc4_.status = ChurchRoomInfo.WEDDING_NONE;
         }
         else
         {
            _loc4_.status = ChurchRoomInfo.WEDDING_ING;
         }
         _loc4_.discription = _loc2_.readUTF();
         _loc4_.canInvite = _loc2_.readBoolean();
         var _loc6_:int = _loc2_.readInt();
         ChurchManager.instance.currentScene = _loc6_ == 1 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
         _loc4_.isUsedSalute = _loc2_.readBoolean();
         this.currentRoom = _loc4_;
         if(this.isAdmin(PlayerManager.Instance.Self))
         {
            this.selfRoom = _loc4_;
         }
      }
      
      private function __updateSelfRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Boolean = _loc2_.readBoolean();
         if(!_loc4_)
         {
            this.selfRoom = null;
            return;
         }
         if(this.selfRoom == null)
         {
            this.selfRoom = new ChurchRoomInfo();
         }
         this.selfRoom.id = _loc2_.readInt();
         this.selfRoom.roomName = _loc2_.readUTF();
         this.selfRoom.mapID = _loc2_.readInt();
         this.selfRoom.valideTimes = _loc2_.readInt();
         this.selfRoom.createID = _loc2_.readInt();
         this.selfRoom.groomID = _loc2_.readInt();
         this.selfRoom.brideID = _loc2_.readInt();
         this.selfRoom.creactTime = _loc2_.readDate();
         this.selfRoom.isUsedSalute = _loc2_.readBoolean();
      }
      
      public function __removePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.clientId;
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(StateType.CHURCH_ROOM_LIST);
         }
      }
      
      public function isAdmin(param1:PlayerInfo) : Boolean
      {
         if(this._currentRoom && param1)
         {
            return param1.ID == this._currentRoom.groomID || param1.ID == this._currentRoom.brideID;
         }
         return false;
      }
      
      public function sendValidateMarry(param1:BasePlayer) : void
      {
         if(PlayerManager.Instance.Self.Grade < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.notLvWoo"));
         }
         else if(param1.Grade < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.notOtherLvWoo"));
         }
         else if(PlayerManager.Instance.Self.IsMarried)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.IsMarried"));
         }
         else if(PlayerManager.Instance.Self.Sex == param1.Sex)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.notAllow"));
         }
         else if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
         }
         else
         {
            SocketManager.Instance.out.sendValidateMarry(param1.ID);
         }
      }
   }
}
