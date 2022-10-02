package fightLib.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.DungeonInfoEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import fightLib.LessonType;
   import fightLib.script.BaseScript;
   import fightLib.script.HighGap.DifficultHighGap;
   import fightLib.script.HighGap.EasyHighGap;
   import fightLib.script.HighGap.NormalHighGap;
   import fightLib.script.HighThrow.DifficultHighThrow;
   import fightLib.script.HighThrow.EasyHighThrow;
   import fightLib.script.HighThrow.NormalHighThrow;
   import fightLib.script.MeasureScree.DifficultMeasureScreenScript;
   import fightLib.script.MeasureScree.EasyMeasureScreenScript;
   import fightLib.script.MeasureScree.NomalMeasureScreenScript;
   import fightLib.script.SixtyDegree.DifficultSixtyDegreeScript;
   import fightLib.script.SixtyDegree.EasySixtyDegreeScript;
   import fightLib.script.SixtyDegree.NormalSixtyDegreeScript;
   import fightLib.script.TwentyDegree.DifficultTwentyDegree;
   import fightLib.script.TwentyDegree.EasyTwentyDegree;
   import fightLib.script.TwentyDegree.NormalTwentyDegree;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.model.Living;
   import game.model.Player;
   import game.view.DungeonHelpView;
   import game.view.DungeonInfoView;
   import game.view.GameView;
   import game.view.smallMap.SmallLiving;
   import road7th.comm.PackageIn;
   
   public class FightLibGameView extends GameView
   {
       
      
      private var _script:BaseScript;
      
      private var _frame:FightLibQuestionFrame;
      
      private var _redPoint:Sprite;
      
      private var _shouldShowTurn:Boolean = true;
      
      private var _isWaittingToAttack:Boolean = false;
      
      private var _scriptStarted:Boolean;
      
      private var _powerTable:MovieClip;
      
      private var _guildMc:MovieClip;
      
      private var _lessonLiving:SmallLiving;
      
      public function FightLibGameView()
      {
         super();
      }
      
      override public function getType() : String
      {
         return StateType.FIGHT_LIB_GAMEVIEW;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this.initScript();
         this.closeShowTurn();
         this.blockFly();
         GameManager.Instance.Current.selfGamePlayer.lockProp = true;
         setPropBarClickEnable(false,true);
         arrowHammerEnable = false;
         blockHammer();
         this.pauseGame();
         _map.smallMap.setHardLevel(FightLibManager.Instance.currentInfo.difficulty,1);
         this._powerTable = ComponentFactory.Instance.creat("tank.fightLib.FightLibPowerTableAsset");
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,this.__popupQuestionFrame);
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,this.__popupQuestionFrame);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__downHandler);
      }
      
      override protected function gameOver() : void
      {
         super.gameOver();
         FightLibManager.Instance.lastFightLibMission = PlayerManager.Instance.Self.fightLibMission;
         FightLibManager.Instance.lastInfo = FightLibManager.Instance.currentInfo;
         FightLibManager.Instance.currentInfo = null;
      }
      
      override public function updateControlBarState(param1:Living) : void
      {
         setPropBarClickEnable(false,true);
      }
      
      private function __reAnswer(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendFightLibReanswer();
         --FightLibManager.Instance.reAnswerNum;
      }
      
      private function __viewTutorial(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FightLibManager.Instance.script.restart();
         GameInSocketOut.sendClientScriptStart();
         this.closeShowTurn();
         if(this._frame)
         {
            this._frame.close();
         }
      }
      
      private function initScript() : void
      {
         if(FightLibManager.Instance.currentInfo.id == LessonType.Measure)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasyMeasureScreenScript(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NomalMeasureScreenScript(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultMeasureScreenScript(this);
            }
         }
         else if(FightLibManager.Instance.currentInfo.id == LessonType.Twenty)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasyTwentyDegree(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NormalTwentyDegree(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultTwentyDegree(this);
            }
         }
         else if(FightLibManager.Instance.currentInfo.id == LessonType.SixtyFive)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasySixtyDegreeScript(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NormalSixtyDegreeScript(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultSixtyDegreeScript(this);
            }
         }
         else if(FightLibManager.Instance.currentInfo.id == LessonType.HighThrow)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasyHighThrow(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NormalHighThrow(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultHighThrow(this);
            }
         }
         else if(FightLibManager.Instance.currentInfo.id == LessonType.HighGap)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasyHighGap(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NormalHighGap(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultHighGap(this);
            }
         }
         FightLibManager.Instance.script = this._script;
      }
      
      public function drawMasks() : void
      {
         if(!_tipLayers)
         {
            _tipLayers = new Sprite();
            addChild(_tipLayers);
         }
         _tipLayers.graphics.clear();
         _tipLayers.graphics.beginFill(0,0.8);
         _tipLayers.graphics.drawRect(-10,-10,828,820);
         _tipLayers.graphics.drawRect(818,122,200,690);
         _tipLayers.graphics.endFill();
      }
      
      public function pauseGame() : void
      {
         this.closeShowTurn();
      }
      
      public function continueGame() : void
      {
         var _loc1_:Point = null;
         _map.smallMap.titleBar.addEventListener(DungeonInfoEvent.DungeonHelpChanged,__dungeonVisibleChanged);
         _barrier = new DungeonInfoView(_map.smallMap.titleBar.turnButton,this);
         _barrier.addEventListener(GameEvent.DungeonHelpVisibleChanged,__dungeonHelpChanged);
         _barrier.addEventListener(GameEvent.UPDATE_SMALLMAPVIEW,__updateSmallMapView);
         _missionHelp = new DungeonHelpView(_map.smallMap.titleBar.turnButton,_barrier,this);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("asset.game.DungeonHelpViewPos");
         _missionHelp.x = _loc1_.x;
         _missionHelp.y = _loc1_.y;
         addChild(_missionHelp);
         setTimeout(this.openShowTurn,3000);
         setTimeout(this.enableReanswerBtn,3000);
      }
      
      public function moveToPlayer() : void
      {
         _map.smallMap.moveToPlayer();
      }
      
      public function splitSmallMapDrager() : void
      {
         _map.smallMap.showSpliter();
      }
      
      public function hideSmallMapSplit() : void
      {
         _map.smallMap.hideSpliter();
      }
      
      public function restoreText() : void
      {
         _map.smallMap.restoreText();
         if(getChildIndex(_map.smallMap) > getChildIndex(ChatManager.Instance.view))
         {
            swapChildren(_map.smallMap,ChatManager.Instance.view);
         }
      }
      
      public function shineText() : void
      {
         if(!this._guildMc)
         {
            this._guildMc = ComponentFactory.Instance.creat("tank.fightLib.GuildMc");
            addChild(this._guildMc);
         }
         this._guildMc.gotoAndStop("Stand");
         this._guildMc.scaleX = 0.14;
         this._guildMc.scaleY = 0.14;
         this._guildMc.x = 899;
         this._guildMc.y = 75;
         TweenLite.to(this._guildMc,2,{
            "x":500,
            "y":298,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.ScaleCompleteHandler
         });
      }
      
      private function ScaleCompleteHandler() : void
      {
         TweenLite.to(this._guildMc,2,{"onComplete":this.StartPlayHandler});
      }
      
      private function StartPlayHandler() : void
      {
         this._guildMc.gotoAndPlay("guild_1");
      }
      
      private function GuildEndHandler() : void
      {
         removeChild(this._guildMc);
         this._guildMc = null;
      }
      
      public function shineText2() : void
      {
         this._guildMc.gotoAndPlay("guild_2");
         addEventListener(Event.ENTER_FRAME,this.onMoviePlay);
      }
      
      private function onMoviePlay(param1:Event) : void
      {
         if(this._guildMc.currentLabel == "end")
         {
            this._guildMc.gotoAndStop("end");
            removeEventListener(Event.ENTER_FRAME,this.onMoviePlay);
            TweenLite.to(this._guildMc,1,{
               "x":899,
               "y":75,
               "scaleX":0.14,
               "scaleY":0.14,
               "onComplete":this.GuildEndHandler
            });
         }
      }
      
      public function screanAddEvent() : void
      {
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__downHandler);
      }
      
      private function __downHandler(param1:MouseEvent) : void
      {
         if(!_map.smallMap.__StartDrag)
         {
            return;
         }
         var _loc2_:int = _map.smallMap.screen.x;
         var _loc3_:int = _map.smallMap.screenX;
         var _loc4_:int = _map.smallMap.screen.y;
         var _loc5_:int = _map.smallMap.screenY;
         if(_loc2_ == _loc3_ && _loc4_ == _loc5_)
         {
            return;
         }
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__downHandler);
         this._script.continueScript();
      }
      
      override protected function __playerChange(param1:CrazyTankSocketEvent) : void
      {
         if(!this._scriptStarted)
         {
            this._script.start();
            this._scriptStarted = true;
         }
         if(this._shouldShowTurn)
         {
            super.__playerChange(param1);
         }
      }
      
      public function clearMask() : void
      {
         _tipLayers.graphics.clear();
      }
      
      public function sendClientScriptStart() : void
      {
         GameInSocketOut.sendClientScriptStart();
      }
      
      public function sendClientScriptEnd() : void
      {
         GameInSocketOut.sendClientScriptEnd();
      }
      
      private function __popupQuestionFrame(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readInt();
            _loc7_ = _loc2_.readInt();
            _loc8_ = _loc2_.readInt();
            _loc9_ = _loc2_.readUTF();
            _loc10_ = _loc2_.readUTF();
            _loc11_ = _loc2_.readUTF();
            _loc12_ = _loc2_.readUTF();
            _loc13_ = _loc2_.readUTF();
            if(this._frame)
            {
               this._frame.close();
            }
            this._frame = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibQuestionFrame",[_loc4_,_loc9_,_loc5_,_loc6_,_loc7_,_loc10_,_loc11_,_loc12_,_loc13_,_loc8_]);
            this._frame.show();
         }
         else if(this._frame)
         {
            this._frame.close();
         }
      }
      
      public function addRedPointInSmallMap() : void
      {
         this._lessonLiving = new SmallLiving();
         _map.smallMap.addObj(this._lessonLiving);
         _map.smallMap.updatePos(this._lessonLiving,new Point(GameManager.Instance.Current.selfGamePlayer.pos.x + 1000,GameManager.Instance.Current.selfGamePlayer.pos.y));
      }
      
      public function removeRedPointInSmallMap() : void
      {
         if(this._lessonLiving)
         {
            _map.smallMap.removeObj(this._lessonLiving);
            this._redPoint = null;
         }
      }
      
      public function leftJustifyWithPlayer() : void
      {
         _map.setCenter(_selfGamePlayer.pos.x + 500,_selfGamePlayer.pos.y,false);
      }
      
      public function leftJustifyWithRedPoint() : void
      {
         _map.setCenter(_selfGamePlayer.pos.x + 1500,_selfGamePlayer.pos.y,false);
      }
      
      override public function addliving(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = null;
         super.addliving(param1);
         if(this._isWaittingToAttack)
         {
            for each(_loc2_ in _gameInfo.livings)
            {
               if(!(_loc2_ is Player))
               {
                  _loc2_.addEventListener(LivingEvent.DIE,this.continueScript);
               }
            }
         }
      }
      
      public function waitAttack() : void
      {
         this._isWaittingToAttack = true;
      }
      
      public function continueScript(param1:LivingEvent) : void
      {
         var _loc2_:Living = null;
         if(FightLibManager.Instance.isWork == true)
         {
            SocketManager.Instance.out.createMonster();
            return;
         }
         this._isWaittingToAttack = false;
         for each(_loc2_ in _gameInfo.livings)
         {
            if(!(_loc2_ is Player))
            {
               _loc2_.removeEventListener(LivingEvent.DIE,this.continueScript);
            }
         }
         this._script.continueScript();
      }
      
      public function closeShowTurn() : void
      {
         this._shouldShowTurn = false;
      }
      
      public function openShowTurn() : void
      {
         this._shouldShowTurn = true;
      }
      
      public function enableReanswerBtn() : void
      {
      }
      
      public function blockFly() : void
      {
      }
      
      public function blockSmallMap() : void
      {
         _map.smallMap.allowDrag = false;
      }
      
      public function blockExist() : void
      {
         _map.smallMap.enableExit = false;
      }
      
      public function enableExist() : void
      {
         _map.smallMap.enableExit = true;
      }
      
      public function activeSmallMap() : void
      {
         _map.smallMap.allowDrag = true;
      }
      
      public function skip() : void
      {
         GameInSocketOut.sendGameSkipNext(1);
      }
      
      public function showPowerTable1() : void
      {
         this._powerTable = ComponentFactory.Instance.creat("tank.fightLib.FightLibPowerTableAsset");
         this._powerTable.y = 70;
         this._powerTable.gotoAndStop(1);
         addChild(this._powerTable);
      }
      
      public function showPowerTable2() : void
      {
         this._powerTable = ComponentFactory.Instance.creat("tank.fightLib.FightLibPowerTableAsset");
         this._powerTable.y = 70;
         this._powerTable.gotoAndStop(2);
         addChild(this._powerTable);
      }
      
      public function showPowerTable3() : void
      {
         this._powerTable = ComponentFactory.Instance.creat("tank.fightLib.FightLibPowerTableAsset");
         this._powerTable.y = 70;
         this._powerTable.gotoAndStop(3);
         addChild(this._powerTable);
      }
      
      public function hidePowerTable() : void
      {
         if(this._powerTable && contains(this._powerTable))
         {
            removeChild(this._powerTable);
         }
         this._powerTable = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         var _loc1_:int = LayerManager.Instance.getLayerByType(LayerManager.STAGE_DYANMIC_LAYER).numChildren;
         while(_loc1_ > 0)
         {
            LayerManager.Instance.getLayerByType(LayerManager.STAGE_DYANMIC_LAYER).removeChildAt(0);
            _loc1_--;
         }
         this.removeEvents();
         if(this._frame)
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
         if(this._powerTable)
         {
            ObjectUtils.disposeObject(this._powerTable);
            this._powerTable = null;
         }
         if(this._redPoint)
         {
            ObjectUtils.disposeObject(this._redPoint);
            this._redPoint = null;
         }
         if(this._guildMc)
         {
            ObjectUtils.disposeObject(this._guildMc);
            this._guildMc = null;
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         var _loc2_:Living = null;
         this._scriptStarted = false;
         this._isWaittingToAttack = false;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,this.__popupQuestionFrame);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__downHandler);
         for each(_loc2_ in _gameInfo.livings)
         {
            if(!(_loc2_ is Player))
            {
               _loc2_.removeEventListener(LivingEvent.DIE,this.continueScript);
            }
         }
         if(this._frame)
         {
            if(this._frame.parent)
            {
               this._frame.dispose();
            }
            this._frame = null;
         }
         if(this._powerTable)
         {
            if(this._powerTable.parent)
            {
               this._powerTable.parent.removeChild(this._powerTable);
            }
            this._powerTable = null;
         }
         if(this._script)
         {
            this._script.dispose();
            this._script = null;
         }
         super.leaving(param1);
         this.dispose();
         GameManager.Instance.reset();
      }
   }
}
