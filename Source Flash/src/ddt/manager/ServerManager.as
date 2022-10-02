package ddt.manager
{
   import baglocked.BagLockedController;
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.DDT;
   import ddt.data.ServerInfo;
   import ddt.data.analyze.ServerListAnalyzer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import pet.sprite.PetSpriteController;
   import road7th.comm.PackageIn;
   
   [Event(name="change",type="flash.events.Event")]
   public class ServerManager extends EventDispatcher
   {
      
      public static const CHANGE_SERVER:String = "changeServer";
      
      public static var AUTO_UNLOCK:Boolean = false;
      
      private static const CONNENT_TIME_OUT:int = 30000;
      
      private static var _instance:ServerManager;
       
      
      private var _list:Vector.<ServerInfo>;
      
      private var _current:ServerInfo;
      
      private var _zoneName:String;
      
      private var _agentid:int;
      
      private var _connentTimer:Timer;
      
      public function ServerManager()
      {
         super();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOGIN,this.__onLoginComplete);
      }
      
      public static function get Instance() : ServerManager
      {
         if(_instance == null)
         {
            _instance = new ServerManager();
         }
         return _instance;
      }
      
      public function get zoneName() : String
      {
         return this._zoneName;
      }
      
      public function set zoneName(param1:String) : void
      {
         this._zoneName = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get AgentID() : int
      {
         return this._agentid;
      }
      
      public function set AgentID(param1:int) : void
      {
         this._agentid = param1;
      }
      
      public function set current(param1:ServerInfo) : void
      {
         this._current = param1;
      }
      
      public function get current() : ServerInfo
      {
         return this._current;
      }
      
      public function get list() : Vector.<ServerInfo>
      {
         return this._list;
      }
      
      public function set list(param1:Vector.<ServerInfo>) : void
      {
         this._list = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function setup(param1:ServerListAnalyzer) : void
      {
         this._list = param1.list;
         this._agentid = param1.agentId;
         this._zoneName = param1.zoneName;
      }
      
      public function canAutoLogin() : Boolean
      {
         this.searchAvailableServer();
         return this._current != null;
      }
      
      public function connentCurrentServer() : void
      {
         SocketManager.Instance.isLogin = false;
         SocketManager.Instance.connect(this._current.IP,this._current.Port);
      }
      
      private function searchAvailableServer() : void
      {
         var _loc1_:PlayerInfo = PlayerManager.Instance.Self;
         if(DDT.SERVER_ID != -1)
         {
            this._current = this._list[DDT.SERVER_ID];
            return;
         }
         this._current = this.searchServerByState(ServerInfo.UNIMPEDED);
         if(this._current == null)
         {
            this._current = this.searchServerByState(ServerInfo.HALF);
         }
         if(this._current == null)
         {
            this._current = this._list[0];
         }
      }
      
      private function searchServerByState(param1:int) : ServerInfo
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._list.length)
         {
            if(this._list[_loc2_].State == param1)
            {
               return this._list[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function connentServer(param1:ServerInfo) : Boolean
      {
         var _loc2_:BaseAlerFrame = null;
         if(param1 == null)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.choose"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.MustLevel < PlayerManager.Instance.Self.Grade)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.your"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.LowestLevel > PlayerManager.Instance.Self.Grade)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.low"));
            this.alertControl(_loc2_);
            return false;
         }
         if(SocketManager.Instance.socket.connected && SocketManager.Instance.socket.isSame(param1.IP,param1.Port) && SocketManager.Instance.isLogin)
         {
            StateManager.setState(StateType.MAIN);
            return false;
         }
         if(param1.State == ServerInfo.ALL_FULL)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.full"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.State == ServerInfo.MAINTAIN)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.maintenance"));
            this.alertControl(_loc2_);
            return false;
         }
         this._current = param1;
         this.connentCurrentServer();
         dispatchEvent(new Event(CHANGE_SERVER));
         return true;
      }
      
      private function alertControl(param1:BaseAlerFrame) : void
      {
         param1.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         _loc2_.dispose();
      }
      
      private function __onLoginComplete(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:BaseAlerFrame = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:SelfInfo = PlayerManager.Instance.Self;
         if(_loc2_.readByte() == 0)
         {
            _loc3_.beginChanges();
            SocketManager.Instance.isLogin = true;
            _loc3_.ZoneID = _loc2_.readInt();
            _loc3_.Attack = _loc2_.readInt();
            _loc3_.Defence = _loc2_.readInt();
            _loc3_.Agility = _loc2_.readInt();
            _loc3_.Luck = _loc2_.readInt();
            _loc3_.GP = _loc2_.readInt();
            _loc3_.Repute = _loc2_.readInt();
            _loc3_.Gold = _loc2_.readInt();
            _loc3_.Money = _loc2_.readInt();
            _loc3_.medal = _loc2_.readInt();
            _loc3_.Score = _loc2_.readInt();
            _loc3_.Hide = _loc2_.readInt();
            _loc3_.FightPower = _loc2_.readInt();
            _loc3_.apprenticeshipState = _loc2_.readInt();
            _loc3_.masterID = _loc2_.readInt();
            _loc3_.setMasterOrApprentices(_loc2_.readUTF());
            _loc3_.graduatesCount = _loc2_.readInt();
            _loc3_.honourOfMaster = _loc2_.readUTF();
            _loc3_.freezesDate = _loc2_.readDate();
            _loc3_.typeVIP = _loc2_.readByte();
            _loc3_.VIPLevel = _loc2_.readInt();
            _loc3_.VIPExp = _loc2_.readInt();
            _loc3_.VIPExpireDay = _loc2_.readDate();
            _loc3_.LastDate = _loc2_.readDate();
            _loc3_.VIPNextLevelDaysNeeded = _loc2_.readInt();
            _loc3_.systemDate = _loc2_.readDate();
            _loc3_.canTakeVipReward = _loc2_.readBoolean();
            _loc3_.OptionOnOff = _loc2_.readInt();
            _loc3_.AchievementPoint = _loc2_.readInt();
            _loc3_.honor = _loc2_.readUTF();
            _loc3_.honorId = _loc2_.readInt();
            TimeManager.Instance.totalGameTime = _loc2_.readInt();
            _loc3_.Sex = _loc2_.readBoolean();
            _loc4_ = _loc2_.readUTF();
            _loc5_ = _loc4_.split("&");
            _loc3_.Style = _loc5_[0];
            _loc3_.Colors = _loc5_[1];
            _loc3_.Skin = _loc2_.readUTF();
            _loc3_.ConsortiaID = _loc2_.readInt();
            _loc3_.ConsortiaName = _loc2_.readUTF();
            _loc3_.badgeID = _loc2_.readInt();
            _loc3_.DutyLevel = _loc2_.readInt();
            _loc3_.DutyName = _loc2_.readUTF();
            _loc3_.Right = _loc2_.readInt();
            _loc3_.consortiaInfo.ChairmanName = _loc2_.readUTF();
            _loc3_.consortiaInfo.Honor = _loc2_.readInt();
            _loc3_.consortiaInfo.Riches = _loc2_.readInt();
            _loc6_ = _loc2_.readBoolean();
            _loc7_ = _loc3_.bagPwdState && !_loc3_.bagLocked;
            _loc3_.bagPwdState = _loc6_;
            if(_loc7_)
            {
               setTimeout(this.releaseLock,1000);
            }
            _loc3_.bagLocked = _loc6_;
            _loc3_.questionOne = _loc2_.readUTF();
            _loc3_.questionTwo = _loc2_.readUTF();
            _loc3_.leftTimes = _loc2_.readInt();
            _loc3_.LoginName = _loc2_.readUTF();
            _loc3_.Nimbus = _loc2_.readInt();
            TaskManager.requestCanAcceptTask();
            _loc3_.PvePermission = _loc2_.readUTF();
            _loc3_.fightLibMission = _loc2_.readUTF();
            _loc3_.userGuildProgress = _loc2_.readInt();
            BossBoxManager.instance.receiebox = _loc2_.readInt();
            BossBoxManager.instance.receieGrade = _loc2_.readInt();
            BossBoxManager.instance.needGetBoxTime = _loc2_.readInt();
            BossBoxManager.instance.currentGrade = PlayerManager.Instance.Self.Grade;
            BossBoxManager.instance.startGradeChangeEvent();
            BossBoxManager.instance.startDelayTime();
            _loc3_.LastSpaDate = _loc2_.readDate();
            _loc3_.shopFinallyGottenTime = _loc2_.readDate();
            _loc3_.UseOffer = _loc2_.readInt();
            _loc3_.matchInfo.dailyScore = _loc2_.readInt();
            _loc3_.matchInfo.dailyWinCount = _loc2_.readInt();
            _loc3_.matchInfo.dailyGameCount = _loc2_.readInt();
            _loc3_.DailyLeagueFirst = _loc2_.readBoolean();
            _loc3_.DailyLeagueLastScore = _loc2_.readInt();
            _loc3_.matchInfo.weeklyScore = _loc2_.readInt();
            _loc3_.matchInfo.weeklyGameCount = _loc2_.readInt();
            _loc3_.matchInfo.weeklyRanking = _loc2_.readInt();
            _loc3_.spdTexpExp = _loc2_.readInt();
            _loc3_.attTexpExp = _loc2_.readInt();
            _loc3_.defTexpExp = _loc2_.readInt();
            _loc3_.hpTexpExp = _loc2_.readInt();
            _loc3_.lukTexpExp = _loc2_.readInt();
            _loc3_.texpTaskCount = _loc2_.readInt();
            _loc3_.texpCount = _loc2_.readInt();
            _loc3_.texpTaskDate = _loc2_.readDate();
            _loc3_.isOldPlayerHasValidEquitAtLogin = _loc2_.readBoolean();
            _loc3_.badLuckNumber = _loc2_.readInt();
            _loc3_.luckyNum = _loc2_.readInt();
            _loc3_.lastLuckyNumDate = _loc2_.readDate();
            _loc3_.lastLuckNum = _loc2_.readInt();
            _loc3_.accumulativeLoginDays = _loc2_.readInt();
            _loc3_.accumulativeAwardDays = _loc2_.readInt();
			_loc3_.totemId = _loc2_.readInt();
			_loc3_.necklaceExp = _loc2_.readInt();
			_loc3_.fineSuitExp = _loc2_.readInt();
            _loc3_.commitChanges();
            MapManager.buildMap();
            PlayerManager.Instance.Self.loadRelatedPlayersInfo();
            StateManager.setState(StateType.MAIN);
            ExternalInterfaceManager.sendTo360Agent(4);
            StartupResourceLoader.Instance.startLoadRelatedInfo();
            SocketManager.Instance.out.sendPlayerGift(_loc3_.ID);
            CalendarManager.getInstance().requestLuckyNum();
            if(DesktopManager.Instance.isDesktop)
            {
               setTimeout(TaskManager.onDesktopApp,500);
            }
            PetSpriteController.Instance.setup();
			CheckSpeedManager.instance.startDelayTime1();
         }
         else
         {
            _loc8_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ServerLinkError"));
            this.alertControl(_loc8_);
         }
      }
      
      private function releaseLock() : void
      {
         AUTO_UNLOCK = true;
         SocketManager.Instance.out.sendBagLocked(BagLockedController.PWD,2);
      }
   }
}
