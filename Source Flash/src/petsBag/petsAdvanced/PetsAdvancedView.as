package petsBag.petsAdvanced
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.event.PetsAdvancedEvent;
   
   public class PetsAdvancedView extends Sprite implements Disposeable
   {
       
      
      protected var _bg:Bitmap;
      
      protected var _petInfo:PetInfo;
      
      protected var _petsBasicInfoView:PetsBasicInfoView;
      
      protected var _viewType:int;
      
      protected var _vBox:VBox;
      
      protected var _itemVector:Vector.<PetsPropItem>;
      
      protected var _btn:SimpleBitmapButton;
      
      protected var _freeBtn:SimpleBitmapButton;
      
      protected var _freeTxt:FilterFrameText;
      
      protected var _allBtn:SelectedCheckButton;
      
      protected var _bagCell:PetsAdvancedCell;
      
      protected var _progress:PetsAdvancedProgressBar;
      
      protected var _starMc:MovieClip;
      
      protected var _gradeMc:MovieClip;
      
      protected var _currentEvolutionExp:int;
      
      protected var _currentPropArr:Array;
      
      protected var _currentGrowArr:Array;
      
      protected var _toLinkTxt:FilterFrameText;
      
      protected var _tip:OneLineTip;
      
      protected var _self:SelfInfo;
      
      private var _clickDate:Number = 0;
      
      public function PetsAdvancedView(param1:int)
      {
         super();
         this._viewType = param1;
         this._petInfo = PetBagController.instance().petModel.currentPetInfo;
         this._itemVector = new Vector.<PetsPropItem>();
         this._self = PlayerManager.Instance.Self;
         this.initView();
         this.initData();
         this.addEvent();
      }
      
      protected function initView() : void
      {
         var _loc2_:PetsPropItem = null;
         if(this._viewType == 1)
         {
            this._bg = ComponentFactory.Instance.creat("petsBag.risingStar.petsBag.bg");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creat("petsBag.evolution.bg");
         }
         addChild(this._bg);
         this._petsBasicInfoView = new PetsBasicInfoView();
         addChild(this._petsBasicInfoView);
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.vBox");
         addChild(this._vBox);
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new PetsPropItem(this._viewType);
            this._itemVector.push(_loc2_);
            this._vBox.addChild(_loc2_);
            _loc1_++;
         }
         this._allBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.allRisingStarBtn");
         addChild(this._allBtn);
         this._allBtn.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.tisingStarTxt");
         this._progress = new PetsAdvancedProgressBar();
         addChild(this._progress);
         this._tip = new OneLineTip();
         this._tip.visible = false;
         addChild(this._tip);
         if(this._viewType == 1)
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.risingStarbtn");
            addChild(this._btn);
            this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.risingStarbtn2");
            addChild(this._freeBtn);
            this._freeTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.risingStarbtn2txt");
            addChild(this._freeTxt);
            PositionUtils.setPos(this._progress,"petsBag.risingStar.progressPos");
            PositionUtils.setPos(this._tip,"petsBag.risingStar.tipPos");
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.evolutionBtn");
            addChild(this._btn);
            this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.evolutionBtn2");
            addChild(this._freeBtn);
            this._freeTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.evolutionBtn2txt");
            addChild(this._freeTxt);
            PositionUtils.setPos(this._allBtn,"petsBag.evolution.allEvolutionBtnPos");
            PositionUtils.setPos(this._progress,"petsBag.evolution.progressPos");
            PositionUtils.setPos(this._tip,"petsBag.evolution.tipPos");
         }
         this._bagCell = new PetsAdvancedCell();
         PositionUtils.setPos(this._bagCell,"petsBag.advaced.petAdvancedCellPos" + this._viewType);
         addChild(this._bagCell);
         this._toLinkTxt = ComponentFactory.Instance.creat("petAndHorse.risingStar.toLinkTxt");
         this._toLinkTxt.mouseEnabled = true;
         this._toLinkTxt.htmlText = LanguageMgr.GetTranslation("petAndHorse.risingStar.toLinkTxtValue");
         PositionUtils.setPos(this._toLinkTxt,"petAndHorse.risingStar.toLinkTxtPos" + this._viewType);
         addChild(this._toLinkTxt);
      }
      
      protected function addEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._freeBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._progress.addEventListener(PetsAdvancedEvent.PROGRESS_MOVIE_COMPLETE,this.__progressMovieHandler);
         this._petsBasicInfoView.addEventListener(PetsAdvancedEvent.ALL_MOVIE_COMPLETE,this.__allComplete);
         this._progress.addEventListener(MouseEvent.ROLL_OVER,this.__showTip);
         this._progress.addEventListener(MouseEvent.ROLL_OUT,this.__hideTip);
         this._toLinkTxt.addEventListener(TextEvent.LINK,this.__toLinkTxtHandler);
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
      
      protected function playNumMovie() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemVector.length)
         {
            this._itemVector[_loc1_].playNumMc();
            _loc1_++;
         }
      }
      
      protected function __allComplete(param1:Event) : void
      {
         if(this._viewType == 1)
         {
            if(this._petInfo.StarLevel < 5)
            {
               this._btn.enable = true;
            }
            else
            {
               this._btn.enable = false;
            }
         }
         else if(this._self.evolutionGrade < PetsAdvancedManager.Instance.evolutionDataList.length)
         {
            this._btn.enable = true;
         }
         else
         {
            this._btn.enable = false;
         }
         PetsAdvancedManager.Instance.isAllMovieComplete = true;
         PetsAdvancedManager.Instance.frame.enableBtn = true;
      }
      
      protected function __progressMovieHandler(param1:PetsAdvancedEvent) : void
      {
         if(this._viewType == 1)
         {
            this._starMc = ComponentFactory.Instance.creat("petsBag.risingStar.starMc");
            addChild(this._starMc);
            PositionUtils.setPos(this._starMc,"petsBag.risingStar.starMcPos" + this._petInfo.StarLevel);
         }
         else
         {
            this._gradeMc = ComponentFactory.Instance.creat("petsBag.evolution.gradeMc");
            this._gradeMc.rotation = 44;
            addChild(this._gradeMc);
            PositionUtils.setPos(this._gradeMc,"petsBag.evolution.gradeMcPos");
         }
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      protected function __enterFrame(param1:Event) : void
      {
      }
      
      protected function __clickHandler(param1:MouseEvent) : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(new Date().time - this._clickDate <= 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         this._clickDate = new Date().time;
         SoundManager.instance.playButtonSound();
         if(this._viewType == 2 && !this._petInfo.IsEquip)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.evolution.cannotEvolutionTxt"));
            return;
         }
         if(this._bagCell.getCount() == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pets.advanced.noPropTxt",this._bagCell.getPropName()));
            return;
         }
         var _loc2_:int = this._bagCell.getExpOfBagcell();
         var _loc3_:int = this._bagCell.getTempleteId();
         if(this._allBtn.selected)
         {
            _loc6_ = Math.ceil((this._progress.max - this._progress.currentExp) / _loc2_);
            _loc4_ = _loc6_ < this._bagCell.getCount() ? int(int(_loc6_)) : int(int(this._bagCell.getCount()));
         }
         else
         {
            _loc4_ = 1;
         }
         var _loc5_:int = this._petInfo.Place;
         if(this._viewType == 1)
         {
            SocketManager.Instance.out.sendPetRisingStar(_loc3_,_loc4_,_loc5_);
         }
         else
         {
            SocketManager.Instance.out.sendPetEvolution(_loc3_,_loc4_);
         }
      }
      
      protected function initData() : void
      {
         this.updatePetData();
      }
      
      protected function updatePetData() : void
      {
         this._currentPropArr = [this._petInfo.Blood * 100,this._petInfo.Attack * 100,this._petInfo.Defence * 100,this._petInfo.Agility * 100,this._petInfo.Luck * 100];
         this._currentGrowArr = [this._petInfo.BloodGrow,this._petInfo.AttackGrow,this._petInfo.DefenceGrow,this._petInfo.AgilityGrow,this._petInfo.LuckGrow];
         this._petsBasicInfoView.setInfo(this._petInfo);
      }
      
      private function __toLinkTxtHandler(param1:TextEvent) : void
      {
         SoundManager.instance.playButtonSound();
         StateManager.setState(StateType.DUNGEON_LIST);
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         this._btn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._freeBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._progress.removeEventListener(PetsAdvancedEvent.PROGRESS_MOVIE_COMPLETE,this.__progressMovieHandler);
         this._petsBasicInfoView.removeEventListener(PetsAdvancedEvent.ALL_MOVIE_COMPLETE,this.__allComplete);
         this._progress.removeEventListener(MouseEvent.ROLL_OVER,this.__showTip);
         this._progress.removeEventListener(MouseEvent.ROLL_OUT,this.__hideTip);
         this._toLinkTxt.removeEventListener(TextEvent.LINK,this.__toLinkTxtHandler);
      }
      
      public function dispose() : void
      {
         var _loc1_:PetsPropItem = null;
         for each(_loc1_ in this._itemVector)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._itemVector = null;
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._petsBasicInfoView);
         this._petsBasicInfoView = null;
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._freeBtn);
         this._freeBtn = null;
         ObjectUtils.disposeObject(this._freeTxt);
         this._freeTxt = null;
         ObjectUtils.disposeObject(this._allBtn);
         this._allBtn = null;
         ObjectUtils.disposeObject(this._tip);
         this._tip = null;
         ObjectUtils.disposeObject(this._bagCell);
         this._bagCell = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._starMc);
         this._starMc = null;
         ObjectUtils.disposeObject(this._gradeMc);
         this._gradeMc = null;
         ObjectUtils.disposeObject(this._toLinkTxt);
         this._toLinkTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
