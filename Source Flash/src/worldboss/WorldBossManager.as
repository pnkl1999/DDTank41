package worldboss
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   
   import ddt.constants.CacheConsts;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.Helpers;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.model.WorldBossBuffInfo;
   import worldboss.model.WorldBossInfo;
   import worldboss.player.PlayerVO;
   import worldboss.player.RankingPersonInfo;
   import worldboss.view.WorldBossIcon;
   import worldboss.view.WorldBossRankingFram;
   
   import flash.external.ExternalInterface;
   
   public class WorldBossManager extends EventDispatcher
   {
      
      private static var _instance:WorldBossManager;
      
      public static var IsSuccessStartGame:Boolean = false;
       
      
      private var _ishallComplete:Boolean = false;
      
      private var _isOpen:Boolean = false;
      
      private var _mapload:BaseLoader;
      
      private var _bossInfo:WorldBossInfo;
      
      private var _entranceBtn:WorldBossIcon;
      
      private var _currentPVE_ID:int;
      
      private var _sky:MovieClip;
      
      public var iconEnterPath:String;
      
      public var mapPath:String;
      
      private var _iconContainer:VBox;
      
      private var _autoBuyBuffs:DictionaryData;
      
      private var _appearPos:Array;
      
      private var _isShowBlood:Boolean = false;
      
      private var _isBuyBuffAlert:Boolean = false;
      
      private var _bossResourceId:String;
      
      private var _rankingInfos:Vector.<RankingPersonInfo>;
      
      private var _autoBlood:Boolean = false;
      
      public function WorldBossManager()
      {
         this._autoBuyBuffs = new DictionaryData();
         this._appearPos = new Array();
         this._rankingInfos = new Vector.<RankingPersonInfo>();
         super();
      }
      
      public static function get Instance() : WorldBossManager
      {
         if(!WorldBossManager._instance)
         {
            WorldBossManager._instance = new WorldBossManager();
         }
         return WorldBossManager._instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_INIT,this.__initWorldBoss);
      }
      
      public function get BossResourceId() : String
      {
         return this._bossResourceId;
      }
	  
	  public function set BossResourceId(param1:String) : void
	  {
		  this._bossResourceId = param1;
	  }
	  
	  public function set CurrentPVE_ID(param1:int) : void
	  {
		  this._currentPVE_ID = param1;
	  }
      
      public function get isBuyBuffAlert() : Boolean
      {
         return this._isBuyBuffAlert;
      }
	  
	  public function set IconEnterPath(param1:String) : void
	  {
		  this.iconEnterPath = param1;
	  }
      
      public function set isBuyBuffAlert(param1:Boolean) : void
      {
         this._isBuyBuffAlert = param1;
      }
      
      public function get autoBuyBuffs() : DictionaryData
      {
         return this._autoBuyBuffs;
      }
      
      public function get isShowBlood() : Boolean
      {
         return this._isShowBlood;
      }
      
      public function get isAutoBlood() : Boolean
      {
         return this._autoBlood;
      }
      
      public function get rankingInfos() : Vector.<RankingPersonInfo>
      {
         return this._rankingInfos;
      }
      
      public function __initWorldBoss(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:WorldBossBuffInfo = null;
         this._bossResourceId = param1.pkg.readUTF();
         this._currentPVE_ID = param1.pkg.readInt();
         param1.pkg.readUTF();
         this.iconEnterPath = this.getWorldbossResource() + "/icon/worldbossIcon.swf";
		 this.creatEnterIcon();
         this.addSocketEvent();
         this._bossInfo.name = param1.pkg.readUTF();
         this._bossInfo.total_Blood = param1.pkg.readInt();
         this._bossInfo.current_Blood = this._bossInfo.total_Blood;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         this.mapPath = this.getWorldbossResource() + "/map/worldbossMap.swf";
         this._appearPos.length = 0;
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            this._appearPos.push(new Point(param1.pkg.readInt(),param1.pkg.readInt()));
            _loc5_++;
         }
         this._bossInfo.playerDefaultPos = Helpers.randomPick(this._appearPos);
         this._bossInfo.begin_time = param1.pkg.readDate();
         this._bossInfo.end_time = param1.pkg.readDate();
