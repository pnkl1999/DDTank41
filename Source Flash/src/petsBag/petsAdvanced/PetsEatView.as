package petsBag.petsAdvanced
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.event.PetsAdvancedEvent;
   
   public class PetsEatView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _eatPetsBtn:SimpleBitmapButton;
      
      private var _eatStoneBtn:SimpleBitmapButton;
      
      private var _weaponBtn:SimpleBitmapButton;
      
      private var _clothesBtn:SimpleBitmapButton;
      
      private var _hatBtn:SimpleBitmapButton;
      
      private var _btnLight:Bitmap;
      
      private var _defenceTxt:FilterFrameText;
      
      private var _attackTxt:FilterFrameText;
      
      private var _defenceAddTxt:FilterFrameText;
      
      private var _attackAddTxt:FilterFrameText;
      
      private var _defenceTitleTxt:FilterFrameText;
      
      private var _attackTitleTxt:FilterFrameText;
      
      private var _autoUseBtn:SelectedCheckButton;
      
      private var _bagCell:PetsAdvancedCell;
      
      private var _progress:PetsAdvancedProgressBar;
      
      private var _chooseMc:MovieClip;
      
      private var _expTitle:Bitmap;
      
      private var _lv:Bitmap;
      
      private var _lvTxt:FilterFrameText;
      
      private var _listPanel:ScrollPanel;
      
      private var _listContainer:Sprite;
      
      private var _petsImgVec:Vector.<PetsEatSmallItem>;
      
      private var _selectedArr:Array;
      
      private var _eatPetsMc:MovieClip;
      
      private var _eatStoneMc:MovieClip;
      
      private var _eatEnd:MovieClip;
      
      private var _petAddExpTxt:FilterFrameText;
      
      private var _petdesTxt:FilterFrameText;
      
      protected var _tip:OneLineTip;
      
      private var _clickDate:Number = 0;
      
      private var clickType:int;
      
      public function PetsEatView()
      {
         this._selectedArr = [];
         super();
         this.initView();
         this.initEvent();
      }
      
      public function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("petsBag.eat.bg");
         addChild(this._bg);
         this._eatPetsBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.eatPetsBtn");
         this._eatPetsBtn.tipData = LanguageMgr.GetTranslation("pet.eatPet.tips");
         addChild(this._eatPetsBtn);
         this._eatStoneBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.eatStoneBtn");
         addChild(this._eatStoneBtn);
         this._weaponBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.weaponBtn");
         addChild(this._weaponBtn);
         this._clothesBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.clothesBtn");
         addChild(this._clothesBtn);
         this._hatBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.hatBtn");
         addChild(this._hatBtn);
         this._btnLight = ComponentFactory.Instance.creat("assets.PetsBag.eatPets.btnLight");
         addChild(this._btnLight);
         this._btnLight.x = this._weaponBtn.x;
         this._btnLight.y = this._weaponBtn.y;
         this._defenceTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.attributeTxt");
         addChild(this._defenceTxt);
         PositionUtils.setPos(this._defenceTxt,"petsBag.eatPets.attributePos2");
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.attributeTxt");
         addChild(this._attackTxt);
         PositionUtils.setPos(this._attackTxt,"petsBag.eatPets.attributePos1");
         this._defenceAddTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.attributeAddTxt");
         addChild(this._defenceAddTxt);
         PositionUtils.setPos(this._defenceAddTxt,"petsBag.eatPets.attributeAddPos2");
         this._attackAddTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.attributeAddTxt");
         addChild(this._attackAddTxt);
         PositionUtils.setPos(this._attackAddTxt,"petsBag.eatPets.attributeAddPos1");
         this._autoUseBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.autoUseBtn");
         addChild(this._autoUseBtn);
         this._autoUseBtn.text = LanguageMgr.GetTranslation("ddt.petsBag.eatPets.autoUse");
         this._bagCell = new PetsAdvancedCell();
         PositionUtils.setPos(this._bagCell,"petsBag.eatPets.petAdvancedCellPos");
         addChild(this._bagCell);
         this._progress = new PetsAdvancedProgressBar();
         addChild(this._progress);
         PositionUtils.setPos(this._progress,"petsBag.eatPets.expBarPos");
         this._expTitle = ComponentFactory.Instance.creat("assets.PetsBag.eatPets.expTitle");
         addChild(this._expTitle);
         this._chooseMc = ComponentFactory.Instance.creat("assets.PetsBag.eatPets.chooseMc");
         addChild(this._chooseMc);
         this._chooseMc.gotoAndStop(1);
         PositionUtils.setPos(this._chooseMc,"PetsBag.eatPets.chooseMcPos");
         this._lv = ComponentFactory.Instance.creatBitmap("assets.petsBag.Lv");
         addChild(this._lv);
         PositionUtils.setPos(this._lv,"petsBag.eatPets.lvBitmapPos");
         this._lvTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.text.Lv");
         addChild(this._lvTxt);
         PositionUtils.setPos(this._lvTxt,"petsBag.eatPets.lvTxtPos");
         this._defenceTitleTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.attributeTitleTxt");
         addChild(this._defenceTitleTxt);
         PositionUtils.setPos(this._defenceTitleTxt,"petsBag.eatPets.defenceTitlePos");
         this._defenceTitleTxt.text = LanguageMgr.GetTranslation("defence");
         this._attackTitleTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.attributeTitleTxt");
         addChild(this._attackTitleTxt);
         PositionUtils.setPos(this._attackTitleTxt,"petsBag.eatPets.attackTitlePos");
         this._attackTitleTxt.text = LanguageMgr.GetTranslation("attack");
         this._tip = new OneLineTip();
         this._tip.visible = false;
         addChild(this._tip);
         PositionUtils.setPos(this._tip,"petsBag.eatPets.expBarTipPos");
         this._listContainer = new Sprite();
         this.updataPets();
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.petsScrollPanel");
         this._listPanel.setView(this._listContainer);
         this._listPanel.invalidateViewport();
         addChild(this._listPanel);
         this._petAddExpTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.petAddExpTxt");
         addChild(this._petAddExpTxt);
         this._petAddExpTxt.text = "0";
         this._petdesTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.eatPets.petDesTxt");
         addChild(this._petdesTxt);
         this._petdesTxt.text = LanguageMgr.GetTranslation("ddt.petsBag.eatpets.petDesTitle");
         this._eatEnd = ComponentFactory.Instance.creat("asset.PetsBag.eatPets.end");
         addChild(this._eatEnd);
         PositionUtils.setPos(this._eatEnd,"petsBag.eatPets.endPos");
         this._eatPetsMc = ComponentFactory.Instance.creat("asset.PetsBag.eatPetsMc");
         addChild(this._eatPetsMc);
         this._eatPetsMc.rotation = -80;
         this._eatPetsMc.scaleY = 0.95;
         this._eatPetsMc.scaleX = 0.95;
         PositionUtils.setPos(this._eatPetsMc,"petsBag.eatPets.eatPetsMcPos");
         this._eatStoneMc = ComponentFactory.Instance.creat("asset.PetsBag.eatStoneMc");
         addChild(this._eatStoneMc);
         this._eatStoneMc.rotation = -75;
         PositionUtils.setPos(this._eatStoneMc,"petsBag.eatPets.eatStoneMcPos");
         this.update();
         this.progressSet();
      }
      
      private function initEvent() : void
      {
         this._eatPetsBtn.addEventListener(MouseEvent.CLICK,this._eatBtnHandler);
         this._eatStoneBtn.addEventListener(MouseEvent.CLICK,this._eatBtnHandler);
         this._weaponBtn.addEventListener(MouseEvent.CLICK,this._selectHandler);
         this._clothesBtn.addEventListener(MouseEvent.CLICK,this._selectHandler);
         this._hatBtn.addEventListener(MouseEvent.CLICK,this._selectHandler);
         this._weaponBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this._progress.addEventListener(MouseEvent.ROLL_OVER,this.__showTip);
         this._progress.addEventListener(MouseEvent.ROLL_OUT,this.__hideTip);
         this._eatEnd.addEventListener("mcEnd",this._mcEndHandler);
         this._eatPetsMc.addEventListener("mcExpChange",this._mcExpChangeHandler);
         this._eatStoneMc.addEventListener("mcExpChange",this._mcExpChangeHandler);
         PetBagController.instance().petModel.addEventListener(PetsAdvancedEvent.EAT_PETS_COMPLETE,this._infoChangeHandler);
      }
      
      protected function __hideTip(param1:MouseEvent) : void
      {
         this._tip.visible = false;
      }
      
      protected function __showTip(param1:MouseEvent) : void
      {
         this._tip.tipData = this._progress.currentExp + "/" + this._progress.max;
         this._tip.visible = true;
      }
      
      private function _infoChangeHandler(param1:PetsAdvancedEvent) : void
      {
         this.updataPets();
         this.stopAllMc();
         this.selectedHandler(null);
         this._bagCell.updateCount();
         if(this.clickType == 1 && this._eatPetsMc)
         {
            this._eatPetsMc.gotoAndPlay(2);
         }
         else if(this.clickType == 2 && this._eatStoneMc)
         {
            this._eatStoneMc.gotoAndPlay(2);
         }
         if(PlayerManager.Instance.Self.pets.length == 0)
         {
            PetsAdvancedManager.Instance.frame.setBtnEnableFalse();
         }
      }
      
      private function _mcExpChangeHandler(param1:Event) : void
      {
         this.progressSet();
         switch(param1.target)
         {
            case this._eatPetsMc:
            case this._eatStoneMc:
               if(this._eatEnd && PetBagController.instance().petModel.eatPetsLevelUp)
               {
                  PetBagController.instance().petModel.eatPetsLevelUp = false;
                  this._eatEnd.gotoAndPlay(2);
                  break;
               }
         }
      }
      
      private function _mcEndHandler(param1:Event) : void
      {
         switch(param1.target)
         {
            case this._eatEnd:
               this.update();
         }
      }
      
      private function progressSet() : void
      {
         if(this._chooseMc)
         {
            switch(this._chooseMc.currentFrame)
            {
               case 1:
                  this._lvTxt.text = PetBagController.instance().petModel.eatPetsInfo.weaponLevel;
                  if(PetBagController.instance().petModel.eatPetsInfo.weaponLevel == PetsAdvancedManager.Instance.petMoePropertyList.length)
                  {
                     this._tip.tipData = "0/0";
                     this._progress.currentExp = 0;
                     this._progress.maxAdvancedGrade();
                     break;
                  }
                  this._progress.max = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.weaponLevel].Exp;
                  this._progress.setProgress(PetBagController.instance().petModel.eatPetsInfo.weaponExp);
                  break;
               case 2:
                  this._lvTxt.text = PetBagController.instance().petModel.eatPetsInfo.clothesLevel;
                  if(PetBagController.instance().petModel.eatPetsInfo.clothesLevel == PetsAdvancedManager.Instance.petMoePropertyList.length)
                  {
                     this._tip.tipData = "0/0";
                     this._progress.currentExp = 0;
                     this._progress.maxAdvancedGrade();
                     break;
                  }
                  this._progress.max = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.clothesLevel].Exp;
                  this._progress.setProgress(PetBagController.instance().petModel.eatPetsInfo.clothesExp);
                  break;
               case 3:
                  this._lvTxt.text = PetBagController.instance().petModel.eatPetsInfo.hatLevel;
                  if(PetBagController.instance().petModel.eatPetsInfo.hatLevel == PetsAdvancedManager.Instance.petMoePropertyList.length)
                  {
                     this._tip.tipData = "0/0";
                     this._progress.currentExp = 0;
                     this._progress.maxAdvancedGrade();
                     break;
                  }
                  this._progress.max = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.hatLevel].Exp;
                  this._progress.setProgress(PetBagController.instance().petModel.eatPetsInfo.hatExp);
                  break;
            }
         }
      }
      
      private function clearPets() : void
      {
         this._petsImgVec = new Vector.<PetsEatSmallItem>();
         while(this._listContainer.numChildren > 0)
         {
            this._listContainer.removeChildAt(0);
         }
      }
      
      private function updataPets() : void
      {
         var _loc3_:PetsEatSmallItem = null;
         var _loc2_:* = null;
         _loc3_ = null;
         this.clearPets();
         var _loc1_:int = 0;
         for(_loc2_ in PlayerManager.Instance.Self.pets)
         {
            if(!PlayerManager.Instance.Self.pets[_loc2_].IsEquip && PlayerManager.Instance.Self.pets[_loc2_].StarLevel >= 3)
            {
               _loc3_ = new PetsEatSmallItem();
               _loc3_.info = PlayerManager.Instance.Self.pets[_loc2_];
               _loc3_.initTips();
               _loc3_.x = 17 + _loc1_ % 2 * 85;
               _loc3_.y = Math.floor(_loc1_ / 2) * 82;
               _loc3_.addEventListener("selected",this.selectedHandler);
               _loc1_++;
               this._listContainer.addChild(_loc3_);
               this._petsImgVec.push(_loc3_);
            }
         }
      }
      
      private function selectedHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc4_:PetInfo = null;
         this.checkItem();
         var _loc3_:int = 0;
         while(_loc3_ < this._selectedArr.length)
         {
            _loc4_ = this._selectedArr[_loc3_][1];
            _loc2_ += Math.pow(10,_loc4_.StarLevel - 2) + 5 * Math.max(_loc4_.Level - 8,_loc4_.Level * 0.2);
            _loc3_++;
         }
         this._petAddExpTxt.text = String(_loc2_);
      }
      
      private function stopAllMc() : void
      {
         this._eatPetsMc.gotoAndStop(1);
         this._eatStoneMc.gotoAndStop(1);
         this._eatEnd.gotoAndStop(1);
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         switch(this._chooseMc.currentFrame)
         {
            case 1:
               if(PetBagController.instance().petModel.eatPetsInfo.weaponLevel > 0 && PetBagController.instance().petModel.eatPetsInfo.weaponLevel < PetsAdvancedManager.Instance.petMoePropertyList.length)
               {
                  _loc1_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.weaponLevel - 1].Attack;
                  _loc2_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.weaponLevel - 1].Lucky;
                  _loc3_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.weaponLevel].Attack;
                  _loc4_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.weaponLevel].Lucky;
               }
               else if(PetBagController.instance().petModel.eatPetsInfo.weaponLevel == 0)
               {
                  _loc1_ = 0;
                  _loc2_ = 0;
                  _loc3_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.weaponLevel].Attack;
                  _loc4_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.weaponLevel].Lucky;
               }
               else if(PetBagController.instance().petModel.eatPetsInfo.weaponLevel == PetsAdvancedManager.Instance.petMoePropertyList.length)
               {
                  _loc1_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.weaponLevel - 1].Attack;
                  _loc2_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.weaponLevel - 1].Lucky;
                  _loc3_ = 0;
                  _loc4_ = 0;
               }
               break;
            case 2:
               if(PetBagController.instance().petModel.eatPetsInfo.clothesLevel > 0 && PetBagController.instance().petModel.eatPetsInfo.clothesLevel < PetsAdvancedManager.Instance.petMoePropertyList.length)
               {
                  _loc1_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.clothesLevel - 1].Agility;
                  _loc2_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.clothesLevel - 1].Blood;
                  _loc3_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.clothesLevel].Agility;
                  _loc4_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.clothesLevel].Blood;
               }
               else if(PetBagController.instance().petModel.eatPetsInfo.clothesLevel == 0)
               {
                  _loc1_ = 0;
                  _loc2_ = 0;
                  _loc3_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.clothesLevel].Agility;
                  _loc4_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.clothesLevel].Blood;
               }
               else if(PetBagController.instance().petModel.eatPetsInfo.clothesLevel == PetsAdvancedManager.Instance.petMoePropertyList.length)
               {
                  _loc1_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.clothesLevel - 1].Agility;
                  _loc2_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.clothesLevel - 1].Blood;
                  _loc3_ = 0;
                  _loc4_ = 0;
               }
               break;
            case 3:
               if(PetBagController.instance().petModel.eatPetsInfo.hatLevel > 0 && PetBagController.instance().petModel.eatPetsInfo.hatLevel < PetsAdvancedManager.Instance.petMoePropertyList.length)
               {
                  _loc1_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.hatLevel - 1].Defence;
                  _loc2_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.hatLevel - 1].Guard;
                  _loc3_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.hatLevel].Defence;
                  _loc4_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.hatLevel].Guard;
               }
               else if(PetBagController.instance().petModel.eatPetsInfo.hatLevel == 0)
               {
                  _loc1_ = 0;
                  _loc2_ = 0;
                  _loc3_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.hatLevel].Defence;
                  _loc4_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.hatLevel].Guard;
               }
               else if(PetBagController.instance().petModel.eatPetsInfo.hatLevel == PetsAdvancedManager.Instance.petMoePropertyList.length)
               {
                  _loc1_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.hatLevel - 1].Defence;
                  _loc2_ = PetsAdvancedManager.Instance.petMoePropertyList[PetBagController.instance().petModel.eatPetsInfo.hatLevel - 1].Guard;
                  _loc3_ = 0;
                  _loc4_ = 0;
               }
         }
         this._attackTxt.text = String(_loc1_);
         this._defenceTxt.text = String(_loc2_);
         this._attackAddTxt.text = String(_loc3_);
         this._defenceAddTxt.text = String(_loc4_);
      }
      
      private function checkItem() : void
      {
         var _loc2_:PetsEatSmallItem = null;
         this._selectedArr = [];
         var _loc1_:int = 0;
         while(_loc1_ < this._petsImgVec.length)
         {
            _loc2_ = this._petsImgVec[_loc1_] as PetsEatSmallItem;
            if(_loc2_.selected)
            {
               this._selectedArr.push([_loc2_.info.Place,_loc2_.info]);
            }
            _loc1_++;
         }
      }
      
      private function _eatBtnHandler(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         switch(param1.target)
         {
            case this._eatPetsBtn:
               this.checkItem();
               this.clickType = 1;
               if(this._selectedArr.length < 1)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petsBag.eatPets.pleaseChoosePets"));
                  return;
               }
               if(this._lvTxt.text == String(PetsAdvancedManager.Instance.petMoePropertyList.length))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petsBag.eatPets.maxLevel"));
                  return;
               }
               if(this.checkEatGreatPets())
               {
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.petsBag.eatpets.eatGreatPets"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertEatGreatPet);
                  return;
               }
               if(this._listContainer.numChildren == this._selectedArr.length)
               {
                  _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.petsBag.eatpets.eatAllPets"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
                  _loc3_.addEventListener(FrameEvent.RESPONSE,this.__alertEatAllPet);
                  return;
               }
               SocketManager.Instance.out.eatPetsHandler(this._chooseMc.currentFrame - 1,1,0,this._selectedArr);
               break;
            case this._eatStoneBtn:
               this.clickType = 2;
               if(new Date().time - this._clickDate <= 2000)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
                  return;
               }
               this._clickDate = new Date().time;
               if(this._lvTxt.text == String(PetsAdvancedManager.Instance.petMoePropertyList.length))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petsBag.eatPets.maxLevel"));
                  return;
               }
               if(this._autoUseBtn.selected)
               {
                  SocketManager.Instance.out.eatPetsHandler(this._chooseMc.currentFrame - 1,2,this._bagCell.getCount(),[]);
               }
               else
               {
                  SocketManager.Instance.out.eatPetsHandler(this._chooseMc.currentFrame - 1,2,1,[]);
               }
               break;
         }
      }
      
      private function __alertEatGreatPet(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._listContainer.numChildren == this._selectedArr.length)
               {
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.petsBag.eatpets.eatAllPets"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertEatAllPet);
                  param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertEatGreatPet);
                  ObjectUtils.disposeObject(param1.currentTarget);
                  return;
               }
               SocketManager.Instance.out.eatPetsHandler(this._chooseMc.currentFrame - 1,1,0,this._selectedArr);
               break;
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertEatGreatPet);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function checkEatGreatPets() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._selectedArr.length)
         {
            if(this._selectedArr[_loc1_][1].StarLevel >= 3)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function __alertEatAllPet(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.eatPetsHandler(this._chooseMc.currentFrame - 1,1,0,this._selectedArr);
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertEatAllPet);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function _selectHandler(param1:MouseEvent) : void
      {
         this.stopAllMc();
         switch(param1.target)
         {
            case this._weaponBtn:
               this._chooseMc.gotoAndStop(1);
               this._attackTitleTxt.text = LanguageMgr.GetTranslation("attack");
               this._defenceTitleTxt.text = LanguageMgr.GetTranslation("luck");
               break;
            case this._clothesBtn:
               this._chooseMc.gotoAndStop(2);
               this._attackTitleTxt.text = LanguageMgr.GetTranslation("agility");
               this._defenceTitleTxt.text = LanguageMgr.GetTranslation("MaxHp");
               break;
            case this._hatBtn:
               this._chooseMc.gotoAndStop(3);
               this._attackTitleTxt.text = LanguageMgr.GetTranslation("defence");
               this._defenceTitleTxt.text = LanguageMgr.GetTranslation("recovery");
         }
         this.update();
         this.progressSet();
         this._btnLight.x = param1.target.x;
         this._btnLight.y = param1.target.y;
      }
      
      private function removeEvent() : void
      {
         this._eatPetsBtn.removeEventListener(MouseEvent.CLICK,this._eatBtnHandler);
         this._eatStoneBtn.removeEventListener(MouseEvent.CLICK,this._eatBtnHandler);
         this._weaponBtn.removeEventListener(MouseEvent.CLICK,this._selectHandler);
         this._clothesBtn.removeEventListener(MouseEvent.CLICK,this._selectHandler);
         this._hatBtn.removeEventListener(MouseEvent.CLICK,this._selectHandler);
         this._progress.removeEventListener(MouseEvent.ROLL_OVER,this.__showTip);
         this._progress.removeEventListener(MouseEvent.ROLL_OUT,this.__hideTip);
         this._eatEnd.removeEventListener("mcEnd",this._mcEndHandler);
         this._eatPetsMc.removeEventListener("mcExpChange",this._mcExpChangeHandler);
         this._eatStoneMc.removeEventListener("mcExpChange",this._mcExpChangeHandler);
         PetBagController.instance().petModel.removeEventListener(PetsAdvancedEvent.EAT_PETS_COMPLETE,this._infoChangeHandler);
      }
      
      public function dispose() : void
      {
         this.stopAllMc();
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._eatPetsBtn)
         {
            ObjectUtils.disposeObject(this._eatPetsBtn);
            this._eatPetsBtn = null;
         }
         if(this._eatStoneBtn)
         {
            ObjectUtils.disposeObject(this._eatStoneBtn);
            this._eatStoneBtn = null;
         }
         if(this._weaponBtn)
         {
            ObjectUtils.disposeObject(this._weaponBtn);
            this._weaponBtn = null;
         }
         if(this._clothesBtn)
         {
            ObjectUtils.disposeObject(this._clothesBtn);
            this._clothesBtn = null;
         }
         if(this._hatBtn)
         {
            ObjectUtils.disposeObject(this._hatBtn);
            this._hatBtn = null;
         }
         if(this._attackTxt)
         {
            ObjectUtils.disposeObject(this._attackTxt);
            this._attackTxt = null;
         }
         if(this._defenceTxt)
         {
            ObjectUtils.disposeObject(this._defenceTxt);
            this._defenceTxt = null;
         }
         if(this._defenceAddTxt)
         {
            ObjectUtils.disposeObject(this._defenceAddTxt);
            this._defenceAddTxt = null;
         }
         if(this._attackAddTxt)
         {
            ObjectUtils.disposeObject(this._attackAddTxt);
            this._attackAddTxt = null;
         }
         if(this._autoUseBtn)
         {
            ObjectUtils.disposeObject(this._autoUseBtn);
            this._autoUseBtn = null;
         }
         if(this._bagCell)
         {
            ObjectUtils.disposeObject(this._bagCell);
            this._bagCell = null;
         }
         if(this._progress)
         {
            ObjectUtils.disposeObject(this._progress);
            this._progress = null;
         }
         if(this._tip)
         {
            ObjectUtils.disposeObject(this._tip);
            this._tip = null;
         }
         if(this._chooseMc)
         {
            ObjectUtils.disposeObject(this._chooseMc);
            this._chooseMc = null;
         }
         if(this._expTitle)
         {
            ObjectUtils.disposeObject(this._expTitle);
            this._expTitle = null;
         }
         if(this._defenceTitleTxt)
         {
            ObjectUtils.disposeObject(this._defenceTitleTxt);
            this._defenceTitleTxt = null;
         }
         if(this._attackTitleTxt)
         {
            ObjectUtils.disposeObject(this._attackTitleTxt);
            this._attackTitleTxt = null;
         }
         if(this._listContainer)
         {
            ObjectUtils.disposeObject(this._listContainer);
            this._listContainer = null;
         }
         if(this._eatPetsMc)
         {
            ObjectUtils.disposeObject(this._eatPetsMc);
            this._eatPetsMc = null;
         }
         if(this._eatStoneMc)
         {
            ObjectUtils.disposeObject(this._eatStoneMc);
            this._eatStoneMc = null;
         }
         if(this._eatEnd)
         {
            ObjectUtils.disposeObject(this._eatEnd);
            this._eatEnd = null;
         }
         ObjectUtils.disposeObject(this._listPanel);
         this._listPanel = null;
         ObjectUtils.disposeObject(this._lv);
         this._lv = null;
         ObjectUtils.disposeObject(this._lvTxt);
         this._lvTxt = null;
         ObjectUtils.disposeObject(this._petAddExpTxt);
         this._petAddExpTxt = null;
         ObjectUtils.disposeObject(this._petdesTxt);
         this._petdesTxt = null;
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}
