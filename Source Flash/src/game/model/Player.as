package game.model
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.LivingEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.character.GameCharacter;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import game.view.map.MapView;
   import pet.date.PetSkillTemplateInfo;
   import room.RoomManager;
   import room.model.DeputyWeaponInfo;
   import room.model.WeaponInfo;
   import room.model.WebSpeedInfo;
   
   [Event(name="beginShoot",type="ddt.events.LivingEvent")]
   [Event(name="addState",type="ddt.events.LivingEvent")]
   [Event(name="usingItem",type="ddt.events.LivingEvent")]
   [Event(name="usingSpecialSkill",type="ddt.events.LivingEvent")]
   [Event(name="danderChanged",type="ddt.events.LivingEvent")]
   [Event(name="bombChanged",type="ddt.events.LivingEvent")]
   public class Player extends TurnedLiving
   {
      
      public static const MaxPsychic:int = 999;
      
      public static const MaxSoulPropUsedCount:int = 2;
      
      public static var MOVE_SPEED:Number = 2;
      
      public static var GHOST_MOVE_SPEED:Number = 8;
      
      public static var FALL_SPEED:Number = 12;
      
      public static const FORCE_MAX:int = 2000;
      
      public static const FORCE_STEP:int = 24;
      
      public static const TOTAL_DANDER:int = 200;
      
      public static const SHOOT_INTERVAL:uint = 24;
      
      public static const SHOOT_TIMER:uint = 1000;
      
      public static const TOTAL_BLOOD:int = 1000;
      
      public static const TOTAL_LEADER_BLOOD:int = 2000;
      
      public static const FULL_HP:int = 1;
      
      public static const LACK_HP:int = 2;
       
      
      private var _currentMap:MapView;
      
      protected var _maxForce:int = 2000;
      
      private var _info:PlayerInfo;
      
      private var _movie:GameCharacter;
      
      public var _expObj:Object;
      
      public var isUpGrade:Boolean;
      
      private var _isWin:Boolean;
      
      public var CurrentLevel:int;
      
      public var CurrentGP:int;
      
      public var TotalKill:int;
      
      public var TotalHurt:int;
      
      public var TotalHitTargetCount:int;
      
      public var TotalShootCount:int;
      
      public var GetCardCount:int;
      
      private var _bossCardCount:int;
      
      public var GainOffer:int;
      
      public var GainGP:int;
      
      public var VipGP:int;
      
      public var MarryGP:int;
      
      public var AcademyGP:int;
      
      public var zoneName:String;
      
      private var _powerRatio:int = 100;
      
      private var _skill:int = -1;
      
      private var _isSpecialSkill:Boolean;
      
      protected var _dander:int;
      
      private var _currentWeapInfo:WeaponInfo;
      
      private var _currentBomb:int;
      
      public var webSpeedInfo:WebSpeedInfo;
      
      private var _currentDeputyWeaponInfo:DeputyWeaponInfo;
      
      private var _isReady:Boolean;
      
      private var _turnTime:int = 0;
      
      private var _reverse:int = 1;
      
      private var _isAutoGuide:Boolean = false;
      
      protected var _petLiving:PetLiving;
      
      public var hasLevelAgain:Boolean = false;
      
      public var hasGardGet:Boolean = false;
      
      private var _pet:Pet;
      
      private var _snapPet:Pet;
      
      public function Player(param1:PlayerInfo, param2:int, param3:int, param4:int)
      {
         this._info = param1;
         super(param2,param3,param4);
         this.setWeaponInfo();
         this.setDeputyWeaponInfo();
         this.webSpeedInfo = new WebSpeedInfo(this._info.webSpeed);
         this.initEvent();
      }
      
      public function get BossCardCount() : int
      {
         return this._bossCardCount;
      }
      
      public function set BossCardCount(param1:int) : void
      {
         this._bossCardCount = param1;
      }
      
      private function initEvent() : void
      {
         this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerPropChanged);
      }
      
      private function removeEvent() : void
      {
         this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerPropChanged);
      }
      
      public function get currentMap() : MapView
      {
         return this._currentMap;
      }
      
      public function set currentMap(param1:MapView) : void
      {
         this._currentMap = param1;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.movie = null;
         character = null;
         if(this._currentWeapInfo)
         {
            this._currentWeapInfo.dispose();
         }
         this._currentWeapInfo = null;
         if(this._currentDeputyWeaponInfo)
         {
            this._currentDeputyWeaponInfo.dispose();
         }
         this._currentDeputyWeaponInfo = null;
         this.webSpeedInfo = null;
         this._info = null;
         super.dispose();
      }
      
      override public function reset() : void
      {
         super.reset();
         _isAttacking = false;
         this._dander = 0;
         if(this._movie)
         {
            this._movie.State = FULL_HP;
         }
      }
      
      override public function get playerInfo() : PlayerInfo
      {
         return this._info;
      }
      
      override public function get isSelf() : Boolean
      {
         return this._info is SelfInfo;
      }
      
      public function get movie() : GameCharacter
      {
         return this._movie;
      }
      
      public function set movie(param1:GameCharacter) : void
      {
         this._movie = param1;
      }
      
      public function get isWin() : Boolean
      {
         return this._isWin;
      }
      
      public function set isWin(param1:Boolean) : void
      {
         this._isWin = param1;
      }
      
      public function set expObj(param1:Object) : void
      {
         this._expObj = param1;
      }
      
      public function get expObj() : Object
      {
         return this._expObj;
      }
      
      public function playerMoveTo(param1:Number, param2:Point, param3:Number, param4:Boolean, param5:Array = null) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PLAYER_MOVETO,0,0,param1,param2,param3,param4,param5));
      }
      
      public function beginShoot() : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.BEGIN_SHOOT));
      }
      
      public function useItem(param1:ItemTemplateInfo) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.USING_ITEM,0,0,param1));
      }
      
      public function useItemByIcon(param1:DisplayObject) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.USING_ITEM,0,0,param1));
      }
      
      public function get maxForce() : int
      {
         return this._maxForce;
      }
      
      public function set maxForce(param1:int) : void
      {
         if(this._maxForce != param1)
         {
            this._maxForce = param1;
            dispatchEvent(new LivingEvent(LivingEvent.MAXFORCE_CHANGED,this._maxForce));
         }
      }
      
      public function get powerRatio() : Number
      {
         return this._powerRatio / 100;
      }
      
      public function set powerRatio(param1:Number) : void
      {
         this._powerRatio = param1;
      }
      
      public function get skill() : int
      {
         return this._skill;
      }
      
      public function set skill(param1:int) : void
      {
         this._skill = param1;
         if(this._skill >= 0)
         {
            dispatchEvent(new LivingEvent(LivingEvent.USING_SPECIAL_SKILL));
         }
      }
      
      public function get isSpecialSkill() : Boolean
      {
         return this._isSpecialSkill;
      }
      
      public function set isSpecialSkill(param1:Boolean) : void
      {
         if(this._isSpecialSkill != param1)
         {
            this._isSpecialSkill = param1;
            if(param1)
            {
               dispatchEvent(new LivingEvent(LivingEvent.USING_SPECIAL_SKILL));
            }
         }
      }
      
      public function get dander() : int
      {
         return this._dander;
      }
      
      public function set dander(param1:int) : void
      {
         if(RoomManager.Instance.current)
         {
            if(RoomManager.Instance.current.gameMode == 8)
            {
               return;
            }
         }
         if(this._dander == param1)
         {
            return;
         }
         if(this._dander > param1 && param1 > 0)
         {
            return;
         }
         if(this._dander < 0)
         {
            this._dander = 0;
         }
         else
         {
            this._dander = param1 > TOTAL_DANDER ? int(int(TOTAL_DANDER)) : int(int(param1));
         }
         dispatchEvent(new LivingEvent(LivingEvent.DANDER_CHANGED,this._dander));
      }
      
      public function reduceDander(param1:int) : void
      {
         if(this._dander == param1)
         {
            return;
         }
         if(this._dander < 0)
         {
            this._dander = 0;
         }
         else
         {
            this._dander = param1 > TOTAL_DANDER ? int(int(TOTAL_DANDER)) : int(int(param1));
         }
         dispatchEvent(new LivingEvent(LivingEvent.DANDER_CHANGED,this._dander));
      }
      
      public function get currentWeapInfo() : WeaponInfo
      {
         return this._currentWeapInfo;
      }
      
      public function get currentBomb() : int
      {
         return this._currentBomb;
      }
      
      public function set currentBomb(param1:int) : void
      {
         if(param1 == this._currentBomb)
         {
            return;
         }
         this._currentBomb = param1;
         dispatchEvent(new LivingEvent(LivingEvent.BOMB_CHANGED,this._currentBomb,0));
      }
      
      override public function beginNewTurn() : void
      {
         super.beginNewTurn();
         this._currentBomb = this._currentWeapInfo.commonBall;
         this._isSpecialSkill = false;
         gemDefense = false;
      }
      
      override public function die(param1:Boolean = true) : void
      {
         if(isLiving)
         {
            this._movie.State = LACK_HP;
            super.die();
            this.isSpecialSkill = false;
            this.dander = 0;
            SoundManager.instance.play("Sound042");
         }
      }
      
      override public function isPlayer() : Boolean
      {
         return true;
      }
      
      protected function setWeaponInfo() : void
      {
         var _loc1_:InventoryItemInfo = new InventoryItemInfo();
         _loc1_.TemplateID = this.playerInfo.WeaponID;
         ItemManager.fill(_loc1_);
         if(this._currentWeapInfo)
         {
            this._currentWeapInfo.dispose();
         }
         this._currentWeapInfo = new WeaponInfo(_loc1_);
         this.currentBomb = this._currentWeapInfo.commonBall;
      }
      
      public function setDeputyWeaponInfo() : void
      {
         var _loc1_:InventoryItemInfo = new InventoryItemInfo();
         _loc1_.TemplateID = this._info.DeputyWeaponID;
         ItemManager.fill(_loc1_);
         this._currentDeputyWeaponInfo = new DeputyWeaponInfo(_loc1_);
      }
      
      public function get currentDeputyWeaponInfo() : DeputyWeaponInfo
      {
         return this._currentDeputyWeaponInfo;
      }
      
      public function hasDeputyWeapon() : Boolean
      {
         return this._info != null && this._info.DeputyWeaponID > 0;
      }
      
      private function __playerPropChanged(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["WeaponID"])
         {
            this.setWeaponInfo();
         }
         else if(param1.changedProperties["DeputyWeaponID"])
         {
            this.setDeputyWeaponInfo();
         }
         if(param1.changedProperties["Grade"] && StateManager.currentStateType != StateType.MISSION_ROOM)
         {
            this.isUpGrade = this._info.IsUpGrade;
            if(this.isSelf)
            {
               PlayerManager.Instance.Self.isUpGradeInGame = true;
            }
         }
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
      
      public function set isReady(param1:Boolean) : void
      {
         this._isReady = param1;
      }
      
      override public function updateBlood(param1:int, param2:int, param3:int = 0) : void
      {
         super.updateBlood(param1,param2,param3);
         if(this._movie == null)
         {
            return;
         }
         if(blood <= maxBlood * 0.3)
         {
            this._movie.State = LACK_HP;
         }
         else
         {
            this._movie.State = FULL_HP;
         }
         this._movie.isLackHp = param2 != 0 && param3 >= maxBlood * 0.1;
      }
      
      public function get turnTime() : int
      {
         return this._turnTime;
      }
      
      public function set turnTime(param1:int) : void
      {
         this._turnTime = param1;
      }
      
      public function get reverse() : int
      {
         return this._reverse;
      }
      
      public function set reverse(param1:int) : void
      {
         this._reverse = param1;
         dispatchEvent(new LivingEvent(LivingEvent.REVERSE_CHANGED,0,0,this._reverse));
      }
      
      public function get isAutoGuide() : Boolean
      {
         if(this._isAutoGuide == true)
         {
            this._isAutoGuide = false;
            return true;
         }
         return this._isAutoGuide;
      }
      
      public function set isAutoGuide(param1:Boolean) : void
      {
         if(this._isAutoGuide == param1)
         {
            return;
         }
         this._isAutoGuide = param1;
      }
      
      public function get petLiving() : PetLiving
      {
         return this._petLiving;
      }
      
      public function set petLiving(param1:PetLiving) : void
      {
         this._petLiving = param1;
      }
      
      public function get currentPet() : Pet
      {
         return this._pet;
      }
      
      public function set currentPet(param1:Pet) : void
      {
         this._pet = param1;
      }
      
      public function get currentSnapPet() : Pet
      {
         return this._snapPet;
      }
      
      public function set currentSnapPet(param1:Pet) : void
      {
         this._snapPet = param1;
      }
      
      private function onUsePetSkill(param1:LivingEvent) : void
      {
         dispatchEvent(new LivingEvent(param1.type,param1.value,0,param1.paras[0]));
      }
      
      public function petBeat(param1:String, param2:Point, param3:Array) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.PET_BEAT,0,0,param1,param2,param3));
      }
      
      public function usePetSkill(param1:int, param2:Boolean) : void
      {
         var _loc3_:PetSkillTemplateInfo = PetSkillManager.getSkillByID(param1);
         if(_loc3_ && param2)
         {
            this.currentPet.MP -= _loc3_.CostMP;
            this.currentPet.useSkill(param1,param2);
         }
         dispatchEvent(new LivingEvent(LivingEvent.USE_PET_SKILL,param1,0,param2));
      }
   }
}
