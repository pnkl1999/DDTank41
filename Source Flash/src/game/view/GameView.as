package game.view
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.BuffType;
   import ddt.data.EquipType;
   import ddt.data.FightAchievModel;
   import ddt.data.FightBuffInfo;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.events.PhyobjEvent;
   import ddt.manager.BallManager;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PageInterfaceManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SkillManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.StatisticManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.MenoryUtil;
   import ddt.view.BackgoundView;
   import ddt.view.PropItemView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.TryAgain;
   import game.actions.ChangeBallAction;
   import game.actions.ChangeNpcAction;
   import game.actions.ChangePlayerAction;
   import game.actions.GameOverAction;
   import game.actions.MissionOverAction;
   import game.actions.PickBoxAction;
   import game.actions.PrepareShootAction;
   import game.actions.ViewEachObjectAction;
   import game.model.GameNeedMovieInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.MissionAgainInfo;
   import game.model.Player;
   import game.model.SimpleBoss;
   import game.model.SmallEnemy;
   import game.model.TurnedLiving;
   import game.objects.ActionType;
   import game.objects.BombAction;
   import game.objects.GameLiving;
   import game.objects.GamePlayer;
   import game.objects.GameSimpleBoss;
   import game.objects.GameSmallEnemy;
   import game.objects.GameSysMsgType;
   import game.objects.SimpleBox;
   import game.objects.SimpleObject;
   import game.objects.TransmissionGate;
   import game.view.control.LiveState;
   import game.view.effects.BaseMirariEffectIcon;
   import game.view.effects.MirariEffectIconManager;
   import game.view.experience.ExpView;
   import org.aswing.KeyboardManager;
   import pet.date.PetSkillTemplateInfo;
   import phy.object.PhysicalObj;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.AutoDisappear;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   
   public class GameView extends GameViewBase
   {
       
      
      private const ZXC_OFFSET:int = 24;
      
      protected var _msg:String = "";
      
      protected var _tipItems:Dictionary;
      
      protected var _tipLayers:Sprite;
      
      protected var _result:ExpView;
      
      private var numCh:Number;
      
      private var _soundPlayFlag:Boolean;
      
      private var _ignoreSmallEnemy:Boolean;
      
      private var _boxArr:Array;
      
      private var _missionAgain:MissionAgainInfo;
      
      protected var _expView:ExpView;
      
      public function GameView()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         GameManager.Instance.gameView = this;
         super.enter(param1,param2);
         MenoryUtil.clearMenory();
         KeyboardManager.getInstance().isStopDispatching = false;
         KeyboardShortcutsManager.Instance.forbiddenSection(KeyboardShortcutsManager.GAME,false);
         _gameInfo.resetResultCard();
         _gameInfo.livings.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         _gameInfo.addEventListener(GameEvent.WIND_CHANGED,this.__windChanged);
         PlayerManager.Instance.Self.FightBag.addEventListener(BagEvent.UPDATE,this.__selfObtainItem);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__updateProp);
         PlayerManager.Instance.Self.TempBag.addEventListener(BagEvent.UPDATE,this.__getTempItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_OVER,this.__gameOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,this.__shoot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,this.__startMove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_VANE,this.__changWind);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_HIDE,this.__playerHide);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,this.__playerNoNole);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROP,this.__playerUsingItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_DANDER,this.__dander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REDUCE_DANDER,this.__reduceDander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,this.__changeShootCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SUICIDE,this.__suicide);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,this.__beginShoot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_BALL,this.__changeBall);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_FROST,this.__forstPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_MOVIE,this.__playMovie);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE,this.__livingTurnRotation);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_SOUND,this.__playSound);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_MOVETO,this.__livingMoveto);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_JUMP,this.__livingJump);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BEAT,this.__livingBeat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SAY,this.__livingSay);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,this.__livingRangeAttacking);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,this.__livingDirChanged);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,this.__focusOnObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_STATE,this.__changeState);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BARRIER_INFO,this.__barrierInfoHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,this.__removePhysicObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,this.__addTipLayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FORBID_DRAG,this.__forbidDragFocus);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOP_LAYER,this.__topLayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTROL_BGM,this.__controlBGM);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,this.__onLivingBoltmove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_TARGET,this.__onChangePlayerTarget);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,this.__fightAchievement);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BUFF,this.__updateBuff);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE,this.__gameSysMessage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_PET_SKILL,this.__usePetSkill);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_BUFF,this.__updatePetBuff);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SKIPNEXT,this.__skipNextHandler);
         StatisticManager.Instance().startAction(StatisticManager.GAME,"yes");
         this._tipItems = new Dictionary(true);
         CacheSysManager.lock(CacheConsts.ALERT_IN_FIGHT);
         PlayerManager.Instance.Self.isUpGradeInGame = false;
         BackgoundView.Instance.hide();
         GameManager.Instance.viewCompleteFlag = true;
         BuffManager.startLoadBuffEffect();
         var _loc3_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.addLivingEvtVec;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            this.addliving(_loc3_[_loc4_]);
            _loc4_++;
         }
         var _loc5_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.setPropertyEvtVec;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            this.objectSetProperty(_loc5_[_loc6_]);
            _loc6_++;
         }
         var _loc7_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.livingFallingEvtVec;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            this.livingFalling(_loc7_[_loc8_]);
            _loc8_++;
         }
         var _loc9_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.livingShowBloodEvtVec;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_.length)
         {
            this.livingShowBlood(_loc9_[_loc10_]);
            _loc10_++;
         }
         var _loc11_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.addMapThingEvtVec;
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_.length)
         {
            this.addMapThing(_loc11_[_loc12_]);
            _loc12_++;
         }
         var _loc13_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.livingActionMappingEvtVec;
         var _loc14_:int = 0;
         while(_loc14_ < _loc13_.length)
         {
            this.livingActionMapping(_loc13_[_loc14_]);
            _loc14_++;
         }
         var _loc15_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.updatePhysicObjectEvtVec;
         var _loc16_:int = 0;
         while(_loc16_ < _loc15_.length)
         {
            this.updatePhysicObject(_loc15_[_loc16_]);
            _loc16_++;
         }
         var _loc17_:Vector.<CrazyTankSocketEvent> = GameManager.Instance.playerBloodEvtVec;
         var _loc18_:int = 0;
         while(_loc18_ < _loc17_.length)
         {
            this.playerBlood(_loc17_[_loc18_]);
            _loc18_++;
         }
         GameManager.Instance.ClearAllCrazyTankSocketEvent();
      }
      
      private function __skipNextHandler(param1:CrazyTankSocketEvent) : void
      {
         if(_gameInfo.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            setTimeout(this.delayFocusSimpleBoss,250);
         }
      }
      
      private function delayFocusSimpleBoss() : void
      {
         if(!_map)
         {
            return;
         }
         var _loc1_:GameSimpleBoss = _map.getOneSimpleBoss;
         if(_loc1_)
         {
            _loc1_.needFocus(0,0,{"priority":3});
         }
      }
      
      private function __updatePetBuff(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:String = _loc2_.readUTF();
         var _loc6_:String = _loc2_.readUTF();
         var _loc7_:String = _loc2_.readUTF();
         var _loc8_:String = _loc2_.readUTF();
         var _loc9_:Boolean = _loc2_.readBoolean();
         var _loc10_:Living = _gameInfo.findLiving(_loc3_);
         var _loc11_:FightBuffInfo = new FightBuffInfo(_loc4_);
         _loc11_.buffPic = _loc7_;
         _loc11_.buffEffect = _loc8_;
         _loc11_.type = BuffType.PET_BUFF;
         var _loc12_:Object = BuffManager.getBuffById(_loc4_);
         if(_loc12_)
         {
            _loc11_.buffName = _loc12_.Name;
            _loc11_.description = _loc12_.Description;
         }
         else
         {
            _loc11_.buffName = _loc5_;
            _loc11_.description = _loc6_;
         }
         if(_loc10_)
         {
            if(_loc9_)
            {
               _loc10_.addPetBuff(_loc11_);
            }
            else
            {
               _loc10_.removePetBuff(_loc11_);
            }
         }
      }
      
      private function __usePetSkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Boolean = _loc2_.readBoolean();
         var _loc6_:Player = _gameInfo.findPlayer(_loc3_);
         var _loc7_:int = _loc2_.readInt();
         if(_loc7_ != 2)
         {
            if(_loc6_ && _loc6_.currentPet && _loc5_)
            {
               _loc6_.usePetSkill(_loc4_,_loc5_);
               if(PetSkillManager.getSkillByID(_loc4_).BallType == PetSkillTemplateInfo.BALL_TYPE_2)
               {
                  _loc6_.isAttacking = false;
                  GameManager.Instance.Current.selfGamePlayer.beginShoot();
               }
            }
            if(!_loc5_)
            {
               GameManager.Instance.dispatchEvent(new LivingEvent(LivingEvent.PETSKILL_USED_FAIL));
            }
         }
      }
      
      private function __gameSysMessage(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:int = _loc2_.readInt();
         switch(_loc3_)
         {
            case GameSysMsgType.GET_ITEM_INVENTORY_FULL:
               MessageTipManager.getInstance().show(String(_loc5_),2);
         }
      }
      
      private function __changeMaxForce(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Living = _gameInfo.findLiving(_loc3_);
         if(_loc5_ && _loc5_.isSelf)
         {
            Player(_loc5_).maxForce = _loc4_;
         }
      }
      
      private function __fightAchievement(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:PackageIn = null;
         var _loc4_:Living = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:AchieveAnimation = null;
         if(PathManager.getFightAchieveEnable())
         {
            if(_achievBar == null)
            {
               _achievBar = ComponentFactory.Instance.creatCustomObject("FightAchievBar");
               addChild(_achievBar);
            }
            _loc3_ = param1.pkg;
            _loc4_ = GameManager.Instance.Current.findLiving(_loc3_.clientId);
            _loc5_ = _loc3_.readInt();
            _loc6_ = _loc3_.readInt();
            _loc7_ = _loc3_.readInt();
            _loc8_ = getTimer();
            _loc9_ = _achievBar.getAnimate(_loc5_);
            if(_loc9_ == null)
            {
               _achievBar.addAnimate(ComponentFactory.Instance.creatCustomObject("AchieveAnimation",[_loc5_,_loc6_,_loc7_,_loc8_]));
            }
            else if(FightAchievModel.getInstance().isNumAchiev(_loc5_))
            {
               _loc9_.setNum(_loc6_);
            }
            else
            {
               _achievBar.rePlayAnimate(_loc9_);
            }
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:DisplayObject = null;
         this.numCh = 0;
         var _loc2_:int = 0;
         while(_loc2_ < stage.numChildren)
         {
            _loc3_ = StageReferance.stage.getChildAt(_loc2_);
            _loc3_.visible = true;
            ++this.numCh;
            if(_loc3_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc3_));
            }
            _loc2_++;
         }
      }
      
      private function show(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            _loc3_.visible = true;
            ++this.numCh;
            if(_loc3_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc3_));
            }
            _loc2_++;
         }
      }
      
      private function __windChanged(param1:GameEvent) : void
      {
         _map.wind = param1.data.wind;
         _vane.update(_map.wind,param1.data.isSelfTurn,param1.data.windNumArr);
      }
      
      override public function getType() : String
      {
         return StateType.FIGHTING;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         var _loc2_:SimpleObject = null;
         GameManager.Instance.viewCompleteFlag = false;
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.onClick);
         SoundManager.instance.stopMusic();
         PageInterfaceManager.restorePageTitle();
         KeyboardShortcutsManager.Instance.forbiddenSection(KeyboardShortcutsManager.GAME,true);
         if(PlayerManager.Instance.hasTempStyle)
         {
            PlayerManager.Instance.readAllTempStyleEvent();
         }
         _gameInfo.removeEventListener(GameEvent.WIND_CHANGED,this.__windChanged);
         _gameInfo.livings.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         _gameInfo.removeAllMonsters();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,this.__shoot);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,this.__startMove);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_VANE,this.__changWind);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_HIDE,this.__playerHide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,this.__playerNoNole);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_PROP,this.__playerUsingItem);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_DANDER,this.__dander);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REDUCE_DANDER,this.__reduceDander);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,this.__changeShootCount);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SUICIDE,this.__suicide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,this.__beginShoot);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_BUFF,this.__updatePetBuff);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_PET_SKILL,this.__usePetSkill);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_BALL,this.__changeBall);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_FROST,this.__forstPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_OVER,this.__gameOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_MOVIE,this.__playMovie);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE,this.__livingTurnRotation);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_SOUND,this.__playSound);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_MOVETO,this.__livingMoveto);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_JUMP,this.__livingJump);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BEAT,this.__livingBeat);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SAY,this.__livingSay);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,this.__livingRangeAttacking);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,this.__livingDirChanged);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,this.__focusOnObject);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_STATE,this.__changeState);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BARRIER_INFO,this.__barrierInfoHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,this.__removePhysicObject);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,this.__addTipLayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FORBID_DRAG,this.__forbidDragFocus);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOP_LAYER,this.__topLayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTROL_BGM,this.__controlBGM);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,this.__onLivingBoltmove);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_TARGET,this.__onChangePlayerTarget);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,this.__fightAchievement);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SKIPNEXT,this.__skipNextHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BUFF,this.__updateBuff);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE,this.__gameSysMessage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PICK_BOX,this.__pickBox);
         PlayerManager.Instance.Self.FightBag.removeEventListener(BagEvent.UPDATE,this.__selfObtainItem);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateProp);
         PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,this.__getTempItem);
         for each(_loc2_ in this._tipItems)
         {
            delete this._tipLayers[_loc2_.Id];
            _loc2_.dispose();
            _loc2_ = null;
         }
         this._tipItems = null;
         if(this._tipLayers)
         {
            if(this._tipLayers.parent)
            {
               this._tipLayers.parent.removeChild(this._tipLayers);
            }
         }
         this._tipLayers = null;
         _gameInfo.resetBossCardCnt();
         if(this._expView)
         {
            this._expView.removeEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         }
         super.leaving(param1);
         if(StateManager.isExitRoom(param1.getType()) && RoomManager.Instance.isReset(RoomManager.Instance.current.type))
         {
            GameManager.Instance.reset();
            RoomManager.Instance.reset();
         }
         else if(StateManager.isExitGame(param1.getType()) && RoomManager.Instance.isReset(RoomManager.Instance.current.type))
         {
            GameManager.Instance.reset();
         }
         BallManager.clearAsset();
         BackgoundView.Instance.show();
      }
      
      override public function addedToStage() : void
      {
         super.addedToStage();
         stage.focus = _map;
      }
      
      override public function getBackType() : String
      {
         if(_gameInfo.roomType == RoomInfo.CHALLENGE_ROOM)
         {
            return StateType.CHALLENGE_ROOM;
         }
         if(_gameInfo.roomType == RoomInfo.MATCH_ROOM)
         {
            return StateType.MATCH_ROOM;
         }
         if(_gameInfo.roomType == RoomInfo.FIGHT_LIB_ROOM)
         {
            return StateType.FIGHT_LIB;
         }
         if(_gameInfo.roomType == RoomInfo.FRESHMAN_ROOM)
         {
            return StateType.FRESHMAN_ROOM;
         }
         return StateType.DUNGEON_ROOM;
      }
      
      protected function __playerChange(param1:CrazyTankSocketEvent) : void
      {
         PageInterfaceManager.restorePageTitle();
         _selfMarkBar.shutdown();
         _map.currentFocusedLiving = null;
         var _loc2_:int = param1.pkg.extend1;
         var _loc3_:Living = _gameInfo.findLiving(_loc2_);
         _gameInfo.currentLiving = _loc3_;
         if(_loc3_ is TurnedLiving)
         {
            this._ignoreSmallEnemy = false;
            if(!_loc3_.isLiving)
            {
               setCurrentPlayer(null);
               return;
            }
            if(_loc3_.playerInfo == PlayerManager.Instance.Self)
            {
               PageInterfaceManager.changePageTitle("");
            }
            param1.executed = false;
            this._soundPlayFlag = true;
            _map.act(new ChangePlayerAction(_map,_loc3_ as TurnedLiving,param1,param1.pkg));
         }
         else
         {
            _map.act(new ChangeNpcAction(this,_map,_loc3_ as Living,param1,param1.pkg,this._ignoreSmallEnemy));
            if(!this._ignoreSmallEnemy)
            {
               this._ignoreSmallEnemy = true;
            }
         }
         var _loc4_:LiveState = _cs as LiveState;
         PrepareShootAction.hasDoSkillAnimation = false;
      }
      
      private function __playMovie(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc3_ = param1.pkg.readUTF();
            _loc2_.playMovie(_loc3_);
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __livingTurnRotation(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc3_ = param1.pkg.readInt() / 10;
            _loc4_ = param1.pkg.readInt() / 10;
            _loc5_ = param1.pkg.readUTF();
            _loc2_.turnRotation(_loc3_,_loc4_,_loc5_);
            _map.bringToFront(_loc2_);
         }
      }
      
      public function addliving(param1:CrazyTankSocketEvent) : void
      {
         var _loc30_:Living = null;
         var _loc31_:GameLiving = null;
         var _loc32_:* = null;
         var _loc33_:String = null;
         var _loc34_:String = null;
         var _loc35_:FightBuffInfo = null;
         var _loc36_:String = null;
         var _loc37_:String = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:String = _loc2_.readUTF();
         var _loc6_:String = _loc2_.readUTF();
         var _loc7_:String = _loc2_.readUTF();
         var _loc8_:Point = new Point(_loc2_.readInt(),_loc2_.readInt());
         var _loc9_:int = _loc2_.readInt();
         var _loc10_:int = _loc2_.readInt();
         var _loc11_:int = _loc2_.readInt();
         var _loc12_:int = _loc2_.readByte();
         var _loc13_:int = _loc2_.readByte();
         var _loc14_:Boolean = _loc13_ == 0 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         var _loc15_:Boolean = _loc2_.readBoolean();
         var _loc16_:Boolean = _loc2_.readBoolean();
         var _loc17_:int = _loc2_.readInt();
         var _loc18_:Dictionary = new Dictionary();
         var _loc19_:int = 0;
         while(_loc19_ < _loc17_)
         {
            _loc33_ = _loc2_.readUTF();
            _loc34_ = _loc2_.readUTF();
            _loc18_[_loc33_] = _loc34_;
            _loc19_++;
         }
         var _loc20_:int = _loc2_.readInt();
         var _loc21_:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
         var _loc22_:int = 0;
         while(_loc22_ < _loc20_)
         {
            _loc35_ = BuffManager.creatBuff(_loc2_.readInt());
            _loc21_.push(_loc35_);
            _loc22_++;
         }
         var _loc23_:Boolean = _loc2_.readBoolean();
         var _loc24_:Boolean = _loc2_.readBoolean();
         var _loc25_:Boolean = _loc2_.readBoolean();
         var _loc26_:Boolean = _loc2_.readBoolean();
         var _loc27_:int = _loc2_.readInt();
         var _loc28_:Dictionary = new Dictionary();
         var _loc29_:int = 0;
         while(_loc29_ < _loc27_)
         {
            _loc36_ = _loc2_.readUTF();
            _loc37_ = _loc2_.readUTF();
            _loc28_[_loc36_] = _loc37_;
            _loc29_++;
         }
         if(_map.getPhysical(_loc4_))
         {
            _map.getPhysical(_loc4_).dispose();
         }
         if(_loc3_ != 4 && _loc3_ != 5 && _loc3_ != 6)
         {
            _loc30_ = new SmallEnemy(_loc4_,_loc11_,_loc10_);
            _loc30_.typeLiving = _loc3_;
            _loc30_.actionMovieName = _loc6_;
            _loc30_.direction = _loc12_;
            _loc30_.pos = _loc8_;
            _loc30_.name = _loc5_;
            _loc30_.isBottom = _loc14_;
            _gameInfo.addGamePlayer(_loc30_);
            _loc31_ = new GameSmallEnemy(_loc30_ as SmallEnemy);
            if(_loc9_ != _loc30_.maxBlood)
            {
               _loc30_.initBlood(_loc9_);
            }
         }
         else
         {
            _loc30_ = new SimpleBoss(_loc4_,_loc11_,_loc10_);
            _loc30_.typeLiving = _loc3_;
            _loc30_.actionMovieName = _loc6_;
            _loc30_.direction = _loc12_;
            _loc30_.pos = _loc8_;
            _loc30_.name = _loc5_;
            _loc30_.isBottom = _loc14_;
            _gameInfo.addGamePlayer(_loc30_);
            _loc31_ = new GameSimpleBoss(_loc30_ as SimpleBoss);
            if(_loc9_ != _loc30_.maxBlood)
            {
               _loc30_.initBlood(_loc9_);
            }
         }
         _loc31_.name = _loc5_;
         _map.addPhysical(_loc31_);
         if(_loc7_.length > 0)
         {
            _loc31_.doAction(_loc7_);
         }
         else
         {
            _loc31_.doAction(Living.BORN_ACTION);
         }
         if(_loc7_.length > 0)
         {
            _loc31_.doAction(_loc7_);
         }
         else if(!_loc18_[Living.STAND_ACTION])
         {
            _loc31_.doAction(Living.BORN_ACTION);
         }
         else
         {
            _loc31_.doAction(Living.STAND_ACTION);
         }
         _loc31_.info.isFrozen = _loc23_;
         _loc31_.info.isHidden = _loc24_;
         _loc31_.info.isNoNole = _loc25_;
         for(_loc32_ in _loc28_)
         {
            setProperty(_loc31_,_loc32_,_loc28_[_loc32_]);
         }
         _playerThumbnailLController.addLiving(_loc31_);
         addChild(_playerThumbnailLController);
         if(_loc30_ is SimpleBoss)
         {
            _map.setCenter(_loc31_.x,_loc31_.y - 150,false);
         }
         else
         {
            _map.setCenter(_loc31_.x,_loc31_.y - 150,true);
         }
      }
      
      private function __addTipLayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc10_:MovieClip = null;
         var _loc11_:Class = null;
         var _loc12_:MovieClipWrapper = null;
         var _loc13_:SimpleObject = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = param1.pkg.readInt();
         var _loc6_:String = param1.pkg.readUTF();
         var _loc7_:String = param1.pkg.readUTF();
         var _loc8_:int = param1.pkg.readInt();
         var _loc9_:int = param1.pkg.readInt();
         if(_loc3_ == 10)
         {
            if(ModuleLoader.hasDefinition(_loc6_))
            {
               _loc11_ = ModuleLoader.getDefinition(_loc6_) as Class;
               _loc10_ = new _loc11_() as MovieClip;
               _loc12_ = new MovieClipWrapper(_loc10_,false,true);
               this.addTipSprite(_loc12_.movie);
               _loc12_.gotoAndPlay(1);
            }
         }
         else
         {
            if(this._tipItems[_loc2_])
            {
               _loc13_ = this._tipItems[_loc2_] as SimpleObject;
            }
            else
            {
               _loc13_ = new SimpleObject(_loc2_,_loc3_,_loc6_,_loc7_);
               this.addTipSprite(_loc13_);
            }
            _loc13_.playAction(_loc7_);
            this._tipItems[_loc2_] = _loc13_;
         }
      }
      
      private function addTipSprite(param1:Sprite) : void
      {
         if(!this._tipLayers)
         {
            this._tipLayers = new Sprite();
            this._tipLayers.mouseEnabled = false;
            this._tipLayers.mouseChildren = false;
            addChild(this._tipLayers);
         }
         this._tipLayers.addChild(param1);
      }
      
      protected function __pickBox(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Array = [];
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_.push(_loc2_.readInt());
            _loc5_++;
         }
         _map.dropOutBox(_loc3_);
         this.hideAllOther();
      }
      
      public function addMapThing(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = param1.pkg.readInt();
         var _loc6_:String = param1.pkg.readUTF();
         var _loc7_:String = param1.pkg.readUTF();
         var _loc8_:int = param1.pkg.readInt();
         var _loc9_:int = param1.pkg.readInt();
         var _loc10_:int = param1.pkg.readInt();
         var _loc11_:int = param1.pkg.readInt();
         var _loc12_:int = param1.pkg.readInt();
         var _loc13_:SimpleObject = null;
         switch(_loc3_)
         {
            case 1:
               _loc13_ = new SimpleBox(_loc2_,_loc6_);
               break;
            case 2:
               _loc13_ = new SimpleObject(_loc2_,1,_loc6_,_loc7_);
               break;
            case 3:
               _loc13_ = new TransmissionGate(_loc2_,_loc3_,"asset.game.transmitted",_loc7_);
               this.hideAllOther();
               break;
            default:
               _loc13_ = new SimpleObject(_loc2_,0,_loc6_,_loc7_,_loc11_ == 6);
         }
         _loc13_.x = _loc4_;
         _loc13_.y = _loc5_;
         _loc13_.scaleX = _loc8_;
         _loc13_.scaleY = _loc9_;
         _loc13_.rotation = _loc10_;
         if(_loc3_ == 1)
         {
            this.addBox(_loc13_);
         }
         this.addEffect(_loc13_,_loc12_,_loc11_);
      }
      
      private function addBox(param1:SimpleObject) : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            if(!this._boxArr)
            {
               this._boxArr = new Array();
            }
            this._boxArr.push(param1);
         }
         else
         {
            this.addEffect(param1);
         }
      }
      
      private function addEffect(param1:SimpleObject, param2:int = 0, param3:int = 0) : void
      {
         switch(param2)
         {
            case -1:
               this.addStageCurtain(param1);
               break;
            case 0:
               _map.addPhysical(param1);
               if(param3 > 0 && param3 != 6)
               {
                  _map.phyBringToFront(param1);
               }
               break;
            default:
               _map.addObject(param1);
               this.getGameLivingByID(param2 - 1).addChild(param1);
         }
      }
      
      public function updatePhysicObject(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:SimpleObject = _map.getPhysical(_loc2_) as SimpleObject;
         if(!_loc3_)
         {
            _loc3_ = this._tipItems[_loc2_] as SimpleObject;
         }
         var _loc4_:String = param1.pkg.readUTF();
         if(_loc3_)
         {
            _loc3_.playAction(_loc4_);
         }
         var _loc5_:PhyobjEvent = new PhyobjEvent(_loc4_);
         dispatchEvent(_loc5_);
      }
      
      private function __applySkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         SkillManager.applySkillToLiving(_loc3_,_loc4_,_loc2_);
      }
      
      private function __removeSkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         SkillManager.removeSkillFromLiving(_loc3_,_loc4_,_loc2_);
      }
      
      private function __mirariEffectShowHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:BaseMirariEffectIcon = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Boolean = _loc2_.readBoolean();
         var _loc6_:Living = _gameInfo.findLiving(_loc3_);
         if(_loc6_ && _loc6_.playerInfo)
         {
            if(_loc6_.playerInfo.ID == _gameInfo.selfGamePlayer.playerInfo.ID)
            {
               _loc6_ = _gameInfo.selfGamePlayer;
            }
         }
         if(_loc6_)
         {
            _loc7_ = MirariEffectIconManager.getInstance().createEffectIcon(_loc4_);
            if(_loc7_ == null)
            {
               return;
            }
            if(_loc5_)
            {
               _loc6_.handleMirariEffect(_loc7_);
            }
            else
            {
               _loc6_.removeMirariEffect(_loc7_);
            }
         }
      }
      
      private function __removePhysicObject(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:PhysicalObj = this.getGameLivingByID(_loc2_);
         if(_loc3_ && _loc3_.parent)
         {
            _map.removePhysical(_loc3_);
         }
         if(_loc3_ && _loc3_.parent)
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         if(_loc3_)
         {
            if(!(_loc3_ is GameLiving) || GameLiving(_loc3_).isExist)
            {
               _loc3_.dispose();
            }
         }
      }
      
      private function __focusOnObject(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Array = [];
         var _loc4_:Object = new Object();
         _loc4_.x = param1.pkg.readInt();
         _loc4_.y = param1.pkg.readInt();
         _loc3_.push(_loc4_);
         _map.act(new ViewEachObjectAction(_map,_loc3_,_loc2_));
      }
      
      private function __barrierInfoHandler(param1:CrazyTankSocketEvent) : void
      {
         barrierInfo = param1;
      }
      
      private function __livingMoveto(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc3_ = new Point(param1.pkg.readInt(),param1.pkg.readInt());
            _loc4_ = new Point(param1.pkg.readInt(),param1.pkg.readInt());
            _loc5_ = param1.pkg.readInt();
            _loc6_ = param1.pkg.readUTF();
            _loc7_ = param1.pkg.readUTF();
            _loc2_.pos = _loc3_;
            _loc2_.moveTo(0,_loc4_,0,true,_loc6_,_loc5_,_loc7_);
            _map.bringToFront(_loc2_);
         }
      }
      
      public function livingFalling(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         var _loc3_:Point = new Point(param1.pkg.readInt(),param1.pkg.readInt());
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         var _loc6_:int = param1.pkg.readInt();
         if(_loc2_)
         {
            _loc2_.fallTo(_loc3_,_loc4_,_loc5_,_loc6_);
            if(_loc3_.y - _loc2_.pos.y > 50)
            {
               _map.setCenter(_loc3_.x,_loc3_.y - 150,false);
            }
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __livingJump(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         var _loc3_:Point = new Point(param1.pkg.readInt(),param1.pkg.readInt());
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         var _loc6_:int = param1.pkg.readInt();
         _loc2_.jumpTo(_loc3_,_loc4_,_loc5_,_loc6_);
         _map.bringToFront(_loc2_);
      }
      
      private function __livingBeat(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:Living = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Living = _gameInfo.findLiving(_loc2_.extend1);
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:uint = _loc2_.readInt();
         var _loc6_:Array = new Array();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = _gameInfo.findLiving(_loc2_.readInt());
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc11_ = _loc2_.readInt();
            _loc12_ = _loc2_.readInt();
            _loc13_ = new Object();
            _loc13_["action"] = _loc4_;
            _loc13_["target"] = _loc8_;
            _loc13_["damage"] = _loc9_;
            _loc13_["targetBlood"] = _loc10_;
            _loc13_["dander"] = _loc11_;
            _loc13_["attackEffect"] = _loc12_;
            _loc6_.push(_loc13_);
            if(_loc8_ && _loc8_.isPlayer() && _loc8_.isLiving)
            {
               (_loc8_ as Player).dander = _loc11_;
            }
            _loc7_++;
         }
         if(_loc3_)
         {
            _loc3_.beat(_loc6_);
         }
      }
      
      private function __livingSay(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(!_loc2_ || !_loc2_.isLiving)
         {
            return;
         }
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:int = param1.pkg.readInt();
         _map.bringToFront(_loc2_);
         _loc2_.say(_loc3_,_loc4_);
      }
      
      private function __livingRangeAttacking(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Living = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.pkg.readInt();
            _loc5_ = param1.pkg.readInt();
            _loc6_ = param1.pkg.readInt();
            _loc7_ = param1.pkg.readInt();
            _loc8_ = param1.pkg.readInt();
            _loc9_ = _gameInfo.findLiving(_loc4_);
            if(_loc9_)
            {
               _loc9_.isHidden = false;
               _loc9_.isFrozen = false;
               _loc9_.updateBlood(_loc6_,_loc8_);
               _loc9_.showAttackEffect(1);
               _map.bringToFront(_loc9_);
               if(_loc9_.isSelf)
               {
                  _map.setCenter(_loc9_.pos.x,_loc9_.pos.y,false);
               }
               if(_loc9_.isPlayer() && _loc9_.isLiving)
               {
                  (_loc9_ as Player).dander = _loc7_;
               }
            }
            _loc3_++;
         }
      }
      
      private function __livingDirChanged(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc3_ = param1.pkg.readInt();
            _loc2_.direction = _loc3_;
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         this._msg = RoomManager.Instance._removeRoomMsg;
         var _loc2_:Player = param1.data as Player;
         var _loc3_:GamePlayer = _players[_loc2_];
         if(_loc3_ && _loc2_)
         {
            if(_map.currentPlayer == _loc2_)
            {
               setCurrentPlayer(null);
            }
            if(_loc2_.isSelf)
            {
               if(RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM || RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
               {
                  StateManager.setState(StateType.ROOM_LIST);
               }
               else if(RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)
               {
                  StateManager.setState(StateType.DUNGEON_LIST);
               }
            }
            _map.removePhysical(_loc3_);
            _loc3_.dispose();
            delete _players[_loc2_];
         }
      }
      
      private function __beginShoot(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:GamePlayer = null;
         if(_map.currentPlayer && _map.currentPlayer.isPlayer() && param1.pkg.clientId != _map.currentPlayer.playerInfo.ID && _gameInfo.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            _map.executeAtOnce();
            _map.setCenter(_map.currentPlayer.pos.x,_map.currentPlayer.pos.y - 150,false);
            _loc2_ = _players[_map.currentPlayer];
         }
         if(_gameInfo.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || _map.currentPlayer && _map.currentPlayer.isPlayer() && param1.pkg.clientId == _map.currentPlayer.playerInfo.ID)
         {
            setPropBarClickEnable(false,false);
            PrepareShootAction.hasDoSkillAnimation = false;
         }
      }
      
      protected function __shoot(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:LocalPlayer = null;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:Bomb = null;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:Living = null;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:Object = null;
         var _loc33_:Point = null;
         var _loc34_:Dictionary = null;
         var _loc35_:Bomb = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc3_)
         {
            _loc4_ = GameManager.Instance.Current.selfGamePlayer;
            _loc5_ = _loc2_.readInt() / 10;
            _loc6_ = _loc2_.readBoolean();
            _loc7_ = _loc2_.readByte();
            _loc8_ = _loc2_.readByte();
            _loc9_ = _loc2_.readByte();
            _loc10_ = [_loc6_,_loc7_,_loc8_,_loc9_];
            GameManager.Instance.Current.setWind(_loc5_,_loc3_.isSelf,_loc10_);
            _loc11_ = new Array();
            _loc12_ = _loc2_.readInt();
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc19_ = new Bomb();
               _loc19_.number = _loc2_.readInt();
               _loc19_.shootCount = _loc2_.readInt();
               _loc19_.IsHole = _loc2_.readBoolean();
               _loc19_.Id = _loc2_.readInt();
               _loc19_.X = _loc2_.readInt();
               _loc19_.Y = _loc2_.readInt();
               _loc19_.VX = _loc2_.readInt();
               _loc19_.VY = _loc2_.readInt();
               _loc20_ = _loc2_.readInt();
               _loc19_.Template = BallManager.findBall(_loc20_);
               _loc19_.Actions = new Array();
               _loc19_.changedPartical = _loc2_.readUTF();
               _loc21_ = _loc2_.readInt() / 1000;
               _loc22_ = _loc2_.readInt() / 1000;
               _loc23_ = _loc21_ * _loc22_;
               _loc19_.damageMod = _loc23_;
               _loc24_ = _loc2_.readInt();
               _loc26_ = 0;
               while(_loc26_ < _loc24_)
               {
                  _loc25_ = _loc2_.readInt();
                  _loc19_.Actions.push(new BombAction(_loc25_,_loc2_.readInt(),_loc2_.readInt(),_loc2_.readInt(),_loc2_.readInt(),_loc2_.readInt()));
                  _loc26_++;
               }
               _loc11_.push(_loc19_);
               _loc13_++;
            }
            _loc3_.shoot(_loc11_,param1);
            _loc14_ = _loc2_.readInt();
            _loc15_ = [];
            _loc16_ = 0;
            while(_loc16_ < _loc14_)
            {
               _loc27_ = _loc2_.readInt();
               _loc28_ = _gameInfo.findLiving(_loc27_);
               _loc29_ = _loc2_.readInt();
               _loc30_ = _loc2_.readInt();
               _loc31_ = _loc2_.readInt();
               _loc32_ = {
                  "target":_loc28_,
                  "hp":_loc30_,
                  "damage":_loc29_,
                  "dander":_loc31_
               };
               _loc15_.push(_loc32_);
               _loc16_++;
            }
            _loc17_ = _loc2_.readInt();
            _loc18_ = "attack" + _loc17_.toString();
            if(_loc17_ != 0)
            {
               _loc33_ = null;
               if(_loc11_.length == 3)
               {
                  _loc33_ = Bomb(_loc11_[1]).target;
               }
               else if(_loc11_.length == 1)
               {
                  _loc33_ = Bomb(_loc11_[0]).target;
               }
               _loc34_ = Player(_loc3_).currentPet.petBeatInfo;
               _loc34_["actionName"] = _loc18_;
               _loc34_["targetPoint"] = _loc33_;
               _loc34_["targets"] = _loc15_;
               _loc35_ = Bomb(_loc11_[_loc11_.length == 3 ? 1 : 0]);
               _loc35_.Actions.push(new BombAction(0,ActionType.PET,param1.pkg.extend1,0,0,0));
            }
         }
      }
      
      private function __suicide(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc2_.die();
         }
      }
      
      private function __changeBall(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:Player = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_ && _loc2_ is Player)
         {
            _loc3_ = _loc2_ as Player;
            _loc4_ = param1.pkg.readBoolean();
            _loc5_ = param1.pkg.readInt();
            _map.act(new ChangeBallAction(_loc3_,_loc4_,_loc5_));
         }
      }
      
      private function __playerUsingItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:DisplayObject = null;
         var _loc10_:String = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc2_.readInt());
         var _loc6_:Living = _gameInfo.findLiving(_loc2_.extend1);
         var _loc7_:Living = _gameInfo.findLiving(_loc2_.readInt());
         var _loc8_:Boolean = _loc2_.readBoolean();
         if(_loc6_ && _loc5_)
         {
            if(_loc6_.isPlayer())
            {
               if(_loc5_.CategoryID == EquipType.Freeze)
               {
                  Player(_loc6_).skill == -1;
               }
               if(!(_loc6_ as Player).isSelf)
               {
                  if(_loc5_.CategoryID == EquipType.OFFHAND || _loc5_.CategoryID == EquipType.TEMP_OFFHAND)
                  {
                     _loc9_ = (_loc6_ as Player).currentDeputyWeaponInfo.getDeputyWeaponIcon();
                     _loc9_.x += 7;
                     (_loc6_ as Player).useItemByIcon(_loc9_);
                  }
                  else
                  {
                     (_loc6_ as Player).useItem(_loc5_);
                     _loc10_ = EquipType.hasPropAnimation(_loc5_);
                     if(_loc10_ != null && _loc7_ && _loc7_.LivingID != _loc6_.LivingID)
                     {
                        _loc7_.playSkillMovie(_loc10_);
                     }
                  }
               }
            }
            if(_map.currentPlayer && _loc7_.team == _map.currentPlayer.team && (RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM || (_loc6_ as Player).isSelf))
            {
               _map.currentPlayer.addState(_loc5_.TemplateID);
            }
            if(!_loc7_.isLiving)
            {
               if(_loc7_.isPlayer())
               {
                  (_loc7_ as Player).addState(_loc5_.TemplateID);
               }
            }
            if(RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM)
            {
               if(!_loc6_.isLiving && _loc7_ && _loc6_.team == _loc7_.team)
               {
                  MessageTipManager.getInstance().show(_loc6_.LivingID + "|" + _loc5_.TemplateID,1);
               }
               if(_loc8_)
               {
                  MessageTipManager.getInstance().show(String(_loc7_.LivingID),3);
               }
            }
         }
      }
      
      private function __updateProp(param1:BagEvent) : void
      {
      }
      
      private function __updateBuff(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:FightBuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Boolean = _loc2_.readBoolean();
         var _loc6_:Living = _gameInfo.findLiving(_loc3_);
         if(_loc6_ && _loc4_ != -1)
         {
            if(_loc5_)
            {
               _loc7_ = BuffManager.creatBuff(_loc4_);
               _loc6_.addBuff(_loc7_);
            }
            else
            {
               _loc6_.removeBuff(_loc4_);
            }
         }
      }
      
      private function __startMove(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Player = _gameInfo.findPlayer(param1.pkg.extend1);
         var _loc4_:Boolean = _loc2_.readBoolean();
         if(_loc4_)
         {
            if(!_loc3_.playerInfo.isSelf)
            {
               this.playerMove(_loc2_,_loc3_);
            }
         }
         else
         {
            this.playerMove(_loc2_,_loc3_);
         }
      }
      
      private function playerMove(param1:PackageIn, param2:Player) : void
      {
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:PickBoxAction = null;
         var _loc3_:int = param1.readByte();
         var _loc4_:Point = new Point(param1.readInt(),param1.readInt());
         var _loc5_:int = param1.readByte();
         var _loc6_:Boolean = param1.readBoolean();
         if(_loc3_ == 2)
         {
            _loc7_ = [];
            _loc8_ = param1.readInt();
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc10_ = new PickBoxAction(param1.readInt(),param1.readInt());
               _loc7_.push(_loc10_);
               _loc9_++;
            }
            if(param2)
            {
               param2.playerMoveTo(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
            }
         }
         else if(param2)
         {
            param2.playerMoveTo(_loc3_,_loc4_,_loc5_,_loc6_);
         }
      }
      
      private function __onLivingBoltmove(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc3_)
         {
            _loc3_.pos = new Point(_loc2_.readInt(),_loc2_.readInt());
         }
      }
      
      public function playerBlood(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc6_)
         {
            _loc6_.updateBlood(_loc4_,_loc3_,_loc5_);
         }
      }
      
      private function __changWind(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         _map.wind = _loc2_.readInt() / 10;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:int = _loc2_.readByte();
         var _loc6_:int = _loc2_.readByte();
         var _loc7_:Array = new Array();
         _loc7_ = [_loc3_,_loc4_,_loc5_,_loc6_];
         _vane.update(_map.wind,false,_loc7_);
      }
      
      private function __playerNoNole(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc2_.isNoNole = param1.pkg.readBoolean();
         }
      }
      
      private function __onChangePlayerTarget(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ == 0)
         {
            if(_playerThumbnailLController)
            {
               _playerThumbnailLController.currentBoss = null;
            }
            return;
         }
         var _loc3_:Living = _gameInfo.findLiving(_loc2_);
         _playerThumbnailLController.currentBoss = _loc3_;
      }
      
      public function objectSetProperty(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:GameLiving = this.getGameLivingByID(param1.pkg.extend1) as GameLiving;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:String = param1.pkg.readUTF();
         setProperty(_loc2_,_loc3_,_loc4_);
      }
      
      private function __playerHide(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc2_.isHidden = param1.pkg.readBoolean();
         }
      }
      
      private function __gameOver(param1:CrazyTankSocketEvent) : void
      {
         this.gameOver();
         _map.act(new GameOverAction(_map,param1,this.showExpView));
      }
      
      private function __missionOver(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:* = null;
         this.gameOver();
         this._missionAgain = new MissionAgainInfo();
         this._missionAgain.value = _gameInfo.missionInfo.tryagain;
         var _loc2_:DictionaryData = RoomManager.Instance.current.players;
         for(_loc3_ in _loc2_)
         {
            if(RoomPlayer(_loc2_[_loc3_]).isHost)
            {
               this._missionAgain.host = RoomPlayer(_loc2_[_loc3_]).playerInfo.NickName;
            }
            if(RoomPlayer(_loc2_[_loc3_]).isSelf)
            {
               if(!GameManager.Instance.Current.selfGamePlayer.petSkillEnabled)
               {
                  GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = true;
               }
            }
         }
         _map.act(new MissionOverAction(_map,param1,this.showExpView));
      }
      
      override protected function gameOver() : void
      {
         PageInterfaceManager.restorePageTitle();
         super.gameOver();
         KeyboardManager.getInstance().isStopDispatching = true;
      }
      
      private function showTryAgain() : void
      {
         var _loc1_:TryAgain = new TryAgain(this._missionAgain);
         _loc1_.addEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         _loc1_.addEventListener(GameEvent.GIVEUP,this.__giveup);
         _loc1_.addEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         _loc1_.show();
         addChild(_loc1_);
      }
      
      private function canShowTryAgainByRoomType() : Boolean
      {
         if(RoomManager.Instance.current.type == 15)
         {
            return false;
         }
         return true;
      }
      
      private function __tryAgainTimeOut(param1:GameEvent) : void
      {
         param1.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         param1.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         param1.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(this._expView)
         {
            this._expView.close();
         }
         this._expView = null;
      }
      
      private function showExpView() : void
      {
         if(ChatManager.Instance.input.parent)
         {
            ChatManager.Instance.switchVisible();
         }
         disposeUI();
         MenoryUtil.clearMenory();
		 if(GameManager.Instance.Current.roomType == RoomInfo.WORLD_BOSS_FIGHT)
		 {
			 StateManager.setState(StateType.WORLDBOSS_ROOM);
			 return;
		 }
         if(GameManager.Instance.Current.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
            return;
         }
         this._expView = new ExpView(_map.mapBitmap);
         this._expView.addEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         addChild(this._expView);
         this._expView.show();
      }
      
      private function __expShowed(param1:GameEvent) : void
      {
         var _loc2_:Living = null;
         var _loc3_:Living = null;
         this._expView.removeEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         for each(_loc2_ in _gameInfo.livings.list)
         {
            if(_loc2_.isSelf)
            {
               if(Player(_loc2_).isWin && this._missionAgain)
               {
                  this._missionAgain.win = true;
               }
               if(Player(_loc2_).hasLevelAgain && this._missionAgain)
               {
                  this._missionAgain.hasLevelAgain = true;
               }
            }
         }
         for each(_loc3_ in _gameInfo.viewers.list)
         {
            if(_loc3_.isSelf)
            {
               if(Player(_loc3_).isWin && this._missionAgain)
               {
                  this._missionAgain.win = true;
               }
               if(Player(_loc3_).hasLevelAgain && this._missionAgain)
               {
                  this._missionAgain.hasLevelAgain = true;
               }
            }
         }
         if((GameManager.isDungeonRoom(_gameInfo) || GameManager.isAcademyRoom(_gameInfo)) && _gameInfo.missionInfo.tryagain > 0)
         {
            if(RoomManager.Instance.current.selfRoomPlayer.isViewer && !this._missionAgain.win && this.canShowTryAgainByRoomType())
            {
               this.showTryAgain();
               if(this._expView)
               {
                  this._expView.visible = false;
               }
            }
            else if(RoomManager.Instance.current.selfRoomPlayer.isViewer && this._missionAgain.win)
            {
               if(this._expView)
               {
                  this._expView.close();
               }
               this._expView = null;
            }
            else if(!_gameInfo.selfGamePlayer.isWin && this.canShowTryAgainByRoomType())
            {
               this.showTryAgain();
               if(this._expView)
               {
                  this._expView.visible = false;
               }
            }
            else
            {
               this._expView.showCard();
               this._expView = null;
            }
         }
         else if(GameManager.isFightLib(_gameInfo))
         {
            this._expView.close();
            this._expView = null;
         }
         else if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._expView.close();
            this._expView = null;
         }
         else
         {
            this._expView.showCard();
            this._expView = null;
         }
      }
      
      private function hideAllOther() : void
      {
         ObjectUtils.disposeObject(_selfMarkBar);
         _selfMarkBar = null;
         ObjectUtils.disposeObject(_cs);
         _cs = null;
         ObjectUtils.disposeObject(_selfBuffBar);
         _selfBuffBar = null;
         _playerThumbnailLController.visible = false;
         ChatManager.Instance.view.visible = false;
         _leftPlayerView.visible = false;
         _vane.visible = false;
         _barrier.visible = false;
      }
      
      private function __giveup(param1:GameEvent) : void
      {
         param1.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         param1.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         param1.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendMissionTryAgain(0,true);
         }
         this._expView.close();
         this._expView = null;
      }
      
      private function __tryAgain(param1:GameEvent) : void
      {
         param1.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         param1.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         param1.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(!RoomManager.Instance.current.selfRoomPlayer.isViewer || GameManager.Instance.TryAgain == GameManager.MissionAgain)
         {
            GameManager.Instance.Current.hasNextMission = true;
         }
         if(RoomManager.Instance.current.type != RoomInfo.LANBYRINTH_ROOM)
         {
            this._expView.close();
         }
         this._expView = null;
      }
      
      private function __dander(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_ && _loc2_ is Player)
         {
            _loc3_ = param1.pkg.readInt();
            (_loc2_ as Player).dander = _loc3_;
         }
      }
      
      private function __reduceDander(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_ && _loc2_ is Player)
         {
            _loc3_ = param1.pkg.readInt();
            (_loc2_ as Player).reduceDander(_loc3_);
         }
      }
      
      private function __changeState(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc2_.State = param1.pkg.readInt();
            _map.setCenter(_loc2_.pos.x,_loc2_.pos.y,true);
         }
      }
      
      private function __selfObtainItem(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:PropInfo = null;
         var _loc4_:AutoDisappear = null;
         var _loc5_:AutoDisappear = null;
         var _loc6_:AutoDisappear = null;
         var _loc7_:MovieClipWrapper = null;
         if(_gameInfo.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            return;
         }
         for each(_loc2_ in param1.changedSlots)
         {
            _loc3_ = new PropInfo(_loc2_);
            _loc3_.Place = _loc2_.Place;
            if(PlayerManager.Instance.Self.FightBag.getItemAt(_loc2_.Place))
            {
               _loc4_ = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropBgAsset"),3);
               _loc4_.x = _vane.x - _loc4_.width / 2 + 48;
               _loc4_.y = _selfMarkBar.y + _selfMarkBar.height + 70;
               LayerManager.Instance.addToLayer(_loc4_,LayerManager.GAME_DYNAMIC_LAYER,false);
               _loc5_ = new AutoDisappear(PropItemView.createView(_loc3_.Template.Pic,62,62),3);
               _loc5_.x = _vane.x - _loc5_.width / 2 + 47;
               _loc5_.y = _selfMarkBar.y + _selfMarkBar.height + 70;
               LayerManager.Instance.addToLayer(_loc5_,LayerManager.GAME_DYNAMIC_LAYER,false);
               _loc6_ = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropCiteAsset"),3);
               _loc6_.x = _vane.x - _loc6_.width / 2 + 45;
               _loc6_.y = _selfMarkBar.y + _selfMarkBar.height + 70;
               LayerManager.Instance.addToLayer(_loc6_,LayerManager.GAME_DYNAMIC_LAYER,false);
               _loc7_ = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.zxcTip"),true,true);
               _loc7_.movie.x += _loc7_.movie.width * _loc2_.Place - this.ZXC_OFFSET * _loc2_.Place;
               LayerManager.Instance.addToLayer(_loc7_.movie,LayerManager.GAME_UI_LAYER,false);
            }
         }
      }
      
      private function __getTempItem(param1:BagEvent) : void
      {
         var _loc2_:Boolean = GameManager.Instance.selfGetItemShowAndSound(param1.changedSlots);
         if(_loc2_ && this._soundPlayFlag)
         {
            this._soundPlayFlag = false;
            SoundManager.instance.play("1001");
         }
      }
      
      private function __forstPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc2_.isFrozen = param1.pkg.readBoolean();
         }
      }
      
      private function __changeShootCount(param1:CrazyTankSocketEvent) : void
      {
         if(_gameInfo.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || param1.pkg.extend1 == _gameInfo.selfGamePlayer.LivingID)
         {
            _gameInfo.selfGamePlayer.shootCount = param1.pkg.readByte();
         }
      }
      
      private function __playSound(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = param1.pkg.readUTF();
         SoundManager.instance.initSound(_loc2_);
         SoundManager.instance.play(_loc2_);
      }
      
      private function __controlBGM(param1:CrazyTankSocketEvent) : void
      {
         if(param1.pkg.readBoolean())
         {
            SoundManager.instance.resumeMusic();
         }
         else
         {
            SoundManager.instance.pauseMusic();
         }
      }
      
      private function __forbidDragFocus(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         _map.smallMap.allowDrag = _loc2_;
         _arrowLeft.allowDrag = _arrowDown.allowDrag = _arrowRight.allowDrag = _arrowUp.allowDrag = _loc2_;
      }
      
      override protected function defaultForbidDragFocus() : void
      {
         _map.smallMap.allowDrag = true;
         _arrowLeft.allowDrag = _arrowDown.allowDrag = _arrowRight.allowDrag = _arrowUp.allowDrag = true;
      }
      
      private function __topLayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.readInt());
         if(_loc2_)
         {
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __loadResource(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:GameNeedMovieInfo = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new GameNeedMovieInfo();
            _loc4_.type = param1.pkg.readInt();
            _loc4_.path = param1.pkg.readUTF();
            _loc4_.classPath = param1.pkg.readUTF();
            _loc4_.startLoad();
            _loc3_++;
         }
      }
      
      public function livingShowBlood(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = Boolean(param1.pkg.readInt());
         (_map.getPhysical(_loc2_) as GameLiving).showBlood(_loc3_);
      }
      
      public function livingActionMapping(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:String = param1.pkg.readUTF();
         if(_map.getPhysical(_loc2_))
         {
            _map.getPhysical(_loc2_).setActionMapping(_loc3_,_loc4_);
         }
      }
      
      private function getGameLivingByID(param1:int) : PhysicalObj
      {
         if(!_map)
         {
            return null;
         }
         return _map.getPhysical(param1);
      }
      
      private function addStageCurtain(param1:SimpleObject) : void
      {
         var obj:SimpleObject = null;
         obj = param1;
         obj.movie.addEventListener("playEnd",function():void
         {
            obj.movie.stop();
            if(obj.parent)
            {
               obj.parent.removeChild(obj);
            }
            obj.dispose();
            obj = null;
         });
         addChild(obj);
      }
   }
}
