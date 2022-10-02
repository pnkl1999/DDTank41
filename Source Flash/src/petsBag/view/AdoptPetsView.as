package petsBag.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.data.BagInfo;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.control.FarmComposeHouseController;
   import farm.viewx.newPet.NewPetViewFrame;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import pet.date.PetInfo;
   import pet.date.PetSkill;
   import pet.date.PetTemplateInfo;
   import petsBag.controller.PetBagController;
   import petsBag.data.AdoptItemInfo;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.event.PetItemEvent;
   import petsBag.view.item.AdoptItem;
   import road7th.comm.PackageIn;
   import trainer.data.ArrowType;
   
   public class AdoptPetsView extends Frame
   {
       
      
      private var _adoptBtn:SimpleBitmapButton;
      
      private var _adoptItemBtn:SimpleBitmapButton;
      
      private var _refreshBtn:TextButton;
      
      private var _listView:SimpleTileList;
      
      private var _petsImgVec:Vector.<AdoptItem>;
      
      public var currentPet:AdoptItem;
      
      private var _refreshTimerTxt:FilterFrameText;
      
      private var _titleBg:DisplayObject;
      
      private var _bg2:DisplayObject;
      
      private var _refreshTimer:Timer;
      
      private var _refreshVolumeImg:Bitmap;
      
      private var _refreshVolumeTxt:FilterFrameText;
      
      private var _refreshVolumeTxtBG:ScaleBitmapImage;
      
      private var _refreshVolumeTip:StripTip;
      
      private var _newPetView:NewPetViewFrame;
      
      private var _petCreditTxt:Bitmap;
      
      private var _petCreditNum:FilterFrameText;
      
      private var _refreshPetPnl:RefreshPetAlertFrame;
      
      private var _isband:Boolean;
      
      private var _money:int;
      
      private var _outFun:Function;
      
      public function AdoptPetsView()
      {
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
         this.updateTimer(FarmComposeHouseController.instance().getNextUpdatePetTimes());
         this.updateRefreshVolume();
         this.__updatePetScore();
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_ADOPT_PET);
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.SELECT_PET,-150,"farmTrainer.selectPetArrowPos","asset.farmTrainer.clickHere","farmTrainer.selectPetTipPos",this);
         }
      }
      
      private function initView() : void
      {
         this._bg2 = ComponentFactory.Instance.creat("farm.adoptPetsView.bg2");
         addToContent(this._bg2);
         this._titleBg = ComponentFactory.Instance.creat("assets.farm.adoptPets");
         addChild(this._titleBg);
         this._adoptBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.adopt");
         addToContent(this._adoptBtn);
         this._adoptItemBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.adoptItem");
         this._adoptItemBtn.visible = false;
         addToContent(this._adoptItemBtn);
         this._refreshBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.refresh");
         addToContent(this._refreshBtn);
         this._refreshTimerTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.adoptRefreshTimer");
         addToContent(this._refreshTimerTxt);
         this._refreshVolumeTxtBG = ComponentFactory.Instance.creatComponentByStylename("farmHouse.adoptRefreshVolumeTxtBG");
         addToContent(this._refreshVolumeTxtBG);
         this._listView = ComponentFactory.Instance.creatCustomObject("farm.simpleTileList.petAdop",[4]);
         addToContent(this._listView);
         this._refreshVolumeImg = ComponentFactory.Instance.creatBitmap("assets.farm.petRefreshVolumeImg");
         addToContent(this._refreshVolumeImg);
         this._refreshVolumeTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.adoptRefreshVolumeTxt");
         addToContent(this._refreshVolumeTxt);
         if(ServerConfigManager.instance.petScoreEnable)
         {
            this._petCreditTxt = ComponentFactory.Instance.creat("assets.farmShop.petCreditTxt");
            this._petCreditNum = ComponentFactory.Instance.creatComponentByStylename("farm.text.petCreditNum");
            addToContent(this._petCreditTxt);
            addToContent(this._petCreditNum);
         }
         this._refreshVolumeTip = ComponentFactory.Instance.creat("farm.refreshVolumeStripTip");
         addToContent(this._refreshVolumeTip);
         this._refreshVolumeTip.setView(this._refreshVolumeImg);
         this._refreshVolumeTip.tipData = LanguageMgr.GetTranslation("ddt.farms.petRefreshVolume");
         this._refreshVolumeTip.width = this._refreshVolumeImg.width;
         this._refreshVolumeTip.height = this._refreshVolumeImg.height;
         this._refreshTimer = new Timer(60 * 1000);
         this._refreshTimer.start();
         this.updateAdoptBtnStatus();
         this.refreshPetBtn(null);
      }
      
      private function update(param1:Array, param2:Array) : void
      {
         var _loc3_:AdoptItem = null;
         var _loc4_:PetTemplateInfo = null;
         if(param1 && param1.length >= 1)
         {
            this.removeItem();
            for each(_loc4_ in param1)
            {
               _loc3_ = ComponentFactory.Instance.creat("farm.petAdoptItem",[_loc4_]);
               this._petsImgVec.push(_loc3_);
            }
         }
         this.updateItems(param2);
         this.currentPet = null;
         this.addItem();
         this.updateAdoptBtnStatus();
      }
      
      private function updateRefreshVolume() : void
      {
         this._refreshVolumeTxt.text = FarmComposeHouseController.instance().refreshVolume();
      }
      
      private function __updatePetScore(param1:CrazyTankSocketEvent = null) : void
      {
         if(this._petCreditNum)
         {
            this._petCreditNum.text = PlayerManager.Instance.Self.petScore.toString();
         }
      }
      
      public function updateTimer(param1:String) : void
      {
         this._refreshTimerTxt.text = param1;
      }
      
      private function addItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._petsImgVec.length)
         {
            this._petsImgVec[_loc1_].addEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
            this._listView.addChild(this._petsImgVec[_loc1_]);
            _loc1_++;
         }
      }
      
      private function updateAdoptBtnStatus() : void
      {
         this._adoptItemBtn.enable = this._adoptBtn.enable = this._petsImgVec.length > 0 && this.currentPet ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         if(this.currentPet)
         {
            this._adoptItemBtn.visible = this.currentPet.isGoodItem;
            this._adoptBtn.visible = !this.currentPet.isGoodItem;
         }
         this._refreshBtn.enable = true;
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
      
      private function removeItemByPlace(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._petsImgVec.length)
         {
            if(this._petsImgVec[_loc2_].itemInfo && param1 == this._petsImgVec[_loc2_].place)
            {
               this._petsImgVec[_loc2_].removeEventListener(PetItemEvent.ITEM_CLICK,this.__petItemClick);
               this._petsImgVec[_loc2_].dispose();
               this._petsImgVec[_loc2_] = null;
               this._petsImgVec.splice(_loc2_,1);
               PetBagController.instance().petModel.adoptItems.remove(param1);
               break;
            }
            _loc2_++;
         }
      }
      
      private function __petItemClick(param1:PetItemEvent) : void
      {
         SoundManager.instance.play("008");
         this.currentPet = param1.data as AdoptItem;
         if(this.currentPet)
         {
            this.setSelectUnSelect(this.currentPet);
         }
         this.updateAdoptBtnStatus();
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.SELECT_PET);
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.ADOPT_PET,-150,"farmTrainer.adoptPetArrowPos","asset.farmTrainer.clickHere","farmTrainer.adoptPetTipPos",this);
         }
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
         this._adoptItemBtn.addEventListener(MouseEvent.CLICK,this.__adoptPet);
         this._refreshBtn.addEventListener(MouseEvent.CLICK,this.__refreshPet);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REFRESH_PET,this.__updateRefreshPet);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._refreshTimer.addEventListener(TimerEvent.TIMER,this.__refreshUpdatePet);
         PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__bagUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updatePetScore);
      }
      
      private function refreshPetBtn(param1:Event) : void
      {
         PositionUtils.setPos(this._adoptBtn,"assets.farm.adoptBtnPos2");
         this._refreshBtn.text = LanguageMgr.GetTranslation("ddt.farms.refresh");
         PositionUtils.setPos(this._refreshBtn,"assets.farm.petRefreshPos");
      }
      
      private function __bagUpdate(param1:Event) : void
      {
         this.updateRefreshVolume();
      }
      
      private function __refreshUpdatePet(param1:TimerEvent) : void
      {
         this.updateTimer(FarmComposeHouseController.instance().getNextUpdatePetTimes());
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
         var _loc14_:AdoptItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         PetBagController.instance().petModel.adoptPets.clear();
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
               else
               {
                  PetBagController.instance().newPetInfo = _loc7_;
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
               else
               {
                  PetBagController.instance().newPetInfo = _loc7_;
               }
            }
            _loc12_++;
         }
         PetBagController.instance().petModel.adoptItems.clear();
         _loc4_ = _loc2_.readInt();
         var _loc13_:int = 0;
         while(_loc13_ < _loc4_)
         {
            _loc14_ = new AdoptItemInfo();
            _loc14_.place = _loc2_.readInt();
            _loc14_.itemTemplateId = _loc2_.readInt();
            _loc14_.itemAmount = _loc2_.readInt();
            PetBagController.instance().petModel.adoptItems.add(_loc14_.place,_loc14_);
            _loc13_++;
         }
         this.update(PetBagController.instance().petModel.adoptPets.list,PetBagController.instance().petModel.adoptItems.list);
         if(!this._newPetView)
         {
            this._newPetView = ComponentFactory.Instance.creatComponentByStylename("farm.newPetViewFrame");
            this._newPetView.petInfo = PetBagController.instance().newPetInfo;
            this._newPetView.addEventListener("newPetFrameClose",this.__onNewPetFrameClose);
            addChild(this._newPetView);
            this.setChildIndex(this._newPetView,0);
         }
      }
      
      private function __onNewPetFrameClose(param1:Event) : void
      {
         this._newPetView.removeEventListener("newPetFrameClose",this.__onNewPetFrameClose);
         TweenMax.to(this,0.2,{"x":255});
      }
      
      private function updateItems(param1:Array) : void
      {
         var _loc2_:AdoptItem = null;
         var _loc3_:AdoptItemInfo = null;
         if(!param1 || param1.length < 1)
         {
            return;
         }
         for each(_loc3_ in param1)
         {
            _loc2_ = ComponentFactory.Instance.creat("farm.petAdoptItem",[null]);
            _loc2_.itemAmount = _loc3_.itemAmount;
            _loc2_.place = _loc3_.place;
            _loc2_.itemTemplateId = _loc3_.itemTemplateId;
            this._petsImgVec.push(_loc2_);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._adoptBtn.removeEventListener(MouseEvent.CLICK,this.__adoptPet);
         this._adoptItemBtn.removeEventListener(MouseEvent.CLICK,this.__adoptPet);
         this._refreshBtn.removeEventListener(MouseEvent.CLICK,this.__refreshPet);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REFRESH_PET,this.__updateRefreshPet);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updatePetScore);
         if(this._refreshTimer)
         {
            this._refreshTimer.stop();
            this._refreshTimer.removeEventListener(TimerEvent.TIMER,this.__refreshUpdatePet);
            this._refreshTimer = null;
         }
         PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__bagUpdate);
      }
      
      private function __adoptPet(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.currentPet.isGoodItem)
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.farms.adoptItemAlertTitle");
         }
         else
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.farms.adoptPetsAlertTitle");
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(_loc2_," ",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"farmSimpleAlertTwo",60,false);
         _loc3_.titleOuterRectPosString = "107,12,5";
         _loc3_.info.customPos = PositionUtils.creatPoint("farmSimpleAlertButtonPos");
         _loc3_.info.dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
         var _loc4_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("farmSimpleAlert.textStyle");
         if(this.currentPet.isGoodItem)
         {
            _loc4_.text = LanguageMgr.GetTranslation("ddt.farms.adoptItemsAlertContonet");
         }
         else
         {
            _loc4_.text = LanguageMgr.GetTranslation("ddt.farms.adoptPetsAlertContonet");
         }
         _loc3_.addToContent(_loc4_);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAdoptResponse);
      }
      
      private function __refreshPet(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = int(LanguageMgr.GetTranslation("ddt.pet.refreshNeed"));
         var _loc3_:Number = PlayerManager.Instance.Self.Money;
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
         var _loc1_:BaseAlerFrame = null;
         if(FarmComposeHouseController.instance().isFourStarPet(PetBagController.instance().petModel.adoptPets.list))
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.farms.refreshPetsAlertTitle"),LanguageMgr.GetTranslation("ddt.farms.refreshPetsAlertContonetI"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"farmSimpleAlert",60,false);
            _loc1_.addEventListener(FrameEvent.RESPONSE,this.__RefreshResponseI);
            _loc1_.titleOuterRectPosString = "206,10,5";
            return;
         }
         this.refreshPetAlert();
      }
      
      private function refreshPetAlert() : void
      {
         if(int(FarmComposeHouseController.instance().refreshVolume()) > 0)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._refreshBtn.enable = false;
            SocketManager.Instance.out.sendRefreshPet(true);
            return;
         }
         if(SharedManager.Instance.isRefreshPet)
         {
            if(this.checkMoney(SharedManager.Instance.isRefreshBand,PetconfigAnalyzer.PetCofnig.AdoptRefereshCost))
            {
               SharedManager.Instance.isRefreshPet = false;
               this._refreshPetPnl = ComponentFactory.Instance.creatComponentByStylename("farm.refreshPetAlertFrame.confirmRefresh");
               LayerManager.Instance.addToLayer(this._refreshPetPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               this._refreshPetPnl.addEventListener(FrameEvent.RESPONSE,this.__onRefreshResponse);
               return;
            }
            SocketManager.Instance.out.sendRefreshPet(true,SharedManager.Instance.isRefreshBand);
            return;
         }
         this._refreshPetPnl = ComponentFactory.Instance.creatComponentByStylename("farm.refreshPetAlertFrame.confirmRefresh");
         LayerManager.Instance.addToLayer(this._refreshPetPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._refreshPetPnl.addEventListener(FrameEvent.RESPONSE,this.__onRefreshResponse);
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
               if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
               {
                  PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.ADOPT_PET);
               }
            }
            else if(this.currentPet && this.currentPet.itemInfo)
            {
               SocketManager.Instance.out.sendAdoptPet(this.currentPet.place);
               this.removeItemByPlace(this.currentPet.place);
               this.currentPet = null;
            }
         }
         this.updateAdoptBtnStatus();
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
         if(this._refreshBtn)
         {
            ObjectUtils.disposeObject(this._refreshBtn);
            this._refreshBtn = null;
         }
         if(this._adoptBtn)
         {
            ObjectUtils.disposeObject(this._adoptBtn);
            this._adoptBtn = null;
         }
         if(this._adoptItemBtn)
         {
            ObjectUtils.disposeObject(this._adoptItemBtn);
            this._adoptItemBtn = null;
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
         if(this._petCreditTxt)
         {
            ObjectUtils.disposeObject(this._petCreditTxt);
            this._petCreditTxt = null;
         }
         if(this._petCreditNum)
         {
            ObjectUtils.disposeObject(this._petCreditNum);
            this._petCreditNum = null;
         }
         if(this._refreshVolumeTxtBG)
         {
            ObjectUtils.disposeObject(this._refreshVolumeTxtBG);
            this._refreshVolumeTxtBG = null;
         }
         if(this._refreshVolumeTip)
         {
            ObjectUtils.disposeObject(this._refreshVolumeTip);
            this._refreshVolumeTip = null;
         }
         if(this._newPetView)
         {
            ObjectUtils.disposeObject(this._newPetView);
         }
         this._newPetView = null;
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
