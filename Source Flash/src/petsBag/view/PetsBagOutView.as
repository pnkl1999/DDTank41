package petsBag.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import pet.sprite.PetSpriteController;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   import petsBag.view.item.FeedItem;
   import road7th.data.DictionaryEvent;
   import road7th.utils.StringHelper;
   import store.HelpFrame;
   import trainer.data.ArrowType;
   
   public class PetsBagOutView extends PetsBagView
   {
       
      
      private var _rePetNameBtn:TextButton;
      
      private var _revertPetBtn:TextButton;
      
      private var _feedItem:FeedItem;
      
      private var _releaseBtn:TextButton;
      
      private var _convertBtn:TextButton;
      
      private var _unFightBtn:TextButton;
      
      private var _petGameSkillPnl:PetGameSkillPnl;
      
      private var _bg2:Bitmap;
      
      private var _feedBtn:TextButton;
      
      private var _groomBtn:SimpleBitmapButton;
      
      public function PetsBagOutView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._rePetNameBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.rePetName");
         this._rePetNameBtn.text = LanguageMgr.GetTranslation("ddt.pets.rePetName");
         addChild(this._rePetNameBtn);
         this._releaseBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.releaseName");
         this._releaseBtn.text = LanguageMgr.GetTranslation("ddt.pets.release");
         addChild(this._releaseBtn);
         this._convertBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.convert");
         this._convertBtn.text = LanguageMgr.GetTranslation("ddt.pets.convert");
         this._revertPetBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.revertPet");
         this._revertPetBtn.text = LanguageMgr.GetTranslation("ddt.pets.revert");
         addChild(this._revertPetBtn);
         this._feedItem = ComponentFactory.Instance.creat("petsBag.feedItem");
         addChild(this._feedItem);
         this._unFightBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.unFight");
         addChild(this._unFightBtn);
         this._unFightBtn.text = LanguageMgr.GetTranslation("ddt.pets.unfight");
         this._petGameSkillPnl = ComponentFactory.Instance.creat("petsBag.petGameSkillPnl");
         addChild(this._petGameSkillPnl);
         _petSkillPnl = ComponentFactory.Instance.creat("petsBag.petSkillPnl",[false]);
         addChild(_petSkillPnl);
         _fightBtn.filters = null;
         _fightBtn.mouseChildren = true;
         _fightBtn.mouseEnabled = true;
         _fightBtn.visible = false;
         this._unFightBtn.visible = false;
         this._feedBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.feed");
         addChild(this._feedBtn);
         this._feedBtn.text = LanguageMgr.GetTranslation("ddt.pets.feed");
         this._groomBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.groom");
         addChild(this._groomBtn);
         this.petFarmGuilde();
      }
      
      private function petFarmGuilde() : void
      {
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_PET_LABEL);
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.FEED_PET,50,"farmTrainer.feedPetArrowPos","asset.farmTrainer.feedPet","farmTrainer.feedPetTipPos",this);
         }
         if(PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.CHOOSE_PET_SKILL] > 0)
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.CHOOSE_PET_SKILL,30,"farmTrainer.petSkillConfigArrowPos","asset.farmTrainer.petSkillConfig","farmTrainer.petSkillConfigTipPos",this);
         }
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._rePetNameBtn.addEventListener(MouseEvent.CLICK,this.__rePetName);
         this._releaseBtn.addEventListener(MouseEvent.CLICK,this.__releasePet);
         this._convertBtn.addEventListener(MouseEvent.CLICK,this.__convertPet);
         this._revertPetBtn.addEventListener(MouseEvent.CLICK,this.__revertPet);
         this._unFightBtn.addEventListener(MouseEvent.CLICK,this.__unFight);
         _fightBtn.addEventListener(MouseEvent.CLICK,this.__fight);
         this._feedBtn.addEventListener(MouseEvent.CLICK,this.__feedPet);
         this._groomBtn.addEventListener(MouseEvent.CLICK,this.__groomPet);
      }
      
      override protected function __onChange(param1:Event) : void
      {
         super.__onChange(param1);
         this.switchFightUnFight(_currentPet && !_currentPet.IsEquip);
      }
      
      override public function set infoPlayer(param1:PlayerInfo) : void
      {
         super.infoPlayer = param1;
         this.addInfoChangeEvent();
         if(PetBagController.instance().petModel.currentPetInfo && PetBagController.instance().petModel.currentPetInfo.IsEquip)
         {
            if(PetBagController.instance().petModel.currentPetInfo.Hunger / PetHappyBar.fullHappyValue < 0.5)
            {
               SocketManager.Instance.out.sendPetFightUnFight(PetBagController.instance().petModel.currentPetInfo.Place,false);
               PetSpriteController.Instance.dispatchEvent(new Event(Event.CLOSE));
            }
         }
      }
      
      override public function updatePetBagView() : void
      {
         super.updatePetBagView();
         if(!hasPet)
         {
            this.mouseChildren = true;
            this.clearInfo();
            this._petGameSkillPnl.mouseChildren = false;
            _fightBtn.visible = hasPet;
            this._unFightBtn.visible = hasPet;
         }
         else
         {
            this.switchFightUnFight(_currentPet && !_currentPet.IsEquip);
         }
         this.updateGameSkill();
         if(_currentPet && _currentPet.GP > 0 && !_currentPet.IsEquip)
         {
            this._revertPetBtn.enable = true;
         }
         else
         {
            this._revertPetBtn.enable = false;
         }
      }
      
      private function updateGameSkill() : void
      {
         this._petGameSkillPnl.pet = PetBagController.instance().petModel.currentPetInfo;
      }
      
      private function addInfoChangeEvent() : void
      {
         _infoPlayer.pets.addEventListener(DictionaryEvent.UPDATE,this.__updateInfoChange);
         _infoPlayer.pets.addEventListener(DictionaryEvent.ADD,this.__updateInfoChange);
         _infoPlayer.pets.addEventListener(DictionaryEvent.REMOVE,this.__updateInfoChange);
      }
      
      private function removeInfoChangeEvent() : void
      {
         _infoPlayer.pets.removeEventListener(DictionaryEvent.UPDATE,this.__updateInfoChange);
         _infoPlayer.pets.removeEventListener(DictionaryEvent.ADD,this.__updateInfoChange);
         _infoPlayer.pets.removeEventListener(DictionaryEvent.REMOVE,this.__updateInfoChange);
      }
      
      private function __updateInfoChange(param1:DictionaryEvent) : void
      {
         var _loc3_:PetInfo = null;
         var _loc2_:PetInfo = param1.data as PetInfo;
         if(_loc2_)
         {
            switch(param1.type)
            {
               case DictionaryEvent.ADD:
                  _petMoveScroll.refreshPetInfo(_loc2_,1);
                  break;
               case DictionaryEvent.UPDATE:
                  _petMoveScroll.refreshPetInfo(_loc2_);
                  _loc3_ = PetBagController.instance().petModel.currentPetInfo;
                  if(_loc3_ && _loc3_.Place == _loc2_.Place)
                  {
                     PetBagController.instance().petModel.currentPetInfo = _loc2_;
                  }
                  break;
               case DictionaryEvent.REMOVE:
                  _petMoveScroll.refreshPetInfo(_loc2_,2);
                  if(_infoPlayer.pets.length > 0)
                  {
                     PetBagController.instance().petModel.currentPetInfo = getFirstPet(_infoPlayer);
                  }
                  else
                  {
                     PetBagController.instance().petModel.currentPetInfo = null;
                  }
            }
         }
         this.updatePetBagView();
      }
      
      private function __rePetName(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:RePetNameFrame = ComponentFactory.Instance.creat("petsBag.rePetNameFrame");
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__AlertRePetNameResponse);
         _loc2_.show();
      }
      
      protected function __AlertRePetNameResponse(param1:FrameEvent) : void
      {
         var _loc2_:RePetNameFrame = param1.currentTarget as RePetNameFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__AlertRePetNameResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this.checkMoney(false,RePetNameFrame.RENAME_NEED_MONEY))
               {
                  _loc2_.dispose();
                  return;
               }
               if(PetBagController.instance().petModel.currentPetInfo && _loc2_.petName.length > 0)
               {
                  SocketManager.Instance.out.sendPetRename(PetBagController.instance().petModel.currentPetInfo.Place,_loc2_.petName,false);
               }
               _loc2_.dispose();
               break;
         }
      }
      
      public function checkMoney(param1:Boolean, param2:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Money < param2)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      protected function __revertPet(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PetBagController.instance().petModel.currentPetInfo)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pets.revertPetAlertMsg",StringHelper.trim(PetBagController.instance().petModel.currentPetInfo.Name)),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertRevertPet);
         }
      }
      
      protected function __alertRevertPet(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pets.revertPetCostMsg",PetconfigAnalyzer.PetCofnig.RecycleCost),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__revertPetCostConfirm);
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertRevertPet);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      protected function __revertPetCostConfirm(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this.checkMoney(false,PetconfigAnalyzer.PetCofnig.RecycleCost))
               {
                  return;
               }
               _loc2_ = _petMoveScroll.currentPage * 5 + _petMoveScroll.selectedIndex;
               SocketManager.Instance.out.sendRevertPet(_loc2_,false);
               break;
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__revertPetCostConfirm);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __convertPet(param1:MouseEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         if(_loc2_)
         {
            if(_loc2_.StarLevel >= PetconfigAnalyzer.PetCofnig.NotRemoveStar)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.convertCannotTxt"));
            }
            else if(_loc2_.StarLevel >= PetconfigAnalyzer.PetCofnig.HighRemoveStar)
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.farms.convertPet",_loc2_.StarLevel),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc3_.enterEnable = false;
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.__alertReleasePet2);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.convertCannotTxt2"));
            }
         }
      }
      
      private function __releasePet(param1:MouseEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         if(_loc2_)
         {
            if(_loc2_.StarLevel >= PetconfigAnalyzer.PetCofnig.NotRemoveStar)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.releaseCannotTxt"));
            }
            else
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.farms.releasePet",StringHelper.trim(PetBagController.instance().petModel.currentPetInfo.Name)),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.__alertReleasePet);
            }
         }
      }
      
      private function __alertReleasePet(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.pets.length == 1 || PlayerManager.Instance.Self.currentPet == PetBagController.instance().petModel.currentPetInfo)
               {
                  PetSpriteController.Instance.dispatchEvent(new Event(Event.CLOSE));
               }
               SocketManager.Instance.out.sendReleasePet(PetBagController.instance().petModel.currentPetInfo.Place);
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertReleasePet);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __alertReleasePet2(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertReleasePet2);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __alertReleasePet3(param1:FrameEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               _loc2_ = false;
               _loc3_ = PetconfigAnalyzer.PetCofnig.HighRemoveStarCost;
               if(PlayerManager.Instance.Self.Money >= _loc3_)
               {
                  if(PlayerManager.Instance.Self.pets.length == 1 || PlayerManager.Instance.Self.currentPet == PetBagController.instance().petModel.currentPetInfo)
                  {
                     PetSpriteController.Instance.dispatchEvent(new Event(Event.CLOSE));
                  }
                  SocketManager.Instance.out.sendReleasePet(PetBagController.instance().petModel.currentPetInfo.Place,true,_loc2_);
                  break;
               }
               LeavePageManager.showFillFrame();
               break;
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertReleasePet3);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __unFight(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PetBagController.instance().petModel.currentPetInfo)
         {
            SocketManager.Instance.out.sendPetFightUnFight(PetBagController.instance().petModel.currentPetInfo.Place,false);
         }
         PetSpriteController.Instance.dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function __fight(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PetBagController.instance().petModel.currentPetInfo)
         {
            SocketManager.Instance.out.sendPetFightUnFight(PetBagController.instance().petModel.currentPetInfo.Place);
            if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.FIGHT_PET);
               PetBagController.instance().showPetFarmGuildArrow(ArrowType.FEED_PET,50,"farmTrainer.feedPetArrowPos","asset.farmTrainer.feedPet","farmTrainer.feedPetTipPos",this);
            }
         }
         PetSpriteController.Instance.dispatchEvent(new Event(Event.OPEN));
      }
      
      private function switchFightUnFight(param1:Boolean = true) : void
      {
         _fightBtn.visible = param1;
         this._unFightBtn.visible = !param1;
      }
      
      private function __feedPet(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PetBagController.instance().petModel.currentPetInfo)
         {
            if(!this._feedItem.itemInfo)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.feedNoFood"));
               return;
            }
            if(PetBagController.instance().petModel.currentPetInfo.Level == 60 || PetBagController.instance().petModel.currentPetInfo.Level == PlayerManager.Instance.Self.Grade)
            {
               if(PetBagController.instance().petModel.currentPetInfo.Hunger == PetconfigAnalyzer.PetCofnig.MaxHunger)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.hungerFull"));
                  return;
               }
            }
            SocketManager.Instance.out.sendPetFeed(this._feedItem.itemInfo.Place,this._feedItem.itemInfo.BagType,PetBagController.instance().petModel.currentPetInfo.Place);
            if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.FEED_PET);
            }
         }
      }
      
      public function startShine() : void
      {
         if(!hasPet)
         {
            return;
         }
         this._feedItem.startShine();
      }
      
      public function stopShine() : void
      {
         this._feedItem.stopShine();
      }
      
      public function clearInfo() : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
         this._feedItem.info = null;
      }
      
      private function __help(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("petsBag.HelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("petsBag.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("ddt.petsBag.readme");
         _loc3_.setButtonPos(158,445);
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __groomPet(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PetsAdvancedManager.Instance.showPetsAdvancedFrame();
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._rePetNameBtn.removeEventListener(MouseEvent.CLICK,this.__rePetName);
         this._revertPetBtn.removeEventListener(MouseEvent.CLICK,this.__revertPet);
         this._releaseBtn.removeEventListener(MouseEvent.CLICK,this.__releasePet);
         this._convertBtn.removeEventListener(MouseEvent.CLICK,this.__convertPet);
         this._unFightBtn.removeEventListener(MouseEvent.CLICK,this.__unFight);
         _fightBtn.removeEventListener(MouseEvent.CLICK,this.__fight);
         this.removeInfoChangeEvent();
         if(this._feedBtn)
         {
            this._feedBtn.removeEventListener(MouseEvent.CLICK,this.__feedPet);
         }
         this._groomBtn.removeEventListener(MouseEvent.CLICK,this.__groomPet);
      }
      
      public function getUnLockItemIndex() : int
      {
         if(this._petGameSkillPnl)
         {
            return this._petGameSkillPnl.UnLockItemIndex;
         }
         return -1;
      }
      
      override public function dispose() : void
      {
         this.clearInfo();
         this.removeEvent();
         this.removeInfoChangeEvent();
         PetBagController.instance().petModel.currentPetInfo = null;
         super.dispose();
         if(this._petGameSkillPnl)
         {
            ObjectUtils.disposeObject(this._petGameSkillPnl);
            this._petGameSkillPnl = null;
         }
         if(this._unFightBtn)
         {
            ObjectUtils.disposeObject(this._unFightBtn);
            this._unFightBtn = null;
         }
         if(this._releaseBtn)
         {
            ObjectUtils.disposeObject(this._releaseBtn);
            this._releaseBtn = null;
         }
         if(this._feedItem)
         {
            ObjectUtils.disposeObject(this._feedItem);
            this._feedItem = null;
         }
         if(this._rePetNameBtn)
         {
            ObjectUtils.disposeObject(this._rePetNameBtn);
            this._rePetNameBtn = null;
         }
         if(this._revertPetBtn)
         {
            ObjectUtils.disposeObject(this._revertPetBtn);
            this._revertPetBtn = null;
         }
         if(this._feedBtn)
         {
            ObjectUtils.disposeObject(this._feedBtn);
            this._feedBtn = null;
         }
         if(this._convertBtn)
         {
            ObjectUtils.disposeObject(this._convertBtn);
            this._convertBtn = null;
         }
         ObjectUtils.disposeObject(this._groomBtn);
         this._groomBtn = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
