package church.controller
{
   import baglocked.BaglockedManager;
   import church.events.WeddingRoomEvent;
   import church.model.ChurchRoomModel;
   import church.view.weddingRoom.WeddingRoomSwitchMovie;
   import church.view.weddingRoom.WeddingRoomView;
   import church.vo.PlayerVO;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.constants.CacheConsts;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class ChurchRoomController extends BaseStateView
   {
       
      
      private var _sceneModel:ChurchRoomModel;
      
      private var _view:WeddingRoomView;
      
      private var timer:Timer;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      public function ChurchRoomController()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function getBackType() : String
      {
         return StateType.CHURCH_ROOM_LIST;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         ChurchManager.instance.removeLoadingEvent();
         CacheSysManager.lock(CacheConsts.ALERT_IN_MARRY);
         super.enter(param1,param2);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         SocketManager.Instance.out.sendCurrentState(0);
         MainToolBar.Instance.hide();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._sceneModel = new ChurchRoomModel();
         this._view = new WeddingRoomView(this,this._sceneModel);
         this._view.show();
         this.resetTimer();
      }
      
      public function resetTimer() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            _loc1_ = ChurchManager.instance.currentRoom.creactTime;
            _loc2_ = TimeManager.Instance.TotalDaysToNow(_loc1_) * 24;
            _loc3_ = (ChurchManager.instance.currentRoom.valideTimes - _loc2_) * 60;
            if(_loc3_ > 10)
            {
               this.stopTimer();
               this.timer = new Timer((_loc3_ - 10) * 60 * 1000,1);
               this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
               this.timer.start();
            }
         }
      }
      
      private function __timerComplete(param1:TimerEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.timerComplete"));
         var _loc2_:ChatData = new ChatData();
         _loc2_.channel = ChatInputView.SYS_NOTICE;
         _loc2_.msg = LanguageMgr.GetTranslation("church.churchScene.SceneControler.timerComplete.msg");
         ChatManager.Instance.chat(_loc2_);
         this.stopTimer();
      }
      
      private function stopTimer() : void
      {
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this.timer = null;
         }
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,this.__addPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,this.__removePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MOVE,this.__movePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HYMENEAL,this.__startWedding);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTINUATION,this.__continuation);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HYMENEAL_STOP,this.__stopWedding);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USEFIRECRACKERS,this.__onUseFire);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GUNSALUTE,this.__onUseSalute);
         ChurchManager.instance.currentRoom.addEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE,this.__updateWeddingStatus);
         ChurchManager.instance.currentRoom.addEventListener(WeddingRoomEvent.ROOM_VALIDETIME_CHANGE,this.__updateValidTime);
         ChurchManager.instance.addEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__sceneChange);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,this.__addPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,this.__removePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MOVE,this.__movePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HYMENEAL,this.__startWedding);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTINUATION,this.__continuation);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HYMENEAL_STOP,this.__stopWedding);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USEFIRECRACKERS,this.__onUseFire);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GUNSALUTE,this.__onUseSalute);
         ChurchManager.instance.currentRoom.removeEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE,this.__updateWeddingStatus);
         ChurchManager.instance.currentRoom.removeEventListener(WeddingRoomEvent.ROOM_VALIDETIME_CHANGE,this.__updateValidTime);
         ChurchManager.instance.removeEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__sceneChange);
      }
      
      private function __continuation(param1:CrazyTankSocketEvent) : void
      {
         if(ChurchManager.instance.currentRoom)
         {
            ChurchManager.instance.currentRoom.valideTimes = param1.pkg.readInt();
         }
      }
      
      private function __updateValidTime(param1:WeddingRoomEvent) : void
      {
         this.resetTimer();
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         ChurchManager.instance.currentRoom = null;
         ChurchManager.instance.currentScene = false;
         SocketManager.Instance.out.sendExitRoom();
         super.leaving(param1);
      }
      
      override public function getType() : String
      {
         return StateType.CHURCH_ROOM;
      }
      
      public function __addPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:PlayerInfo = new PlayerInfo();
         _loc3_.beginChanges();
         _loc3_.Grade = _loc2_.readInt();
         _loc3_.Hide = _loc2_.readInt();
         _loc3_.Repute = _loc2_.readInt();
         _loc3_.ID = _loc2_.readInt();
         _loc3_.NickName = _loc2_.readUTF();
         _loc3_.typeVIP = _loc2_.readByte();
         _loc3_.VIPLevel = _loc2_.readInt();
         _loc3_.Sex = _loc2_.readBoolean();
         _loc3_.Style = _loc2_.readUTF();
         _loc3_.Colors = _loc2_.readUTF();
         _loc3_.Skin = _loc2_.readUTF();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         _loc3_.FightPower = _loc2_.readInt();
         _loc3_.WinCount = _loc2_.readInt();
         _loc3_.TotalCount = _loc2_.readInt();
         _loc3_.Offer = _loc2_.readInt();
         _loc3_.commitChanges();
         var _loc6_:PlayerVO = new PlayerVO();
         _loc6_.playerInfo = _loc3_;
         _loc6_.playerPos = new Point(_loc4_,_loc5_);
         if(_loc3_.ID == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         this._sceneModel.addPlayer(_loc6_);
      }
      
      public function __removePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.clientId;
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(StateType.CHURCH_ROOM_LIST);
         }
         else
         {
            if(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
            {
               return;
            }
            this._sceneModel.removePlayer(_loc2_);
         }
      }
      
      public function __movePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:Point = null;
         var _loc2_:int = param1.pkg.clientId;
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         if(ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
         {
            return;
         }
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         var _loc6_:Array = _loc5_.split(",");
         var _loc7_:Array = [];
         var _loc8_:uint = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = new Point(_loc6_[_loc8_],_loc6_[_loc8_ + 1]);
            _loc7_.push(_loc9_);
            _loc8_ += 2;
         }
         this._view.movePlayer(_loc2_,_loc7_);
      }
      
      private function __updateWeddingStatus(param1:WeddingRoomEvent) : void
      {
         if(!ChurchManager.instance.currentScene)
         {
            this._view.switchWeddingView();
         }
      }
      
      public function playWeddingMovie() : void
      {
         this._view.playerWeddingMovie();
      }
      
      public function startWedding() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:PlayerVO = null;
         if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self) && ChurchManager.instance.currentRoom.status != ChurchRoomInfo.WEDDING_ING)
         {
            _loc1_ = ChurchManager.instance.currentRoom.creactTime;
            _loc2_ = TimeManager.Instance.TotalDaysToNow(_loc1_) * 24;
            _loc3_ = (ChurchManager.instance.currentRoom.valideTimes - _loc2_) * 60;
            if(_loc3_ < 10)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.valid"));
               return;
            }
            _loc4_ = this._sceneModel.getPlayerFromID(PlayerManager.Instance.Self.SpouseID);
            if(!_loc4_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.spouse"));
               return;
            }
            if(ChurchManager.instance.currentRoom.isStarted)
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.isStarted"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
               return;
            }
            SocketManager.Instance.out.sendStartWedding();
         }
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var _loc2_:PlayerVO = null;
         if(this._baseAlerFrame)
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.Money < 999)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               _loc2_ = this._sceneModel.getPlayerFromID(PlayerManager.Instance.Self.SpouseID);
               if(!_loc2_)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.spouse"));
                  return;
               }
               SocketManager.Instance.out.sendStartWedding();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
         }
      }
      
      private function __startWedding(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = param1.pkg.readBoolean();
         if(_loc3_)
         {
            ChurchManager.instance.currentRoom.isStarted = true;
            ChurchManager.instance.currentRoom.status = ChurchRoomInfo.WEDDING_ING;
         }
      }
      
      private function __stopWedding(param1:CrazyTankSocketEvent) : void
      {
         ChurchManager.instance.currentRoom.status = ChurchRoomInfo.WEDDING_NONE;
      }
      
      public function modifyDiscription(param1:String, param2:Boolean, param3:String, param4:String) : void
      {
         SocketManager.Instance.out.sendModifyChurchDiscription(param1,param2,param3,param4);
      }
      
      public function useFire(param1:int, param2:int) : void
      {
         this._view.useFire(param1,param2);
      }
      
      private function __onUseFire(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         this.useFire(_loc2_,_loc3_);
      }
      
      private function __onUseSalute(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         this.setSaulte(_loc2_);
      }
      
      public function setSaulte(param1:int) : void
      {
         this._view.setSaulte(param1);
      }
      
      private function __sceneChange(param1:WeddingRoomEvent) : void
      {
         this.readyEnterScene();
      }
      
      public function readyEnterScene() : void
      {
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         var _loc1_:WeddingRoomSwitchMovie = new WeddingRoomSwitchMovie(true,0.06);
         addChild(_loc1_);
         _loc1_.playMovie();
         _loc1_.addEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__readyEnterOk);
      }
      
      private function __readyEnterOk(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(WeddingRoomSwitchMovie.SWITCH_COMPLETE,this.__readyEnterOk);
         this.enterScene();
      }
      
      public function enterScene() : void
      {
         var _loc1_:Point = null;
         this._sceneModel.reset();
         if(!ChurchManager.instance.currentScene)
         {
            _loc1_ = new Point(514,637);
         }
         this._view.setMap(_loc1_);
         var _loc2_:int = !!ChurchManager.instance.currentScene ? int(int(2)) : int(int(1));
         SocketManager.Instance.out.sendSceneChange(_loc2_);
      }
      
      public function giftSubmit(param1:uint) : void
      {
         SocketManager.Instance.out.sendChurchLargess(param1);
      }
      
      public function roomContinuation(param1:int) : void
      {
         SocketManager.Instance.out.sendChurchContinuation(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.stopTimer();
         if(this._sceneModel)
         {
            this._sceneModel.dispose();
         }
         this._sceneModel = null;
         if(this._view)
         {
            if(this._view.parent)
            {
               this._view.parent.removeChild(this._view);
            }
            this._view.dispose();
         }
         this._view = null;
         CacheSysManager.unlock(CacheConsts.ALERT_IN_MARRY);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_MARRY);
      }
   }
}
