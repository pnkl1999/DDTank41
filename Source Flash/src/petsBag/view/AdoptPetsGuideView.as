package petsBag.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import pet.date.PetSkill;
   import pet.date.PetTemplateInfo;
   import pet.sprite.PetSpriteController;
   import petsBag.controller.PetBagController;
   import petsBag.event.PetItemEvent;
   import petsBag.view.item.AdoptItem;
   import road7th.comm.PackageIn;
   
   public class AdoptPetsGuideView extends Frame
   {
       
      
      private var _adoptBtn:SimpleBitmapButton;
      
      private var _listView:SimpleTileList;
      
      private var _petsImgVec:Vector.<AdoptItem>;
      
      public var currentPet:AdoptItem;
      
      private var _refreshTimerTxt:FilterFrameText;
      
      private var _titleBg:DisplayObject;
      
      private var _bg2:DisplayObject;
      
      private var _refreshVolumeImg:Bitmap;
      
      private var _refreshVolumeTxt:FilterFrameText;
      
      private var _desBg:ScaleBitmapImage;
      
      private var _descList:Array;
      
      private var _money:int;
      
      private var _outFun:Function;
      
      private var _refreshPetPnl:RefreshPetAlertFrame;
      
      public function AdoptPetsGuideView()
      {
         this._descList = new Array(LanguageMgr.GetTranslation("ddt.farm.petguide1"),LanguageMgr.GetTranslation("ddt.farm.petguide2"),LanguageMgr.GetTranslation("ddt.farm.petguide3"),LanguageMgr.GetTranslation("ddt.farm.petguide4"));
         super();
         this._petsImgVec = new Vector.<AdoptItem>();
         this.initView();
         this.initEvent();
         escEnable = true;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         SocketManager.Instance.out.sendRefreshPet();
      }
      
      private function initView() : void
      {
         this._bg2 = ComponentFactory.Instance.creat("farm.adoptPetsView.bg2");
         addToContent(this._bg2);
         this._titleBg = ComponentFactory.Instance.creat("assets.farm.adoptPets");
         addChild(this._titleBg);
         this._desBg = ComponentFactory.Instance.creatComponentByStylename("farm.adoptPetsView.descBg2");
         addToContent(this._desBg);
         this._adoptBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.guide.button.adopt");
         addToContent(this._adoptBtn);
         this._refreshTimerTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.adoptdescTitle");
         this._refreshTimerTxt.text = LanguageMgr.GetTranslation("ddt.farms.desc");
         addToContent(this._refreshTimerTxt);
         this._listView = ComponentFactory.Instance.creatCustomObject("farm.simpleTileList.petAdop",[4]);
         addToContent(this._listView);
         this._refreshVolumeImg = ComponentFactory.Instance.creatBitmap("assets.farm.petRecommendImg");
         addToContent(this._refreshVolumeImg);
         this._refreshVolumeTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.adoptdesctxt");
         addToContent(this._refreshVolumeTxt);
         this.updateAdoptBtnStatus();
      }
      
      private function update(param1:Array) : void
      {
         var _loc2_:AdoptItem = null;
         var _loc3_:PetTemplateInfo = null;
         if(!param1 || param1.length < 1)
         {
            return;
         }
         this.removeItem();
         for each(_loc3_ in param1)
         {
            _loc2_ = ComponentFactory.Instance.creat("farm.petAdoptItem",[_loc3_]);
            this._petsImgVec.push(_loc2_);
         }
         this.currentPet = null;
         this.addItem();
         this.updateAdoptBtnStatus();
      }
      
      public function updateTimer(param1:String) : void
      {
      }
      
      private function addItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._petsImgVec.length)
         {
            if(_loc1_ > 3)
            {
               return;
            }
            this._petsImgVec[_loc1_].addEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
            this._listView.addChild(this._petsImgVec[_loc1_]);
            _loc1_++;
         }
      }
      
      private function updateAdoptBtnStatus() : void
      {
         this._adoptBtn.enable = this._petsImgVec.length > 0 && this.currentPet ? Boolean(Boolean(true)) : Boolean(Boolean(false));
      }
      
      private function removeItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._petsImgVec.length)
         {
            this._petsImgVec[_loc1_].removeEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
            this._petsImgVec[_loc1_].dispose();
            this._petsImgVec[_loc1_] = null;
            _loc1_++;
         }
         this._petsImgVec.splice(0,this._petsImgVec.length);
      }
      
      private function removeItemByPetInfo(param1:PetInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._petsImgVec.length)
         {
            if(this._petsImgVec[_loc2_].info)
            {
               if(this._petsImgVec[_loc2_].info.TemplateID == param1.TemplateID && this._petsImgVec[_loc2_].info.Place == param1.Place)
               {
                  this._petsImgVec[_loc2_].removeEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
                  this._petsImgVec[_loc2_].dispose();
                  this._petsImgVec[_loc2_] = null;
                  this._petsImgVec.splice(_loc2_,1);
                  PetBagController.instance().petModel.adoptPets.remove(param1.Place);
                  break;
               }
            }
            _loc2_++;
         }
      }
      
      private function __petItemClick(param1:PetItemEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         this.currentPet = param1.data as AdoptItem;
         if(this.currentPet)
         {
            this.setSelectUnSelect(this.currentPet);
            _loc2_ = this._petsImgVec.indexOf(this.currentPet);
            if(_loc2_ > 0 && _loc2_ < 4)
            {
               this._refreshVolumeTxt.text = "   " + this._descList[_loc2_];
            }
            else
            {
               this._refreshVolumeTxt.text = this.currentPet.info.Description;
            }
         }
         this.updateAdoptBtnStatus();
      }
      
      private function setSelectUnSelect(param1:AdoptItem, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this._petsImgVec.length)
         {
            if(this._petsImgVec[_loc3_] && this._petsImgVec[_loc3_] != param1)
            {
               this._petsImgVec[_loc3_].isSelect = param2;
            }
            _loc3_++;
         }
      }
      
      private function initEvent() : void
      {
         this._adoptBtn.addEventListener(MouseEvent.CLICK,this.__adoptPet);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REFRESH_PET,this.__updateRefreshPet);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function __updateRefreshPet(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:PetInfo = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:PetSkill = null;
         var _loc11_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         var _loc12_:int = 0;
         while(_loc12_ < _loc4_)
         {
            if(_loc3_)
            {
               _loc5_ = _loc2_.readInt();
               _loc6_ = _loc2_.readInt();
               _loc7_ = new PetInfo();
               _loc7_.TemplateID = _loc6_;
               PetInfoManager.fillPetInfo(_loc7_);
               _loc7_.Name = _loc2_.readUTF();
               _loc7_.Attack = _loc2_.readInt();
               _loc7_.Defence = _loc2_.readInt();
               _loc7_.Luck = _loc2_.readInt();
               _loc7_.Agility = _loc2_.readInt();
               _loc7_.Blood = _loc2_.readInt();
               _loc7_.Damage = _loc2_.readInt();
               _loc7_.Guard = _loc2_.readInt();
               _loc7_.AttackGrow = _loc2_.readInt();
               _loc7_.DefenceGrow = _loc2_.readInt();
               _loc7_.LuckGrow = _loc2_.readInt();
               _loc7_.AgilityGrow = _loc2_.readInt();
               _loc7_.BloodGrow = _loc2_.readInt();
               _loc7_.DamageGrow = _loc2_.readInt();
               _loc7_.GuardGrow = _loc2_.readInt();
               _loc7_.Level = _loc2_.readInt();
               _loc7_.GP = _loc2_.readInt();
               _loc7_.MaxGP = _loc2_.readInt();
               _loc7_.Hunger = _loc2_.readInt();
               _loc7_.MP = _loc2_.readInt();
               _loc8_ = _loc2_.readInt();
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc11_ = _loc2_.readInt();
                  _loc10_ = new PetSkill(_loc11_);
                  _loc7_.addSkill(_loc10_);
                  _loc2_.readInt();
                  _loc9_++;
               }
               _loc7_.MaxActiveSkillCount = _loc2_.readInt();
               _loc7_.MaxStaticSkillCount = _loc2_.readInt();
               _loc7_.MaxSkillCount = _loc2_.readInt();
               _loc7_.Place = _loc5_;
               if(_loc7_.Place != -1)
               {
                  PetBagController.instance().petModel.adoptPets.add(_loc7_.Place,_loc7_);
               }
            }
            else
            {
               _loc5_ = _loc2_.readInt();
               _loc6_ = _loc2_.readInt();
               _loc7_ = new PetInfo();
               _loc7_.TemplateID = _loc6_;
               PetInfoManager.fillPetInfo(_loc7_);
               _loc7_.Name = _loc2_.readUTF();
               _loc7_.Attack = _loc2_.readInt();
               _loc7_.Defence = _loc2_.readInt();
               _loc7_.Luck = _loc2_.readInt();
               _loc7_.Agility = _loc2_.readInt();
               _loc7_.Blood = _loc2_.readInt();
               _loc7_.Damage = _loc2_.readInt();
               _loc7_.Guard = _loc2_.readInt();
               _loc7_.AttackGrow = _loc2_.readInt();
               _loc7_.DefenceGrow = _loc2_.readInt();
               _loc7_.LuckGrow = _loc2_.readInt();
               _loc7_.AgilityGrow = _loc2_.readInt();
               _loc7_.BloodGrow = _loc2_.readInt();
               _loc7_.DamageGrow = _loc2_.readInt();
               _loc7_.GuardGrow = _loc2_.readInt();
               _loc7_.Level = _loc2_.readInt();
               _loc7_.GP = _loc2_.readInt();
               _loc7_.MaxGP = _loc2_.readInt();
               _loc7_.Hunger = _loc2_.readInt();
               _loc7_.MP = _loc2_.readInt();
               _loc8_ = _loc2_.readInt();
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc11_ = _loc2_.readInt();
                  _loc10_ = new PetSkill(_loc11_);
                  _loc7_.addSkill(_loc10_);
                  _loc2_.readInt();
                  _loc9_++;
               }
               _loc7_.MaxActiveSkillCount = _loc2_.readInt();
               _loc7_.MaxStaticSkillCount = _loc2_.readInt();
               _loc7_.MaxSkillCount = _loc2_.readInt();
               _loc7_.Place = _loc5_;
               if(_loc7_.Place != -1)
               {
                  PetBagController.instance().petModel.adoptPets.add(_loc7_.Place,_loc7_);
               }
            }
            _loc12_++;
         }
         this.update(PetBagController.instance().petModel.adoptPets.list);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._adoptBtn.removeEventListener(MouseEvent.CLICK,this.__adoptPet);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REFRESH_PET,this.__updateRefreshPet);
      }
      
      private function __adoptPet(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.farms.adoptPetsAlertTitle")," ",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _loc2_.info.customPos = PositionUtils.creatPoint("farmSimpleAlertButtonPos");
         _loc2_.titleOuterRectPosString = "126,13,5";
         _loc2_.info.dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
         _loc2_.info.buttonGape = 90;
         var _loc3_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("farmSimpleAlert.textStyle");
         _loc3_.text = LanguageMgr.GetTranslation("ddt.farms.adoptPetsAlertContonet");
         _loc2_.addToContent(_loc3_);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onAdoptResponse);
      }
      
      private function __refreshPet(param1:MouseEvent) : void
      {
         var _loc4_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:int = int(LanguageMgr.GetTranslation("ddt.pet.refreshNeed"));
         var _loc3_:Number = PlayerManager.Instance.Self.Money;
         if(PlayerManager.Instance.Self.Money < _loc2_ && int(this._refreshVolumeTxt.text) <= 0)
         {
            _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc4_.moveEnable = false;
            _loc4_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            return;
         }
         this.refeshPet();
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function refeshPet() : void
      {
         this.refreshPetAlert();
      }
      
      private function refreshPetAlert() : void
      {
         if(SharedManager.Instance.isRefreshPet)
         {
            SocketManager.Instance.out.sendRefreshPet(true,false);
            return;
         }
         this._refreshPetPnl = ComponentFactory.Instance.creatComponentByStylename("farm.refreshPetAlertFrame.confirmRefresh");
         LayerManager.Instance.addToLayer(this._refreshPetPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._refreshPetPnl.addEventListener(FrameEvent.RESPONSE,this.__onRefreshResponse);
      }
      
      private function __RefreshResponseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__RefreshResponseI);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.refreshPetAlert();
         }
      }
      
      private function __onAdoptResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAdoptResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(this.currentPet && this.currentPet.info as PetInfo)
            {
               SocketManager.Instance.out.sendAdoptPet((this.currentPet.info as PetInfo).Place);
               this.removeItemByPetInfo(this.currentPet.info);
               this.currentPet = null;
               PetSpriteController.Instance.dispatchEvent(new Event(Event.OPEN));
            }
            this.dispose();
         }
         if(this._adoptBtn)
         {
            this.updateAdoptBtnStatus();
         }
      }
      
      private function __onRefreshResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(this.checkMoney(false,PetconfigAnalyzer.PetCofnig.AdoptRefereshCost))
            {
               return;
            }
            SocketManager.Instance.out.sendRefreshPet(true,false);
         }
         this._refreshPetPnl.removeEventListener(FrameEvent.RESPONSE,this.__onRefreshResponse);
         this._refreshPetPnl.dispose();
      }
      
      public function checkMoney(param1:Boolean, param2:int, param3:Function = null) : Boolean
      {
         this._money = param2;
         this._outFun = param3;
         if(PlayerManager.Instance.Self.Money < param2)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeItem();
         if(this._titleBg)
         {
            ObjectUtils.disposeObject(this._titleBg);
            this._titleBg = null;
         }
         if(this._bg2)
         {
            ObjectUtils.disposeObject(this._bg2);
            this._bg2 = null;
         }
         if(this._refreshTimerTxt)
         {
            ObjectUtils.disposeObject(this._refreshTimerTxt);
            this._refreshTimerTxt = null;
         }
         if(this.currentPet)
         {
            ObjectUtils.disposeObject(this.currentPet);
            this.currentPet = null;
         }
         if(this._listView)
         {
            ObjectUtils.disposeObject(this._listView);
            this._listView = null;
         }
         if(this._adoptBtn)
         {
            ObjectUtils.disposeObject(this._adoptBtn);
            this._adoptBtn = null;
         }
         if(this._refreshVolumeImg)
         {
            ObjectUtils.disposeObject(this._refreshVolumeImg);
            this._refreshVolumeImg = null;
         }
         if(this._refreshVolumeTxt)
         {
            ObjectUtils.disposeObject(this._refreshVolumeTxt);
            this._refreshVolumeTxt = null;
         }
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
