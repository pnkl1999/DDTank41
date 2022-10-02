package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetInfoManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import pet.date.PetTemplateInfo;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetStarExpData;
   import petsBag.event.PetsAdvancedEvent;
   import petsBag.view.item.StarBar;
   import road7th.comm.PackageIn;
   
   public class PetsRisingStarView extends PetsAdvancedView
   {
       
      
      private var _starBar:StarBar;
      
      private var _maxStarTxt:FilterFrameText;
      
      private var _helpTxt1:FilterFrameText;
      
      private var _helpTxt2:FilterFrameText;
      
      private var _helpTxt3:FilterFrameText;
      
      private var _petStarInfo:PetStarExpData;
      
      private var _oldPropArr:Array;
      
      private var _oldGrowArr:Array;
      
      private var _propLevelArr_one:Array;
      
      private var _propLevelArr_two:Array;
      
      private var _propLevelArr_three:Array;
      
      private var _growLevelArr_one:Array;
      
      private var _growLevelArr_two:Array;
      
      private var _growLevelArr_three:Array;
      
      private var _maxStarLevel:int = 4;
      
      public function PetsRisingStarView()
      {
         super(1);
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._maxStarTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.helpTxt");
         this._maxStarTxt.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.maxStarTxt");
         PositionUtils.setPos(this._maxStarTxt,"petsBag.risingStar.maxStarPos");
         addChild(this._maxStarTxt);
         if(_petInfo.StarLevel == this._maxStarLevel)
         {
            this._maxStarTxt.visible = true;
         }
         else
         {
            this._maxStarTxt.visible = false;
            this._starBar = new StarBar();
            this._starBar.starNum(_petInfo.StarLevel + 1);
            PositionUtils.setPos(this._starBar,"petsBag.risingStar.nextStarPos");
            addChild(this._starBar);
         }
         this._helpTxt1 = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.helpTxt");
         addChild(this._helpTxt1);
         this._helpTxt1.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.helpTxt1");
         this._helpTxt2 = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.helpTxt");
         addChild(this._helpTxt2);
         this._helpTxt2.y = this._helpTxt1.y + 16;
         this._helpTxt2.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.helpTxt2");
         this._helpTxt3 = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.helpTxt");
         addChild(this._helpTxt3);
         this._helpTxt3.y = this._helpTxt2.y + 29;
         this._helpTxt3.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.helpTxt3");
         if(_petInfo.StarLevel >= this._maxStarLevel)
         {
            _btn.enable = false;
         }
      }
      
      override protected function initData() : void
      {
         super.initData();
         this.updateData();
      }
      
      private function updateData() : void
      {
         var _loc1_:PetStarExpData = null;
         var _loc2_:int = 0;
         var _loc3_:PetTemplateInfo = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         for each(_loc1_ in PetsAdvancedManager.Instance.risingStarDataList)
         {
            if(_loc1_.OldID == _petInfo.TemplateID)
            {
               this._petStarInfo = _loc1_;
               _progress.max = this._petStarInfo.Exp;
               _progress.setProgress(_petInfo.currentStarExp);
               break;
            }
         }
         if(_petInfo.StarLevel >= this._maxStarLevel)
         {
            _tip.tipData = "0/0";
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               _itemVector[_loc2_].setData(_loc2_,0,0);
               _loc2_++;
            }
            _progress.maxAdvancedGrade();
         }
         else if(this._petStarInfo)
         {
            _loc3_ = PetInfoManager.getPetByTemplateID(this._petStarInfo.NewID);
            if(!_loc3_)
            {
               return;
            }
            this._oldPropArr = [_loc3_.HighBlood,_loc3_.HighAttack,_loc3_.HighDefence,_loc3_.HighAgility,_loc3_.HighLuck];
            this._oldGrowArr = [_loc3_.HighBloodGrow,_loc3_.HighAttackGrow,_loc3_.HighDefenceGrow,_loc3_.HighAgilityGrow,_loc3_.HighLuckGrow];
            this._propLevelArr_one = this._oldPropArr;
            this._growLevelArr_one = this.getAddedPropArr(1,this._oldGrowArr);
            this._propLevelArr_two = this._oldPropArr;
            this._growLevelArr_two = this.getAddedPropArr(2,this._oldGrowArr);
            this._propLevelArr_three = this._oldPropArr;
            this._growLevelArr_three = this.getAddedPropArr(3,this._oldGrowArr);
            if(_petInfo.Level < 30)
            {
               _loc7_ = 0;
               while(_loc7_ < this._propLevelArr_one.length)
               {
                  this._propLevelArr_one[_loc7_] += (_petInfo.Level - 1) * this._growLevelArr_one[_loc7_] - _currentPropArr[_loc7_];
                  this._growLevelArr_one[_loc7_] -= _currentGrowArr[_loc7_];
                  this._propLevelArr_one[_loc7_] = Math.ceil(this._propLevelArr_one[_loc7_] / 10) / 10;
                  this._growLevelArr_one[_loc7_] = Math.ceil(this._growLevelArr_one[_loc7_] / 10) / 10;
                  _loc7_++;
               }
               _loc4_ = this._propLevelArr_one;
               _loc5_ = this._growLevelArr_one;
            }
            else if(_petInfo.Level < 50)
            {
               _loc8_ = 0;
               while(_loc8_ < this._propLevelArr_two.length)
               {
                  this._propLevelArr_two[_loc8_] += (_petInfo.Level - 30) * this._growLevelArr_two[_loc8_] + 29 * this._growLevelArr_one[_loc8_] - _currentPropArr[_loc8_];
                  this._growLevelArr_two[_loc8_] -= _currentGrowArr[_loc8_];
                  this._propLevelArr_two[_loc8_] = Math.ceil(this._propLevelArr_two[_loc8_] / 10) / 10;
                  this._growLevelArr_two[_loc8_] = Math.ceil(this._growLevelArr_two[_loc8_] / 10) / 10;
                  _loc8_++;
               }
               _loc4_ = this._propLevelArr_two;
               _loc5_ = this._growLevelArr_two;
            }
            else
            {
               _loc9_ = 0;
               while(_loc9_ < this._propLevelArr_three.length)
               {
                  this._propLevelArr_three[_loc9_] += (_petInfo.Level - 50) * this._growLevelArr_three[_loc9_] + 20 * this._growLevelArr_two[_loc9_] + 29 * this._growLevelArr_one[_loc9_] - _currentPropArr[_loc9_];
                  this._growLevelArr_three[_loc9_] -= _currentGrowArr[_loc9_];
                  this._propLevelArr_three[_loc9_] = Math.ceil(this._propLevelArr_three[_loc9_] / 10) / 10;
                  this._growLevelArr_three[_loc9_] = Math.ceil(this._growLevelArr_three[_loc9_] / 10) / 10;
                  _loc9_++;
               }
               _loc4_ = this._propLevelArr_three;
               _loc5_ = this._growLevelArr_three;
            }
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
               _itemVector[_loc6_].setData(_loc6_,_loc4_[_loc6_],_loc5_[_loc6_]);
               _loc6_++;
            }
         }
      }
      
      private function getAddedPropArr(param1:int, param2:Array) : Array
      {
         var _loc3_:Array = new Array();
         _loc3_.push(param2[0] * Math.pow(2,param1 - 1));
         var _loc4_:int = 1;
         while(_loc4_ < 5)
         {
            _loc3_.push(param2[_loc4_] * Math.pow(1.5,param1 - 1));
            _loc4_++;
         }
         return _loc3_;
      }
      
      override protected function __enterFrame(param1:Event) : void
      {
         if(!_starMc)
         {
            return;
         }
         if(_starMc.currentFrame == 100)
         {
            _petsBasicInfoView.dispatchEvent(new PetsAdvancedEvent(PetsAdvancedEvent.STARORGRADE_MOVIE_COMPLETE));
            playNumMovie();
            updatePetData();
            this.updateData();
         }
         else if(_starMc.currentFrame >= 110)
         {
            _starMc.stop();
            removeChild(_starMc);
            this.updateView();
            _starMc = null;
            removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
      }
      
      private function updateView() : void
      {
         _petsBasicInfoView.updateStar(_petInfo.StarLevel);
         if(_petInfo.StarLevel < 5)
         {
            this._starBar.starNum(_petInfo.StarLevel + 1);
         }
         else
         {
            ObjectUtils.disposeObject(this._starBar);
            this._starBar = null;
            this._maxStarTxt.visible = true;
         }
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_RISINGSTAR,this.__risingStarHandler);
      }
      
      protected function __risingStarHandler(param1:CrazyTankSocketEvent) : void
      {
         _petInfo = PetBagController.instance().petModel.currentPetInfo;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            _btn.enable = false;
         }
         _bagCell.updateCount();
         _progress.setProgress(_petInfo.currentStarExp,_loc3_);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_RISINGSTAR,this.__risingStarHandler);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._starBar);
         this._starBar = null;
         ObjectUtils.disposeObject(this._maxStarTxt);
         this._maxStarTxt = null;
         ObjectUtils.disposeObject(this._helpTxt1);
         this._helpTxt1 = null;
         ObjectUtils.disposeObject(this._helpTxt2);
         this._helpTxt2 = null;
         ObjectUtils.disposeObject(this._helpTxt3);
         this._helpTxt3 = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
