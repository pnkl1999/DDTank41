package game.model
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffType;
   import ddt.data.FightBuffInfo;
   import ddt.data.FightContainerBuff;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingCommandEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.BuffManager;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.actions.ActionManager;
   import game.actions.BaseAction;
   import game.interfaces.ICommandedAble;
   import game.objects.SimpleBox;
   import game.view.effects.BaseMirariEffectIcon;
   import road7th.data.DictionaryData;
   import road7th.data.StringObject;
   
   [Event(name="posChanged",type="ddt.events.LivingEvent")]
   [Event(name="dirChanged",type="ddt.events.LivingEvent")]
   [Event(name="forzenChanged",type="ddt.events.LivingEvent")]
   [Event(name="hiddenChanged",type="ddt.events.LivingEvent")]
   [Event(name="noholeChanged",type="ddt.events.LivingEvent")]
   [Event(name="die",type="ddt.events.LivingEvent")]
   [Event(name="angleChanged",type="ddt.events.LivingEvent")]
   [Event(name="bloodChanged",type="ddt.events.LivingEvent")]
   [Event(name="beginNewTurn",type="ddt.events.LivingEvent")]
   [Event(name="shoot",type="ddt.events.LivingEvent")]
   [Event(name="beat",type="ddt.events.LivingEvent")]
   [Event(name="transmit",type="ddt.events.LivingEvent")]
   [Event(name="moveTo",type="ddt.events.LivingEvent")]
   [Event(name="fall",type="ddt.events.LivingEvent")]
   [Event(name="jump",type="ddt.events.LivingEvent")]
   [Event(name="say",type="ddt.events.LivingEvent")]
   public class Living extends EventDispatcher implements ICommandedAble
   {
      
      public static const CRY_ACTION:String = "cry";
      
      public static const STAND_ACTION:String = "stand";
      
      public static const DIE_ACTION:String = "die";
      
      public static const SHOOT_ACTION:String = "beat2";
      
      public static const BORN_ACTION:String = "born";
      
      public static const RENEW:String = "renew";
      
      public static const ANGRY_ACTION:String = "angry";
      
      public static const WALK_ACTION:String = "walk";
      
      public static const DEFENCE_ACTION:String = "shield";
      
      public static const SUICIDE:int = 6;
      
      public static const WOUND:int = 3;
      
      public static const FLASH_BACK:int = 7;
       
      
      public var character:ShowCharacter;
      
      public var typeLiving:int;
      
      private var _state:int = 0;
      
      private var _onChange:Boolean;
      
      private var _mirariEffects:DictionaryData;
      
      private var _localBuffs:Vector.<FightBuffInfo>;
      
      private var _turnBuffs:Vector.<FightBuffInfo>;
      
      private var _petBuffs:Vector.<FightBuffInfo>;
      
      public var outTurnBuffs:Vector.<FightBuffInfo>;
      
      private var _noPicPetBuff:DictionaryData;
      
      public var maxEnergy:int = 240;
      
      public var isExist:Boolean = true;
      
      public var isBottom:Boolean;
      
      public var isLocked:Boolean;
      
      private var _isLockFly:Boolean = false;
      
      private var _isLockAngle:Boolean;
      
      private var _payBuff:FightContainerBuff;
      
      private var _name:String = "";
      
      private var _livingID:int;
      
      private var _team:int;
      
      private var _fallingType:int = 0;
      
      protected var _pos:Point;
      
      private var _direction:int = 1;
      
      private var _maxBlood:int;
      
      private var _blood:int;
      
      private var _isFrozen:Boolean;
      
      private var _isGemGlow:Boolean;
      
      private var _gemDefense:Boolean;
      
      private var _isHidden:Boolean;
      
      private var _isNoNole:Boolean;
      
      protected var _lockState:Boolean;
      
      protected var _lockType:int = 1;
      
      protected var _isLiving:Boolean;
      
      private var _playerAngle:Number = 0;
      
      private var _actionMovieName:String;
      
      private var _isMoving:Boolean;
      
      public var isFalling:Boolean;
      
      private var _actionManager:ActionManager;
      
      private var _actionMovie:Bitmap;
      
      private var _thumbnail:BitmapData;
      
      private var _defaultAction:String = "";
      
      private var _cmdList:Dictionary;
      
      public var outProperty:Dictionary;
      
      private var _shootInterval:int;
      
      protected var _psychic:int = 0;
      
      protected var _energy:Number = 1;
      
      public function Living(param1:int, param2:int, param3:int)
      {
         this._localBuffs = new Vector.<FightBuffInfo>();
         this._turnBuffs = new Vector.<FightBuffInfo>();
         this._petBuffs = new Vector.<FightBuffInfo>();
         this.outTurnBuffs = new Vector.<FightBuffInfo>();
         this._noPicPetBuff = new DictionaryData();
         this._pos = new Point(0,0);
         this._shootInterval = Player.SHOOT_INTERVAL;
         super();
         this._livingID = param1;
         this._team = param2;
         this._maxBlood = param3;
         this._actionManager = new ActionManager();
         this._mirariEffects = new DictionaryData();
         this.reset();
      }
      
      public function get MirariEffects() : DictionaryData
      {
         return this._mirariEffects;
      }
      
      public function get isBoss() : Boolean
      {
         return this.typeLiving == 4 && this.typeLiving == 5 && this.typeLiving == 6;
      }
      
      public function reset() : void
      {
         this._blood = this._maxBlood;
         this._isLiving = true;
         this._isFrozen = false;
         this._gemDefense = false;
         this._isHidden = false;
         this._isNoNole = false;
         this.isLockAngle = false;
         this._localBuffs = new Vector.<FightBuffInfo>();
         this._turnBuffs = new Vector.<FightBuffInfo>();
         this._petBuffs = new Vector.<FightBuffInfo>();
         ObjectUtils.disposeObject(this._payBuff);
         this._payBuff = null;
      }
      
      public function clearEffectIcon() : void
      {
         this._mirariEffects.clear();
      }
      
      public function set isLockFly(param1:Boolean) : void
      {
         this._isLockFly = param1;
         dispatchEvent(new LivingEvent(LivingEvent.LOCKFLY_CHANGED,0,0,this._isLockFly));
      }
      
      public function get isLockFly() : Boolean
      {
         return this._isLockFly;
      }
      
      public function get petBuffs() : Vector.<FightBuffInfo>
      {
         return this._petBuffs;
      }
      
      public function get isLockAngle() : Boolean
      {
         return this._isLockAngle;
      }
      
      public function set isLockAngle(param1:Boolean) : void
      {
         if(this._isLockAngle == param1)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._isLockAngle)
         {
            _loc2_ = 1;
         }
         if(param1)
         {
            _loc3_ = 1;
         }
         this._isLockAngle = param1;
         dispatchEvent(new LivingEvent(LivingEvent.LOCKANGLE_CHANGE,_loc3_,_loc2_));
      }
      
      public function hasEffect(param1:BaseMirariEffectIcon) : Boolean
      {
         return this._mirariEffects[String(param1.mirariType)] != null;
      }
      
      public function get localBuffs() : Vector.<FightBuffInfo>
      {
         return this._localBuffs;
      }
      
      public function get turnBuffs() : Vector.<FightBuffInfo>
      {
         return this._turnBuffs;
      }
      
      public function set turnBuffs(param1:Vector.<FightBuffInfo>) : void
      {
         this._turnBuffs = param1;
      }
      
      private function addPayBuff(param1:FightBuffInfo) : void
      {
         if(this._payBuff == null)
         {
            this._payBuff = new FightContainerBuff(-1);
            this._localBuffs.unshift(this._payBuff);
         }
         this._payBuff.addPayBuff(param1);
      }
      
      public function addBuff(param1:FightBuffInfo) : void
      {
         param1.isSelf = this.isSelf;
         if(BuffType.isPayBuff(param1))
         {
            this.addPayBuff(param1);
            return;
         }
         if(param1.type == BuffType.Local)
         {
            this._localBuffs.push(param1);
         }
         else
         {
            if(this.hasBuff(param1,this._turnBuffs))
            {
               return;
            }
            this._turnBuffs.push(param1);
         }
         param1.execute(this);
         dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,param1.type));
      }
      
      private function hasBuff(param1:FightBuffInfo, param2:Vector.<FightBuffInfo>) : Boolean
      {
         var _loc3_:FightBuffInfo = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.id == param1.id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function removeBuff(param1:int) : void
      {
         var _loc2_:Vector.<FightBuffInfo> = null;
         var _loc3_:int = 0;
         if(BuffType.isLocalBuffByID(param1))
         {
            _loc2_ = this._localBuffs;
            _loc3_ = BuffType.Local;
         }
         else
         {
            _loc2_ = this._turnBuffs;
            _loc3_ = BuffType.Turn;
         }
         var _loc4_:int = _loc2_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc2_[_loc5_].id == param1)
            {
               _loc2_[_loc5_].unExecute(this);
               _loc2_.splice(_loc5_,1);
               if(_loc3_ == BuffType.Local)
               {
                  this._localBuffs = this._localBuffs.sort(this.buffCompare);
               }
               else
               {
                  this._turnBuffs = this._turnBuffs.sort(this.buffCompare);
               }
               dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,_loc3_));
               break;
            }
            _loc5_++;
         }
      }
      
      protected function buffCompare(param1:FightBuffInfo, param2:FightBuffInfo) : Number
      {
         if(param1.priority == param2.priority)
         {
            return 0;
         }
         if(param1.priority < param2.priority)
         {
            return 1;
         }
         return -1;
      }
      
      public function handleMirariEffect(param1:BaseMirariEffectIcon) : void
      {
         if(param1.single)
         {
            if(!this.hasEffect(param1))
            {
               this._mirariEffects.add(param1.mirariType,param1);
            }
         }
         else
         {
            this._mirariEffects.add(param1.mirariType,param1);
         }
         param1.excuteEffect(this);
      }
      
      public function removeMirariEffect(param1:BaseMirariEffectIcon) : void
      {
         param1.dispose();
         this._mirariEffects.remove(param1.mirariType);
         param1.unExcuteEffect(this);
      }
      
      public function dispose() : void
      {
         this.isExist = false;
         if(this._actionMovie)
         {
            if(this._actionMovie.parent)
            {
               this._actionMovie.parent.removeChild(this._actionMovie);
            }
            this._actionMovie.bitmapData.dispose();
         }
         this._actionMovie = null;
         if(this._thumbnail)
         {
            this._thumbnail.dispose();
         }
         this._thumbnail = null;
         this.character = null;
         if(this._mirariEffects)
         {
            this._mirariEffects.clear();
         }
         this._mirariEffects = null;
         if(this._actionManager)
         {
            this._actionManager.clear();
         }
         this._actionManager = null;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get LivingID() : int
      {
         return this._livingID;
      }
      
      public function get team() : int
      {
         return this._team;
      }
      
      public function set team(param1:int) : void
      {
         this._team = param1;
      }
      
      public function set fallingType(param1:int) : void
      {
         this._fallingType = 0;
      }
      
      public function get fallingType() : int
      {
         return this._fallingType;
      }
      
      public function get onChange() : Boolean
      {
         return this._onChange;
      }
      
      public function set onChange(param1:Boolean) : void
      {
         this._onChange = param1;
      }
      
      public function get pos() : Point
      {
         return this._pos;
      }
      
      public function set pos(param1:Point) : void
      {
         if(!param1)
         {
            return;
         }
         if(this._pos.equals(param1) == false)
         {
            this._pos = param1;
            dispatchEvent(new LivingEvent(LivingEvent.POS_CHANGED));
         }
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      public function set direction(param1:int) : void
      {
         if(this._direction == param1)
         {
            return;
         }
         this._direction = param1;
         this.sendCommand("changeDir");
         dispatchEvent(new LivingEvent(LivingEvent.DIR_CHANGED));
      }
      
      public function get maxBlood() : int
      {
         return this._maxBlood;
      }
      
      public function set maxBlood(param1:int) : void
      {
         this._maxBlood = param1;
         dispatchEvent(new LivingEvent(LivingEvent.MAX_HP_CHANGED));
      }
      
      public function get blood() : int
      {
         return this._blood;
      }
      
      public function set blood(param1:int) : void
      {
         this._blood = param1 > this.maxBlood ? int(int(this.maxBlood)) : int(int(param1));
      }
      
      public function initBlood(param1:int) : void
      {
         this.blood = param1;
         dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,param1,0,5));
      }
      
      public function get isFrozen() : Boolean
      {
         return this._isFrozen;
      }
      
      public function set isFrozen(param1:Boolean) : void
      {
         if(this._isFrozen == param1)
         {
            return;
         }
         this._isFrozen = param1;
         dispatchEvent(new LivingEvent(LivingEvent.FORZEN_CHANGED));
      }
      
      public function get isGemGlow() : Boolean
      {
         return this._isGemGlow;
      }
      
      public function set isGemGlow(param1:Boolean) : void
      {
         if(this._isGemGlow != param1)
         {
            this._isGemGlow = param1;
            dispatchEvent(new LivingEvent(LivingEvent.GEM_GLOW_CHANGED));
         }
      }
      
      public function get gemDefense() : Boolean
      {
         return this._gemDefense;
      }
      
      public function set gemDefense(param1:Boolean) : void
      {
         if(this._gemDefense == param1)
         {
            return;
         }
         this._gemDefense = param1;
         dispatchEvent(new LivingEvent(LivingEvent.GEM_DEFENSE_CHANGED));
      }
      
      public function get isHidden() : Boolean
      {
         return this._isHidden;
      }
      
      public function set isHidden(param1:Boolean) : void
      {
         if(param1 == this._isHidden)
         {
            return;
         }
         this._isHidden = param1;
         dispatchEvent(new LivingEvent(LivingEvent.HIDDEN_CHANGED));
      }
      
      public function get isNoNole() : Boolean
      {
         return this._isNoNole;
      }
      
      public function set isNoNole(param1:Boolean) : void
      {
         if(this._isNoNole != param1)
         {
            this._isNoNole = param1;
            if(this._isNoNole)
            {
               this.addBuff(BuffManager.creatBuff(BuffType.NoHole));
            }
            else
            {
               this.removeBuff(BuffType.NoHole);
            }
         }
      }
      
      public function set LockState(param1:Boolean) : void
      {
         if(this._lockState != param1)
         {
            this._lockState = param1;
            if(this._lockState)
            {
               if(this.LockType == 1 || this.LockType == 2 || this.LockType == 3)
               {
                  this.addBuff(BuffManager.creatBuff(BuffType.LockState));
               }
            }
            else
            {
               this.removeBuff(BuffType.LockState);
            }
         }
      }
      
      public function get LockState() : Boolean
      {
         return this._lockState;
      }
      
      public function set LockType(param1:int) : void
      {
         this._lockType = param1;
      }
      
      public function get LockType() : int
      {
         return this._lockType;
      }
      
      public function get isLiving() : Boolean
      {
         return this._isLiving;
      }
      
      public function die(param1:Boolean = true) : void
      {
         if(this._isLiving)
         {
            this._isLiving = false;
            dispatchEvent(new LivingEvent(LivingEvent.DIE,0,0,param1));
            this._turnBuffs = new Vector.<FightBuffInfo>();
            dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,BuffType.Turn));
         }
      }
      
      public function get playerAngle() : Number
      {
         return this._playerAngle;
      }
      
      public function set playerAngle(param1:Number) : void
      {
         this._playerAngle = param1;
         dispatchEvent(new LivingEvent(LivingEvent.ANGLE_CHANGED));
      }
      
      public function get actionMovieName() : String
      {
         return this._actionMovieName;
      }
      
      public function set actionMovieName(param1:String) : void
      {
         this._actionMovieName = param1;
      }
      
      public function get isMoving() : Boolean
      {
         return this._isMoving;
      }
      
      public function set isMoving(param1:Boolean) : void
      {
         this._isMoving = param1;
      }
      
      public function updateBlood(param1:int, param2:int, param3:int = 0) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!this.isLiving)
         {
            return;
         }
         if(param2 == WOUND)
         {
            this._blood = param1;
            dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,param1,this._blood,param2,param3));
         }
         if(param2 == FLASH_BACK)
         {
            _loc4_ = this._blood;
            this._blood -= param3;
            dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,this._blood,_loc4_,param2,param3));
         }
         else if(this._blood != param1)
         {
            _loc5_ = this._blood;
            this.blood = param1;
            if(param2 != SUICIDE && this._isLiving)
            {
               dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,param1,_loc5_,param2,param3));
            }
         }
         else if(param2 == 0 && param1 >= this._blood)
         {
            dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,param1,this._blood,param2,param3));
         }
         if(this._blood <= 0)
         {
            this._blood = 0;
            this.die(param2 != SUICIDE);
         }
      }
      
      public function get actionCount() : int
      {
         if(this._actionManager)
         {
            return this._actionManager.actionCount;
         }
         return 0;
      }
      
      public function traceCurrentAction() : void
      {
         this._actionManager.traceAllRemainAction();
      }
      
      public function act(param1:BaseAction) : void
      {
         this._actionManager.act(param1);
      }
      
      public function update() : void
      {
         if(this._actionManager != null)
         {
            this._actionManager.execute();
         }
      }
      
      public function actionManagerClear() : void
      {
         this._actionManager.clear();
      }
      
      public function excuteAtOnce() : void
      {
         this._actionManager.executeAtOnce();
         this._actionManager.clear();
      }
      
      public function set actionMovieBitmap(param1:Bitmap) : void
      {
         this._actionMovie = param1;
      }
      
      public function get actionMovieBitmap() : Bitmap
      {
         return this._actionMovie;
      }
      
      public function isPlayer() : Boolean
      {
         return false;
      }
      
      public function get isSelf() : Boolean
      {
         return false;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return null;
      }
      
      public function startMoving() : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.START_MOVING));
      }
      
      public function beginNewTurn() : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BEGIN_NEW_TURN));
      }
      
      public function shoot(param1:Array, param2:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SHOOT,0,0,param1,param2));
      }
      
      public function beat(param1:Array) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BEAT,0,0,param1));
      }
      
      public function beatenBy(param1:Living) : void
      {
         param1.addEventListener(LivingEvent.BEAT,this.__beatenBy);
      }
      
      private function __beatenBy(param1:LivingEvent) : void
      {
         var _loc2_:Living = param1.paras[1];
         var _loc3_:int = param1.paras[2];
         var _loc4_:int = param1.value;
         var _loc5_:int = param1.paras[3];
         if(this.isLiving)
         {
            this.isHidden = false;
            this.showAttackEffect(_loc5_);
            this.updateBlood(_loc4_,3,_loc3_);
         }
      }
      
      public function transmit(param1:Point) : void
      {
         if(this._pos.equals(param1) == false)
         {
            this._pos = param1;
            dispatchEvent(new LivingEvent(LivingEvent.POS_CHANGED));
         }
      }
      
      public function showAttackEffect(param1:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SHOW_ATTACK_EFFECT,0,0,param1));
      }
      
      public function moveTo(param1:Number, param2:Point, param3:Number, param4:Boolean, param5:String = "", param6:int = 3, param7:String = "") : void
      {
         if(this.isPlayer() || this._isLiving)
         {
            if(param2.x > this._pos.x)
            {
               this.direction = 1;
            }
            else
            {
               this.direction = -1;
            }
            dispatchEvent(new LivingEvent(LivingEvent.MOVE_TO,0,0,param1,param2,param3,param4,param5,param6,param7));
         }
      }
      
      public function changePos(param1:Point, param2:String = "") : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.CHANGE_POS,0,0,param1));
      }
      
      public function fallTo(param1:Point, param2:int, param3:String = "", param4:int = 0) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.FALL,0,0,param1,param2,param3,param4));
      }
      
      public function jumpTo(param1:Point, param2:int, param3:String = "", param4:int = 0) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.JUMP,0,0,param1,param2,param3,param4));
      }
      
      public function set State(param1:int) : void
      {
         if(this._state == param1)
         {
            return;
         }
         this._state = param1;
         dispatchEvent(new LivingEvent(LivingEvent.CHANGE_STATE));
      }
      
      public function get State() : int
      {
         return this._state;
      }
      
      public function say(param1:String, param2:int = 0) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SAY,0,0,param1,param2));
      }
      
      public function playMovie(param1:String, param2:Function = null, param3:Array = null) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PLAY_MOVIE,0,0,param1,param2,param3));
      }
      
      public function turnRotation(param1:int, param2:int, param3:String) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.TURN_ROTATION,0,0,param1,param2,param3));
      }
      
      public function set defaultAction(param1:String) : void
      {
         this._defaultAction = param1;
         dispatchEvent(new LivingEvent(LivingEvent.DEFAULT_ACTION_CHANGED));
      }
      
      public function get defaultAction() : String
      {
         return this._defaultAction;
      }
      
      public function doDefaultAction() : void
      {
         this.playMovie(this._defaultAction);
      }
      
      public function pick(param1:SimpleBox) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BOX_PICK,0,0,param1));
      }
      
      private function cmdX(param1:int) : void
      {
      }
      
      public function get commandList() : Dictionary
      {
         if(!this._cmdList)
         {
            this.initCommand();
         }
         return this._cmdList;
      }
      
      public function initCommand() : void
      {
         this._cmdList = new Dictionary();
         this._cmdList["x"] = this.cmdX;
      }
      
      public function command(param1:String, param2:*) : Boolean
      {
         if(this.commandList[param1])
         {
            this.commandList[param1](param2);
         }
         return true;
      }
      
      public function sendCommand(param1:String, param2:Object = null) : void
      {
         dispatchEvent(new LivingCommandEvent("someCommand"));
      }
      
      public function setProperty(param1:String, param2:String) : void
      {
         var property:String = param1;
         var value:String = param2;
         var vo:StringObject = new StringObject(value);
         try
         {
            if(vo.isBoolean)
            {
               this[property] = vo.getBoolean();
               return;
            }
            if(vo.isInt)
            {
               this[property] = vo.getInt();
               return;
            }
            this[property] = vo;
         }
         catch(e:Error)
         {
         }
      }
      
      public function bomd() : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BOMBED));
      }
      
      public function playSkillMovie(param1:String) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PLAYSKILLMOVIE,0,0,param1));
      }
      
      public function removeSkillMovie(param1:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.REMOVESKILLMOVIE,0,0,param1));
      }
      
      public function applySkill(param1:int, ... rest) : void
      {
         var _loc3_:LivingEvent = null;
         if(rest == null || rest.length == 0)
         {
            _loc3_ = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,param1);
         }
         else if(rest.length == 1)
         {
            _loc3_ = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,param1,rest[0]);
         }
         else if(rest.length == 2)
         {
            _loc3_ = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,param1,rest[0],rest[1]);
         }
         else if(rest.length == 3)
         {
            _loc3_ = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,param1,rest[0],rest[1],rest[2]);
         }
         else if(rest.length == 4)
         {
            _loc3_ = new LivingEvent(LivingEvent.APPLY_SKILL,0,0,param1,rest[0],rest[1],rest[2],rest[3]);
         }
         dispatchEvent(_loc3_);
      }
      
      public function get shootInterval() : int
      {
         return this._shootInterval;
      }
      
      public function set shootInterval(param1:int) : void
      {
         this._shootInterval = param1;
      }
      
      public function get maxPsychic() : int
      {
         return Player.MaxPsychic;
      }
      
      public function get psychic() : int
      {
         return this._psychic >= 0 ? int(int(this._psychic)) : int(int(0));
      }
      
      public function set psychic(param1:int) : void
      {
         if(this._psychic != param1 && param1 <= this.maxPsychic)
         {
            this._psychic = param1;
            dispatchEvent(new LivingEvent(LivingEvent.PSYCHIC_CHANGED));
         }
      }
      
      public function get energy() : Number
      {
         return this._energy;
      }
      
      public function set energy(param1:Number) : void
      {
         if(param1 != this._energy && param1 <= this.maxEnergy)
         {
            this._energy = param1 >= 0 ? Number(Number(param1)) : Number(Number(0));
            dispatchEvent(new LivingEvent(LivingEvent.ENERGY_CHANGED));
         }
      }
      
      public function get thumbnail() : BitmapData
      {
         return this._thumbnail;
      }
      
      public function set thumbnail(param1:BitmapData) : void
      {
         if(this._thumbnail != null)
         {
            this._thumbnail.dispose();
         }
         this._thumbnail = param1;
      }
      
      public function addPetBuff(param1:FightBuffInfo) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:FightBuffInfo = null;
         if(param1.buffPic != "-1")
         {
            _loc2_ = false;
            for each(_loc3_ in this._petBuffs)
            {
               if(_loc3_.id == param1.id)
               {
                  ++_loc3_.Count;
                  _loc2_ = true;
                  break;
               }
            }
            if(!_loc2_)
            {
               this._petBuffs.push(param1);
            }
         }
         else
         {
            this._noPicPetBuff.add(param1.id,true);
         }
         param1.execute(this);
         dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,param1.type));
      }
      
      public function showEffect(param1:String) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PLAYSKILLMOVIE,0,0,param1));
      }
      
      public function showBuffEffect(param1:String, param2:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PLAY_CONTINUOUS_EFFECT,0,0,param1,param2));
      }
      
      public function removeBuffEffect(param1:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.REMOVE_CONTINUOUS_EFFECT,0,0,param1));
      }
      
      public function removePetBuff(param1:FightBuffInfo) : void
      {
         var _loc2_:int = this._petBuffs.length;
         var _loc3_:int = param1.id;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(this._petBuffs[_loc4_].id == _loc3_)
            {
               this._petBuffs[_loc4_].unExecute(this);
               this._petBuffs.splice(_loc4_,1);
               dispatchEvent(new LivingEvent(LivingEvent.BUFF_CHANGED,0,0,param1.type));
               break;
            }
            _loc4_++;
         }
         if(param1.buffPic == "-1" && this._noPicPetBuff[param1.id])
         {
            this._noPicPetBuff.remove(param1.id);
            param1.unExecute(this);
         }
      }
   }
}
