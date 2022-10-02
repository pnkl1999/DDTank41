package farm.viewx
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.PNGHitAreaFactory;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.player.FarmPlayer;
   import farm.player.vo.PlayerVO;
   import farm.view.compose.event.SelectComposeItemEvent;
   import farm.viewx.helper.FarmHelperView;
   import farm.viewx.shop.FarmShopView;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   import petsBag.view.AdoptPetsGuideView;
   import petsBag.view.AdoptPetsView;
   import trainer.data.ArrowType;
   
   public class FarmMainView extends Sprite implements Disposeable
   {
       
      
      private var _bgSprite:Sprite;
      
      private var _bg:Bitmap;
      
      private var _water:MovieClip;
      
      private var _water1:MovieClip;
      
      private var _waterwheel:MovieClip;
      
      private var _float:MovieClip;
      
      private var _pastureHouseBtn:MovieClip;
      
      private var _pastureHitArea:Sprite;
      
      private var _friendListView:FarmFriendListView;
      
      private var _farmHelperBtn:BaseButton;
      
      private var _farmShopBtn:BaseButton;
      
      private var _doSeedBtn:BaseButton;
      
      private var _doMatureBtn:BaseButton;
      
      private var _goHomeBtn:BaseButton;
      
      private var _buyExpBtn:SimpleBitmapButton;
      
      private var _goTreasureBtn:SimpleButton;
      
      private var _farmShovelBtn:FarmKillCropCell;
      
      private var _arrangeBtn:BaseButton;
      
      private var _fireflyMC1:MovieClip;
      
      private var _fireflyMC2:MovieClip;
      
      private var _fireflyMC3:MovieClip;
      
      private var _startHelperMC:MovieClip;
      
      private var _farmPromptPop:Bitmap;
      
      private var _fieldView:FarmFieldsView;
      
      private var _hostNameBmp:Bitmap;
      
      private var _farmName:FilterFrameText;
      
      private var _newPetPao:Bitmap;
      
      private var _newdragon:Bitmap;
      
      private var _newPetText:FilterFrameText;
      
      private var _buyExpText:FilterFrameText;
      
      private var _buyExpEffect:MovieImage;
      
      private var _selfPlayer:FarmPlayer;
      
      private var _friendPlayer:FarmPlayer;
      
      private var _currentLoadingPlayer:FarmPlayer;
      
      private var _lastClick:Number = 0;
      
      private var _clickInterval:Number = 200;
      
      private var _mouseMovie:MovieClip;
      
      private var _sceneScene:SceneScene;
      
      private var _meshLayer:Sprite;
      
      private var _needMoney:int;
      
      private var _farmBuyExpFrame:FarmBuyExpFrame;
      
      private var _selectedView:ManureOrSeedSelectedView;
      
      private var _farmHelper:FarmHelperView;
      
      private var _farmShop:FarmShopView;
      
      private var _currentFarmHelperFrame:int;
      
      private var _money:int;
      
      private var _outFun:Function;
      
      public function FarmMainView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.farm.mainViewBg");
         this._bgSprite = new Sprite();
         this._bgSprite.addChild(this._bg);
         this.addChild(this._bgSprite);
         this._water = ClassUtils.CreatInstance("asset.farm.water");
         PositionUtils.setPos(this._water,"farm.waterPos");
         this._water1 = ClassUtils.CreatInstance("asset.farm.water1");
         PositionUtils.setPos(this._water1,"farm.waterPos1");
         this._waterwheel = ClassUtils.CreatInstance("asset.farm.waterwheel");
         PositionUtils.setPos(this._waterwheel,"farm.waterwheelPos");
         this._float = ClassUtils.CreatInstance("asset.farm.float");
         PositionUtils.setPos(this._float,"farm.floatPos");
         this._fireflyMC1 = ClassUtils.CreatInstance("asset.farm.fireflyAsset");
         PositionUtils.setPos(this._fireflyMC1,"farm.fireflyPos1");
         this._fireflyMC2 = ClassUtils.CreatInstance("asset.farm.fireflyAsset");
         PositionUtils.setPos(this._fireflyMC2,"farm.fireflyPos2");
         this._fireflyMC3 = ClassUtils.CreatInstance("asset.farm.fireflyAsset");
         PositionUtils.setPos(this._fireflyMC3,"farm.fireflyPos3");
         this._water.mouseEnabled = this._water.mouseChildren = this._waterwheel.mouseEnabled = this._waterwheel.mouseChildren = this._float.mouseEnabled = this._float.mouseChildren = this._fireflyMC1.mouseEnabled = this._fireflyMC1.mouseChildren = this._fireflyMC2.mouseEnabled = this._fireflyMC2.mouseChildren = this._fireflyMC3.mouseEnabled = this._fireflyMC3.mouseChildren = this._water1.mouseEnabled = this._water1.mouseChildren = false;
         addChild(this._water);
         addChild(this._water1);
         addChild(this._waterwheel);
         addChild(this._float);
         addChild(this._fireflyMC1);
         addChild(this._fireflyMC2);
         addChild(this._fireflyMC3);
         this._meshLayer = ComponentFactory.Instance.creat("asset.farm.zone") as Sprite;
         this._meshLayer.alpha = 0;
         addChild(this._meshLayer);
         this._fieldView = new FarmFieldsView();
         PositionUtils.setPos(this._fieldView,"farm.fieldsView");
         addChild(this._fieldView);
         this._pastureHouseBtn = ClassUtils.CreatInstance("asset.farm.pastureBtn");
         PositionUtils.setPos(this._pastureHouseBtn,"farm.pasturehousebtnPos");
         this._pastureHouseBtn.mouseChildren = false;
         this._pastureHouseBtn.mouseEnabled = false;
         this._pastureHouseBtn.gotoAndStop(1);
         addChild(this._pastureHouseBtn);
         this._pastureHitArea = PNGHitAreaFactory.drawHitArea(DisplayUtils.getDisplayBitmapData(this._pastureHouseBtn));
         this._pastureHouseBtn.hitArea = this._pastureHitArea;
         this._pastureHitArea.alpha = 0;
         this._pastureHitArea.x = this._pastureHouseBtn.x;
         this._pastureHitArea.y = this._pastureHouseBtn.y;
         this._pastureHitArea.buttonMode = true;
         this.initToolBtn();
         this._hostNameBmp = ComponentFactory.Instance.creatBitmap("asset.farm.fieldHostName");
         this._hostNameBmp.x = (StageReferance.stageWidth - this._hostNameBmp.width) / 2;
         addChild(this._hostNameBmp);
         this._farmName = ComponentFactory.Instance.creatComponentByStylename("farm.mainView.hostName");
         addChild(this._farmName);
         this._farmName.text = FarmModelController.instance.model.currentFarmerName;
         this._friendListView = new FarmFriendListView();
         PositionUtils.setPos(this._friendListView,"farm.friendListViewPos");
         this.petFarmGuilde();
         this._startHelperMC = ClassUtils.CreatInstance("assets.farm.startHelper.mc") as MovieClip;
         this._startHelperMC.visible = false;
         PositionUtils.setPos(this._startHelperMC,"farm.helper.startHelper.mc.Pos");
         addChild(this._startHelperMC);
         addChild(this._pastureHitArea);
         if(ServerConfigManager.instance.petScoreEnable)
         {
            this._farmPromptPop = ComponentFactory.Instance.creatBitmap("assets.farmShop.promptPop");
            addChild(this._farmPromptPop);
         }
         addChild(this._friendListView);
         this.checkHelper();
         if(FarmModelController.instance.midAutumnFlag)
         {
            this.addSelfPlayer();
         }
      }
      
      public function addSelfPlayer() : void
      {
         var _loc2_:PlayerVO = null;
         var _loc1_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.farm.MouseClickMovie") as Class;
         this._mouseMovie = new _loc1_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         addChild(this._mouseMovie);
         this._sceneScene = new SceneScene();
         this._sceneScene.setHitTester(new PathMapHitTester(this._meshLayer));
         if(!this._selfPlayer)
         {
            _loc2_ = new PlayerVO();
            _loc2_.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new FarmPlayer(_loc2_,this.addPlayerCallBack);
         }
      }
      
      private function addPlayerCallBack(param1:FarmPlayer, param2:Boolean, param3:int) : void
      {
         if(param3 == 0)
         {
            if(!param1)
            {
               return;
            }
            this._currentLoadingPlayer = null;
            param1.sceneScene = this._sceneScene;
            param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = param1.playerVO.scenePlayerDirection;
            if(!this._selfPlayer && param1.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               this._selfPlayer = param1;
               addChild(this._selfPlayer);
               this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            }
            else
            {
               this._friendPlayer = param1;
               addChild(param1);
            }
            param1.playerPoint = new Point(200,300);
            param1.sceneCharacterStateType = "natural";
            addEventListener(Event.ENTER_FRAME,this.__updateFrame);
         }
      }
      
      protected function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
         }
      }
      
      protected function __onPlayerClick(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         if(this._selfPlayer)
         {
            _loc2_ = this.globalToLocal(new Point(param1.stageX,param1.stageY));
            if(getTimer() - this._lastClick > this._clickInterval)
            {
               this._lastClick = getTimer();
               if(!this._sceneScene.hit(_loc2_))
               {
                  this._mouseMovie.x = _loc2_.x;
                  this._mouseMovie.y = _loc2_.y;
                  this._mouseMovie.play();
                  this._selfPlayer.playerVO.walkPath = this._sceneScene.searchPath(this._selfPlayer.playerPoint,_loc2_);
                  this._selfPlayer.playerVO.walkPath.shift();
                  this._selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this._selfPlayer.playerPoint,this._selfPlayer.playerVO.walkPath[0]);
                  this._selfPlayer.playerVO.currentWalkStartPoint = this._selfPlayer.currentWalkStartPoint;
               }
            }
         }
      }
      
      protected function __updateFrame(param1:Event) : void
      {
         if(this._selfPlayer)
         {
            this._selfPlayer.updatePlayer();
         }
         if(this._friendPlayer)
         {
            this._friendPlayer.updatePlayer();
         }
      }
      
      private function dargonPetShow() : void
      {
         this._newPetPao = ComponentFactory.Instance.creatBitmap("assets.farm.newPetPao");
         addChild(this._newPetPao);
         this._newdragon = ComponentFactory.Instance.creatBitmap("assets.farm.newdragon");
         addChild(this._newdragon);
         this._newPetText = ComponentFactory.Instance.creatComponentByStylename("confirmHelperMoneyAlertFrame.newPetComesTxt");
         this._newPetText.htmlText = LanguageMgr.GetTranslation("ddt.farms.newPetsComew");
         addChild(this._newPetText);
      }
      
      private function set newPetShowVisble(param1:Boolean) : void
      {
         this._newPetPao.visible = param1;
         this._newdragon.visible = param1;
         this._newPetText.visible = param1;
      }
      
      private function checkHelper() : void
      {
         if(PlayerManager.Instance.Self.isFarmHelper && PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
         {
            this._fieldView.setFieldByHelper();
            this.setVisibleByAuto(false);
            if(this._farmHelper == null)
            {
               this._farmHelper = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperView.helper");
               this._farmHelper.show();
            }
         }
      }
      
      private function setVisibleByAuto(param1:Boolean = true) : void
      {
         if(this._farmShopBtn)
         {
            this._farmShopBtn.enable = param1;
         }
         if(this._doSeedBtn)
         {
            this._doSeedBtn.enable = param1;
         }
         if(this._doMatureBtn)
         {
            this._doMatureBtn.enable = param1;
         }
         if(this._farmShovelBtn)
         {
            this._farmShovelBtn.setBtnVis(param1);
         }
         if(this._startHelperMC)
         {
            this._startHelperMC.visible = !param1;
         }
      }
      
      private function __setVisible(param1:FarmEvent) : void
      {
         this.setVisibleByAuto(false);
      }
      
      private function __setVisibleFal(param1:FarmEvent) : void
      {
         this.setVisibleByAuto(true);
      }
      
      private function petFarmGuilde() : void
      {
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.OPEN_ADOPT_PET,-150,"farmTrainer.openAdoptPetArrowPos","asset.farmTrainer.clickHere","farmTrainer.openAdoptPetTipPos",this);
         }
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
         {
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.CLICK_SEEDING_BTN,-60,"farmTrainer.seedArrowPos","asset.farmTrainer.seed","farmTrainer.seedTipPos",this);
         }
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.GRAIN_IN_FRAME);
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.GAINS,-50,"farmTrainer.grainArrowPos","asset.farmTrainer.grain2","farmTrainer.grainFieldTipPos",this);
         }
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK6) && SharedManager.Instance.stoneFriend)
         {
            SharedManager.Instance.stoneFriend = false;
            SharedManager.Instance.save();
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.OPEN_IM,-150,"farmTrainer.openFriendsArrowPos","asset.farmTrainer.openFriends","farmTrainer.openFriendsTipPos",this);
         }
      }
      
      private function petFarmGuildeClear() : void
      {
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_ADOPT_PET);
         }
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CLICK_SEEDING_BTN);
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CLICK_SEEDING_BTN);
         }
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.GAINS);
         }
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK6))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_IM);
         }
      }
      
      protected function initToolBtn() : void
      {
         this._farmHelperBtn = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperBtn");
         addChild(this._farmHelperBtn);
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
         this._farmShopBtn = ComponentFactory.Instance.creatComponentByStylename("farm.farmShopBtn");
         addChild(this._farmShopBtn);
         this._doSeedBtn = ComponentFactory.Instance.creatComponentByStylename("farm.doSeedBtn");
         addChild(this._doSeedBtn);
         this._doMatureBtn = ComponentFactory.Instance.creatComponentByStylename("farm.doMatureBtn");
         addChild(this._doMatureBtn);
         this._goHomeBtn = ComponentFactory.Instance.creatComponentByStylename("farm.gohomeBtn");
         addChild(this._goHomeBtn);
         this._farmShovelBtn = new FarmKillCropCell();
         addChild(this._farmShovelBtn);
         PositionUtils.setPos(this._farmShovelBtn,"farm.farmShovelBtn");
         this._goHomeBtn.visible = false;
         this._farmShovelBtn.visible = true;
      }
      
      private function initEvent() : void
      {
         this._farmHelperBtn.addEventListener(MouseEvent.ROLL_OVER,this.__farmHelperOver);
         this._farmHelperBtn.addEventListener(MouseEvent.ROLL_OUT,this.__farmHelperOut);
         this._farmHelperBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.__farmHelperDown);
         this._farmHelperBtn.addEventListener(MouseEvent.CLICK,this.__showHelper);
         this._doSeedBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__doSeedOver);
         this._doSeedBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__doSeedOut);
         this._doMatureBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__doMatureOver);
         this._doMatureBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__doMatureOut);
         this._farmShopBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__farmShopOver);
         this._farmShopBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__farmShopOut);
         this._goHomeBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__goHomeOver);
         this._goHomeBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__goHomeOut);
         if(this._goTreasureBtn)
         {
            this._goTreasureBtn.addEventListener(MouseEvent.CLICK,this.__goTreasureBtn);
         }
         this._doSeedBtn.addEventListener(MouseEvent.CLICK,this.__onSelectedBtnClick);
         this._doMatureBtn.addEventListener(MouseEvent.CLICK,this.__onFastForwardSelectedBtnClick);
         this._farmShopBtn.addEventListener(MouseEvent.CLICK,this.__showShop);
         this._pastureHitArea.addEventListener(MouseEvent.CLICK,this.__pastureHouse);
         this._pastureHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.__pastureOver);
         this._pastureHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.__pastureOut);
         this._goHomeBtn.addEventListener(MouseEvent.CLICK,this.__goHomeHandler);
         FarmModelController.instance.addEventListener(FarmEvent.FIELDS_INFO_READY,this.__enterFram);
         PetBagController.instance().addEventListener(UpdatePetFarmGuildeEvent.FINISH,this.__updatePetFarmGuilde);
         this._fieldView.addEventListener(SelectComposeItemEvent.KILLCROP_ICON,this.__killcrop_iconShow);
         FarmModelController.instance.addEventListener(FarmEvent.BEGIN_HELPER,this.__setVisible);
         FarmModelController.instance.addEventListener(FarmEvent.STOP_HELPER,this.__setVisibleFal);
         FarmModelController.instance.addEventListener(FarmEvent.LOADER_SUPER_PET_FOOD_PRICET_LIST,this.__priectListLoadComplete);
         FarmModelController.instance.addEventListener(FarmEvent.UPDATE_BUY_EXP_REMAIN_NUM,this.__updateNum);
         FarmModelController.instance.addEventListener(FarmEvent.ARRANGE_FRIEND_FARM,this.__arrangeBackHandler);
         this._bgSprite.addEventListener(MouseEvent.CLICK,this.__onPlayerClick);
         this.addFieldBlockEvent();
      }
      
      private function __goTreasureBtn(param1:MouseEvent) : void
      {
      }
      
      private function __arrangeBackHandler(param1:FarmEvent) : void
      {
         this._arrangeBtn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
         this._arrangeBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__arrangeOver);
         this._arrangeBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__arrangeOut);
         this._arrangeBtn.removeEventListener(MouseEvent.CLICK,this.__arrangeHandler);
         this._arrangeBtn.filterString = "grayFilter,grayFilter,grayFilter,grayFilter";
         this._arrangeBtn.tipGapH = 100;
         this._arrangeBtn.tipStyle = "ddt.view.tips.OneLineTip";
         if(FarmModelController.instance.model.isArrange)
         {
            this._arrangeBtn.tipData = LanguageMgr.GetTranslation("ddt.farm.arrange.tips");
         }
         else
         {
            this._arrangeBtn.tipData = LanguageMgr.GetTranslation("ddt.farm.arrange2");
         }
      }
      
      private function addFieldBlockEvent() : void
      {
         var _loc1_:int = this._fieldView.fields.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._fieldView.fields[_loc2_].addEventListener(FarmEvent.FIELDBLOCK_CLICK,this.__onFieldBlockClick);
            _loc2_++;
         }
      }
      
      protected function __onFieldBlockClick(param1:FarmEvent) : void
      {
         var _loc3_:Point = null;
         if(FarmModelController.instance.model.helperArray[0] || FarmModelController.instance.model.currentFarmerId != PlayerManager.Instance.Self.ID)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this._selectedView == null)
         {
            this._selectedView = new ManureOrSeedSelectedView();
            addChild(this._selectedView);
         }
         var _loc2_:int = this._fieldView.fields.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(param1.currentTarget == this._fieldView.fields[_loc4_])
            {
               _loc3_ = PositionUtils.creatPoint("farm.fieldsView.fieldPos" + _loc4_);
            }
            _loc4_++;
         }
         var _loc5_:Point = PositionUtils.creatPoint("assets.farm.filedbolckRect");
         var _loc6_:Number = this._selectedView.height / this._selectedView.width;
         this._selectedView.width = _loc5_.x;
         this._selectedView.height = _loc6_ * this._selectedView.width;
         this._selectedView.x = _loc3_.x + this._fieldView.x;
         if(this._selectedView.x + this._selectedView.width > StageReferance.stageWidth - 90)
         {
            this._selectedView.x = StageReferance.stageWidth - this._selectedView.width - 90;
         }
         this._selectedView.y = _loc3_.y + this._fieldView.y - this._selectedView.height;
         this._selectedView.viewType = ManureOrSeedSelectedView.SEED;
      }
      
      protected function __updateNum(param1:FarmEvent) : void
      {
         if(FarmModelController.instance.model.buyExpRemainNum > 0)
         {
            if(this._buyExpText)
            {
               this._buyExpText.text = FarmModelController.instance.model.buyExpRemainNum.toString();
            }
         }
         else
         {
            this._buyExpBtn.visible = false;
            this._buyExpText.visible = false;
            this._buyExpEffect.visible = false;
         }
      }
      
      protected function __priectListLoadComplete(param1:Event) : void
      {
         this._buyExpBtn = UICreatShortcut.creatAndAdd("Farm.FarmMainView.buyExpBtn",this);
         this._buyExpText = UICreatShortcut.creatTextAndAdd("Farm.FarmMainView.buyExpNumText","",this);
         this._buyExpText.text = FarmModelController.instance.model.buyExpRemainNum.toString();
         this._buyExpEffect = UICreatShortcut.creatAndAdd("Farm.FarmMainView.buyExpBtnEffect",this);
         this._buyExpBtn.addEventListener(MouseEvent.CLICK,this.__onBuyExpClick);
         if(FarmModelController.instance.model.buyExpRemainNum <= 0)
         {
            this._buyExpBtn.visible = false;
            this._buyExpText.visible = false;
            this._buyExpEffect.visible = false;
         }
         FarmModelController.instance.removeEventListener(FarmEvent.LOADER_SUPER_PET_FOOD_PRICET_LIST,this.__priectListLoadComplete);
      }
      
      protected function __onBuyExpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._farmBuyExpFrame = ComponentFactory.Instance.creatComponentByStylename("farm.viewx.farmBuyExpFrame");
         this._farmBuyExpFrame.show();
         this._farmBuyExpFrame.addEventListener(FrameEvent.RESPONSE,this.__BuyExpFrameResponse);
      }
      
      protected function __BuyExpFrameResponse(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.playButtonSound();
            if(this._farmBuyExpFrame)
            {
               this._farmBuyExpFrame.removeEventListener(FrameEvent.RESPONSE,this.__BuyExpFrameResponse);
            }
            ObjectUtils.disposeObject(this._farmBuyExpFrame);
            this._farmBuyExpFrame = null;
         }
      }
      
      private function __doSeedOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __doSeedOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __doMatureOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __doMatureOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __farmShopOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __farmShopOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __goHomeOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __goHomeOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __arrangeOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __arrangeOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __updatePetFarmGuilde(param1:UpdatePetFarmGuildeEvent) : void
      {
         PetBagController.instance().finishTask();
         this.petFarmGuilde();
      }
      
      private function __killcrop_iconShow(param1:SelectComposeItemEvent) : void
      {
         this._farmShovelBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      protected function __pastureOut(param1:MouseEvent) : void
      {
         this._pastureHouseBtn.gotoAndStop(1);
      }
      
      protected function __pastureOver(param1:MouseEvent) : void
      {
         this._pastureHouseBtn.gotoAndStop(2);
      }
      
      private function setFarmPlayerInfo() : void
      {
         if(this._friendPlayer)
         {
            this._friendPlayer.dispose();
            this._friendPlayer = null;
         }
         this.deleteSelfPlayer();
         this.addSelfPlayer();
      }
      
      protected function __enterFram(param1:FarmEvent) : void
      {
         var _loc2_:PlayerVO = null;
         if(FarmModelController.instance.midAutumnFlag)
         {
            this.setFarmPlayerInfo();
         }
         if(this._arrangeBtn && this._arrangeBtn.hasEventListener(MouseEvent.CLICK))
         {
            this._arrangeBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__arrangeOver);
            this._arrangeBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__arrangeOut);
            this._arrangeBtn.removeEventListener(MouseEvent.CLICK,this.__arrangeHandler);
         }
         if(PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
         {
            if(PlayerManager.Instance.Self.isFarmHelper)
            {
               this.setVisibleByAuto(false);
            }
            else
            {
               this.setVisibleByAuto(true);
            }
         }
         else if(this._arrangeBtn && !FarmModelController.instance.model.isArrange)
         {
            this._arrangeBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__arrangeOver);
            this._arrangeBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__arrangeOut);
            this._arrangeBtn.addEventListener(MouseEvent.CLICK,this.__arrangeHandler);
         }
         this._farmName.text = FarmModelController.instance.model.currentFarmerName;
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            this.petFarmGuilde();
            this._pastureHitArea.buttonMode = this._pastureHitArea.mouseEnabled = this._pastureHitArea.mouseChildren = true;
            this._farmShopBtn.visible = this._doSeedBtn.visible = this._doMatureBtn.visible = true;
            this._goHomeBtn.visible = false;
            if(this._arrangeBtn)
            {
               this._arrangeBtn.visible = false;
               this._arrangeBtn.tipStyle = null;
            }
            this._farmShovelBtn.visible = true;
            this._farmHelperBtn.visible = true;
            if(this._goTreasureBtn)
            {
               this._goTreasureBtn.visible = true;
            }
            if(FarmModelController.instance.model.buyExpRemainNum > 0)
            {
               this._buyExpBtn.visible = true;
               this._buyExpText.visible = true;
               this._buyExpEffect.visible = true;
            }
            if(PlayerManager.Instance.Self.isFarmHelper)
            {
               if(this._startHelperMC)
               {
                  this._startHelperMC.visible = true;
               }
            }
         }
         else
         {
            this.petFarmGuildeClear();
            this._pastureHitArea.buttonMode = this._pastureHitArea.mouseEnabled = this._pastureHitArea.mouseChildren = false;
            this._farmShopBtn.visible = this._doSeedBtn.visible = this._doMatureBtn.visible = false;
            this._goHomeBtn.visible = true;
            if(this._arrangeBtn)
            {
               this._arrangeBtn.visible = true;
            }
            if(this._arrangeBtn)
            {
               if(FarmModelController.instance.model.isArrange)
               {
                  this._arrangeBtn.filterString = "grayFilter,grayFilter,grayFilter,grayFilter";
                  this._arrangeBtn.tipData = LanguageMgr.GetTranslation("ddt.farm.arrange.tips");
                  this._arrangeBtn.tipStyle = "ddt.view.tips.OneLineTip";
                  this._arrangeBtn.tipGapH = 100;
               }
               else
               {
                  this._arrangeBtn.filterString = "null,lightFilter,null,grayFilter";
                  this._arrangeBtn.tipGapH = -222;
                  this._arrangeBtn.tipStyle = null;
               }
            }
            if(this._goTreasureBtn)
            {
               this._goTreasureBtn.visible = false;
            }
            this._farmShovelBtn.visible = false;
            this._farmHelperBtn.visible = false;
            this._buyExpBtn.visible = false;
            this._buyExpText.visible = false;
            this._buyExpEffect.visible = false;
            if(this._startHelperMC)
            {
               this._startHelperMC.visible = false;
            }
            if(this._selectedView)
            {
               this._selectedView.visible = false;
            }
            if(FarmModelController.instance.midAutumnFlag)
            {
               _loc2_ = new PlayerVO();
               _loc2_.playerInfo = PlayerManager.Instance.findPlayer(FarmModelController.instance.model.currentFarmerId);
               this._currentLoadingPlayer = new FarmPlayer(_loc2_,this.addPlayerCallBack);
               this._currentLoadingPlayer.isChatBall = true;
               this._selfPlayer.playerPoint = new Point(356,430);
               this._selfPlayer.sceneCharacterDirection = SceneCharacterDirection.LB;
            }
         }
      }
      
      private function __goHomeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
         PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.SHOW_STEAL);
      }
      
      private function __arrangeHandler(param1:MouseEvent) : void
      {
         if(!FarmModelController.instance.model.isArrange)
         {
            SoundManager.instance.play("008");
            FarmModelController.instance.arrange();
         }
      }
      
      private function __onSelectedBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedView != null)
         {
            this._selectedView.dispose();
            this._selectedView = null;
         }
         this._selectedView = new ManureOrSeedSelectedView();
         addChild(this._selectedView);
         PositionUtils.setPos(this._selectedView,"farm.seedSelectViewPos");
         switch(param1.currentTarget)
         {
            case this._doSeedBtn:
               this._selectedView.viewType = ManureOrSeedSelectedView.SEED;
               break;
            case this._doMatureBtn:
         }
      }
      
      private function __onFastForwardSelectedBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._needMoney = FarmModelController.instance.gropPrice * this.ripeNum();
         if(this._needMoney == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farms.noFastForwardInfo"));
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.farms.fastForwardAllInfo",this._needMoney),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      protected function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Boolean = (param1.target as BaseAlerFrame).isBand;
         (param1.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         (param1.target as BaseAlerFrame).dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(this.checkMoney(_loc2_,this._needMoney))
            {
               return;
            }
            SocketManager.Instance.out.fastForwardGrop(_loc2_,true,-1);
         }
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
      
      private function ripeNum() : int
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] && _loc2_[_loc3_].seedID != 0 && _loc2_[_loc3_].realNeedTime > 0)
            {
               _loc1_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function __showHelper(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._selectedView)
         {
            this._selectedView.visible = false;
         }
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
         this._farmHelper = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperView.helper");
         this._farmHelper.show();
         this._farmHelper.addEventListener(FrameEvent.RESPONSE,this.__closeHelperView);
      }
      
      private function __closeHelperView(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._farmHelper.removeEventListener(FrameEvent.RESPONSE,this.__closeHelperView);
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
         }
      }
      
      private function __showShop(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._farmShop = ComponentFactory.Instance.creatComponentByStylename("farm.farmShopView.shop");
         this._farmShop.addEventListener(FrameEvent.RESPONSE,this.__closeFarmShop);
         this._farmShop.show();
      }
      
      private function __closeFarmShop(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._farmShop.removeEventListener(FrameEvent.RESPONSE,this.__closeFarmShop);
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               ObjectUtils.disposeObject(this._farmShop);
               this._farmShop = null;
         }
      }
      
      private function __pastureHouse(param1:MouseEvent) : void
      {
         var _loc2_:AdoptPetsGuideView = null;
         var _loc3_:AdoptPetsView = null;
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            SoundManager.instance.play("008");
            if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK1))
            {
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("farm.adoptPetsView.adoptGuide");
               _loc2_.show();
            }
            else
            {
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("farm.adoptPetsView.adopt");
               _loc3_.show();
               _loc3_.x = 170;
            }
         }
      }
      
      private function __farmHelperOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
      }
      
      private function __farmHelperOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
      }
      
      private function __farmHelperDown(param1:MouseEvent) : void
      {
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
      }
      
      private function removeEvent() : void
      {
         this._farmHelperBtn.removeEventListener(MouseEvent.ROLL_OVER,this.__farmHelperOver);
         this._farmHelperBtn.removeEventListener(MouseEvent.ROLL_OUT,this.__farmHelperOut);
         this._farmHelperBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.__farmHelperDown);
         this._farmHelperBtn.removeEventListener(MouseEvent.CLICK,this.__showHelper);
         this._doSeedBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__doSeedOver);
         this._doSeedBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__doSeedOut);
         this._doMatureBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__doMatureOver);
         this._doMatureBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__doMatureOut);
         this._farmShopBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__farmShopOver);
         this._farmShopBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__farmShopOut);
         this._goHomeBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__goHomeOver);
         this._goHomeBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__goHomeOut);
         if(this._goTreasureBtn)
         {
            this._goTreasureBtn.removeEventListener(MouseEvent.CLICK,this.__goTreasureBtn);
         }
         if(this._arrangeBtn && this._arrangeBtn.hasEventListener(MouseEvent.CLICK))
         {
            this._arrangeBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__arrangeOver);
            this._arrangeBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__arrangeOut);
            this._arrangeBtn.removeEventListener(MouseEvent.CLICK,this.__arrangeHandler);
         }
         this._doSeedBtn.removeEventListener(MouseEvent.CLICK,this.__onSelectedBtnClick);
         this._doMatureBtn.removeEventListener(MouseEvent.CLICK,this.__onFastForwardSelectedBtnClick);
         this._farmShopBtn.removeEventListener(MouseEvent.CLICK,this.__showShop);
         this._pastureHitArea.removeEventListener(MouseEvent.CLICK,this.__pastureHouse);
         this._pastureHitArea.removeEventListener(MouseEvent.MOUSE_OVER,this.__pastureOver);
         this._pastureHitArea.removeEventListener(MouseEvent.MOUSE_OUT,this.__pastureOut);
         this._goHomeBtn.removeEventListener(MouseEvent.CLICK,this.__goHomeHandler);
         if(this._buyExpBtn)
         {
            this._buyExpBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyExpClick);
         }
         FarmModelController.instance.removeEventListener(FarmEvent.FIELDS_INFO_READY,this.__enterFram);
         PetBagController.instance().removeEventListener(UpdatePetFarmGuildeEvent.FINISH,this.__updatePetFarmGuilde);
         this._fieldView.removeEventListener(SelectComposeItemEvent.KILLCROP_ICON,this.__killcrop_iconShow);
         FarmModelController.instance.removeEventListener(FarmEvent.BEGIN_HELPER,this.__setVisible);
         FarmModelController.instance.removeEventListener(FarmEvent.STOP_HELPER,this.__setVisibleFal);
         FarmModelController.instance.removeEventListener(FarmEvent.LOADER_SUPER_PET_FOOD_PRICET_LIST,this.__priectListLoadComplete);
         FarmModelController.instance.removeEventListener(FarmEvent.UPDATE_BUY_EXP_REMAIN_NUM,this.__updateNum);
         FarmModelController.instance.removeEventListener(FarmEvent.ARRANGE_FRIEND_FARM,this.__arrangeBackHandler);
         this.removeFieldBolckEvent();
      }
      
      private function removeFieldBolckEvent() : void
      {
         var _loc1_:int = this._fieldView.fields.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._fieldView.fields[_loc2_].removeEventListener(FarmEvent.FIELDBLOCK_CLICK,this.__onFieldBlockClick);
            _loc2_++;
         }
      }
      
      private function deleteSelfPlayer() : void
      {
         if(this._selfPlayer)
         {
            this._selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            removeEventListener(Event.ENTER_FRAME,this.__updateFrame);
            this._selfPlayer.dispose();
            this._selfPlayer = null;
         }
         if(this._sceneScene)
         {
            this._sceneScene.dispose();
            this._sceneScene = null;
         }
         ObjectUtils.disposeObject(this._mouseMovie);
         this._mouseMovie = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._water)
         {
            ObjectUtils.disposeObject(this._water);
         }
         this._water = null;
         if(this._water1)
         {
            ObjectUtils.disposeObject(this._water1);
         }
         this._water1 = null;
         if(this._waterwheel)
         {
            ObjectUtils.disposeObject(this._waterwheel);
         }
         this._waterwheel = null;
         if(this._float)
         {
            ObjectUtils.disposeObject(this._float);
         }
         this._float = null;
         if(this._farmPromptPop)
         {
            ObjectUtils.disposeObject(this._farmPromptPop);
         }
         this._farmPromptPop = null;
         if(this._pastureHouseBtn)
         {
            ObjectUtils.disposeObject(this._pastureHouseBtn);
         }
         this._pastureHouseBtn = null;
         if(this._pastureHitArea)
         {
            ObjectUtils.disposeObject(this._pastureHitArea);
         }
         this._pastureHitArea = null;
         if(this._friendListView)
         {
            ObjectUtils.disposeObject(this._friendListView);
         }
         this._friendListView = null;
         if(this._farmHelperBtn)
         {
            ObjectUtils.disposeObject(this._farmHelperBtn);
         }
         this._farmHelperBtn = null;
         if(this._farmShopBtn)
         {
            ObjectUtils.disposeObject(this._farmShopBtn);
         }
         this._farmShopBtn = null;
         if(this._doSeedBtn)
         {
            ObjectUtils.disposeObject(this._doSeedBtn);
         }
         this._doSeedBtn = null;
         if(this._doMatureBtn)
         {
            ObjectUtils.disposeObject(this._doMatureBtn);
         }
         this._doMatureBtn = null;
         if(this._goHomeBtn)
         {
            ObjectUtils.disposeObject(this._goHomeBtn);
         }
         this._goHomeBtn = null;
         if(this._arrangeBtn)
         {
            ObjectUtils.disposeObject(this._arrangeBtn);
         }
         this._arrangeBtn = null;
         if(this._fireflyMC1)
         {
            ObjectUtils.disposeObject(this._fireflyMC1);
         }
         this._fireflyMC1 = null;
         if(this._fireflyMC2)
         {
            ObjectUtils.disposeObject(this._fireflyMC2);
         }
         this._fireflyMC2 = null;
         if(this._fireflyMC3)
         {
            ObjectUtils.disposeObject(this._fireflyMC3);
         }
         this._fireflyMC3 = null;
         if(this._fieldView)
         {
            ObjectUtils.disposeObject(this._fieldView);
         }
         this._fieldView = null;
         if(this._startHelperMC)
         {
            ObjectUtils.disposeObject(this._startHelperMC);
         }
         this._startHelperMC = null;
         if(this._hostNameBmp)
         {
            ObjectUtils.disposeObject(this._hostNameBmp);
         }
         this._hostNameBmp = null;
         if(this._farmName)
         {
            ObjectUtils.disposeObject(this._farmName);
         }
         this._farmName = null;
         if(this._selectedView)
         {
            ObjectUtils.disposeObject(this._selectedView);
         }
         this._selectedView = null;
         if(this._farmShovelBtn)
         {
            this._farmShovelBtn.dispose();
         }
         this._farmShovelBtn = null;
         if(this._newPetPao)
         {
            ObjectUtils.disposeObject(this._newPetPao);
         }
         this._newPetPao = null;
         if(this._newdragon)
         {
            ObjectUtils.disposeObject(this._newdragon);
         }
         this._newdragon = null;
         if(this._newPetText)
         {
            ObjectUtils.disposeObject(this._newPetText);
         }
         this._newPetText = null;
         if(this._goTreasureBtn)
         {
            ObjectUtils.disposeObject(this._goTreasureBtn);
         }
         this._goTreasureBtn = null;
         if(this._farmBuyExpFrame)
         {
            this._farmBuyExpFrame.removeEventListener(FrameEvent.RESPONSE,this.__BuyExpFrameResponse);
         }
         ObjectUtils.disposeObject(this._buyExpText);
         this._buyExpText = null;
         ObjectUtils.disposeObject(this._buyExpEffect);
         this._buyExpEffect = null;
         ObjectUtils.disposeObject(this._buyExpBtn);
         this._buyExpBtn = null;
         ObjectUtils.disposeObject(this._farmBuyExpFrame);
         this._farmBuyExpFrame = null;
         if(this._bgSprite)
         {
            this._bgSprite.removeEventListener(MouseEvent.CLICK,this.__onPlayerClick);
            ObjectUtils.disposeObject(this._bgSprite);
            this._bgSprite = null;
         }
         this.deleteSelfPlayer();
         if(this._meshLayer)
         {
            ObjectUtils.disposeObject(this._meshLayer);
         }
         this._meshLayer = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
