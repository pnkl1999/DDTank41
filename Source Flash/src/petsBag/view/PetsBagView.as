package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFightPropertyData;
   import petsBag.event.PetsAdvancedEvent;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   import petsBag.view.item.PetPropButton;
   
   public class PetsBagView extends Sprite implements Disposeable
   {
       
      
      private var _bgPet:DisplayObject;
      
      protected var _bgSkillPnl:DisplayObject;
      
      protected var _petMoveScroll:PetMoveScroll;
      
      protected var _petName:FilterFrameText;
      
      private var _fightPowerImg:Bitmap;
      
      private var _fightPowrTxt:FilterFrameText;
      
      protected var _showPet:ShowPet;
      
      protected var _happyBarPet:PetHappyBar;
      
      protected var _petExpProgress:PetExpProgress;
      
      protected var _petSkillPnl:PetSkillPnl;
      
      protected var _attackPbtn:PetPropButton;
      
      protected var _defencePbtn:PetPropButton;
      
      protected var _HPPbtn:PetPropButton;
      
      protected var _agilityPbtn:PetPropButton;
      
      protected var _luckPbtn:PetPropButton;
      
      protected var _fightBtn:TextButton;
      
      protected var _infoPlayer:PlayerInfo;
      
      protected var _currentPet:PetInfo;
      
      protected var _downArowImg:Bitmap;
      
      protected var _downArowText:Bitmap;
      
      protected var _currentGradeInfo:PetFightPropertyData;
      
      protected var _downArowTextData:Array;
      
      protected var _currentPetHappyStar:int = -1;
      
      public function PetsBagView()
      {
         this._downArowTextData = ["100","40","20","0"];
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set infoPlayer(param1:PlayerInfo) : void
      {
         if(this._infoPlayer == param1)
         {
            return;
         }
         this._infoPlayer = param1;
         if(!this._infoPlayer)
         {
            return;
         }
         this._petMoveScroll.infoPlayer = this._infoPlayer;
         PetBagController.instance().petModel.currentPetInfo = this.getFirstPet(this._infoPlayer);
         this._currentPet = PetBagController.instance().petModel.currentPetInfo;
         this.updatePetBagView();
      }
      
      public function playShined(param1:int) : void
      {
         this._showPet.getBagCell(param1).shinePlay();
      }
      
      public function stopShined(param1:int) : void
      {
         this._showPet.getBagCell(param1).shineStop();
      }
      
      protected function getFirstPet(param1:PlayerInfo) : PetInfo
      {
         var _loc2_:PetInfo = null;
         var _loc3_:int = 0;
         if(param1.currentPet)
         {
            _loc2_ = param1.currentPet;
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < param1.pets.length)
            {
               if(param1.pets[_loc3_])
               {
                  return param1.pets[_loc3_];
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      protected function initView() : void
      {
         this._bgPet = ComponentFactory.Instance.creat("assets.petsBag.BG");
         addChild(this._bgPet);
         this._bgSkillPnl = ComponentFactory.Instance.creat("petsBag.SkillPnl.myBG");
         addChild(this._bgSkillPnl);
         this._petMoveScroll = new PetMoveScroll();
         this._petMoveScroll.x = 7;
         this._petMoveScroll.y = 4;
         addChild(this._petMoveScroll);
         this._petName = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.PetName");
         addChild(this._petName);
         this._showPet = ComponentFactory.Instance.creat("petsBag.showPet");
         addChild(this._showPet);
         this._happyBarPet = ComponentFactory.Instance.creatComponentByStylename("petsBag.petHappyBar");
         addChild(this._happyBarPet);
         this._petExpProgress = ComponentFactory.Instance.creatComponentByStylename("petExpProgress");
         addChild(this._petExpProgress);
         this._attackPbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.attack");
         addChild(this._attackPbtn);
         this._defencePbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.defence");
         addChild(this._defencePbtn);
         this._HPPbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.HP");
         addChild(this._HPPbtn);
         this._agilityPbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.agility");
         addChild(this._agilityPbtn);
         this._luckPbtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.propbutton.luck");
         addChild(this._luckPbtn);
         this._attackPbtn.propName = LanguageMgr.GetTranslation("attack");
         this._defencePbtn.propName = LanguageMgr.GetTranslation("defence");
         this._HPPbtn.propName = LanguageMgr.GetTranslation("MaxHp");
         this._agilityPbtn.propName = LanguageMgr.GetTranslation("agility");
         this._luckPbtn.propName = LanguageMgr.GetTranslation("luck");
         this._fightBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.fight");
         addChild(this._fightBtn);
         this._fightBtn.text = LanguageMgr.GetTranslation("ddt.pets.fight");
         this._fightBtn.mouseChildren = false;
         this._fightBtn.mouseEnabled = false;
         this._fightBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this.updateProperByPetStatus();
         this._downArowImg = ComponentFactory.Instance.creatBitmap("assets.petsBag.downArowImg");
         addChild(this._downArowImg);
      }
      
      protected function initEvent() : void
      {
         PetBagController.instance().petModel.addEventListener(Event.CHANGE,this.__onChange);
         PetsAdvancedManager.Instance.addEventListener(PetsAdvancedEvent.EVOLUTION_COMPLETE,this.__evolutionSuccessHandler);
      }
      
      protected function __evolutionSuccessHandler(param1:Event) : void
      {
         if(!this._currentPet.IsEquip)
         {
            return;
         }
         this.updatePetsPropByEvolution();
         this.updatePropertyTip();
      }
      
      protected function removeEvent() : void
      {
         PetBagController.instance().petModel.removeEventListener(Event.CHANGE,this.__onChange);
         PetsAdvancedManager.Instance.removeEventListener(PetsAdvancedEvent.EVOLUTION_COMPLETE,this.__evolutionSuccessHandler);
      }
      
      protected function __onChange(param1:Event) : void
      {
         if(PetBagController.instance().isOtherPetViewOpen)
         {
            return;
         }
         this._currentPet = PetBagController.instance().petModel.currentPetInfo;
         if(this._currentPet)
         {
            this.updatePetBagView();
         }
         this._petMoveScroll.updateSelect();
      }
      
      public function get hasPet() : Boolean
      {
         return this._infoPlayer && this._infoPlayer.pets.list.length > 0;
      }
      
      public function updatePetBagView() : void
      {
         if(!this.hasPet)
         {
            this.mouseChildren = false;
            this.disableAllObj();
            this._petExpProgress.noPet();
         }
         var _loc1_:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         this._petName.text = !!Boolean(_loc1_) ? _loc1_.Name : "";
         this._petExpProgress.setProgress(!!Boolean(_loc1_) ? Number(Number(_loc1_.GP)) : Number(Number(0)),!!Boolean(_loc1_) ? Number(Number(_loc1_.MaxGP)) : Number(Number(0)));
         this.updatePetsPropByEvolution();
         this._happyBarPet.info = _loc1_;
         this.updateSkill();
         this.updateProperByPetStatus();
         this.updatePetSatiation();
         ShowPet.isPetEquip = false;
         this._showPet.update();
      }
      
      public function updatePetsPropByEvolution() : void
      {
         var _loc2_:PetFightPropertyData = null;
         var _loc1_:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         for each(_loc2_ in PetsAdvancedManager.Instance.evolutionDataList)
         {
            if(this._infoPlayer.evolutionGrade == 0)
            {
               this._currentGradeInfo = new PetFightPropertyData();
               break;
            }
            if(_loc2_.ID == this._infoPlayer.evolutionGrade)
            {
               this._currentGradeInfo = _loc2_;
               break;
            }
         }
         if(!this._currentGradeInfo)
         {
            this._currentGradeInfo = new PetFightPropertyData();
         }
         if(_loc1_)
         {
            this._attackPbtn.propValue = !!_loc1_.IsEquip ? int(int(_loc1_.Attack + this._currentGradeInfo.Attack)) : int(int(_loc1_.Attack));
            this._defencePbtn.propValue = !!_loc1_.IsEquip ? int(int(_loc1_.Defence + this._currentGradeInfo.Defence)) : int(int(_loc1_.Defence));
            this._HPPbtn.propValue = !!_loc1_.IsEquip ? int(int(_loc1_.Blood + this._currentGradeInfo.Blood)) : int(int(_loc1_.Blood));
            this._agilityPbtn.propValue = !!_loc1_.IsEquip ? int(int(_loc1_.Agility + this._currentGradeInfo.Agility)) : int(int(_loc1_.Agility));
            this._luckPbtn.propValue = !!_loc1_.IsEquip ? int(int(_loc1_.Luck + this._currentGradeInfo.Lucky)) : int(int(_loc1_.Luck));
         }
      }
      
      protected function updatePropertyTip() : void
      {
         if(this._currentPet && this._currentGradeInfo)
         {
            this._attackPbtn.currentPropValue = this._currentPet.Attack;
            this._attackPbtn.addedPropValue = !!this._currentPet.IsEquip ? int(int(this._currentGradeInfo.Attack)) : int(int(0));
            this._defencePbtn.currentPropValue = this._currentPet.Defence;
            this._defencePbtn.addedPropValue = !!this._currentPet.IsEquip ? int(int(this._currentGradeInfo.Defence)) : int(int(0));
            this._agilityPbtn.currentPropValue = this._currentPet.Agility;
            this._agilityPbtn.addedPropValue = !!this._currentPet.IsEquip ? int(int(this._currentGradeInfo.Agility)) : int(int(0));
            this._luckPbtn.currentPropValue = this._currentPet.Luck;
            this._luckPbtn.addedPropValue = !!this._currentPet.IsEquip ? int(int(this._currentGradeInfo.Lucky)) : int(int(0));
            this._HPPbtn.currentPropValue = this._currentPet.Blood;
            this._HPPbtn.addedPropValue = !!this._currentPet.IsEquip ? int(int(this._currentGradeInfo.Blood)) : int(int(0));
            this._attackPbtn.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.attact");
            this._defencePbtn.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.defense");
            this._agilityPbtn.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.agility");
            this._luckPbtn.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.luck");
            this._HPPbtn.property = LanguageMgr.GetTranslation("ddt.pets.hp");
         }
      }
      
      public function addPetEquip(param1:InventoryItemInfo) : void
      {
         this._showPet.addPetEquip(param1);
      }
      
      public function delPetEquip(param1:int, param2:int) : void
      {
         this._showPet.delPetEquip(param2);
      }
      
      protected function updatePetSatiation() : void
      {
         var _loc1_:int = 0;
         if(PetBagController.instance().petModel && PetBagController.instance().petModel.currentPetInfo)
         {
            _loc1_ = PetBagController.instance().petModel.currentPetInfo.PetHappyStar;
            if(this._currentPetHappyStar != _loc1_)
            {
               if(this._downArowText)
               {
                  ObjectUtils.disposeObject(this._downArowText);
               }
               this._downArowText = null;
               if(_loc1_ == 1 || _loc1_ == 2)
               {
                  this._downArowText = ComponentFactory.Instance.creatBitmap("assets.petsBag.downArowText" + this._downArowTextData[_loc1_]);
                  this._downArowText.x = this._downArowImg.x + (this._downArowImg.width - this._downArowText.width) / 2;
                  this._downArowText.y = this._downArowImg.y + this._downArowImg.height;
                  addChild(this._downArowText);
                  this.setDownArowVisible(true);
               }
               else
               {
                  this.setDownArowVisible(false);
               }
               this._currentPetHappyStar = _loc1_;
            }
         }
         else
         {
            this.setDownArowVisible(false);
         }
      }
      
      protected function setDownArowVisible(param1:Boolean) : void
      {
         if(this._downArowImg)
         {
            this._downArowImg.visible = param1;
         }
      }
      
      protected function updateProperByPetStatus(param1:Boolean = true) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         this.updatePropertyTip();
         if(PetBagController.instance().petModel.currentPetInfo)
         {
            _loc2_ = PetBagController.instance().petModel.currentPetInfo.Hunger / PetHappyBar.fullHappyValue;
            _loc3_ = "";
            this._attackPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.attactDetail");
            this._defencePbtn.detail = LanguageMgr.GetTranslation("ddt.pets.defenseDetail");
            this._agilityPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.agilityDetail");
            this._luckPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.luckDetail");
            this._HPPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.hpDetail");
            this._attackPbtn.propColor = 16774857;
            this._defencePbtn.propColor = 16774857;
            this._agilityPbtn.propColor = 16774857;
            this._luckPbtn.propColor = 16774857;
            this._HPPbtn.propColor = 16774857;
            this._attackPbtn.valueFilterString = 1;
            this._agilityPbtn.valueFilterString = 1;
            this._luckPbtn.valueFilterString = 1;
            this._HPPbtn.valueFilterString = 1;
            this._defencePbtn.valueFilterString = 1;
            if(_loc2_ < 0.8)
            {
               _loc3_ = PetBagController.instance().petModel.currentPetInfo.PetHappyStar > 0 ? LanguageMgr.GetTranslation("ddt.pets.petHappyDesc",PetHappyBar.petPercentArray[PetBagController.instance().petModel.currentPetInfo.PetHappyStar]) : LanguageMgr.GetTranslation("ddt.pets.petUnFight");
            }
            this._attackPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.attactDetail") + _loc3_;
            this._defencePbtn.detail = LanguageMgr.GetTranslation("ddt.pets.defenseDetail") + _loc3_;
            this._agilityPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.agilityDetail") + _loc3_;
            this._luckPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.luckDetail") + _loc3_;
            this._HPPbtn.detail = LanguageMgr.GetTranslation("ddt.pets.hpDetail") + _loc3_;
         }
      }
      
      protected function updateSkill() : void
      {
         var _loc1_:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         var _loc2_:Array = !!Boolean(_loc1_) ? _loc1_.skills : [];
         if(this._petSkillPnl)
         {
            this._petSkillPnl.itemInfo = _loc2_;
         }
      }
      
      protected function disableAllObj() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            if(_loc2_ is InteractiveObject)
            {
               this.disableObj(_loc2_ as InteractiveObject);
            }
            _loc1_++;
         }
      }
      
      protected function disableObj(param1:InteractiveObject) : void
      {
         param1.mouseEnabled = false;
      }
      
      protected function enableObj(param1:InteractiveObject) : void
      {
         param1.mouseEnabled = true;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bgPet)
         {
            ObjectUtils.disposeObject(this._bgPet);
            this._bgPet = null;
         }
         if(this._bgSkillPnl)
         {
            ObjectUtils.disposeObject(this._bgSkillPnl);
            this._bgSkillPnl = null;
         }
         if(this._petMoveScroll)
         {
            ObjectUtils.disposeObject(this._petMoveScroll);
            this._petMoveScroll = null;
         }
         if(this._petName)
         {
            ObjectUtils.disposeObject(this._petName);
            this._petName = null;
         }
         if(this._showPet)
         {
            ObjectUtils.disposeObject(this._showPet);
            this._showPet = null;
         }
         if(this._happyBarPet)
         {
            ObjectUtils.disposeObject(this._happyBarPet);
            this._happyBarPet = null;
         }
         if(this._petExpProgress)
         {
            ObjectUtils.disposeObject(this._petExpProgress);
            this._petExpProgress = null;
         }
         if(this._petSkillPnl)
         {
            ObjectUtils.disposeObject(this._petSkillPnl);
            this._petSkillPnl = null;
         }
         if(this._attackPbtn)
         {
            ObjectUtils.disposeObject(this._attackPbtn);
            this._attackPbtn = null;
         }
         if(this._defencePbtn)
         {
            ObjectUtils.disposeObject(this._defencePbtn);
            this._defencePbtn = null;
         }
         if(this._HPPbtn)
         {
            ObjectUtils.disposeObject(this._HPPbtn);
            this._HPPbtn = null;
         }
         if(this._agilityPbtn)
         {
            ObjectUtils.disposeObject(this._agilityPbtn);
            this._agilityPbtn = null;
         }
         if(this._luckPbtn)
         {
            ObjectUtils.disposeObject(this._luckPbtn);
            this._luckPbtn = null;
         }
         if(this._fightBtn)
         {
            ObjectUtils.disposeObject(this._fightBtn);
            this._fightBtn = null;
         }
         if(this._downArowText)
         {
            ObjectUtils.disposeObject(this._downArowText);
            this._downArowText = null;
         }
         if(this._downArowImg)
         {
            ObjectUtils.disposeObject(this._downArowImg);
            this._downArowImg = null;
         }
         this._infoPlayer = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
