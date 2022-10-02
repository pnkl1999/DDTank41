package ddt.states
{
   import academy.AcademyController;
   import auctionHouse.controller.AuctionHouseController;
   import church.controller.ChurchRoomController;
   import church.controller.ChurchRoomListController;
   import civil.CivilController;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.utils.StringUtils;
   import consortion.ConsortionControl;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.view.UIModuleSmallLoading;
   import farm.viewx.FarmSwitchView;
   import fightLib.FightLibState;
   import fightLib.view.FightLibGameView;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import game.view.GameView;
   import hall.HallStateView;
   import hotSpring.controller.HotSpringRoomController;
   import hotSpring.controller.HotSpringRoomListController;
   import littleGame.LittleGame;
   import littleGame.LittleHall;
   import login.LoginStateView;
   import lottery.LotteryContorller;
   import lottery.contorller.CardLotteryContorller;
   import room.view.states.ChallengeRoomState;
   import room.view.states.DungeonRoomState;
   import room.view.states.FreshmanRoomState;
   import room.view.states.MatchRoomState;
   import room.view.states.MissionRoomState;
   import roomList.pveRoomList.DungeonListController;
   import roomList.pvpRoomList.RoomListController;
   import roomLoading.RoomLoadingState;
   import shop.ShopController;
   import tofflist.TofflistController;
   import trainer.view.TrainerGameView;
   import lightRoad.Controller.LightRoadController;
   import worldboss.WorldBossAwardController;
   import worldboss.WorldBossManager;
   import worldboss.WorldBossRoomController;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.view.WorldBossFightRoomState;
   
   public class StateCreater implements IStateCreator
   {
       
      
      private var _state:Dictionary;
      
      private var _currentStateType:String;
      
      public function StateCreater()
      {
         this._state = new Dictionary();
         super();
      }
      
      public function create(param1:String) : BaseStateView
      {
         switch(param1)
         {
            case StateType.LOGIN:
               return new LoginStateView();
            case StateType.MAIN:
               return new HallStateView();
            case StateType.ROOM_LOADING:
               return new RoomLoadingState();
            case StateType.ROOM_LIST:
               return new RoomListController();
            case StateType.TOFFLIST:
               return new TofflistController();
            case StateType.DUNGEON_LIST:
               return new DungeonListController();
            case StateType.CONSORTIA:
               return new ConsortionControl();
            case StateType.FARM:
               return new FarmSwitchView();
            case StateType.CHURCH_ROOM_LIST:
               return new ChurchRoomListController();
            case StateType.CHURCH_ROOM:
               return new ChurchRoomController();
            case StateType.SHOP:
               return new ShopController();
            case StateType.MATCH_ROOM:
               return new MatchRoomState();
            case StateType.DUNGEON_ROOM:
               return new DungeonRoomState();
            case StateType.CHALLENGE_ROOM:
               return new ChallengeRoomState();
            case StateType.TRAINER:
               return new TrainerGameView();
            case StateType.MISSION_ROOM:
               return new MissionRoomState();
            case StateType.FIGHTING:
               return new GameView();
            case StateType.CIVIL:
               return new CivilController();
            case StateType.HOT_SPRING_ROOM_LIST:
               return new HotSpringRoomListController();
            case StateType.HOT_SPRING_ROOM:
               return new HotSpringRoomController();
            case StateType.FRESHMAN_ROOM:
               return new FreshmanRoomState();
            case StateType.ACADEMY_REGISTRATION:
               return new AcademyController();
            case StateType.FIGHT_LIB:
               return new FightLibState();
            case StateType.FIGHT_LIB_GAMEVIEW:
               return new FightLibGameView();
            case StateType.LITTLEHALL:
               return new LittleHall();
            case StateType.LITTLEGAME:
               return new LittleGame();
            case StateType.AUCTION:
               return new AuctionHouseController();
            case StateType.LOTTERY_HALL:
               return new LotteryContorller();
            case StateType.LOTTERY_CARD:
               return new CardLotteryContorller();
			case StateType.WORLDBOSS_ROOM:
				return WorldBossRoomController.Instance;
			case StateType.WORLDBOSS_AWARD:
				return new WorldBossAwardController();
			case StateType.WORLDBOSS_FIGHT_ROOM:
				return new WorldBossFightRoomState();
			case StateType.LIGHTROAD_WINDOW:
				return LightRoadController.Instance;
            default:
               return null;
         }
      }
      
      public function createAsync(param1:String, param2:Function) : void
      {
         var _loc4_:int = 0;
         var _loc3_:StateLoadingInfo = this.getStateLoadingInfo(param1,this.getNeededUIModuleByType(param1),param2);
         this._currentStateType = param1;
         if(_loc3_.isComplete)
         {
            param2(this.create(param1));
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onCloseLoading);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUimoduleLoadComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUimoduleLoadProgress);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.neededUIModule.length)
            {
               UIModuleLoader.Instance.addUIModuleImp(_loc3_.neededUIModule[_loc4_],param1);
               _loc4_++;
            }
         }
      }
      
      private function __onCloseLoading(param1:Event) : void
      {
         if(PlayerManager.Instance.Self.Grade >= 2)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onCloseLoading);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUimoduleLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUimoduleLoadProgress);
			if(this._currentStateType == StateType.WORLDBOSS_FIGHT_ROOM)
			{
				WorldBossManager.Instance.dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.STOPFIGHT));
			}
         }
      }
      
      private function getStateLoadingInfo(param1:String, param2:String = null, param3:Function = null) : StateLoadingInfo
      {
         var _loc4_:StateLoadingInfo = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         _loc4_ = this._state[param1];
         if(_loc4_ == null)
         {
            _loc4_ = new StateLoadingInfo();
            if(param2 != null && param2 != "")
            {
               _loc5_ = param2.split(",");
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  _loc4_.neededUIModule.push(_loc5_[_loc6_]);
                  _loc6_++;
               }
            }
            else
            {
               _loc4_.isComplete = true;
            }
            _loc4_.state = param1;
            _loc4_.callBack = param3;
            this._state[param1] = _loc4_;
         }
         return _loc4_;
      }
      
      private function __onUimoduleLoadComplete(param1:UIModuleEvent) : void
      {
         var _loc5_:BaseStateView = null;
         if(StringUtils.isEmpty(param1.state))
         {
            return;
         }
         var _loc2_:StateLoadingInfo = this.getStateLoadingInfo(param1.state);
         if(_loc2_.completeedUIModule.indexOf(param1.module) == -1)
         {
            _loc2_.completeedUIModule.push(param1.module);
         }
         var _loc3_:Boolean = true;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.neededUIModule.length)
         {
            if(_loc2_.completeedUIModule.indexOf(_loc2_.neededUIModule[_loc4_]) == -1)
            {
               _loc3_ = false;
            }
            _loc4_++;
         }
         _loc2_.isComplete = _loc3_;
         if(_loc2_.isComplete && this._currentStateType == _loc2_.state)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUimoduleLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUimoduleLoadProgress);
            UIModuleSmallLoading.Instance.hide();
            _loc5_ = this.create(param1.state);
            if(_loc2_.callBack != null)
            {
               _loc2_.callBack(_loc5_);
            }
         }
      }
      
      private function __onUimoduleLoadError(param1:UIModuleEvent) : void
      {
      }
      
      private function __onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         var _loc2_:StateLoadingInfo = null;
         var _loc3_:StateLoadingInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         for each(_loc2_ in this._state)
         {
            if(_loc2_.neededUIModule.indexOf(param1.module) != -1)
            {
               _loc2_.progress[param1.module] = param1.loader.progress;
            }
         }
         _loc3_ = this.getStateLoadingInfo(param1.state);
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.neededUIModule.length)
         {
            if(_loc3_.progress[_loc3_.neededUIModule[_loc5_]] != null)
            {
               _loc6_ = _loc3_.progress[_loc3_.neededUIModule[_loc5_]];
               _loc4_ += _loc6_ * 100 / _loc3_.neededUIModule.length;
            }
            _loc5_++;
         }
         if(this._currentStateType == _loc3_.state)
         {
            UIModuleSmallLoading.Instance.progress = _loc4_;
         }
      }
      
      public function getNeededUIModuleByType(param1:String) : String
      {
         if(param1 == StateType.MAIN)
         {
            return UIModuleTypes.HALL;
         }
         if(param1 == StateType.TOFFLIST)
         {
            return UIModuleTypes.TOFFLIST;
         }
         if(param1 == StateType.CONSORTIA)
         {
            return UIModuleTypes.CONSORTIA + "," + UIModuleTypes.CONSORTIACLUB + "," + UIModuleTypes.CONSORTIAII + "," + UIModuleTypes.BANK;
         }
         if(param1 == StateType.SHOP)
         {
            return UIModuleTypes.SHOP;
         }
         if(param1 == StateType.ROOM_LIST || param1 == StateType.DUNGEON_LIST || param1 == StateType.DUNGEON_ROOM || param1 == StateType.MATCH_ROOM || param1 == StateType.FRESHMAN_ROOM || param1 == StateType.WORLDBOSS_FIGHT_ROOM)
         {
            return UIModuleTypes.ROOM_LIST + "," + UIModuleTypes.ROOM + "," + UIModuleTypes.GAME + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEOVER;
         }
         if(param1 == StateType.MATCH_ROOM || param1 == StateType.DUNGEON_ROOM)
         {
            return UIModuleTypes.ROOM + "," + UIModuleTypes.CHAT_BALL;
         }
         if(param1 == StateType.CHALLENGE_ROOM)
         {
            return UIModuleTypes.CHALLENGE_ROOM;
         }
         if(param1 == StateType.CHURCH_ROOM_LIST)
         {
            return UIModuleTypes.CHURCH_ROOM_LIST;
         }
         if(param1 == StateType.CHURCH_ROOM)
         {
            return UIModuleTypes.CHURCH_ROOM;
         }
         if(param1 == StateType.CIVIL)
         {
            return UIModuleTypes.CIVIL;
         }
         if(param1 == StateType.HOT_SPRING_ROOM_LIST)
         {
            return UIModuleTypes.HOT_SPRING_ROOM_LIST;
         }
         if(param1 == StateType.HOT_SPRING_ROOM)
         {
            return UIModuleTypes.HOT_SPRING_ROOM;
         }
         if(param1 == StateType.FIGHTING)
         {
            return UIModuleTypes.GAME + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEOVER + "," + UIModuleTypes.CHAT_BALL;
         }
         if(param1 == StateType.TRAINER)
         {
            return UIModuleTypes.GAME + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEOVER + "," + UIModuleTypes.ROOM + "," + UIModuleTypes.CHAT_BALL;
         }
         if(param1 == StateType.ACADEMY_REGISTRATION)
         {
            return UIModuleTypes.ACADEMY;
         }
         if(param1 == StateType.FIGHT_LIB)
         {
            return UIModuleTypes.FIGHT_LIB;
         }
         if(param1 == StateType.LITTLEHALL)
         {
            return UIModuleTypes.LITTLEGAME + "," + UIModuleTypes.SHOP;
         }
         if(param1 == StateType.AUCTION)
         {
            return UIModuleTypes.AUCTION;
         }
         if(param1 == StateType.FARM)
         {
            return UIModuleTypes.FARM + "," + UIModuleTypes.CHAT_BALL;
         }
         if(param1 == StateType.LOTTERY_CARD || param1 == StateType.LOTTERY_HALL)
         {
            return UIModuleTypes.LOTTERY;
         }
		 if(param1 == StateType.WORLDBOSS_AWARD)
		 {
			 return UIModuleTypes.WORLDBOSS_MAP + "," + UIModuleTypes.SHOP + "," + UIModuleTypes.LITTLEGAME;
		 }
		 if(param1 == StateType.WORLDBOSS_ROOM)
		 {
			 return UIModuleTypes.WORLDBOSS_MAP + "," + UIModuleTypes.ROOM + "," + UIModuleTypes.ROOM_LIST + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEOVER;
		 }
         return "";
      }
   }
}
