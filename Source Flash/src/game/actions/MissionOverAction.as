package game.actions
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.map.MissionInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.FightLibManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getDefinitionByName;
   import game.GameManager;
   import game.model.BaseSettleInfo;
   import game.model.GameInfo;
   import game.model.Player;
   import game.view.MissionOverInfoPanel;
   import game.view.experience.ExpView;
   import game.view.map.MapView;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.NewHandQueue;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import trainer.view.BaseExplainFrame;
   import trainer.view.ExplainOne;
   import trainer.view.ExplainPlane;
   import trainer.view.ExplainPowerThree;
   import trainer.view.ExplainTen;
   import trainer.view.ExplainThreeFourFive;
   import trainer.view.ExplainTwoTwenty;
   import trainer.view.NewHandContainer;
   
   import worldboss.WorldBossRoomController;
   import ddt.manager.SocketManager;
   
   public class MissionOverAction extends BaseAction
   {
       
      
      private var _event:CrazyTankSocketEvent;
      
      private var _executed:Boolean;
      
      private var _count:int;
      
      private var _map:MapView;
      
      private var _func:Function;
      
      private var infoPane:MissionOverInfoPanel;
      
      private var _clicked:Boolean;
      
      private var _c:int;
      
      private var _one:ExplainOne;
      
      private var _win:MovieClipWrapper;
      
      private var _ten:ExplainTen;
      
      private var _powerThree:ExplainPowerThree;
      
      private var _plane:ExplainPlane;
      
      private var _twoTwenty:ExplainTwoTwenty;
      
      private var _threeFourFive:ExplainThreeFourFive;
      
      private var _lost:MovieClipWrapper;
      
      public function MissionOverAction(param1:MapView, param2:CrazyTankSocketEvent, param3:Function, param4:Number = 3000)
      {
         super();
         this._event = param2;
         this._map = param1;
         this._func = param3;
         this._count = param4 / 40;
         this.readInfo(this._event);
      }
      
      public static function getGradedStr(param1:int) : String
      {
         if(param1 >= 3)
         {
            return "S";
         }
         if(param1 >= 2)
         {
            return "A";
         }
         if(param1 == 0)
         {
            return "C";
         }
         if(param1 < 2)
         {
            return "B";
         }
         return "C";
      }
      
      private function readInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc6_:Object = null;
         var _loc7_:BaseSettleInfo = null;
         var _loc8_:Player = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:uint = 0;
         _loc2_ = param1.pkg;
         var _loc3_:GameInfo = GameManager.Instance.Current;
         _loc3_.missionInfo.missionOverPlayer = [];
         _loc3_.missionInfo.tackCardType = _loc2_.readInt();
         _loc3_.hasNextMission = _loc2_.readBoolean();
         if(_loc3_.hasNextMission)
         {
            _loc3_.missionInfo.pic = _loc2_.readUTF();
         }
         _loc3_.missionInfo.canEnterFinall = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new Object();
            _loc7_ = new BaseSettleInfo();
            _loc7_.playerid = _loc2_.readInt();
            _loc7_.level = _loc2_.readInt();
            _loc7_.treatment = _loc2_.readInt();
            _loc8_ = _loc3_.findGamerbyPlayerId(_loc7_.playerid);
            _loc6_.gainGP = _loc2_.readInt();
            _loc8_.isWin = _loc2_.readBoolean();
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc8_.GetCardCount = _loc9_;
            _loc8_.BossCardCount = _loc9_;
            _loc8_.hasLevelAgain = _loc2_.readBoolean();
            _loc8_.hasGardGet = _loc2_.readBoolean();
            if(_loc8_.isWin)
            {
               if(_loc9_ == 0)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_0;
               }
               else if(_loc9_ == 1 && !_loc3_.hasNextMission)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_6;
               }
               else if(_loc9_ == 1 && _loc3_.hasNextMission)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_2;
               }
               else if(_loc9_ == 2 && _loc3_.hasNextMission)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_3;
               }
               else if(_loc9_ == 2 && !_loc3_.hasNextMission)
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_4;
               }
               else
               {
                  _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_0;
               }
            }
            else
            {
               _loc6_.gameOverType = ExpView.GAME_OVER_TYPE_5;
			   if(RoomManager.Instance.current.type == 14)
			   {
				   SocketManager.Instance.out.sendWorldBossRoomStauts(3);
				   WorldBossRoomController.Instance.setSelfStatus(3);
			   }
            }
            _loc8_.expObj = _loc6_;
            if(_loc8_.playerInfo.ID == _loc3_.selfGamePlayer.playerInfo.ID)
            {
               _loc3_.selfGamePlayer.BossCardCount = _loc8_.BossCardCount;
            }
            _loc3_.missionInfo.missionOverPlayer.push(_loc7_);
            _loc5_++;
         }
         if(_loc3_.selfGamePlayer.BossCardCount > 0)
         {
            _loc11_ = _loc2_.readInt();
            _loc3_.missionInfo.missionOverNPCMovies = [];
            _loc12_ = 0;
            while(_loc12_ < _loc11_)
            {
               _loc3_.missionInfo.missionOverNPCMovies.push(_loc2_.readUTF());
               _loc12_++;
            }
         }
         _loc3_.missionInfo.nextMissionIndex = _loc3_.missionInfo.missionIndex + 1;
      }
      
      override public function cancel() : void
      {
         this._event.executed = true;
      }
      
      override public function execute() : void
      {
         var _loc1_:MovieClipWrapper = null;
         _loc1_ = null;
         var _loc2_:MovieClip = null;
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._executed = true;
         }
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            if(GameManager.Instance.Current.selfGamePlayer.isWin)
            {
               if(NewHandGuideManager.Instance.mapID == 111)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_EXPLAIN_ONE,this.exeExplainOne,this.preExplainOne,this.finExplainOne,0,true));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN,this.exeWin,this.preWin,this.finWin));
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 112)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_EXPLAIN_TEN,this.exeExplainTen,this.preExplainTen,this.finExplainTen));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_I,this.exeWin,this.preWin,this.finWinI));
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 113)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_POWER_THREE,this.exePowerThree,this.prePowerThree,this.finPowerThree));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_II,this.exeWin,this.preWin,this.finWinI));
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 114)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_PLANE,this.exePlane,this.prePlane,this.finPlane));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_III,this.exeWin,this.preWin,this.finWinI));
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 115)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_TWO_TWENTY,this.exeTwoTwenty,this.preTwoTwenty,this.finTwoTwenty));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_IV,this.exeWin,this.preWin,this.finWinI));
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 116)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_THREE_FOUR_FIVE,this.exeThreeFourFive,this.preThreeFourFive,this.finThreeFourFive));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_V,this.exeWin,this.preWin,this.finWinI));
                  _isFinished = true;
                  return;
               }
            }
            else
            {
               switch(NewHandGuideManager.Instance.mapID)
               {
                  case 111:
                  case 112:
                  case 113:
                  case 114:
                  case 115:
                  case 116:
                     NewHandQueue.Instance.push(new Step(Step.POP_LOST,this.exeLost,this.preLost,this.finLost));
                     _isFinished = true;
                     return;
               }
            }
         }
         if(!this._executed)
         {
            if(this._map.hasSomethingMoving() == false && (this._map.currentPlayer == null || this._map.currentPlayer.actionCount == 0))
            {
               this._executed = true;
               this._event.executed = true;
               if(this._map.currentPlayer)
               {
                  this._map.currentPlayer.beginNewTurn();
               }
               this.infoPane = new MissionOverInfoPanel();
               this.upContextView(this.infoPane);
               if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
               {
                  FightLibManager.Instance.lastWin = GameManager.Instance.Current.selfGamePlayer.isWin;
               }
               if(GameManager.Instance.Current.selfGamePlayer.isWin)
               {
                  _loc2_ = ClassUtils.CreatInstance("asset.game.winAsset");
               }
               else
               {
                  _loc2_ = ClassUtils.CreatInstance("asset.game.lostAsset");
               }
               this.infoPane.x = 77;
               _loc2_.addChild(this.infoPane);
               _loc1_ = new MovieClipWrapper(_loc2_,true,true);
               SoundManager.instance.play("040");
               _loc1_.movie.x = 500;
               _loc1_.movie.y = 360;
               _loc1_.addEventListener(Event.COMPLETE,this.__complete);
               this._map.gameView.addChild(_loc1_.movie);
            }
         }
         else
         {
            --this._count;
            if(this._count <= 0)
            {
               this._func();
               _isFinished = true;
            }
         }
      }
      
      private function __explainEnter(param1:Event) : void
      {
         (param1.currentTarget as EventDispatcher).removeEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
         this._clicked = true;
      }
      
      private function preExplainOne() : void
      {
         NewHandContainer.Instance.showMovie("asset.trainer.pickOneMove");
      }
      
      private function exeExplainOne() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._one = ComponentFactory.Instance.creatCustomObject("trainer.ExplainOne");
            this._one.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._one.show();
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.pickOneMove");
         }
         return this._clicked;
      }
      
      private function finExplainOne() : void
      {
         this._one.dispose();
         this._one = null;
      }
      
      private function preWin() : void
      {
         SoundManager.instance.stopMusic();
         SoundManager.instance.setMusicVolumeByRatio(2);
         this._win = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.winAsset"),true,true);
         this._win.movie.x = 500;
         this._win.movie.y = 360;
         this._map.gameView.addChild(this._win.movie);
         SoundManager.instance.play("040");
      }
      
      private function exeWin() : Boolean
      {
         return this._win.movie.currentFrame == this._win.movie.totalFrames;
      }
      
      private function finWin() : void
      {
         StateManager.setState(StateType.MAIN);
         this._win = null;
         NewHandQueue.Instance.dispose();
      }
      
      private function preExplainTen() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.pickTenMove");
      }
      
      /*private function exeExplainTen() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._ten = ComponentFactory.Instance.creatCustomObject("trainer.ExplainTen");
            this._ten.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._ten.show();
            getDefinitionByName("TrainerStep").instance.send(getDefinitionByName("TrainerStep").GET_ADD_HARM);
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.pickTenMove");
         }
         return this._clicked;
      }*/
	  
	  private function exeExplainTen() : Boolean
	  {
		  _c++;
		  if(_c == 51)
		  {
			  _ten = ComponentFactory.Instance.creatCustomObject("trainer.ExplainTen");
			  _ten.addEventListener("explainEnter",__explainEnter);
			  _ten.show();
		  }
		  else if(_c == 55)
		  {
			  NewHandContainer.Instance.hideMovie("asset.trainer.pickTenMove");
		  }
		  return _clicked;
	  }
      
      private function finExplainTen() : void
      {
         this._ten.dispose();
         this._ten = null;
      }
      
      private function finWinI() : void
      {
         this._win = null;
         NewHandQueue.Instance.dispose();
         this._func();
      }
      
      private function prePowerThree() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.getPowerThreeMove");
      }
      
      private function exePowerThree() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._powerThree = ComponentFactory.Instance.creatCustomObject("trainer.ExplainPowerThree");
            this._powerThree.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._powerThree.show();
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.getPowerThreeMove");
         }
         return this._clicked;
      }
      
      private function finPowerThree() : void
      {
         this._powerThree.dispose();
         this._powerThree = null;
      }
      
      private function prePlane() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.pickPlaneMove");
      }
      
      private function exePlane() : Boolean
      {
         ++this._c;
         if(this._c == 64)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.pickPlaneMove");
            this._plane = ComponentFactory.Instance.creatCustomObject("trainer.ExplainPlane");
            this._plane.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._plane.show();
         }
         return this._clicked;
      }
      
      private function finPlane() : void
      {
         this._plane.dispose();
         this._plane = null;
      }
      
      private function preTwoTwenty() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.getTwoTwentyMove");
      }
      
      private function exeTwoTwenty() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._twoTwenty = ComponentFactory.Instance.creatCustomObject("trainer.ExplainTwoTwenty");
            this._twoTwenty.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._twoTwenty.show();
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.getTwoTwentyMove");
         }
         return this._clicked;
      }
      
      private function finTwoTwenty() : void
      {
         this._twoTwenty.dispose();
         this._twoTwenty = null;
      }
      
      private function preThreeFourFive() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.getThreeFourFiveMove");
      }
      
      private function exeThreeFourFive() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._threeFourFive = ComponentFactory.Instance.creatCustomObject("trainer.ExplainThreeFourFive");
            this._threeFourFive.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._threeFourFive.show();
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.getThreeFourFiveMove");
         }
         return this._clicked;
      }
      
      private function finThreeFourFive() : void
      {
         this._threeFourFive.dispose();
         this._threeFourFive = null;
      }
      
      private function preLost() : void
      {
         this._lost = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.lostAsset"),true,true);
         this._lost.movie.x = 500;
         this._lost.movie.y = 360;
         this._map.gameView.addChild(this._lost.movie);
         SoundManager.instance.play("040");
      }
      
      private function exeLost() : Boolean
      {
         return this._lost.movie.currentFrame == this._lost.movie.totalFrames;
      }
      
      private function finLost() : void
      {
         this._lost = null;
         NewHandQueue.Instance.dispose();
         this._func();
      }
      
      private function __complete(param1:Event) : void
      {
         MovieClipWrapper(param1.target).removeEventListener(Event.COMPLETE,this.__complete);
         this.infoPane.dispose();
         this.infoPane = null;
      }
      
      private function upContextView(param1:MissionOverInfoPanel) : void
      {
         var _loc2_:MissionInfo = GameManager.Instance.Current.missionInfo;
         var _loc3_:BaseSettleInfo = GameManager.Instance.Current.missionInfo.findMissionOverInfo(PlayerManager.Instance.Self.ID);
         param1.titleTxt1.text = LanguageMgr.GetTranslation("tank.game.actions.kill");
         param1.valueTxt1.text = String(_loc2_.currentValue2);
         param1.titleTxt2.text = LanguageMgr.GetTranslation("tank.game.actions.turn");
         param1.valueTxt2.text = String(_loc2_.currentValue1);
         param1.titleTxt3.text = LanguageMgr.GetTranslation("tank.game.BloodStrip.HP");
         param1.valueTxt3.text = String(_loc3_.treatment);
      }
   }
}
