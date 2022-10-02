package game.model
{
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import game.GameManager;
   import game.objects.SimpleBox;
   import road7th.data.DictionaryData;
   import trainer.data.Step;
   
   [Event(name="energyChanged",type="ddt.events.LivingEvent")]
   [Event(name="gunangleChanged",type="ddt.events.LivingEvent")]
   [Event(name="forceChanged",type="ddt.events.LivingEvent")]
   [Event(name="skip",type="ddt.events.LivingEvent")]
   [Event(name="sendShootAction",type="ddt.events.LivingEvent")]
   [Event(name="showMark",type="ddt.events.LivingEvent")]
   public class LocalPlayer extends Player
   {
      
      public static const SET_ENABLE:String = "setEnable";
       
      
      private var _isUsedItem:Boolean = false;
      
      private var _isUsedPetSkillWithNoItem:Boolean = false;
      
      public var twoKillEnabled:Boolean = true;
      
      public var _numObject:Object;
      
      private var _petSkillEnabled:Boolean = true;
      
      private var _iscalcForce:Boolean = false;
      
      public var shootType:int = 0;
      
      public var shootCount:int = 0;
      
      public var shootTime:int;
      
      private var _gunAngle:Number = 0;
      
      private var _force:Number = 0;
      
      private var _selfDieTimer:Timer;
      
      public var isLast:Boolean = true;
      
      private var _selfDieTimeDelayPassed:Boolean = false;
      
      private var _flyCoolDown:int = 0;
      
      private var _flyEnabled:Boolean = true;
      
      private var _deputyWeaponEnabled:Boolean = true;
      
      private var _deputyWeaponCount:int;
      
      private var _blockDeputyWeapon:Boolean = false;
      
      private var _deputyWeaponCoolDown:int;
      
      public var soulPropCount:int = 0;
      
      private var _threeKillEnabled:Boolean = true;
      
      private var _spellKillEnabled:Boolean = true;
      
      private var _propEnabled:Boolean = true;
      
      private var _customPropEnabled:Boolean = true;
      
      private var _lockRightProp:Boolean = false;
      
      private var _rightPropEnabled:Boolean = true;
      
      private var _lockDeputyWeapon:Boolean = false;
      
      private var _lockFly:Boolean = false;
      
      private var _lockSpellKill:Boolean = false;
      
      private var _lockProp:Boolean;
      
      private var _soulPropEnabled:Boolean = true;
      
      private var _flyCount:int;
      
      public var NewHandEnemyBlood:int;
      
      public var NewHandSelfBlood:int;
      
      public var NewHandHurtSelfCounter:int;
      
      public var NewHandHurtEnemyCounter:int;
      
      public var NewHandBeEnemyHurtCounter:int;
      
      public var NewHandBloodCounter:int;
      
      public var NewHandEnemyIsFrozen:Boolean;
      
      public var lastFireBombs:Array;
      
      public function LocalPlayer(param1:SelfInfo, param2:int, param3:int, param4:int)
      {
         super(param1,param2,param3,param4);
         if(param1.DeputyWeaponID > 0)
         {
            this.deputyWeaponCount = param1.DeputyWeapon.StrengthenLevel + 1;
         }
         this._numObject = {};
      }
      
      public function get selfInfo() : SelfInfo
      {
         return playerInfo as SelfInfo;
      }
      
      public function get isUsedPetSkillWithNoItem() : Boolean
      {
         return this._isUsedPetSkillWithNoItem;
      }
      
      public function set isUsedPetSkillWithNoItem(param1:Boolean) : void
      {
         this._isUsedPetSkillWithNoItem = param1;
      }
      
      public function showMark(param1:int) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SHOW_MARK,0,0,param1 - 1));
      }
      
      public function set petSkillEnabled(param1:Boolean) : void
      {
         if(this._petSkillEnabled != param1)
         {
            this._petSkillEnabled = param1;
            dispatchEvent(new LivingEvent(LivingEvent.PROPENABLED_CHANGED));
         }
      }
      
      public function set iscalcForce(param1:Boolean) : void
      {
         if(this._iscalcForce == param1)
         {
            return;
         }
         this._iscalcForce = param1;
         dispatchEvent(new LivingEvent(LivingEvent.IS_CALCFORCE_CHANGE));
      }
      
      public function get iscalcForce() : Boolean
      {
         return this._iscalcForce;
      }
      
      public function get isUsedItem() : Boolean
      {
         return this._isUsedItem;
      }
      
      public function set isUsedItem(param1:Boolean) : void
      {
         this._isUsedItem = param1;
      }
      
      public function get petSkillEnabled() : Boolean
      {
         return this._petSkillEnabled;
      }
      
      override public function set pos(param1:Point) : void
      {
         if(param1.equals(_pos) == false)
         {
            if(isLiving && onChange == true)
            {
               energy -= Math.abs(param1.x - _pos.x) * powerRatio;
            }
            super.pos = param1;
         }
      }
      
      public function manuallySetGunAngle(param1:Number) : Boolean
      {
         var _loc2_:int = this.gunAngle;
         this.gunAngle = param1;
         return Boolean(_loc2_ != this.gunAngle);
      }
      
      public function get gunAngle() : Number
      {
         return this._gunAngle;
      }
      
      public function set gunAngle(param1:Number) : void
      {
         if(param1 == this._gunAngle)
         {
            return;
         }
         if(currentBomb == 3 && (param1 < 0 || param1 > 90))
         {
            return;
         }
         if(currentBomb != 3 && param1 < currentWeapInfo.armMinAngle)
         {
            this._gunAngle = currentWeapInfo.armMinAngle;
            return;
         }
         if(currentBomb != 3 && param1 > currentWeapInfo.armMaxAngle)
         {
            this._gunAngle = currentWeapInfo.armMaxAngle;
            return;
         }
         this._gunAngle = param1;
         dispatchEvent(new LivingEvent(LivingEvent.GUNANGLE_CHANGED));
      }
      
      public function calcBombAngle() : Number
      {
         return direction > 0 ? Number(Number(playerAngle - this._gunAngle)) : Number(Number(playerAngle + this._gunAngle - 180));
      }
      
      public function get force() : Number
      {
         return this._force;
      }
      
      public function set force(param1:Number) : void
      {
         this._force = Math.min(param1,Player.FORCE_MAX);
         dispatchEvent(new LivingEvent(LivingEvent.FORCE_CHANGED));
      }
      
      override public function beginNewTurn() : void
      {
         super.beginNewTurn();
         this.checkAngle();
         dispatchEvent(new LivingEvent(LivingEvent.GUNANGLE_CHANGED));
         this.shootType = 0;
         this._isUsedPetSkillWithNoItem = false;
         this._isUsedItem = false;
      }
      
      private function checkAngle() : void
      {
         if(this._gunAngle < currentWeapInfo.armMinAngle)
         {
            this.gunAngle = currentWeapInfo.armMinAngle;
            return;
         }
         if(this._gunAngle > currentWeapInfo.armMaxAngle)
         {
            this.gunAngle = currentWeapInfo.armMaxAngle;
            return;
         }
      }
      
      public function skip() : void
      {
         if(isAttacking)
         {
            stopAttacking();
            dispatchEvent(new LivingEvent(LivingEvent.SKIP));
         }
      }
      
      public function sendShootAction(param1:Number) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SEND_SHOOT_ACTION,0,0,param1));
      }
      
      public function canUseProp(param1:TurnedLiving) : Boolean
      {
         return this == param1 && !LockState || !isLiving && team == param1.team;
      }
      
      override public function pick(param1:SimpleBox) : void
      {
         super.pick(param1);
         if(param1.isGhost)
         {
            psychic += param1.psychic;
         }
         SocketManager.Instance.out.sendGamePick(param1.Id);
      }
      
      override protected function setWeaponInfo() : void
      {
         super.setWeaponInfo();
         this.gunAngle = currentWeapInfo.armMinAngle;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.lockDeputyWeapon = this.lockFly = this.lockSpellKill = false;
         this.threeKillEnabled = this.flyEnabled = this.deputyWeaponEnabled = this.rightPropEnabled = this.customPropEnabled = true;
         this._flyCoolDown = this._deputyWeaponCoolDown = 0;
         if(currentWeapInfo)
         {
            this.gunAngle = currentWeapInfo.armMinAngle;
         }
         if(playerInfo.DeputyWeaponID > 0)
         {
            this.deputyWeaponCount = playerInfo.DeputyWeapon.StrengthenLevel + 1;
         }
      }
      
      override public function die(param1:Boolean = true) : void
      {
         var _loc3_:Living = null;
         var _loc2_:DictionaryData = GameManager.Instance.Current.findTeam(team);
         for each(_loc3_ in _loc2_)
         {
            if(!_loc3_.isSelf && _loc3_.isLiving)
            {
               this.isLast = false;
               break;
            }
         }
         super.die(param1);
         this._selfDieTimer = new Timer(500,1);
         this._selfDieTimer.start();
         this._selfDieTimer.addEventListener(TimerEvent.TIMER,this.__onDieDelayPassed);
         this.rightPropEnabled = this.spellKillEnabled = this.flyEnabled = this.deputyWeaponEnabled = false;
         if(isSelf)
         {
            ChatManager.Instance.view.output.ghostState = param1;
         }
      }
      
      private function __onDieDelayPassed(param1:TimerEvent) : void
      {
         this.removeSelfDieTimer();
         this._selfDieTimeDelayPassed = true;
      }
      
      private function removeSelfDieTimer() : void
      {
         if(this._selfDieTimer == null)
         {
            return;
         }
         this._selfDieTimer.stop();
         this._selfDieTimer.removeEventListener(TimerEvent.TIMER,this.__onDieDelayPassed);
         this._selfDieTimer = null;
      }
      
      public function get selfDieTimeDelayPassed() : Boolean
      {
         return this._selfDieTimeDelayPassed;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeSelfDieTimer();
      }
      
      override public function set isAttacking(param1:Boolean) : void
      {
         if(param1)
         {
            --this._flyCoolDown;
            --this._deputyWeaponCoolDown;
         }
         if(this._flyCoolDown <= 0 && energy >= EquipType.FLY_ENERGY && !this._lockFly)
         {
            this.flyEnabled = true;
         }
         if(hasDeputyWeapon() && this._deputyWeaponCoolDown <= 0 && energy >= currentDeputyWeaponInfo.energy && !this._lockDeputyWeapon && _isLiving)
         {
            this.deputyWeaponEnabled = true;
         }
         this.propEnabled = this.spellKillEnabled = this.threeKillEnabled = true;
         super.isAttacking = param1;
      }
      
      public function get flyCoolDown() : int
      {
         return this._flyCoolDown;
      }
      
      public function useFly() : String
      {
         if(this.flyEnabled && _isAttacking)
         {
            this.useFlyImp();
         }
         else
         {
            if(!_isAttacking)
            {
               return UsePropErrorCode.NotAttacking;
            }
            if((this._lockFly || _lockState) && _lockType != 0)
            {
               return UsePropErrorCode.LockState;
            }
            if(_isLiving && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
            {
               if(this._flyCoolDown > 0)
               {
                  return UsePropErrorCode.FlyNotCoolDown;
               }
               if(_energy < EquipType.FLY_ENERGY)
               {
                  return UsePropErrorCode.EmptyEnergy;
               }
            }
         }
         return UsePropErrorCode.None;
      }
      
      private function useFlyImp() : void
      {
         this._flyCoolDown = EquipType.FLY_CD;
         SocketManager.Instance.out.sendAirPlane();
         var _loc1_:InventoryItemInfo = new InventoryItemInfo();
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(10016);
         _loc1_.TemplateID = _loc2_.TemplateID;
         _loc1_.Pic = "2";
         _loc1_.Property4 = _loc2_.Property4;
         var _loc3_:PropInfo = new PropInfo(_loc1_);
         this.useItem(_loc3_.Template);
         currentBomb = 3;
         this.flyEnabled = false;
         this.rightPropEnabled = false;
         if(hasDeputyWeapon() && EquipType.isAngel(currentDeputyWeaponInfo.Template))
         {
            this.deputyWeaponEnabled = false;
         }
         this.spellKillEnabled = false;
      }
      
      public function get flyEnabled() : Boolean
      {
         return _isLiving && !this._lockFly && this._flyEnabled && this._flyCoolDown <= 0 && _energy >= EquipType.FLY_ENERGY;
      }
      
      public function set flyEnabled(param1:Boolean) : void
      {
         if(this._flyEnabled != param1)
         {
            this._flyEnabled = param1;
            dispatchEvent(new LivingEvent(LivingEvent.FLY_CHANGED));
         }
      }
      
      public function set deputyWeaponEnabled(param1:Boolean) : void
      {
         if(this._deputyWeaponEnabled != param1)
         {
            this._deputyWeaponEnabled = param1;
            dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
         }
      }
      
      public function get deputyWeaponEnabled() : Boolean
      {
         if(hasDeputyWeapon())
         {
            return _isLiving && !this._lockDeputyWeapon && !this._blockDeputyWeapon && this._deputyWeaponEnabled && this._deputyWeaponCount > 0 && this._deputyWeaponCoolDown <= 0 && _energy >= currentDeputyWeaponInfo.energy;
         }
         return false;
      }
      
      public function get deputyWeaponCount() : int
      {
         return this._deputyWeaponCount;
      }
      
      public function set deputyWeaponCount(param1:int) : void
      {
         if(this._deputyWeaponCount != param1)
         {
            this._deputyWeaponCount = param1;
            dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
         }
      }
      
      public function blockDeputyWeapon() : void
      {
         this._blockDeputyWeapon = true;
         this._deputyWeaponCoolDown = 100000;
         this.deputyWeaponEnabled = false;
      }
      
      public function allowDeputyWeapon() : void
      {
         this._blockDeputyWeapon = false;
         this.deputyWeaponEnabled = true;
      }
      
      private function useDeputyWeaponImp() : void
      {
         this._deputyWeaponCoolDown = currentDeputyWeaponInfo.coolDown;
         SocketManager.Instance.out.useDeputyWeapon();
         var _loc1_:DisplayObject = currentDeputyWeaponInfo.getDeputyWeaponIcon();
         _loc1_.x += 7;
         useItemByIcon(_loc1_);
         energy -= Number(currentDeputyWeaponInfo.energy);
         if(hasDeputyWeapon() && currentDeputyWeaponInfo.ballId > 0)
         {
            currentBomb = currentDeputyWeaponInfo.ballId;
         }
         this.deputyWeaponEnabled = false;
         if(EquipType.isAngel(currentDeputyWeaponInfo.Template))
         {
            this.spellKillEnabled = false;
            this.flyEnabled = false;
            this.rightPropEnabled = false;
         }
      }
      
      public function get deputyWeaponCoolDown() : int
      {
         return this._deputyWeaponCoolDown;
      }
      
      public function useDeputyWeapon() : String
      {
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
         {
            SoundManager.instance.play("008");
         }
         var _loc1_:Number = Number(currentDeputyWeaponInfo.energy);
         if(this.deputyWeaponEnabled && _isAttacking)
         {
            this.useDeputyWeaponImp();
         }
         else if(hasDeputyWeapon())
         {
            if(!_isAttacking)
            {
               return UsePropErrorCode.NotAttacking;
            }
            if((this._lockDeputyWeapon || _lockState) && _lockType != 0)
            {
               return UsePropErrorCode.LockState;
            }
            if(this._deputyWeaponCount <= 0)
            {
               return UsePropErrorCode.DeputyWeaponEmpty;
            }
            if(this._deputyWeaponCoolDown > 0)
            {
               return UsePropErrorCode.DeputyWeaponNotCoolDown;
            }
            if(_energy < _loc1_)
            {
               return UsePropErrorCode.EmptyEnergy;
            }
         }
         return UsePropErrorCode.None;
      }
      
      override public function setDeputyWeaponInfo() : void
      {
         super.setDeputyWeaponInfo();
         if(hasDeputyWeapon())
         {
            this.deputyWeaponCount = playerInfo.DeputyWeapon.StrengthenLevel + 1;
         }
      }
      
      public function useProp(param1:PropInfo, param2:int) : String
      {
         if(_isLiving)
         {
            return this.usePropAtLive(param1,param2);
         }
         return this.usePropAtSoul(param1,param2);
      }
      
      override public function set dander(param1:int) : void
      {
         super.dander = param1;
      }
      
      private function usePropAtSoul(param1:PropInfo, param2:int) : String
      {
         if(this._soulPropEnabled)
         {
            if(this.soulPropCount >= MaxSoulPropUsedCount)
            {
               return UsePropErrorCode.SoulPropOverFlow;
            }
            if(param2 == 2)
            {
               this.useItem(param1.Template);
               GameInSocketOut.sendUseProp(param2,param1.Place,param1.Template.TemplateID);
               ++this.soulPropCount;
            }
            else
            {
               if(psychic < param1.needPsychic)
               {
                  return UsePropErrorCode.EmptyPsychic;
               }
               this.useItem(param1.Template);
               GameInSocketOut.sendUseProp(param2,param1.Place,param1.Template.TemplateID);
               psychic -= param1.needPsychic;
               ++this.soulPropCount;
            }
         }
         return UsePropErrorCode.None;
      }
      
      private function usePropAtLive(param1:PropInfo, param2:int) : String
      {
         if(!_isLiving && param2 == 1)
         {
            return UsePropErrorCode.NotLiving;
         }
         if(!_isAttacking)
         {
            return UsePropErrorCode.NotAttacking;
         }
         if(_lockState)
         {
            if(_lockType != 0)
            {
               return UsePropErrorCode.LockState;
            }
         }
         else
         {
            if(_energy < param1.needEnergy)
            {
               return UsePropErrorCode.EmptyEnergy;
            }
            this.updateNums(param1);
            if(param1.TemplateID == EquipType.ADD_TWO_ATTACK || param1.TemplateID == EquipType.ADD_ONE_ATTACK || param1.TemplateID == EquipType.THREEKILL)
            {
               if(!this.twoKillEnabled)
               {
                  GameInSocketOut.sendUseProp(param2,param1.Place,param1.Template.TemplateID);
                  return UsePropErrorCode.Done;
               }
               if(this.pushUseProp(param2,param1))
               {
                  return UsePropErrorCode.Done;
               }
            }
            if(param1.TemplateID != EquipType.THREEKILL)
            {
               this.useItem(param1.Template);
               GameInSocketOut.sendUseProp(param2,param1.Place,param1.Template.TemplateID);
               return UsePropErrorCode.Done;
            }
            if(this.threeKillEnabled)
            {
               this.useItem(param1.Template);
               GameInSocketOut.sendUseProp(param2,param1.Place,param1.Template.TemplateID);
               return UsePropErrorCode.Done;
            }
         }
         return UsePropErrorCode.None;
      }
      
      private function pushUseProp(param1:int, param2:PropInfo) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Boolean = false;
         if(param2.TemplateID == EquipType.ADD_TWO_ATTACK || param2.TemplateID == EquipType.ADD_ONE_ATTACK)
         {
            _loc4_ = this._numObject[param2.TemplateID] as int;
            if(_loc4_ == 2)
            {
               this.sendProp(param1,param2);
               _loc3_ = true;
            }
            else if(_loc4_ > 2)
            {
               _loc3_ = true;
            }
         }
         if(param2.TemplateID == EquipType.ADD_TWO_ATTACK || param2.TemplateID == EquipType.ADD_ONE_ATTACK || param2.TemplateID == EquipType.THREEKILL)
         {
            _loc5_ = this._numObject[EquipType.ADD_TWO_ATTACK] as int;
            _loc6_ = this._numObject[EquipType.THREEKILL] as int;
            _loc7_ = this._numObject[EquipType.ADD_ONE_ATTACK] as int;
            if(_loc5_ >= 1 && _loc6_ >= 1)
            {
               this.sendProp(param1,param2);
               _loc3_ = true;
            }
            else if(_loc6_ >= 1 && _loc7_ >= 1)
            {
               this.sendProp(param1,param2);
               _loc3_ = true;
            }
            else if(_loc5_ >= 1 && _loc7_ >= 1)
            {
               this.sendProp(param1,param2);
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function sendProp(param1:int, param2:PropInfo) : void
      {
         this.useItem(param2.Template);
         GameInSocketOut.sendUseProp(param1,param2.Place,param2.Template.TemplateID);
         dispatchEvent(new Event(LocalPlayer.SET_ENABLE));
         this.twoKillEnabled = false;
      }
      
      private function updateNums(param1:PropInfo) : void
      {
         var _loc2_:int = 0;
         if(this._numObject.hasOwnProperty(param1.TemplateID))
         {
            _loc2_ = this._numObject[param1.TemplateID] as int;
         }
         _loc2_++;
         this._numObject[param1.TemplateID] = _loc2_;
      }
      
      override public function useItem(param1:ItemTemplateInfo) : void
      {
         if(param1.TemplateID == EquipType.THREEKILL)
         {
            this.useThreeKillImp();
         }
         super.useItem(param1);
      }
      
      public function clearPropArr() : void
      {
         this._numObject = {};
         this.twoKillEnabled = true;
      }
      
      public function get threeKillEnabled() : Boolean
      {
         return this._threeKillEnabled && this._propEnabled && this._rightPropEnabled;
      }
      
      public function set threeKillEnabled(param1:Boolean) : void
      {
         if(this._threeKillEnabled != param1)
         {
            this._threeKillEnabled = param1;
            dispatchEvent(new LivingEvent(LivingEvent.THREEKILL_CHANGED));
         }
      }
      
      private function useThreeKillImp() : void
      {
         this.threeKillEnabled = false;
         this.spellKillEnabled = false;
         if(hasDeputyWeapon() && EquipType.isAngel(currentDeputyWeaponInfo.Template))
         {
            this.deputyWeaponEnabled = false;
         }
      }
      
      public function useSpellKill() : String
      {
         if(this.spellKillEnabled && _isAttacking)
         {
            this.useSpellKillImp();
            return UsePropErrorCode.Done;
         }
         return UsePropErrorCode.None;
      }
      
      private function useSpellKillImp() : void
      {
         this.spellKillEnabled = this.flyEnabled = this.threeKillEnabled = false;
         if(hasDeputyWeapon() && EquipType.isAngel(currentDeputyWeaponInfo.Template))
         {
            this.deputyWeaponEnabled = false;
         }
         skill = 0;
         isSpecialSkill = true;
         this.dander = 0;
         GameInSocketOut.sendGameCMDStunt();
      }
      
      public function get spellKillEnabled() : Boolean
      {
         return this._spellKillEnabled && _dander >= Player.TOTAL_DANDER && !this._lockSpellKill && _isLiving;
      }
      
      public function set spellKillEnabled(param1:Boolean) : void
      {
         if(this._spellKillEnabled != param1)
         {
            this._spellKillEnabled = param1;
            dispatchEvent(new LivingEvent(LivingEvent.SPELLKILL_CHANGED));
         }
      }
      
      public function set propEnabled(param1:Boolean) : void
      {
         if(this._propEnabled != param1)
         {
            this._propEnabled = param1;
            dispatchEvent(new LivingEvent(LivingEvent.PROPENABLED_CHANGED));
         }
      }
      
      public function get propEnabled() : Boolean
      {
         return this._propEnabled && !this._lockProp;
      }
      
      public function get customPropEnabled() : Boolean
      {
         return this._customPropEnabled && this._propEnabled;
      }
      
      public function set customPropEnabled(param1:Boolean) : void
      {
         if(this._customPropEnabled != param1)
         {
            this._customPropEnabled = param1;
            dispatchEvent(new LivingEvent(LivingEvent.CUSTOMENABLED_CHANGED));
         }
      }
      
      public function set lockRightProp(param1:Boolean) : void
      {
         if(this._lockRightProp != param1)
         {
            this._lockRightProp = param1;
            dispatchEvent(new LivingEvent(LivingEvent.RIGHTENABLED_CHANGED));
         }
      }
      
      public function get lockRightProp() : Boolean
      {
         return this._lockRightProp;
      }
      
      public function get rightPropEnabled() : Boolean
      {
         return this._rightPropEnabled && this._propEnabled && _isLiving && !this._lockRightProp;
      }
      
      public function set rightPropEnabled(param1:Boolean) : void
      {
         if(this._rightPropEnabled != param1)
         {
            this._rightPropEnabled = param1;
            dispatchEvent(new LivingEvent(LivingEvent.RIGHTENABLED_CHANGED));
         }
      }
      
      public function get lockDeputyWeapon() : Boolean
      {
         return this._lockDeputyWeapon;
      }
      
      public function set lockDeputyWeapon(param1:Boolean) : void
      {
         if(this._lockDeputyWeapon != param1)
         {
            this._lockDeputyWeapon = param1;
            dispatchEvent(new LivingEvent(LivingEvent.DEPUTYWEAPON_CHANGED));
         }
      }
      
      public function get lockFly() : Boolean
      {
         return this._lockFly;
      }
      
      public function set lockFly(param1:Boolean) : void
      {
         if(this._lockFly != param1)
         {
            this._lockFly = param1;
            dispatchEvent(new LivingEvent(LivingEvent.FLY_CHANGED));
         }
      }
      
      public function get lockSpellKill() : Boolean
      {
         return this._lockSpellKill;
      }
      
      public function set lockSpellKill(param1:Boolean) : void
      {
         if(this._lockSpellKill != param1)
         {
            this._lockSpellKill = param1;
            dispatchEvent(new LivingEvent(LivingEvent.SPELLKILL_CHANGED));
         }
      }
      
      public function set lockProp(param1:Boolean) : void
      {
         if(this._lockProp != param1)
         {
            this._lockProp = param1;
            dispatchEvent(new LivingEvent(LivingEvent.PROPENABLED_CHANGED));
         }
      }
      
      public function get lockProp() : Boolean
      {
         return this._lockProp;
      }
      
      public function get shootEnabled() : Boolean
      {
         return _isAttacking && _isLiving;
      }
      
      public function get soulPropEnabled() : Boolean
      {
         return this._soulPropEnabled;
      }
      
      public function set soulPropEnabled(param1:Boolean) : void
      {
         this._soulPropEnabled = param1;
      }
      
      public function setCenter(param1:Number, param2:Number, param3:Boolean) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.SETCENTER,0,0,param1,param2,param3));
      }
      
      public function get flyCount() : int
      {
         return this._flyCount;
      }
      
      public function set flyCount(param1:int) : void
      {
         this._flyCount = param1;
         dispatchEvent(new LivingEvent(LivingEvent.FLY_CHANGED));
      }
   }
}
