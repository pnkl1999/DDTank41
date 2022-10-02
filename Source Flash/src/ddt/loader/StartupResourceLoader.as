package ddt.loader
{
   import accumulativeLogin.AccumulativeLoginAnalyer;
   import accumulativeLogin.AccumulativeManager;
   import calendar.CalendarManager;
   import cardSystem.CardControl;
   import cardSystem.analyze.CardPropIncreaseRuleAnalyzer;
   import cardSystem.analyze.SetsPropertiesAnalyzer;
   import cardSystem.analyze.SetsSortRuleAnalyzer;
   import cardSystem.analyze.UpgradeRuleAnalyzer;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.loader.TextLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.analyze.ConsortionListAnalyzer;
   import consortion.analyze.ConsortionMemberAnalyer;
   import ddt.data.Experience;
   import ddt.data.GoodsAdditioner;
   import ddt.data.PetExperience;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.BadgeInfoAnalyzer;
   import ddt.data.analyze.BallInfoAnalyzer;
   import ddt.data.analyze.BoxTempInfoAnalyzer;
   import ddt.data.analyze.DailyLeagueAwardAnalyzer;
   import ddt.data.analyze.DailyLeagueLevelAnalyzer;
   import ddt.data.analyze.DaylyGiveAnalyzer;
   import ddt.data.analyze.DungeonAnalyzer;
   import ddt.data.analyze.EffortItemTemplateInfoAnalyzer;
   import ddt.data.analyze.EquipSuitTempleteAnalyzer;
   import ddt.data.analyze.ExpericenceAnalyze;
   import ddt.data.analyze.FilterWordAnalyzer;
   import ddt.data.analyze.FriendListAnalyzer;
   import ddt.data.analyze.GoodCategoryAnalyzer;
   import ddt.data.analyze.GoodsAdditionAnalyer;
   import ddt.data.analyze.ItemTempleteAnalyzer;
   import ddt.data.analyze.LanguageAnalyzer;
   import ddt.data.analyze.LoginSelectListAnalyzer;
   import ddt.data.analyze.MapAnalyzer;
   import ddt.data.analyze.MovingNotificationAnalyzer;
   import ddt.data.analyze.MyAcademyPlayersAnalyze;
   import ddt.data.analyze.PetExpericenceAnalyze;
   import ddt.data.analyze.PetInfoAnalyzer;
   import ddt.data.analyze.PetMoePropertyAnalyzer;
   import ddt.data.analyze.PetSkillAnalyzer;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.analyze.QuestListAnalyzer;
   import ddt.data.analyze.QuestionInfoAnalyze;
   import ddt.data.analyze.RegisterAnalyzer;
   import ddt.data.analyze.ServerConfigAnalyz;
   import ddt.data.analyze.ServerListAnalyzer;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.data.analyze.ShopItemDisCountAnalyzer;
   import ddt.data.analyze.ShopItemSortAnalyzer;
   import ddt.data.analyze.SuitTempleteAnalyzer;
   import ddt.data.analyze.TexpExpAnalyze;
   import ddt.data.analyze.UserBoxInfoAnalyzer;
   import ddt.data.analyze.VipSettingAnalyzer;
   import ddt.data.analyze.VoteInfoAnalyzer;
   import ddt.data.analyze.VoteSubmitAnalyzer;
   import ddt.data.analyze.WeaponBallInfoAnalyze;
   import ddt.data.analyze.WeekOpenMapAnalyze;
   import ddt.data.analyze.WishInfoAnalyzer;
   import ddt.events.StartupEvent;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.BallManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.DailyLeagueManager;
   import ddt.manager.DesktopManager;
   import ddt.manager.EffortManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QuestionInfoMannager;
   import ddt.manager.SelectListManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ServerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.manager.VoteManager;
   import ddt.manager.WeaponBallManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.RequestVairableCreater;
   import email.manager.MailManager;
   import farm.analyzer.FoodComposeListAnalyzer;
   import farm.control.FarmComposeHouseController;
   import feedback.FeedbackManager;
   import feedback.analyze.LoadFeedbackReplyAnalyzer;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.net.URLVariables;
   import flash.system.System;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.getDefinitionByName;
   import newTitle.NewTitleManager;
   import newTitle.analyzer.NewTitleDataAnalyz;
   import noviceactivity.NoviceActivityAnalyzer;
   import noviceactivity.NoviceActivityManager;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   import petsBag.petsAdvanced.PetsEvolutionDataAnalyzer;
   import petsBag.petsAdvanced.PetsRisingStarDataAnalyzer;
   import roomList.movingNotification.MovingNotificationManager;
   import store.analyze.StoreEquipExpericenceAnalyze;
   import store.data.StoreEquipExperience;
   import store.forge.wishBead.WishBeadManager;
   import store.view.strength.analyzer.ItemStrengthenGoodsInfoAnalyzer;
   import store.view.strength.manager.ItemStrengthenGoodsInfoManager;
   import texpSystem.controller.TexpManager;
   import vip.VipController;
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.analyze.ActivitySystemItemsDataAnalyzer;
   import chickActivation.ChickActivationManager;
   import AvatarCollection.data.AvatarCollectionUnitDataAnalyzer;
   import AvatarCollection.data.AvatarCollectionItemDataAnalyzer;
   import AvatarCollection.AvatarCollectionManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import totem.HonorUpManager;
   import totem.TotemManager;
   import totem.data.HonorUpDataAnalyz;
   import totem.data.TotemDataAnalyz;
   import store.analyze.StoreEquipExpericenceAnalyze;
   import ddt.data.analyze.FineSuitAnalyze;
   import ddt.manager.FineSuitManager;
   
   public class StartupResourceLoader extends EventDispatcher
   {
      
      public static const NEWBIE:int = 1;
      
      public static const NORMAL:int = 2;
      
      public static const USER_GUILD_RESOURCE_COMPLETE:String = "userGuildResourceComplete";
      
      private static var _instance:StartupResourceLoader;
       
      
      private var _currentMode:int = 0;
      
      private var _uimoduleProgress:int;
      
      private var _progressArr:Array;
      
      private var _trainerComplete:Boolean;
      
      private var _trainerUIComplete:Boolean;
      
      public var _queueIsComplete:Boolean;
      
      private var _loaderQueue:QueueLoader;
      
      private var _requestProgress:int;
      
      private var _rechargeCount:int = 0;
      
      public function StartupResourceLoader()
      {
         super();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIMoudleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIModuleProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onUIModuleLoadError);
      }
      
      public static function get Instance() : StartupResourceLoader
      {
         if(_instance == null)
         {
            _instance = new StartupResourceLoader();
         }
         return _instance;
      }
      
      private function __onUIModuleLoadError(param1:UIModuleEvent) : void
      {
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ddt.StartupResourceLoader.Error.LoadModuleError",param1.module),LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      public function get progress() : int
      {
         if(this._queueIsComplete)
         {
            return 99;
         }
         var _loc1_:int = this._uimoduleProgress + this._requestProgress + 40;
         return _loc1_ > 99 ? int(int(99)) : int(int(_loc1_));
      }
      
      public function start(param1:int) : void
      {
         this._currentMode = param1;
         this.loadLanguage();
      }
      
      private function loadLanguage() : void
      {
         var _loc1_:QueueLoader = new QueueLoader();
         var _loc2_:BaseLoader = this.creatLanguageLoader();
         _loc1_.addLoader(_loc2_);
         _loc1_.addLoader(this.creatZhanLoader());
         _loc1_.addEventListener(Event.COMPLETE,this.__onLoadLanguageComplete);
         _loc1_.start();
      }
      
      private function __onLoadLanguageComplete(param1:Event) : void
      {
         var _loc2_:QueueLoader = param1.currentTarget as QueueLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onLoadLanguageComplete);
         this.loadExppression();
         this._setStageRightMouse();
      }
      
      private function loadExppression() : void
      {
         var _loc1_:ModuleLoader = LoaderManager.Instance.creatLoader(PathManager.getExpressionPath(),BaseLoader.MODULE_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingExpressionResourcesFailure");
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc1_.addEventListener(LoaderEvent.COMPLETE,this.__onExpressionLoadComplete);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      private function __onExpressionLoadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.PROGRESS,this.__onLoadError);
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onExpressionLoadComplete);
         this.loadUIModule();
      }
      
      private function __onUIModuleProgress(param1:UIModuleEvent) : void
      {
         var _loc5_:uint = 0;
         var _loc7_:String = null;
         var _loc2_:BaseLoader = param1.loader;
         if(param1.module == UIModuleTypes.ROAD_COMPONENT)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.COREI)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.COREII)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.CORE_ICON_AND_TIP)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.CORE_SCALE_BITMAP)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.CHAT)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.PLAYER_TIP)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.LEVEL_ICON)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.ENTHRALL)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.TRAINER)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.TRAINER_UI)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.HALL)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.TOOLBAR)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.QUEST)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.TIMEBOX)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.ACADEMY_COMMON)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(param1.module == UIModuleTypes.DDT_HALLICON)
         {
            this.setLoaderProgressArr(param1.module,_loc2_.progress);
         }
         if(!this._progressArr)
         {
            return;
         }
         var _loc4_:Number = 0;
         var _loc6_:uint = this._progressArr.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = this._progressArr[_loc5_];
            _loc4_ += this._progressArr[_loc7_];
            _loc5_++;
         }
         this._uimoduleProgress = int(_loc4_ / _loc6_ * 35);
      }
      
      private function setLoaderProgressArr(param1:String, param2:Number = 0) : void
      {
         if(!this._progressArr)
         {
            this._progressArr = [];
         }
         if(this._progressArr.indexOf(param1) < 0)
         {
            this._progressArr.push(param1);
            this._progressArr[param1] = param2;
         }
         else
         {
            this._progressArr[param1] = param2;
         }
      }
      
      public function addUserGuildResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TRAINER_UI);
      }
      
      public function finishLoadingProgress() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIMoudleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIModuleProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onUIModuleLoadError);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function startLoadRelatedInfo() : void
      {
         var _loc1_:QueueLoader = new QueueLoader();
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            _loc1_.addLoader(this.creatVoteSubmit());
         }
         _loc1_.addLoader(this.creatBallInfoLoader());
         _loc1_.addLoader(this.creatFriendListLoader());
         _loc1_.addLoader(this.creatMyacademyPlayerListLoader());
         _loc1_.addLoader(this.getMyConsortiaData());
         _loc1_.addLoader(this.createCalendarRequest());
         _loc1_.addLoader(MailManager.Instance.getAllEmailLoader());
         _loc1_.addLoader(MailManager.Instance.getSendedEmailLoader());
         _loc1_.addLoader(ConsortionModelControl.Instance.getLevelUpInfo());
         _loc1_.addLoader(this.creatFeedbackInfoLoader());
         _loc1_.addLoader(this.createConsortiaLoader());
         _loc1_.addLoader(this.creatShopDisCountRealTimesLoader());
         _loc1_.start();
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            if(param1.loader.analyzer.message != null)
            {
               _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
            }
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onSetupSourceLoadComplete(param1:Event) : void
      {
         var _loc2_:QueueLoader = param1.currentTarget as QueueLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
         _loc2_.removeEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
         _loc2_.dispose();
         _loc2_ = null;
         this._queueIsComplete = true;
         dispatchEvent(new StartupEvent(StartupEvent.CORE_SETUP_COMPLETE));
      }
      
      private function __onUIMoudleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TRAINER || param1.module == UIModuleTypes.TRAINER_UI)
         {
            if(param1.module == UIModuleTypes.TRAINER)
            {
               this._trainerComplete = true;
            }
            if(param1.module == UIModuleTypes.TRAINER_UI)
            {
               this._trainerUIComplete = true;
            }
            if(this._trainerComplete && this._trainerUIComplete)
            {
               dispatchEvent(new Event(USER_GUILD_RESOURCE_COMPLETE));
            }
         }
         if(param1.module == UIModuleTypes.TIMEBOX)
         {
            dispatchEvent(new StartupEvent(StartupEvent.CORE_LOAD_COMPLETE));
            this._loaderQueue = new QueueLoader();
            this._queueIsComplete = false;
            this._loaderQueue.addEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
            this._loaderQueue.addEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
            this.addLoader(this.creatActiveInfoLoader());
            this.addLoader(this.creatItemTempleteLoader());
            this.addLoader(this.creatGoodCategoryLoader());
            this.addLoader(this.creatShopTempleteLoader());
            this.addLoader(this.createCardSetsUpgradeRule());
            this.addLoader(this.createCardPropIncreaseRule());
            this.addLoader(this.createCardSetsSortRule());
            this.addLoader(this.createCardSetsProperties());
            this.addLoader(ConsortionModelControl.Instance.loadSkillInfoList());
            this.addLoader(this.creatServerListLoader());
            this.addLoader(this.creatSelectListLoader());
            this.addLoader(this.creatQuestTempleteLoader());
            this.addLoader(this.creatEffortTempleteLoader());
            this.addLoader(this.creatAllQuestionInfoLoader());
            this.addLoader(this.creatUserBoxInfoLoader());
            this.addLoader(this.creatBoxTempInfoLoader());
            this.addLoader(this.creatDailyInfoLoader());
            this.addLoader(this.creatMovingNotificationLoader());
            this.addLoader(this.creatShopSortLoader());
            this.addLoader(this.creatMapInfoLoader());
            this.addLoader(this.creatDungeonInfoLoader());
            this.addLoader(this.creatOpenMapInfoLoader());
            this.addLoader(this.creatExpericenceAnalyzeLoader());
            this.addLoader(this.creatWeaponBallAnalyzeLoader());
            this.addLoader(this.creatBallInfoLoader());
            this.addLoader(this.creatTexpExpLoader());
            this.addLoader(this.creatBadgeInfoLoader());
            this.addLoader(this.creatDailyLeagueAwardLoader());
            this.addLoader(this.creatDailyLeagueLevelLoader());
            this.addLoader(this.createWishInfoLader());
            this.addLoader(this.creatServerConfigLoader());
            this.addLoader(this.createNoviceAndRechargeLoader());
            this.addLoader(this.creatPetInfoLoader());
            this.addLoader(this.creatPetSkillLoader());
            this.addLoader(this.creatPetConfigLoader());
            this.addLoader(this.creatPetExpericenceAnalyzeLoader());
            this.addLoader(this.createLoadPetMoePropertyLoader());
            this.addLoader(this.createStoreEquipConfigLoader());
            this.addLoader(this.creatItemStrengthenGoodsInfoLoader());
            this.addLoader(this.createPetsEvolutionDataLoader());
            this.addLoader(this.createPetsRisingStarDataLoader());
            if(PathManager.suitEnable)
            {
               this.addLoader(this.creatSuitTempleteLoader());
               this.addLoader(this.creatEquipSuitTempleteLoader());
            }
            this.addLoader(this.accumulativeLoginLoader());
            this.addLoader(this.createNewTitleDataLoader());
			this.addLoader(this.createActivitySystemItemsLoader());
			this.addLoader(this.createAvatarCollectionUnitDataLoader());
			this.addLoader(this.createAvatarCollectionItemDataLoader());
			this.addLoader(this.createTotemTemplateLoader());
			this.addLoader(this.createHonorUpTemplateLoader());
			this.addLoader(this.createFineSuitInfoLoader());
            this._loaderQueue.start();
         }
      }
      
      private function addLoader(param1:BaseLoader) : void
      {
         this._loaderQueue.addLoader(param1);
      }
      
      private function __onSetupSourceLoadChange(param1:Event) : void
      {
         this._requestProgress = (param1.currentTarget as QueueLoader).completeCount;
      }
      
      private function creatShopDisCountRealTimesLoader() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ShopCheapItemList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.ShopDisCountRealTimesFailure");
         _loc2_.analyzer = new ShopItemDisCountAnalyzer(ShopManager.Instance.updateRealTimesItemsByDisCount);
         return _loc2_;
      }
      
      private function creatVoteSubmit() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["userId"] = PlayerManager.Instance.Self.ID;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("VoteSubmit.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.vip.loadVip.error");
         _loc2_.analyzer = new VoteSubmitAnalyzer(this.loadVoteXml);
         return _loc2_;
      }
      
      public function loadVoteXml(param1:VoteSubmitAnalyzer) : void
      {
         var _loc2_:BaseLoader = null;
         if(param1.result == VoteSubmitAnalyzer.FILENAME)
         {
            _loc2_ = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath(VoteSubmitAnalyzer.FILENAME),BaseLoader.TEXT_LOADER);
            _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.view.vote.loadXMLError");
            _loc2_.analyzer = new VoteInfoAnalyzer(VoteManager.Instance.loadCompleted);
            LoaderManager.Instance.startLoad(_loc2_);
         }
      }
      
      private function creatActiveInfoLoader() : BaseLoader
      {
         return CalendarManager.getInstance().requestActiveEvent();
      }
      
      private function creatBallInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("BallList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBombMetadataFailure");
         _loc1_.analyzer = new BallInfoAnalyzer(BallManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatBoxTempInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadBoxTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsListFailure");
         _loc1_.analyzer = new BoxTempInfoAnalyzer(BossBoxManager.instance.setupBoxTempInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatDungeonInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadPVEItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingCopyMapsInformationFailure");
         _loc1_.analyzer = new DungeonAnalyzer(MapManager.setupDungeonInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatPetSkillLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("Petskillinfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetSkillFail");
         _loc1_.analyzer = new PetSkillAnalyzer(PetSkillManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatEffortTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("AchievementList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAchievementTemplateFormFailure");
         _loc1_.analyzer = new EffortItemTemplateInfoAnalyzer(EffortManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatFriendListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         _loc1_["uname"] = PlayerManager.Instance.Account.Account;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("IMListLoad.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         _loc2_.analyzer = new FriendListAnalyzer(PlayerManager.Instance.setupFriendList);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      private function creatMyacademyPlayerListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["RelationshipID"] = PlayerManager.Instance.Self.masterID;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("UserApprenticeshipInfoList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
         _loc2_.analyzer = new MyAcademyPlayersAnalyze(PlayerManager.Instance.setupMyacademyPlayers);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      private function creatGoodCategoryLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadItemsCategory.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingItemTypeFailure");
         _loc1_.analyzer = new GoodCategoryAnalyzer(ItemManager.Instance.setupGoodsCategory);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatItemTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("TemplateAllList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         _loc1_.analyzer = new ItemTempleteAnalyzer(ItemManager.Instance.setupGoodsTemplates);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatSuitTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SuitTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         _loc1_.analyzer = new SuitTempleteAnalyzer(ItemManager.Instance.setupSuitTemplates);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatEquipSuitTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SuitPartEquipInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         _loc1_.analyzer = new EquipSuitTempleteAnalyzer(ItemManager.Instance.setupEquipSuitTemplates);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatBadgeInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaBadgeConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBadgeInfoFailure");
         _loc1_.analyzer = new BadgeInfoAnalyzer(BadgeInfoManager.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatLanguageLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.getLanguagePath(),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = "Load Language Error!!!";
         _loc1_.analyzer = new LanguageAnalyzer(LanguageMgr.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatMovingNotificationLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.getMovingNotificationPath(),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAnnouncementFailure");
         _loc1_.analyzer = new MovingNotificationAnalyzer(MovingNotificationManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatDailyInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("DailyAwardList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingLoginFailedRewardInformation");
         _loc1_.analyzer = new DaylyGiveAnalyzer(CalendarManager.getInstance().setDailyInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatMapInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadMapsItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadMapInformationFailure");
         _loc1_.analyzer = new MapAnalyzer(MapManager.setupMapInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatOpenMapInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("MapServerList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingOpenMapListFailure");
         _loc1_.analyzer = new WeekOpenMapAnalyze(MapManager.setupOpenMapInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatQuestTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("QuestList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTaskListFailure");
         _loc1_.analyzer = new QuestListAnalyzer(TaskManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatRegisterLoader() : BaseLoader
      {
         var _loc1_:* = getDefinitionByName("register.RegisterState");
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc2_["Sex"] = _loc1_.SelectedSex;
         _loc2_["NickName"] = _loc1_.Nickname;
         _loc2_["Name"] = PlayerManager.Instance.Account.Account;
         _loc2_["Pass"] = PlayerManager.Instance.Account.Password;
         _loc2_["site"] = "";
         var _loc3_:RequestLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("VisualizeRegister.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.FailedToRegister");
         _loc3_.analyzer = new RegisterAnalyzer(null);
         _loc3_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc3_;
      }
      
      private function creatSelectListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["username"] = PlayerManager.Instance.Account.Account;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoginSelectList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingRoleListFailure");
         _loc2_.analyzer = new LoginSelectListAnalyzer(SelectListManager.Instance.setup);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function creatServerListLoader() : BaseLoader
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ServerList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingServerListFailure");
         _loc2_.analyzer = new ServerListAnalyzer(ServerManager.Instance.setup);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function createCardSetsSortRule() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("CardInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.cardSystem.loadfail.setsSortRule");
         _loc1_.analyzer = new SetsSortRuleAnalyzer(CardControl.Instance.initSetsSortRule);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createCardSetsUpgradeRule() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("CardUpdateCondition.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.cardSystem.loadfail.setsUpgradeRule");
         _loc1_.analyzer = new UpgradeRuleAnalyzer(CardControl.Instance.initSetsUpgradeRule);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createCardPropIncreaseRule() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("CardUpdateInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.cardSystem.loadfail.propIncreaseRule");
         _loc1_.analyzer = new CardPropIncreaseRuleAnalyzer(CardControl.Instance.initPropIncreaseRule);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createCardSetsProperties() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("CardBuffList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.cardSystem.loadfail.setsProperties");
         _loc1_.analyzer = new SetsPropertiesAnalyzer(CardControl.Instance.initSetsProperties);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatShopTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ShopItemList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingStoreItemsFail");
         _loc1_.analyzer = new ShopItemAnalyzer(ShopManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatGoodsAdditionLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ItemStrengthenPlusData.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsAdditionFail");
         _loc1_.analyzer = new GoodsAdditionAnalyer(GoodsAdditioner.Instance.addGoodsAddition);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatShopSortLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ShopGoodsShowList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.TheClassificationOfGoodsLoadingShopFailure");
         _loc1_.analyzer = new ShopItemSortAnalyzer(ShopManager.Instance.sortShopItems);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatAllQuestionInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadAllQuestions.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTestFailure");
         _loc1_.analyzer = new QuestionInfoAnalyze(QuestionInfoMannager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatUserBoxInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadUserBox.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingChestsInformationFailure");
         _loc1_.analyzer = new UserBoxInfoAnalyzer(BossBoxManager.instance.setupBoxInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatZhanLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.getZhanPath(),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = "LoadingDirtyCharacterSheetsFailure";
         _loc1_.analyzer = new FilterWordAnalyzer(FilterWordManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function createConsortiaLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         _loc1_["page"] = 1;
         _loc1_["size"] = 10000;
         _loc1_["order"] = -1;
         _loc1_["consortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
         _loc1_["userID"] = -1;
         _loc1_["state"] = -1;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaUsersList.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGuildMembersListFailure");
         _loc2_.analyzer = new ConsortionMemberAnalyer(ConsortionModelControl.Instance.memberListComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      private function createCalendarRequest() : BaseLoader
      {
         return CalendarManager.getInstance().request();
      }
      
      private function getMyConsortiaData() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["page"] = 1;
         _loc1_["size"] = 1;
         _loc1_["name"] = "";
         _loc1_["level"] = -1;
         _loc1_["ConsortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
         _loc1_["order"] = -1;
         _loc1_["openApply"] = -1;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ConsortiaList.ashx"),BaseLoader.COMPRESS_REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.LoadMyconsortiaInfoError");
         _loc2_.analyzer = new ConsortionListAnalyzer(ConsortionModelControl.Instance.selfConsortionComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      private function creatFeedbackInfoLoader() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["userid"] = PlayerManager.Instance.Self.ID;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("AdvanceQuestionRead.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingComplainInformationFailure");
         _loc2_.analyzer = new LoadFeedbackReplyAnalyzer(FeedbackManager.instance.setupFeedbackData);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      private function creatExpericenceAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LevelList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingAchievementTemplateFormFailure");
         _loc1_.analyzer = new ExpericenceAnalyze(Experience.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatTexpExpLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ExerciseInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingTexpExpFailure");
         _loc1_.analyzer = new TexpExpAnalyze(TexpManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatWeaponBallAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("BombConfig.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWeaponBallListFormFailure");
         _loc1_.analyzer = new WeaponBallInfoAnalyze(WeaponBallManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatVipSettingLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("VipSettingList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingVipSettingFailure");
         _loc1_.analyzer = new VipSettingAnalyzer(VipController.instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatDailyLeagueAwardLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("DailyLeagueAward.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueAwardFailure");
         _loc1_.analyzer = new DailyLeagueAwardAnalyzer(DailyLeagueManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatDailyLeagueLevelLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("DailyLeagueLevel.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         _loc1_.analyzer = new DailyLeagueLevelAnalyzer(DailyLeagueManager.Instance.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function createWishInfoLader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("GoldEquipTemplateLoad.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         _loc1_.analyzer = new WishInfoAnalyzer(WishBeadManager.instance.getwishInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function creatServerConfigLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ServerConfig.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDailyLeagueLevelFailure");
         _loc1_.analyzer = new ServerConfigAnalyz(ServerConfigManager.instance.getserverConfigInfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function addRegisterUIModule() : void
      {
         this.addUIModlue(UIModuleTypes.ROAD_COMPONENT);
         this.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
         this.addUIModlue(UIModuleTypes.CORE_SCALE_BITMAP);
         this.addUIModlue(UIModuleTypes.COREI);
         this.addUIModlue(UIModuleTypes.COREII);
         this.addUIModlue(UIModuleTypes.CHAT);
         this.addUIModlue(UIModuleTypes.PLAYER_TIP);
         this.addUIModlue(UIModuleTypes.LEVEL_ICON);
         this.addUIModlue(UIModuleTypes.ENTHRALL);
         this.addUIModlue(UIModuleTypes.TRAINER);
         this.addUIModlue(UIModuleTypes.TRAINER_UI);
         this.addUIModlue(UIModuleTypes.HALL);
         this.addUIModlue(UIModuleTypes.TOOLBAR);
         this.addUIModlue(UIModuleTypes.QUEST);
         this.addUIModlue(UIModuleTypes.ACADEMY_COMMON);
         this.addUIModlue(UIModuleTypes.DDT_HALLICON);
         this.setLoaderProgressArr(UIModuleTypes.ROAD_COMPONENT);
         this.setLoaderProgressArr(UIModuleTypes.CORE_ICON_AND_TIP);
         this.setLoaderProgressArr(UIModuleTypes.CORE_SCALE_BITMAP);
         this.setLoaderProgressArr(UIModuleTypes.COREI);
         this.setLoaderProgressArr(UIModuleTypes.COREII);
         this.setLoaderProgressArr(UIModuleTypes.CHAT);
         this.setLoaderProgressArr(UIModuleTypes.PLAYER_TIP);
         this.setLoaderProgressArr(UIModuleTypes.LEVEL_ICON);
         this.setLoaderProgressArr(UIModuleTypes.ENTHRALL);
         this.setLoaderProgressArr(UIModuleTypes.TRAINER);
         this.setLoaderProgressArr(UIModuleTypes.TRAINER_UI);
         this.setLoaderProgressArr(UIModuleTypes.HALL);
         this.setLoaderProgressArr(UIModuleTypes.TOOLBAR);
         this.setLoaderProgressArr(UIModuleTypes.QUEST);
         this.setLoaderProgressArr(UIModuleTypes.ACADEMY_COMMON);
         this.setLoaderProgressArr(UIModuleTypes.DDT_HALLICON);
      }
      
      private function loadUIModule() : void
      {
         if(this._currentMode == NEWBIE)
         {
            this.addUIModlue(UIModuleTypes.TIMEBOX);
            this.setLoaderProgressArr(UIModuleTypes.TIMEBOX);
         }
         else if(this._currentMode == NORMAL)
         {
            this.addUIModlue(UIModuleTypes.ROAD_COMPONENT);
            this.addUIModlue(UIModuleTypes.CORE_ICON_AND_TIP);
            this.addUIModlue(UIModuleTypes.CORE_SCALE_BITMAP);
            this.addUIModlue(UIModuleTypes.COREI);
            this.addUIModlue(UIModuleTypes.COREII);
            this.addUIModlue(UIModuleTypes.CHAT);
            this.addUIModlue(UIModuleTypes.PLAYER_TIP);
            this.addUIModlue(UIModuleTypes.LEVEL_ICON);
            this.addUIModlue(UIModuleTypes.ENTHRALL);
            this.addUIModlue(UIModuleTypes.HALL);
            this.addUIModlue(UIModuleTypes.TOOLBAR);
            this.addUIModlue(UIModuleTypes.QUEST);
            this.addUIModlue(UIModuleTypes.TIMEBOX);
            this.addUIModlue(UIModuleTypes.ACADEMY_COMMON);
            this.addUIModlue(UIModuleTypes.DDTCORESCALEBITMAP);
            this.addUIModlue(UIModuleTypes.DDT_HALLICON);
            this.addUIModlue(UIModuleTypes.WONDERFULACTIVI);
            this.setLoaderProgressArr(UIModuleTypes.ROAD_COMPONENT);
            this.setLoaderProgressArr(UIModuleTypes.CORE_ICON_AND_TIP);
            this.setLoaderProgressArr(UIModuleTypes.CORE_SCALE_BITMAP);
            this.setLoaderProgressArr(UIModuleTypes.COREI);
            this.setLoaderProgressArr(UIModuleTypes.COREII);
            this.setLoaderProgressArr(UIModuleTypes.CHAT);
            this.setLoaderProgressArr(UIModuleTypes.PLAYER_TIP);
            this.setLoaderProgressArr(UIModuleTypes.LEVEL_ICON);
            this.setLoaderProgressArr(UIModuleTypes.ENTHRALL);
            this.setLoaderProgressArr(UIModuleTypes.HALL);
            this.setLoaderProgressArr(UIModuleTypes.TOOLBAR);
            this.setLoaderProgressArr(UIModuleTypes.QUEST);
            this.setLoaderProgressArr(UIModuleTypes.TIMEBOX);
            this.setLoaderProgressArr(UIModuleTypes.ACADEMY_COMMON);
            this.setLoaderProgressArr(UIModuleTypes.DDTCORESCALEBITMAP);
            this.setLoaderProgressArr(UIModuleTypes.DDT_HALLICON);
         }
      }
      
      public function addNotStartupNeededResource() : void
      {
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.BAG);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.CHAT_BALL);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.ROOM_LIST);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.ROOM);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.CHALLENGE_ROOM);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GAME);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GAMEII);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GAMEOVER);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.STORE);
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.IM);
      }
      
      private function addUIModlue(param1:String) : void
      {
         UIModuleLoader.Instance.addUIModlue(param1);
      }
      
      private function _setStageRightMouse() : void
      {
         LayerManager.Instance.getLayerByType(LayerManager.STAGE_BOTTOM_LAYER).contextMenu = this.creatRightMenu();
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.addCallback("sendSwfNowUrl",this.receivedFromJavaScript);
         }
      }
      
      private function creatRightMenu() : ContextMenu
      {
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         var _loc2_:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.share"));
         _loc2_.separatorBefore = true;
         _loc1_.customItems.push(_loc2_);
         _loc2_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onQQMSNClick);
         var _loc3_:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.collection"));
         _loc3_.separatorBefore = true;
         _loc1_.customItems.push(_loc3_);
         _loc3_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.addFavClick);
         var _loc4_:ContextMenuItem = new ContextMenuItem(LanguageMgr.GetTranslation("Crazytank.supply"));
         _loc4_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.goPayClick);
         _loc1_.customItems.push(_loc4_);
         _loc1_.builtInItems.zoom = true;
         return _loc1_;
      }
      
      private function onQQMSNClick(param1:ContextMenuEvent) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("getLocationUrl","");
         }
      }
      
      public function receivedFromJavaScript(param1:String) : void
      {
         this._receivedFromJavaScriptII(param1);
      }
      
      private function _receivedFromJavaScriptII(param1:String) : void
      {
         System.setClipboard(param1);
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("crazytank.copyOK"),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function addFavClick(param1:ContextMenuEvent) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("addToFavorite","");
         }
      }
      
      public function creatPetInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("PetTemplateInfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetInfoFail");
         _loc1_.analyzer = new PetInfoAnalyzer(PetInfoManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      private function goPayClick(param1:ContextMenuEvent) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function createNoviceAndRechargeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("EventRewardItemList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingLeagueAwardFailure");
         _loc1_.analyzer = new NoviceActivityAnalyzer(NoviceActivityManager.instance.setList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatPetConfigLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("PetConfigInfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadPetConfigFail");
         _loc1_.analyzer = new PetconfigAnalyzer(null);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatPetExpericenceAnalyzeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("PetLevelInfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingPetExpirenceTemplateFormFailure");
         _loc1_.analyzer = new PetExpericenceAnalyze(PetExperience.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createLoadPetMoePropertyLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadPetMoeProperty.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.rescueRewardFail");
         _loc1_.analyzer = new PetMoePropertyAnalyzer(PetsAdvancedManager.Instance.moePropertyComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatItemStrengthenGoodsInfoLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ItemStrengthenGoodsInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadItemStrengthenGoodsInfoListFail");
         _loc1_.analyzer = new ItemStrengthenGoodsInfoAnalyzer(ItemStrengthenGoodsInfoManager.setup);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createPetsEvolutionDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadPetFightProperty.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.PetsAdvancedDataFail");
         _loc1_.analyzer = new PetsEvolutionDataAnalyzer(PetsAdvancedManager.Instance.evolutionDataComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function createPetsRisingStarDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadPetStarExp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.PetsAdvancedDataFail");
         _loc1_.analyzer = new PetsRisingStarDataAnalyzer(PetsAdvancedManager.Instance.risingStarDataComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function creatFoodComposeLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("FoodComposeList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadFoodComposeListFail");
         _loc1_.analyzer = new FoodComposeListAnalyzer(FarmComposeHouseController.instance().setupFoodComposeList);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc1_;
      }
      
      public function accumulativeLoginLoader() : BaseLoader
      {
         ++this._rechargeCount;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["rnd"] = TextLoader.TextLoaderKey + this._rechargeCount.toString();
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoginAwardItemTemplate.xml"),BaseLoader.COMPRESS_TEXT_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.accumulativeLoginInfoFail");
         _loc2_.analyzer = new AccumulativeLoginAnalyer(AccumulativeManager.instance.loadTempleteDataComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
      }
      
      public function createNewTitleDataLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("NewTitleInfo.xml"),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.newTitleDataFail");
         _loc1_.analyzer = new NewTitleDataAnalyz(NewTitleManager.instance.newTitleDataSetup);
         return _loc1_;
      }
	  
	  private function activitySystemItemsDataHandler(param1:DataAnalyzer) : void
	  {
		  var _loc2_:ActivitySystemItemsDataAnalyzer = null;
		  if(param1 is ActivitySystemItemsDataAnalyzer)
		  {
			  _loc2_ = param1 as ActivitySystemItemsDataAnalyzer;
			  //PyramidManager.instance.templateDataSetup(_loc2_.pyramidSystemDataList);
			  GuildMemberWeekManager.instance.templateDataSetup(_loc2_.guildMemberWeekDataList);
			  //GrowthPackageManager.instance.templateDataSetup(_loc2_.growthPackageDataList);
			  //KingDivisionManager.Instance.templateDataSetup(_loc2_.kingDivisionDataList);
			  ChickActivationManager.instance.templateDataSetup(_loc2_.chickActivationDataList);
		  }
	  }
	  
	  public function createActivitySystemItemsLoader() : BaseLoader
	  {
		  var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivitySystemItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
		  _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.activitySystemItemsInfoFail");
		  _loc1_.analyzer = new ActivitySystemItemsDataAnalyzer(this.activitySystemItemsDataHandler);
		  _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
		  return _loc1_;
	  }
	  
	  public function createAvatarCollectionUnitDataLoader() : BaseLoader
	  {
		  var loc1:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ClothPropertyTemplateInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
		  loc1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.AvatarCollectionUnitDataFail");
		  loc1.analyzer = new AvatarCollectionUnitDataAnalyzer(AvatarCollectionManager.instance.unitListDataSetup);
		  loc1.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
		  return loc1;
	  }
	  
	  public function createAvatarCollectionItemDataLoader() : BaseLoader
	  {
		  var loc1:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ClothGroupTemplateInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
		  loc1.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.AvatarCollectionItemDataFail");
		  loc1.analyzer = new AvatarCollectionItemDataAnalyzer(AvatarCollectionManager.instance.itemListDataSetup);
		  loc1.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
		  return loc1;
	  }
	  
	  public function createTotemTemplateLoader() : BaseLoader
	  {
		  var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("TotemInfo.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
		  _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadTotemInfoFail");
		  _loc1_.analyzer = new TotemDataAnalyz(TotemManager.instance.setup);
		  _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
		  return _loc1_;
	  }
	  
	  public function createHonorUpTemplateLoader() : BaseLoader
	  {
		  var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("TotemHonorTemplate.xml"),BaseLoader.TEXT_LOADER);
		  _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadHonorUpInfoFail");
		  _loc1_.analyzer = new HonorUpDataAnalyz(HonorUpManager.instance.setup);
		  _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
		  return _loc1_;
	  }
	  
	  public function createStoreEquipConfigLoader() : BaseLoader
	  {
		  var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LoadStrengthExp.xml"),BaseLoader.TEXT_LOADER);
		  _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadStoreEquipExperienceAllFail");
		  _loc1_.analyzer = new StoreEquipExpericenceAnalyze(StoreEquipExperience.setup);
		  _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
		  return _loc1_;
	  }
	  
	  public function createFineSuitInfoLoader() : BaseLoader
	  {
		  var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SetsBuildTemp.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
		  _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadSuitInfoFail");
		  _loc1_.analyzer = new FineSuitAnalyze(FineSuitManager.Instance.setup);
		  return _loc1_;
	  }
   }
}
