package trainer.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.character.GameCharacter;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.gametrainer.objects.TrainerEquip;
   import game.gametrainer.objects.TrainerWeapon;
   import game.model.Living;
   import game.model.Player;
   import game.objects.GamePlayer;
   import game.view.AutoPropEffect;
   import game.view.GameView;
   import hall.HallStateView;
   import road7th.data.DictionaryEvent;
   import road7th.utils.MovieClipWrapper;
   //import trainer.TrainStep;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.NewHandQueue;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   
   public class TrainerGameView extends GameView
   {
       
      
      private const eatOffset:int = -10;
      
      private var _player:GamePlayer;
      
      private var _shouldShowTurn:Boolean;
      
      private var _locked:Boolean;
      
      private var _picked:Boolean;
      
      private var _count:int;
      
      private var _dieNum:int;
      
      private var _weapon:TrainerWeapon;
      
      private var _equip:TrainerEquip;
      
      private var bogu:Living;
      
      private var toolForPick:MovieClip;
      
      public function TrainerGameView()
      {
         super();
      }
      
      override public function getType() : String
      {
         return StateType.TRAINER;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         var _loc3_:BaseLoader = null;
         super.enter(param1,param2);
         ChatManager.Instance.state = ChatManager.CHAT_TRAINER_STATE;
         ChatManager.Instance.view.visible = false;
         ChatManager.Instance.chatDisabled = true;
         this.setDefaultAngle();
         this.reset();
         this.checkUserGuid();
         if(!HallStateView.SoundLoaded)
         {
            _loc3_ = LoaderManager.Instance.creatLoader(PathManager.solveSoundSwf(),BaseLoader.MODULE_LOADER);
            _loc3_.addEventListener(LoaderEvent.COMPLETE,this.__onAudioLoadComplete);
            LoaderManager.Instance.startLoad(_loc3_);
         }
      }
      
      private function __onAudioLoadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onAudioLoadComplete);
         if(param1.loader.isSuccess)
         {
            SoundManager.instance.setupAudioResource();
            HallStateView.SoundLoaded = true;
         }
      }
      
      private function reset() : void
      {
         this._shouldShowTurn = true;
         this._locked = false;
         this._picked = false;
         this._count = 0;
         this._dieNum = 0;
      }
      
      private function checkUserGuid() : void
      {
         if(NewHandGuideManager.Instance.mapID == 111)
         {
            NewHandQueue.Instance.push(new Step(Step.POP_MOVE,this.exeMoveUI,this.preMoveUI));
            NewHandQueue.Instance.push(new Step(Step.MOVE,this.exeMove,this.preMove,this.finMove));
            NewHandQueue.Instance.push(new Step(Step.SPAWN,this.exeSpawn,this.preSpawn,null,2000));
            NewHandQueue.Instance.push(new Step(Step.POP_TIP_ONE,this.exeTipOne,this.preTipOne,this.finTipOne));
            NewHandQueue.Instance.push(new Step(Step.POP_ENERGY,this.exeEnergyUI,this.preEnergyUI));
            NewHandQueue.Instance.push(new Step(Step.BEAT_LIVING_RIGHT,this.exeBeatLivingRight,this.preBeatLivingRight,this.finBeatLivingRight));
            NewHandQueue.Instance.push(new Step(Step.BEAT_LIVING_LEFT,this.exeBeatLivingLeft,this.preBeatLivingLeft,this.finBeatLivingLeft,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_ONE,this.exePickOne,this.prePickOne,this.finPickOne,1500));
         }
         else if(NewHandGuideManager.Instance.mapID == 112)
         {
            NewHandQueue.Instance.push(new Step(Step.PLAY_ONE_GLOW,this.exeOneGlow,this.preOneGlow,this.finOneGlow));
            NewHandQueue.Instance.push(new Step(Step.POP_ANGLE,this.exeAngle,this.preAngle,this.finAngle));
            NewHandQueue.Instance.push(new Step(Step.SPAWN_SMALL_BOGU,this.exeSmallBogu,this.preSmallBogu,this.finSmallBogu));
            NewHandQueue.Instance.push(new Step(Step.SPAWN_BIG_BOGU,this.exeBigBogu,this.preBigBogu,this.finBigBogu,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_TEN,this.exePickTen,this.prePickTen,this.finPickTen,1500));
         }
         else if(NewHandGuideManager.Instance.mapID == 113)
         {
            NewHandQueue.Instance.push(new Step(Step.PICK_POWER_THREE,this.exePickPower,this.prePickPower,this.finPickPower,1500));
         }
         else if(NewHandGuideManager.Instance.mapID == 114)
         {
            NewHandQueue.Instance.push(new Step(Step.ARROW_THREE,this.exeArrowThree,this.preArrowThree,this.finArrowThree));
            NewHandQueue.Instance.push(new Step(Step.ARROW_POWER,this.exeArrowPower,this.preArrowPower,this.finArrowPower,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_PLANE,this.exePickPlane,this.prePickPlane,this.finPickPlane,1500));
         }
         else if(NewHandGuideManager.Instance.mapID == 115)
         {
            NewHandQueue.Instance.push(new Step(Step.BEAT_JIANJIAO_BOGU,this.exeBeatJianjiaoBogu,this.preBeatJianjiaoBogu,this.finBeatJianjiaoBogu,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_TWO_TWENTY,this.exePickTwoTwenty,this.prePickTwoTwenty,this.finPickTwoTwenty,1500));
         }
         else if(NewHandGuideManager.Instance.mapID == 116)
         {
            NewHandQueue.Instance.push(new Step(Step.BEAT_ROBOT,this.exeBeatRobot,this.preBeatRobot,this.finBeatRobot,4000));
            NewHandQueue.Instance.push(new Step(Step.PICK_THREE_FOUR_FIVE,this.exePickThreeFourFive,this.prePickThreeFourFive,this.finPickThreeFourFive,1500));
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         super.leaving(param1);
         NewHandGuideManager.Instance.mapID = 0;
         this.disposeThis();
      }
      
      private function showAchieve() : void
      {
         var _loc1_:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance("game.trainer.achiveAsset"),true,true);
         PositionUtils.setPos(_loc1_.movie,"trainer.posAchieve");
         LayerManager.Instance.addToLayer(_loc1_.movie,LayerManager.GAME_TOP_LAYER,false);
      }
      
      override protected function __playerChange(param1:CrazyTankSocketEvent) : void
      {
         if(this._locked)
         {
            _map.lockFocusAt(PositionUtils.creatPoint("trainer.posLockFocus"));
         }
         if(this._shouldShowTurn)
         {
            super.__playerChange(param1);
            _selfMarkBar.enabled = true;
         }
         else
         {
            _selfMarkBar.enabled = false;
         }
         setPropBarClickEnable(true,true);
      }
      
      override protected function __shoot(param1:CrazyTankSocketEvent) : void
      {
         super.__shoot(param1);
         if(this._locked)
         {
            _map.releaseFocus();
         }
      }
      
      public function set shouldShowTurn(param1:Boolean) : void
      {
         this._shouldShowTurn = param1;
      }
      
      public function skip() : void
      {
         GameInSocketOut.sendGameSkipNext(1);
      }
      
      private function enableSpace(param1:Boolean) : void
      {
         if(param1)
         {
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownSpace,true);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownSpace,false);
         }
         else
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownSpace,true,99);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownSpace,false,99);
         }
      }
      
      private function enableLeftAndRight(param1:Boolean) : void
      {
         if(param1)
         {
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownLeftRight,true);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownLeftRight,false);
         }
         else
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownLeftRight,true,99);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownLeftRight,false,99);
         }
      }
      
      private function enableUpAndDown(param1:Boolean) : void
      {
         if(param1)
         {
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownUpDown,true);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownUpDown,false);
         }
         else
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownUpDown,true,99);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownUpDown,false,99);
         }
      }
      
      private function __keyDownSpace(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SPACE)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private function __keyDownLeftRight(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT || param1.keyCode == 65 || param1.keyCode == 68)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private function __keyDownUpDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN || param1.keyCode == 87 || param1.keyCode == 83)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private function preMoveUI() : void
      {
         _selfMarkBar.enabled = false;
         _map.smallMap.allowDrag = false;
         this.enableSpace(false);
         this.enableLeftAndRight(false);
         this.enableUpAndDown(false);
         setBarrierVisible(false);
         setPlayerThumbVisible(false);
         this.shouldShowTurn = false;
         this._player = _players[_gameInfo.selfGamePlayer] as GamePlayer;
         this._player.player.isAttacking = true;
         this._player.player.maxEnergy = 10000;
         _gameInfo.selfGamePlayer.energy = 10000;
         NewHandContainer.Instance.showMovie("asset.trainer.mcMove");
         setTimeout(NewHandContainer.Instance.showMovie,1000,"asset.trainer.leftKeyShineAsset","trainer.posLeftKey");
      }
      
      private function exeMoveUI() : Boolean
      {
         return true;
      }
      
      private function preMove() : void
      {
         this._weapon = new TrainerWeapon(100001);
         this._weapon.pos = PositionUtils.creatPoint("trainer1.posWeapon");
         this._player.map.addPhysical(this._weapon);
         this.enableLeftAndRight(true);
         GameManager.Instance.Current.selfGamePlayer.selfInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerPropChanged,false,-1);
      }
      
      private function exeMove() : Boolean
      {
         var _loc1_:MovieClipWrapper = null;
         var _loc2_:MovieClipWrapper = null;
         _loc1_ = null;
         _loc2_ = null;
         if(this._weapon)
         {
            if(this._player.pos.x - this._weapon.pos.x < 65)
            {
               GameInSocketOut.sendUpdatePlayStep("pickUpWeapon");
               _loc1_ = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset"),true,true);
               _loc1_.addFrameScriptAt(12,this.headWeaponEffect);
               SoundManager.instance.play("039");
               _loc1_.movie.y = this.eatOffset;
               this._player.addChild(_loc1_.movie);
               this._player.doAction(GameCharacter.HANDCLIP);
               this._weapon.dispose();
               this._weapon = null;
               NewHandContainer.Instance.hideMovie("asset.trainer.leftKeyShineAsset");
               NewHandContainer.Instance.showMovie("asset.trainer.rightKeyShineAsset","trainer.posRightKey");
               this._equip = new TrainerEquip(100002);
               this._equip.pos = PositionUtils.creatPoint("trainer1.posEquip");
               this._player.map.addPhysical(this._equip);
            }
         }
         if(this._equip)
         {
            if(this._player.pos.x - this._equip.pos.x > -10)
            {
               GameInSocketOut.sendUpdatePlayStep("pickUpHat");
               _loc2_ = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset"),true,true);
               _loc2_.addFrameScriptAt(12,this.headEquipEffect);
               SoundManager.instance.play("039");
               _loc2_.movie.y = this.eatOffset;
               this._player.addChild(_loc2_.movie);
               this._player.doAction(GameCharacter.HANDCLIP);
               this._equip.dispose();
               this._equip = null;
               this.enableLeftAndRight(false);
            }
         }
         if(!this._weapon && !this._equip)
         {
            ++this._count;
         }
         return !this._weapon && !this._equip && this._count >= 55;
      }
      
      private function __playerPropChanged(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["WeaponID"])
         {
            this.setDefaultAngle();
         }
      }
      
      private function setDefaultAngle() : void
      {
         GameManager.Instance.Current.selfGamePlayer.manuallySetGunAngle(35);
      }
      
      private function headWeaponEffect() : void
      {
         this.headEffect(ComponentFactory.Instance.creatBitmap("asset.trainer.TrainerWeaponIcon"));
      }
      
      private function headEquipEffect() : void
      {
         var _loc1_:String = !!PlayerManager.Instance.Self.Sex ? "asset.trainer.TrainerManEquipIcon" : "asset.trainer.TrainerWomanEquipIcon";
         this.headEffect(ComponentFactory.Instance.creatBitmap(_loc1_));
      }
      
      private function headEffect(param1:DisplayObject) : void
      {
         var _loc2_:AutoPropEffect = new AutoPropEffect(param1);
         PositionUtils.setPos(_loc2_,"trainer1.posHeadEffect");
         param1.width = 62;
         param1.height = 62;
         this._player.addChild(_loc2_);
      }
      
      private function finMove() : void
      {
         GameManager.Instance.Current.selfGamePlayer.selfInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerPropChanged,false);
         NewHandContainer.Instance.hideMovie("asset.trainer.rightKeyShineAsset");
         NewHandContainer.Instance.hideMovie("asset.trainer.mcMove");
         this.showAchieve();
         setPlayerThumbVisible(true);
         SoundManager.instance.play("018");
      }
      
      private function preSpawn() : void
      {
         this._count = 0;
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addBogu);
         GameInSocketOut.sendUpdatePlayStep("createRightBogu");
      }
      
      private function exeSpawn() : Boolean
      {
         if(this.bogu)
         {
            ++this._count;
         }
         return this.bogu && this._count >= 50;
      }
      
      private function preTipOne() : void
      {
         this._count = 0;
         NewHandContainer.Instance.showMovie("asset.trainer.mcBeatBoguAsset");
      }
      
      private function exeTipOne() : Boolean
      {
         ++this._count;
         return this._count >= 106;
      }
      
      private function finTipOne() : void
      {
         NewHandContainer.Instance.hideMovie("asset.trainer.mcBeatBoguAsset");
      }
      
      private function preEnergyUI() : void
      {
         this._count = 0;
         NewHandContainer.Instance.showMovie("asset.trainer.mcEnergy");
         setEnergyVisible(true);
         this.shouldShowTurn = true;
         this.skip();
      }
      
      private function exeEnergyUI() : Boolean
      {
         ++this._count;
         return this._count >= 25;
      }
      
      private function preBeatLivingRight() : void
      {
         this.enableSpace(true);
      }
      
      private function exeBeatLivingRight() : Boolean
      {
         if(this.bogu && !this.bogu.isLiving)
         {
            this.enableLeftAndRight(true);
            return true;
         }
         return false;
      }
      
      private function finBeatLivingRight() : void
      {
         NewHandContainer.Instance.hideMovie("asset.trainer.mcEnergy");
         this.showAchieve();
         this.shouldShowTurn = false;
         this.skip();
         SoundManager.instance.play("018");
         this.disposeBogu();
      }
      
      private function preBeatLivingLeft() : void
      {
         this._count = 0;
         this.enableSpace(false);
         this.lockMap();
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addBogu);
         GameInSocketOut.sendUpdatePlayStep("createLeftBogu");
      }
      
      private function exeBeatLivingLeft() : Boolean
      {
         if(this.bogu)
         {
            ++this._count;
         }
         if(this._count == 50)
         {
            NewHandContainer.Instance.showMovie("asset.trainer.mcBigEnergyAsset");
         }
         else if(this._count == 100)
         {
            this.shouldShowTurn = true;
            this.skip();
            this.enableSpace(true);
         }
         return this.bogu && !this.bogu.isLiving;
      }
      
      private function finBeatLivingLeft() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         NewHandContainer.Instance.hideMovie("asset.trainer.mcBigEnergyAsset");
         _map.releaseFocus();
      }
      
      private function prePickOne() : void
      {
         this.showAchieve();
         this.creatToolForPick("asset.trainer.pickOneAsset");
      }
      
      private function exePickOne() : Boolean
      {
         return this._picked;
      }
      
      private function finPickOne() : void
      {
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.GAIN_ADDONE);
         this.disposeBogu();
      }
      
      private function __addBogu(param1:DictionaryEvent) : void
      {
         this.bogu = param1.data as Living;
      }
      
      private function disposeBogu() : void
      {
         _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__addBogu);
         this.bogu = null;
      }
      
      private function lockMap() : void
      {
         _map.lockFocusAt(PositionUtils.creatPoint("trainer.posLockFocus"));
         this._locked = true;
      }
      
      private function preOneGlow() : void
      {
         this._count = 0;
         this.enableUpAndDown(true);
         NewHandContainer.Instance.showMovie("asset.trainer.getOne");
      }
      
      private function exeOneGlow() : Boolean
      {
         ++this._count;
         return this._count >= 93;
      }
      
      private function finOneGlow() : void
      {
         NewHandContainer.Instance.hideMovie("asset.trainer.getOne");
      }
      
      private function preAngle() : void
      {
         NewHandContainer.Instance.showMovie("asset.trainer.mcAngle");
      }
      
      private function exeAngle() : Boolean
      {
         return true;
      }
      
      private function finAngle() : void
      {
      }
      
      private function preSmallBogu() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addBogu);
         GameInSocketOut.sendUpdatePlayStep("createsmallbogu");
      }
      
      private function exeSmallBogu() : Boolean
      {
         return this.bogu && !this.bogu.isLiving;
      }
      
      private function finSmallBogu() : void
      {
         this.disposeBogu();
         this.shouldShowTurn = false;
         this.skip();
      }
      
      private function preBigBogu() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addBogu);
         _gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__showArrow);
         GameInSocketOut.sendUpdatePlayStep("createbigbogu");
         setTimeout(this.showTurn,5000);
      }
      
      private function showTurn() : void
      {
         this.shouldShowTurn = true;
         this.skip();
      }
      
      private function exeBigBogu() : Boolean
      {
         return this.bogu && !this.bogu.isLiving;
      }
      
      private function finBigBogu() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         _gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__showArrow);
         NewHandContainer.Instance.hideMovie("asset.trainer.mcAngle");
      }
      
      private function prePickTen() : void
      {
         this.creatToolForPick("asset.trainer.pickTenAsset");
      }
      
      private function exePickTen() : Boolean
      {
         return this._picked;
      }
      
      private function finPickTen() : void
      {
         this.disposeToolForPick();
         this.disposeBogu();
         SocketManager.Instance.out.syncWeakStep(Step.GAIN_TEN_PERSENT);
      }
      
      private function prePickPower() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__onAddLiving);
      }
      
      private function __onAddLiving(param1:DictionaryEvent) : void
      {
         _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__onAddLiving);
         this.bogu = param1.data as Living;
         this.bogu.addEventListener(LivingEvent.DIE,this.__onLivingDie);
      }
      
      private function __onLivingDie(param1:LivingEvent) : void
      {
         //TrainStep.send(TrainStep.Step.GET_POW);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         this.bogu.removeEventListener(LivingEvent.DIE,this.__onLivingDie);
         setTimeout(this.creatToolForPick,4000,"asset.trainer.getPowerThreeAsset");
      }
      
      private function exePickPower() : Boolean
      {
         return this._picked;
      }
      
      private function finPickPower() : void
      {
         this.bogu = null;
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.POWER_OPEN);
         SocketManager.Instance.out.syncWeakStep(Step.THREE_OPEN);
      }
      
      private function preArrowThree() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__add);
         _gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__showThreeArrow);
      }
      
      private function __add(param1:DictionaryEvent) : void
      {
         var _loc2_:Living = param1.data as Living;
         if(_loc2_.typeLiving == 5)
         {
            this.bogu = _loc2_;
         }
         else
         {
            _loc2_.addEventListener(LivingEvent.DIE,this.__die);
         }
      }
      
      private function __die(param1:LivingEvent) : void
      {
         (param1.currentTarget as EventDispatcher).removeEventListener(LivingEvent.DIE,this.__die);
         ++this._dieNum;
      }
      
      private function exeArrowThree() : Boolean
      {
         return this._dieNum >= 5;
      }
      
      private function finArrowThree() : void
      {
         _gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__showThreeArrow);
      }
      
      private function preArrowPower() : void
      {
         _gameInfo.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__showPowerArrow);
         _gameInfo.selfGamePlayer.addEventListener(LivingEvent.DANDER_CHANGED,this.__showPowerArrow);
      }
      
      private function exeArrowPower() : Boolean
      {
         return this.bogu && !this.bogu.isLiving;
      }
      
      private function finArrowPower() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__add);
         _gameInfo.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__showPowerArrow);
         _gameInfo.selfGamePlayer.removeEventListener(LivingEvent.DANDER_CHANGED,this.__showPowerArrow);
      }
      
      private function prePickPlane() : void
      {
         this.creatToolForPick("asset.trainer.pickPlaneAsset");
      }
      
      private function exePickPlane() : Boolean
      {
         return this._picked;
      }
      
      private function finPickPlane() : void
      {
         //TrainStep.send(TrainStep.Step.COLLECT_PLANE);
         this.bogu = null;
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.PLANE_OPEN);
      }
      
      private function __showThreeArrow(param1:LivingEvent) : void
      {
         if(_gameInfo.selfGamePlayer.isAttacking)
         {
            NewHandContainer.Instance.showArrow(ArrowType.TIP_THREE,-90,"trainer.posTipThree");
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function __showPowerArrow(param1:LivingEvent) : void
      {
         if(_gameInfo.selfGamePlayer.isAttacking)
         {
            if(_gameInfo.selfGamePlayer.dander >= Player.TOTAL_DANDER)
            {
               NewHandContainer.Instance.showArrow(ArrowType.TIP_POWER,-30,"trainer.posTipPower");
            }
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function __showArrow(param1:LivingEvent) : void
      {
         if(_gameInfo.selfGamePlayer.isAttacking)
         {
            NewHandContainer.Instance.showArrow(ArrowType.TIP_ONE,-90,"trainer.posTipOne");
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(-1);
         }
      }
      
      private function preBeatJianjiaoBogu() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addJianjiaoBogu);
         setTimeout(__dungeonVisibleChanged,5500,null);
      }
      
      private function __addJianjiaoBogu(param1:DictionaryEvent) : void
      {
         var _loc2_:Living = param1.data as Living;
         if(_loc2_.typeLiving == 5)
         {
            _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__addJianjiaoBogu);
            this.bogu = _loc2_;
         }
      }
      
      private function exeBeatJianjiaoBogu() : Boolean
      {
         return this.bogu && !this.bogu.isLiving;
      }
      
      private function finBeatJianjiaoBogu() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
      }
      
      private function prePickTwoTwenty() : void
      {
         this.creatToolForPick("asset.trainer.pickTwoTwentyAsset");
      }
      
      private function exePickTwoTwenty() : Boolean
      {
         return this._picked;
      }
      
      private function finPickTwoTwenty() : void
      {
         //TrainStep.send(TrainStep.Step.GET_ADD_HARMTWO);
         this.bogu = null;
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.TWO_OPEN);
         SocketManager.Instance.out.syncWeakStep(Step.TWENTY_OPEN);
      }
      
      private function preBeatRobot() : void
      {
         _gameInfo.livings.addEventListener(DictionaryEvent.ADD,this.__addRobot);
      }
      
      private function __addRobot(param1:DictionaryEvent) : void
      {
         var _loc2_:Living = param1.data as Living;
         if(_loc2_.typeLiving == 5)
         {
            _gameInfo.livings.removeEventListener(DictionaryEvent.ADD,this.__addRobot);
            this.bogu = _loc2_;
         }
      }
      
      private function exeBeatRobot() : Boolean
      {
         return this.bogu && !this.bogu.isLiving;
      }
      
      private function finBeatRobot() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
      }
      
      private function prePickThreeFourFive() : void
      {
         this.creatToolForPick("asset.trainer.pickThreeFourFiveAsset");
      }
      
      private function exePickThreeFourFive() : Boolean
      {
         return this._picked;
      }
      
      private function finPickThreeFourFive() : void
      {
         //TrainStep.send(TrainStep.Step.GET_ADD_HARMTHREE);
         this.bogu = null;
         this.disposeToolForPick();
         SocketManager.Instance.out.syncWeakStep(Step.THIRTY_OPEN);
         SocketManager.Instance.out.syncWeakStep(Step.FORTY_OPEN);
         SocketManager.Instance.out.syncWeakStep(Step.FIFTY_OPEN);
      }
      
      private function __missionOver(param1:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         NewHandQueue.Instance.dispose();
         NewHandContainer.Instance.hideMovie("-1");
         NewHandContainer.Instance.clearArrowByID(-1);
      }
      
      private function exeBeatBogu() : Boolean
      {
         return this.bogu && !this.bogu.isLiving;
      }
      
      private function creatToolForPick(param1:String) : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         _loc2_ = _map.localToGlobal(new Point(this.bogu.pos.x,this.bogu.pos.y));
         this.toolForPick = ClassUtils.CreatInstance(param1) as MovieClip;
         this.toolForPick.buttonMode = true;
         this.toolForPick.addEventListener(MouseEvent.CLICK,this.__pickTool);
         this.toolForPick.x = _loc2_.x;
         this.toolForPick.y = _loc2_.y;
         this.toolForPick.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.toolForPick.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         LayerManager.Instance.addToLayer(this.toolForPick,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         SoundManager.instance.play("156");
      }
      
      private function disposeToolForPick() : void
      {
         ObjectUtils.disposeObject(this.toolForPick);
         this.toolForPick.removeEventListener(MouseEvent.CLICK,this.__pickTool);
         this.toolForPick.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.toolForPick.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this.toolForPick = null;
         this._picked = false;
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         this.toolForPick.filters = null;
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         this.toolForPick.filters = [new GlowFilter(16737792,1,30,30,2)];
      }
      
      private function __pickTool(param1:MouseEvent) : void
      {
         this._picked = true;
         SoundManager.instance.play("008");
         SoundManager.instance.play("157");
      }
      
      private function disposeThis() : void
      {
         this.enableLeftAndRight(true);
         this.enableUpAndDown(true);
         this.enableSpace(true);
         this._player = null;
         this.bogu = null;
         if(this._weapon)
         {
            this._weapon.dispose();
            this._weapon = null;
         }
         if(this._equip)
         {
            this._equip.dispose();
            this._equip = null;
         }
      }
   }
}
