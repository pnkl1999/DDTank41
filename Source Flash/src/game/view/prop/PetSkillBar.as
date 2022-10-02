package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightPropMode;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.LocalPlayer;
   import game.view.tool.PetEnergyStrip;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import pet.date.PetSkill;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.controller.PetBagController;
   import road7th.comm.PackageIn;
   import trainer.data.ArrowType;
   
   public class PetSkillBar extends FightPropBar
   {
       
      
      private var _skillCells:Vector.<PetSkillCell>;
      
      private var _usedItem:Boolean = false;
      
      private var _usedSpecialSkill:Boolean = false;
      
      private var _usedPetSkill:Boolean = false;
      
      private var _bg:Bitmap;
      
      private var _petEnergyStrip:PetEnergyStrip;
      
      private var letters:Array;
      
      public function PetSkillBar(param1:LocalPlayer)
      {
         this.letters = ["Q","E","T","Y","U"];
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.petSkillBar.back");
         PositionUtils.setPos(this._bg,"game.petSikllBar.BGPos");
         addChild(this._bg);
         this._skillCells = new Vector.<PetSkillCell>();
         super(param1);
         this.updateCellEnable();
         if(GameManager.Instance.Current.selfGamePlayer.currentPet)
         {
            this._petEnergyStrip = new PetEnergyStrip(GameManager.Instance.Current.selfGamePlayer.currentPet);
            PositionUtils.setPos(this._petEnergyStrip,"asset.game.mpStripPos");
            addChild(this._petEnergyStrip);
         }
         this.skillInfoInit(null);
      }
      
      override public function enter() : void
      {
         this.addEvent();
      }
      
      override protected function addEvent() : void
      {
         var _loc1_:PetSkillCell = null;
         for each(_loc1_ in this._skillCells)
         {
            if(_loc1_.isEnabled)
            {
               _loc1_.addEventListener(MouseEvent.CLICK,this.onCellClick);
            }
         }
         _self.currentPet.addEventListener(LivingEvent.PET_MP_CHANGE,this.__onChange);
         _self.currentPet.addEventListener(LivingEvent.USE_PET_SKILL,this.__onUsePetSkill);
         _self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__onAttackingChange);
         _self.addEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         _self.addEventListener(LivingEvent.USING_ITEM,this.__onUseItem);
         _self.addEventListener(LivingEvent.IS_CALCFORCE_CHANGE,this.__onChange);
         _self.addEventListener(LivingEvent.PETSKILL_ENABLED_CHANGED,this.__onChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_SKILL_CD,this.__petSkillCD);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         GameManager.Instance.addEventListener(LivingEvent.PETSKILL_USED_FAIL,this.__onPetSkillUsedFail);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROUND_ONE_END,this.__onRoundOneEnd);
         GameManager.Instance.addEventListener(GameManager.SKILL_INFO_INIT_GAME,this.skillInfoInit);
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:PetSkillCell = null;
         for each(_loc1_ in this._skillCells)
         {
            if(_loc1_.isEnabled)
            {
               _loc1_.removeEventListener(MouseEvent.CLICK,this.onCellClick);
            }
         }
         _self.currentPet.removeEventListener(LivingEvent.PET_MP_CHANGE,this.__onChange);
         _self.currentPet.removeEventListener(LivingEvent.USE_PET_SKILL,this.__onUsePetSkill);
         _self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__onAttackingChange);
         _self.removeEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         _self.removeEventListener(LivingEvent.USING_ITEM,this.__onUseItem);
         _self.removeEventListener(LivingEvent.IS_CALCFORCE_CHANGE,this.__onChange);
         _self.removeEventListener(LivingEvent.PETSKILL_ENABLED_CHANGED,this.__onChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_SKILL_CD,this.__petSkillCD);
         GameManager.Instance.removeEventListener(LivingEvent.PETSKILL_USED_FAIL,this.__onPetSkillUsedFail);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ROUND_ONE_END,this.__onRoundOneEnd);
         GameManager.Instance.removeEventListener(GameManager.SKILL_INFO_INIT_GAME,this.skillInfoInit);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      override protected function __keyDown(param1:KeyboardEvent) : void
      {
         var _loc4_:PetSkillCell = null;
         if(_self && _self.isLocked)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.onlyFly"));
            return;
         }
         var _loc2_:int = -1;
         switch(param1.keyCode)
         {
            case KeyStroke.VK_Q.getCode():
               _loc2_ = 0;
               break;
            case KeyStroke.VK_E.getCode():
               _loc2_ = 1;
               break;
            case KeyStroke.VK_T.getCode():
               _loc2_ = 2;
               break;
            case KeyStroke.VK_Y.getCode():
               _loc2_ = 3;
               break;
            case KeyStroke.VK_U.getCode():
               _loc2_ = 4;
         }
         var _loc3_:String = this.letters[_loc2_];
         for each(_loc4_ in this._skillCells)
         {
            if(_loc4_.shortcutKey == _loc3_ && _loc4_.skillInfo && _loc4_.skillInfo.isActiveSkill && _loc4_.isEnabled && _loc4_.enabled)
            {
               _loc4_.useProp();
               break;
            }
         }
      }
      
      private function __onPetSkillUsedFail(param1:LivingEvent) : void
      {
         this._usedPetSkill = false;
         _self.deputyWeaponEnabled = true;
         _self.isUsedPetSkillWithNoItem = false;
      }
      
      private function __onChange(param1:LivingEvent) : void
      {
         this.updateCellEnable();
      }
      
      private function skillInfoInit(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PetSkillCell = null;
         var _loc2_:Array = GameManager.Instance.petSkillList;
         if(_loc2_)
         {
            _loc3_ = _loc2_.length;
            while(_loc4_ < _loc3_)
            {
               for each(_loc5_ in this._skillCells)
               {
                  if(_loc5_.skillInfo && _loc5_.skillInfo.ID == _loc2_[_loc4_].id)
                  {
                     _loc5_.turnNum = _loc5_.skillInfo.ColdDown + 1 - _loc2_[_loc4_].cd;
                     break;
                  }
               }
               _loc4_++;
            }
            GameManager.Instance.petSkillList = null;
         }
      }
      
      private function __petSkillCD(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:PetSkillCell = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         for each(_loc5_ in this._skillCells)
         {
            if(_loc5_.skillInfo.ID == _loc3_)
            {
               _loc5_.turnNum = _loc5_.skillInfo.ColdDown + 1 - _loc4_;
            }
         }
         this.updateCellEnable();
      }
      
      private function __usingSpecialKill(param1:LivingEvent) : void
      {
         var _loc2_:PetSkillCell = null;
         for each(_loc2_ in this._skillCells)
         {
            _loc2_.enabled = false;
         }
         this._usedSpecialSkill = true;
      }
      
      private function __onUseItem(param1:LivingEvent) : void
      {
         var _loc2_:PetSkillCell = null;
         for each(_loc2_ in this._skillCells)
         {
            if(_loc2_.skillInfo)
            {
               if(_loc2_.skillInfo.BallType == PetSkillTemplateInfo.BALL_TYPE_1 || _loc2_.skillInfo.BallType == PetSkillTemplateInfo.BALL_TYPE_2)
               {
                  _loc2_.enabled = false;
               }
            }
         }
         this._usedItem = true;
      }
      
      private function __onUsePetSkill(param1:LivingEvent) : void
      {
         var _loc2_:PetSkillCell = null;
         for each(_loc2_ in this._skillCells)
         {
            if(_loc2_.skillInfo)
            {
               if(_loc2_.skillInfo.ID == param1.value)
               {
                  _loc2_.turnNum = 0;
                  break;
               }
            }
         }
         this.updateCellEnable();
      }
      
      protected function __onRoundOneEnd(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PetSkillCell = null;
         for each(_loc2_ in this._skillCells)
         {
            ++_loc2_.turnNum;
         }
         this._usedItem = false;
         this._usedSpecialSkill = false;
         this._usedPetSkill = false;
         _self.isUsedPetSkillWithNoItem = false;
         this.updateCellEnable();
      }
      
      private function __onAttackingChange(param1:LivingEvent) : void
      {
         this.updateCellEnable();
      }
      
      private function updateCellEnable() : void
      {
         var _loc2_:PetSkillCell = null;
         var _loc1_:Boolean = _self.petSkillEnabled;
         for each(_loc2_ in this._skillCells)
         {
            if(_loc2_.skillInfo)
            {
               switch(_loc2_.skillInfo.BallType)
               {
                  case PetSkillTemplateInfo.BALL_TYPE_0:
                     _loc2_.enabled = _loc1_ && _self.isAttacking && !this._usedPetSkill && !this._usedSpecialSkill && _loc2_.skillInfo.CostMP <= _self.currentPet.MP && _loc2_.turnNum > _loc2_.skillInfo.ColdDown;
                     break;
                  case PetSkillTemplateInfo.BALL_TYPE_1:
                     _loc2_.enabled = _loc1_ && _self.isAttacking && !this._usedPetSkill && !this._usedItem && !this._usedSpecialSkill && _loc2_.skillInfo.CostMP <= _self.currentPet.MP && _loc2_.turnNum > _loc2_.skillInfo.ColdDown;
                     break;
                  case PetSkillTemplateInfo.BALL_TYPE_2:
                     _loc2_.enabled = _loc1_ && _self.isAttacking && !this._usedPetSkill && !this._usedItem && !this._usedSpecialSkill && !_self.iscalcForce && _loc2_.skillInfo.CostMP <= _self.currentPet.MP && _loc2_.turnNum > _loc2_.skillInfo.ColdDown;
                     break;
                  case PetSkillTemplateInfo.BALL_TYPE_3:
                     _loc2_.enabled = _loc1_ && _self.isAttacking && !this._usedPetSkill && !this._usedSpecialSkill && _loc2_.skillInfo.CostMP <= _self.currentPet.MP && _loc2_.turnNum > _loc2_.skillInfo.ColdDown;
               }
            }
            if(PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.USE_PET_SKILL] > 0 && _loc2_.enabled)
            {
               PetBagController.instance().showPetFarmGuildArrow(ArrowType.USE_PET_SKILL,0,"farmTrainer.petSkillUseArrowPos","asset.farmTrainer.clickHere","farmTrainer.petSkillUseTipPos",this);
            }
         }
      }
      
      private function onCellClick(param1:MouseEvent) : void
      {
         if(_self.isLocked)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.onlyFly"));
            return;
         }
         var _loc2_:PetSkillCell = param1.currentTarget as PetSkillCell;
         if(_loc2_.enabled && _self.isAttacking)
         {
            SoundManager.instance.play("008");
            if(_loc2_.skillInfo.BallType == PetSkillTemplateInfo.BALL_TYPE_1 || _loc2_.skillInfo.BallType == PetSkillTemplateInfo.BALL_TYPE_2)
            {
               if(_self.isUsedItem)
               {
                  return;
               }
               _self.customPropEnabled = false;
               _self.deputyWeaponEnabled = false;
               _self.isUsedPetSkillWithNoItem = true;
            }
            SocketManager.Instance.out.sendPetSkill(_loc2_.skillInfo.ID);
            this._usedPetSkill = true;
            if(PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.USE_PET_SKILL] > 0)
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.USE_PET_SKILL);
               PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.USE_PET_SKILL] = 0;
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:PetSkillCell = null;
         this.removeEvent();
         for each(_loc1_ in this._skillCells)
         {
            _loc1_.dispose();
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         this._skillCells = null;
         if(this._petEnergyStrip)
         {
            ObjectUtils.disposeObject(this._petEnergyStrip);
         }
         this._petEnergyStrip = null;
         super.dispose();
      }
      
      override protected function drawCells() : void
      {
         var _loc1_:Point = null;
         var _loc3_:int = 0;
         var _loc4_:PetSkillCell = null;
         var _loc5_:int = 0;
         var _loc6_:PetSkill = null;
         if(_self.currentPet)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("CustomPetPropCellPos");
            _loc3_ = 0;
            while(_loc3_ < this.letters.length)
            {
               _loc4_ = new PetSkillCell(this.letters[_loc3_],FightPropMode.HORIZONTAL,false,33,33);
               _loc5_ = _self.currentPet.equipedSkillIDs[_loc3_];
               if(_loc5_ > 0)
               {
                  _loc6_ = new PetSkill(_loc5_);
                  _loc4_.creteSkillCell(_loc6_,true);
                  this._skillCells.push(_loc4_);
               }
               else if(_loc5_ == 0)
               {
                  _loc4_.creteSkillCell(null);
               }
               else
               {
                  _loc4_.creteSkillCell(null,true);
               }
               _loc4_.setPossiton(_loc1_.x + _loc3_ * 35,_loc1_.y);
               addChild(_loc4_);
               _loc3_++;
            }
            drawLayer();
         }
      }
   }
}