//		 ExternalInterface.call("console.log", "this._bossInfo.begin_time", this._bossInfo.begin_time);
//		 ExternalInterface.call("console.log", "this._bossInfo.end_time", this._bossInfo.end_time);
         this._bossInfo.fight_time = param1.pkg.readInt();
         this._bossInfo.fightOver = param1.pkg.readBoolean();
		 this._bossInfo.roomClose = param1.pkg.readBoolean();
         this._bossInfo.ticketID = param1.pkg.readInt();
         this._bossInfo.need_ticket_count = param1.pkg.readInt();
         this._bossInfo.timeCD = param1.pkg.readInt();
         this._bossInfo.reviveMoney = param1.pkg.readInt();
         this._bossInfo.buffArray.length = 0;
         var _loc6_:int = param1.pkg.readInt();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
			 
            _loc8_ = new WorldBossBuffInfo();
            _loc8_.ID = param1.pkg.readInt();
            _loc8_.name = param1.pkg.readUTF();
            _loc8_.price = param1.pkg.readInt();
            _loc8_.decription = param1.pkg.readUTF();
            _loc8_.costID = param1.pkg.readInt();
//			ExternalInterface.call("console.log", "_loc8_", _loc8_);
            this._bossInfo.buffArray.push(_loc8_);
			 
            _loc7_++;
         }
         this._isShowBlood = param1.pkg.readBoolean();
         this._autoBlood = param1.pkg.readBoolean();
         this.isOpen = true;
         this.addshowHallEntranceBtn();
		 this.creatEnterIcon(!this._bossInfo.roomClose);
         dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.GAME_INIT));
      }
      
      private function addSocketEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ENTER,this.__enter);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE,this.__update);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER,this.__fightOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE,this.__leaveRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING,this.__showRanking);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_OVER,this.__allOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_FULL,this.__gameRoomFull);
      }
      
      private function removeSocketEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ENTER,this.__enter);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE,this.__update);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER,this.__fightOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE,this.__leaveRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING,this.__showRanking);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_OVER,this.__allOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_FULL,this.__gameRoomFull);
      }
      
      private function __gameRoomFull(param1:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.WORLDBOSS_ROOM_FULL));
      }
	  
	  import hallIcon.HallIconManager;
	  import hallIcon.HallIconType;
      private function creatEnterIcon(isEndedEvent:Boolean = true) : void
      {
         //if(this.isOpen)
         //{
         //   return;
         //}
         //if(!this._entranceBtn)
         //{
         //   this._entranceBtn = new WorldBossIcon();
         //}
		 //this._entranceBtn = new WorldBossIcon();
		 if (this._bossInfo == null)
		 {
			 this._bossInfo = new WorldBossInfo();
		 }
         this._bossInfo.myPlayerVO = new PlayerVO();
		 
		 if (this._bossResourceId == "1")
		 {
			 HallIconManager.instance.updateSwitchHandler(HallIconType.WORLDBOSSENTRANCE1, isEndedEvent, null);
		 }
		 else if (this._bossResourceId == "2")
		 {
			 HallIconManager.instance.updateSwitchHandler(HallIconType.WANTSTRONG, isEndedEvent, null);
		 }
		 else if (this._bossResourceId == "4")
		 {
			 HallIconManager.instance.updateSwitchHandler(HallIconType.WORLDBOSSENTRANCE4, isEndedEvent, null);
		 }
      }
      
      private function __enter(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.pkg.bytesAvailable > 0 && param1.pkg.readBoolean())
         {
            this._bossInfo.isLiving = !param1.pkg.readBoolean();
            this._bossInfo.myPlayerVO.reviveCD = param1.pkg.readInt();
            _loc2_ = param1.pkg.readInt();
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._bossInfo.myPlayerVO.buffID = param1.pkg.readInt();
               _loc3_++;
            }
            if(this._bossInfo.myPlayerVO.reviveCD > 0)
            {
               this._bossInfo.myPlayerVO.playerStauts = 3;
               this._bossInfo.myPlayerVO.playerPos = new Point(int(Math.random() * 300 + 300),int(Math.random() * 850) + 250);
            }
            else
            {
               this._bossInfo.myPlayerVO.playerPos = this._bossInfo.playerDefaultPos;
               this._bossInfo.myPlayerVO.playerStauts = 1;
            }
            dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.ALLOW_ENTER));
         }
      }
      
      private function __update(param1:CrazyTankSocketEvent) : void
      {
         this._autoBlood = param1.pkg.readBoolean();
         this._bossInfo.total_Blood = param1.pkg.readInt();
         this._bossInfo.current_Blood = param1.pkg.readInt();
         dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.BOSS_HP_UPDATA));
      }
      
      private function __fightOver(param1:CrazyTankSocketEvent) : void
      {
         this._bossInfo.fightOver = true;
         this._bossInfo.isLiving = !param1.pkg.readBoolean();
         dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.FIGHT_OVER));
      }
      
      private function __leaveRoom(param1:Event) : void
      {
         this._bossInfo.roomClose = true;
         if(StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
         {
            StateManager.setState(StateType.WORLDBOSS_AWARD);
            WorldBossRoomController.Instance.dispose();
         }
         dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.ROOM_CLOSE));
      }
      
      private function __showRanking(param1:CrazyTankSocketEvent) : void
      {
         if(param1.pkg.readBoolean())
         {
            this.showRankingFrame(param1.pkg);
         }
         else
         {
            this.showRankingInRoom(param1.pkg);
         }
      }
      
      private function showRankingFrame(param1:PackageIn) : void
      {
         var _loc5_:RankingPersonInfo = null;
         this._rankingInfos.length = 0;
         WorldBossRankingFram._rankingPersons = new Array();
         var _loc2_:WorldBossRankingFram = ComponentFactory.Instance.creat("worldboss.ranking.frame");
         var _loc3_:int = param1.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new RankingPersonInfo();
            _loc5_.id = param1.readInt();
            _loc5_.name = param1.readUTF();
            _loc5_.damage = param1.readInt();
            _loc2_.addPersonRanking(_loc5_);
            this._rankingInfos.push(_loc5_);
            _loc4_++;
         }
         if(!(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT) && StateManager.currentStateType != StateType.WORLDBOSS_ROOM))
         {
            _loc2_.show();
         }
      }
      
      private function showRankingInRoom(param1:PackageIn) : void
      {
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_RANKING_INROOM,param1));
      }
      
      private function __allOver(param1:CrazyTankSocketEvent) : void
      {
         this._bossInfo.fightOver = true;
         this._bossInfo.roomClose = true;
         this.isOpen = false;
		 if(StateManager.currentStateType == StateType.WORLDBOSS_AWARD || StateManager.currentStateType == StateType.WORLDBOSS_FIGHT_ROOM || StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
		 {
			 StateManager.setState(StateType.MAIN);
		 }
         ///*
		 if(this._entranceBtn.parent)
         {
            this._entranceBtn.parent.removeChild(this._entranceBtn);
         }
         this._entranceBtn = null;
		 //*/
         this.removeSocketEvent();
      }
      
      public function enterGame() : void
      {
         SocketManager.Instance.out.enterUserGuide(WorldBossManager.Instance.currentPVE_ID,14);
         if(!WorldBossManager.Instance.bossInfo.fightOver)
         {
            IsSuccessStartGame = true;
            GameInSocketOut.sendGameStart();
            SocketManager.Instance.out.sendWorldBossRoomStauts(2);
            dispatchEvent(new Event(WorldBossRoomEvent.ENTERING_GAME));
         }
         else
         {
            StateManager.setState(StateType.WORLDBOSS_ROOM);
         }
      }
      
      public function exitGame() : void
      {
         IsSuccessStartGame = false;
         GameInSocketOut.sendGamePlayerExit();
      }
      
      public function showEntranceBtn() : void
      {
		  this._ishallComplete = true;
		  if(this._iconContainer == null || !this.isOpen)
		  {
			  return;
		  }
		  //this._iconContainer.addChild(this._entranceBtn);
		  //this._iconContainer.arrange();
		  //this._entranceBtn.setFrame(!!this._bossInfo.fightOver ? int(2) : int(1));
      }
      
      public function addshowHallEntranceBtn() : void
      {
         if(this._ishallComplete && StateManager.currentStateType == StateType.MAIN)
         {
            this.showEntranceBtn();
         }
      }
      
      public function showHallSkyEffort(param1:MovieClip) : void
      {
         if(param1 == this._sky)
         {
            return;
         }
         ObjectUtils.disposeObject(this._sky);
         this._sky = param1;
      }
      
      public function set isOpen(param1:Boolean) : void
      {
         this._isOpen = param1;
         //this._entranceBtn.visible = this.isOpen;
         //this._entranceBtn.setFrame(!!this._bossInfo.fightOver ? int(2) : int(1));
         if(StateManager.currentStateType == StateType.MAIN)
         {
            if(this._sky)
            {
               this._sky.visible = !this._bossInfo.fightOver;
            }
         }
         if((StateManager.currentStateType == StateType.WORLDBOSS_AWARD || StateManager.currentStateType == StateType.WORLDBOSS_ROOM) && !this.isOpen)
         {
            StateManager.setState(StateType.MAIN);
         }
      }
      
      public function buyBuff() : Boolean
      {
         var _loc5_:WorldBossBuffInfo = null;
         var _loc6_:WorldBossBuffInfo = null;
         var _loc7_:WorldBossBuffInfo = null;
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Number = PlayerManager.Instance.Self.Money;
         var _loc4_:Array = new Array();
         for each(_loc5_ in this._autoBuyBuffs.list)
         {
            _loc1_ += _loc5_.price;
         }
         _loc2_ = PlayerManager.Instance.Self.Money >= _loc1_;
         if(!_loc2_)
         {
            for each(_loc6_ in this._bossInfo.buffArray)
            {
               if(!this._autoBuyBuffs[_loc6_.ID] && _loc3_ >= _loc6_.price)
               {
                  _loc4_.push(_loc6_.ID);
                  _loc3_ -= _loc6_.price;
                  if(_loc3_ == 0)
                  {
                     break;
                  }
               }
            }
         }
         else
         {
            for each(_loc7_ in this._autoBuyBuffs.list)
            {
               _loc4_.push(_loc7_.ID);
            }
         }
         SocketManager.Instance.out.sendBuyWorldBossBuff(_loc4_);
         return _loc2_;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get currentPVE_ID() : int
      {
         return this._currentPVE_ID;
      }
      
      public function get bossInfo() : WorldBossInfo
      {
         return this._bossInfo;
      }
      
      public function getWorldbossResource() : String
      {
         return PathManager.SITE_MAIN + "image/worldboss/" + this._bossResourceId;
      }
      
      public function set iconContainer(param1:VBox) : void
      {
         this._iconContainer = param1;
      }
      
      public function showRankingText() : void
      {
         var _loc3_:RankingPersonInfo = null;
         WorldBossRankingFram._rankingPersons = new Array();
         var _loc1_:WorldBossRankingFram = ComponentFactory.Instance.creat("worldboss.ranking.frame");
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc3_ = new RankingPersonInfo();
            _loc3_.id = 1;
            _loc3_.name = "hawang" + _loc2_;
            _loc3_.damage = 2 * _loc2_ + _loc2_ * _loc2_ + 50;
            _loc1_.addPersonRanking(_loc3_);
            _loc2_++;
         }
         _loc1_.show();
      }
   }
}
