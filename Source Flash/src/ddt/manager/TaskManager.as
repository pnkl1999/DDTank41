package ddt.manager
{
   import com.pickgliss.action.ShowTipAction;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.TextLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.BagInfo;
   import ddt.data.analyze.QuestListAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.data.quest.QuestCategory;
   import ddt.data.quest.QuestCondition;
   import ddt.data.quest.QuestDataInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TaskEvent;
   import ddt.states.StateType;
   import ddt.utils.BitArray;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import ddt.view.chat.ChatEvent;
   import exitPrompt.ExitPromptManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   //import overSeasCommunity.OverSeasCommunController;
   import petsBag.controller.PetBagController;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   import quest.TaskMainFrame;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryEvent;
   import road7th.utils.MovieClipWrapper;
   //import trainer.TrainStep;
   import trainer.controller.LevelRewardManager;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import tryonSystem.TryonSystemController;
   import flash.external.ExternalInterface;
   
   [Event(name="changed",type="tank.events.TaskEvent")]
   [Event(name="add",type="tank.events.TaskEvent")]
   [Event(name="remove",type="tank.events.TaskEvent")]
   public class TaskManager
   {
      
      public static const GUIDE_QUEST_ID:int = 339;
      
      public static const COLLECT_INFO_EMAIL:int = 544;
      
      public static const COLLECT_INFO_CELLPHONE:int = 545;
      
      public static const achievementQuestNo:int = 1000;
      
      public static var itemAwardSelected:int;
      
      private static var _selectedQuest:QuestInfo;
      
      private static var _questListLoader:TextLoader;
      
      private static var _mainFrame:TaskMainFrame;
      
      private static var _questDataInited:Boolean;
      
      private static var _instance:TaskManager;
      
      private static var _isShown:Boolean = false;
      
      private static const _questListPath:String = "QuestList.xml";
      
      private static var _allQuests:Dictionary;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      private static var _questLog:BitArray;
      
      public static var _newQuests:Array = new Array();
      
      public static var _currentCategory:int = 0;
      
      public static var currentQuest:QuestInfo;
      
      private static var _currentNewQuest:QuestInfo;
      
      private static var _isShowing:Boolean;
      
      private static var mc:MovieClipWrapper;
      
      private static var _itemListenerArr:Array;
      
      private static var _annexListenerArr:Array;
      
      private static var _desktopCond:QuestCondition;
      
      private static var _friendListenerArr:Array;
      
      private static var _consortChatConditions:Array;
       
      
      public function TaskManager()
      {
         super();
      }
      
      public static function set selectedQuest(param1:QuestInfo) : void
      {
         _selectedQuest = param1;
      }
      
      public static function get selectedQuest() : QuestInfo
      {
         return _selectedQuest;
      }
      
      public static function get instance() : TaskManager
      {
         if(_instance == null)
         {
            _instance = new TaskManager();
         }
         return _instance;
      }
      
      public static function get MainFrame() : TaskMainFrame
      {
         if(!_mainFrame)
         {
            _mainFrame = ComponentFactory.Instance.creat("QuestFrame");
         }
         return _mainFrame;
      }
      
      public static function switchVisible() : void
      {
		 //ExternalInterface.call("console.log", "_isShown", _isShown);
         if(!_isShown)
         {
            MainFrame.open();
            _isShown = true;
			return;
         }
         else
         {
            if(TryonSystemController.Instance.view != null)
            {
               return;
            }
            _mainFrame.dispose();
            _mainFrame = null;
            _isShown = false;
			_dispatcher.dispatchEvent(new Event(TaskMainFrame.TASK_FRAME_HIDE));
			return;
         }
		 
      }
      
      public static function get isShow() : Boolean
      {
         return _isShown;
      }
      
      public static function set isShow(param1:Boolean) : void
      {
         _isShown = param1;
         if(!_isShown)
         {
            _mainFrame = null;
         }
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.removeEventListener(param1,param2);
      }
      
      public static function setup(param1:QuestListAnalyzer) : void
      {
         allQuests = param1.list;
         _questDataInited = false;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_UPDATE,__updateAcceptedTask);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_FINISH,__questFinish);
      }
      
      public static function addQuest(param1:QuestInfo) : void
      {
         TaskManager.allQuests[param1.Id] = param1;
      }
      
      public static function loadQuestLog(param1:ByteArray) : void
      {
         param1.position = 0;
         if(_questLog == null)
         {
            _questLog = new BitArray();
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _questLog.writeByte(param1.readByte());
            _loc2_++;
         }
      }
      
	  private static function IsQuestFinish(questId:int) : Boolean
	  {
		  if(!_questLog)
		  {
			  return false;
		  }
		  if(questId > _questLog.length * 8 || questId < 1)
		  {
			  return false;
		  }
		  questId--;
		  var index:int = questId / 8;
		  var offset:int = questId % 8;
		  var result:int = _questLog[index] & 1 << offset;
		  return result != 0;
	  }
      
      public static function get allQuests() : Dictionary
      {
         if(!_allQuests)
         {
            _allQuests = new Dictionary();
         }
         return _allQuests;
      }
      
      public static function set allQuests(param1:Dictionary) : void
      {
         _allQuests = param1;
      }
      
      public static function getQuestByID(param1:int) : QuestInfo
      {
         if(!allQuests)
         {
            return null;
         }
         return allQuests[param1];
      }
      
      public static function getQuestDataByID(param1:int) : QuestDataInfo
      {
         if(!getQuestByID(param1))
         {
            return null;
         }
         return getQuestByID(param1).data;
      }
      
      public static function getAvailableQuests(param1:int = -1, param2:Boolean = true) : QuestCategory
      {
         var _loc4_:QuestInfo = null;
         var _loc3_:QuestCategory = new QuestCategory();
         for each(_loc4_ in allQuests)
         {
            if(param1 > -1)
            {
               if(param1 == 5)
               {
                  if(_loc4_.Type <= 100)
                  {
                     continue;
                  }
               }
               else if(param1 != _loc4_.Type)
               {
                  continue;
               }
            }
            if(param1 == 3)
            {
               if(_loc4_.id >= 2000 && _loc4_.id <= 2018)
               {
                  continue;
               }
            }
            if(param2 && _loc4_.data && !_loc4_.data.isExist)
            {
               requestQuest(_loc4_);
            }
            else if(isAvailableQuest(_loc4_,true))
            {
               if(_loc4_.Id != achievementQuestNo)
               {
                  if(_loc4_.isCompleted)
                  {
                     _loc3_.addCompleted(_loc4_);
                  }
                  else if(_loc4_.data && _loc4_.data.isNew)
                  {
                     _loc3_.addNew(_loc4_);
                  }
                  else
                  {
                     _loc3_.addQuest(_loc4_);
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public static function getQuestCategory() : void
      {
      }
      
      public static function get allAvailableQuests() : Array
      {
         return getAvailableQuests(-1,false).list;
      }
      
      public static function get allCurrentQuest() : Array
      {
         return getAvailableQuests(-1,true).list;
      }
      
      public static function get mainQuests() : Array
      {
         return getAvailableQuests(0,true).list;
      }
      
      public static function get sideQuests() : Array
      {
         return getAvailableQuests(1,true).list;
      }
      
      public static function get dailyQuests() : Array
      {
         return getAvailableQuests(2,true).list;
      }
      
      public static function get texpQuests() : Array
      {
         return getAvailableQuests(5,true).list;
      }
      
      public static function get newQuests() : Array
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in allAvailableQuests)
         {
            if(_loc2_.data && _loc2_.data.needInformed && _loc2_.Type != 2)
            {
               _loc1_.push(_loc2_);
            }
         }
         _newQuests = _loc1_;
         return _loc1_;
      }
      
      public static function set currentCategory(param1:int) : void
      {
         _currentCategory = param1;
      }
      
      public static function get currentCategory() : int
      {
         if(selectedQuest)
         {
            return selectedQuest.Type;
         }
         return _currentCategory;
      }
      
      public static function get welcomeQuests() : Array
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in dailyQuests)
         {
            if(_loc2_.otherCondition != 1)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_.reverse();
      }
      
      public static function get welcomeGuildQuests() : Array
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in dailyQuests)
         {
            if(_loc2_.otherCondition == 1)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_.reverse();
      }
      
      public static function getTaskData(param1:int) : QuestDataInfo
      {
         if(getQuestByID(param1))
         {
            return getQuestByID(param1).data;
         }
         return null;
      }
      
      private static function isAvailableQuest(param1:QuestInfo, param2:Boolean = false) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:QuestInfo = null;
         var _loc3_:Array = PathManager.DISABLE_TASK_ID;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1.id == parseInt(_loc3_[_loc4_]))
            {
               return false;
            }
            _loc4_++;
         }
         if(param1.disabled)
         {
            return false;
         }
         if(param1.texpTaskIsTimeOut())
         {
            return false;
         }
         if(param1.Type <= 100)
         {
            _loc5_ = PlayerManager.Instance.Self.Grade;
            if(param1.NeedMinLevel > _loc5_ || param1.NeedMaxLevel < _loc5_)
            {
               return false;
            }
         }
         if(param1.PreQuestID != "0,")
         {
            _loc6_ = [];
            _loc6_ = param1.PreQuestID.split(",");
            for each(_loc7_ in _loc6_)
            {
               if(_loc7_ != 0)
               {
                  if(getQuestByID(_loc7_))
                  {
                     _loc8_ = getQuestByID(_loc7_);
                     if(!_loc8_)
                     {
                        return false;
                     }
                     if(!isAchieved(_loc8_))
                     {
                        return false;
                     }
                  }
               }
            }
         }
         if(!(isValidateByDate(param1) && isAvailableByGuild(param1) && isAvailableByMarry(param1)))
         {
            return false;
         }
         if(param1.Type <= 100 && haveLog(param1))
         {
            return false;
         }
         if(!param1.isAvailable)
         {
            return false;
         }
         if(param1.data == null || !param1.data.isExist && param1.CanRepeat)
         {
            requestQuest(param1);
            if(param2 && param1.Type != 4)
            {
               return false;
            }
         }
         return true;
      }
      
      public static function isAchieved(param1:QuestInfo) : Boolean
      {
         if(param1.isAchieved)
         {
            return true;
         }
         if(!param1.CanRepeat)
         {
            if(IsQuestFinish(param1.Id))
            {
               return true;
            }
         }
         return false;
      }
      
      private static function haveLog(param1:QuestInfo) : Boolean
      {
         if(param1.CanRepeat)
         {
            if(param1.data && param1.data.repeatLeft == 0)
            {
               return true;
            }
            return false;
         }
         if(IsQuestFinish(param1.Id))
         {
            return true;
         }
         return false;
      }
      
      public static function isValidateByDate(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return !param1.isTimeOut();
      }
      
      public static function isAvailableByGuild(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return param1.otherCondition != 1 || PlayerManager.Instance.Self.ConsortiaID != 0;
      }
      
      public static function isAvailableByMarry(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return param1.otherCondition != 2 || PlayerManager.Instance.Self.IsMarried;
      }
      
      private static function __updateAcceptedTask(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:QuestInfo = null;
         var _loc7_:QuestDataInfo = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = new QuestInfo();
            if(getQuestByID(_loc5_))
            {
               _loc6_ = getQuestByID(_loc5_);
               if(_loc6_.data)
               {
                  _loc7_ = _loc6_.data;
               }
               else
               {
                  _loc7_ = new QuestDataInfo(_loc5_);
                  if(_loc6_.required)
                  {
                     _loc7_.isNew = true;
                  }
               }
               _loc7_.isAchieved = _loc2_.readBoolean();
               _loc8_ = _loc2_.readInt();
               _loc9_ = _loc2_.readInt();
               _loc10_ = _loc2_.readInt();
               _loc11_ = _loc2_.readInt();
               _loc7_.setProgress(_loc8_,_loc9_,_loc10_,_loc11_);
               _loc7_.CompleteDate = _loc2_.readDate();
               _loc7_.repeatLeft = _loc2_.readInt();
               _loc7_.quality = _loc2_.readInt();
               _loc7_.isExist = _loc2_.readBoolean();
               _loc6_.data = _loc7_;
               if(_loc7_.isNew)
               {
                  addNewQuest(_loc6_);
               }
               if(PetBagController.instance().isPetFarmGuildeTask(_loc6_.QuestID))
               {
                  PetBagController.instance().dispatchEvent(new UpdatePetFarmGuildeEvent(UpdatePetFarmGuildeEvent.FINISH,_loc6_));
               }
               _dispatcher.dispatchEvent(new TaskEvent(TaskEvent.CHANGED,_loc6_,_loc7_));
            }
            _loc4_++;
         }
         loadQuestLog(_loc2_.readByteArray());
         _questDataInited = true;
         checkHighLight();
      }
      
      private static function addNewQuest(param1:QuestInfo) : void
      {
         if(!_newQuests)
         {
            _newQuests = new Array();
         }
         if(_newQuests.indexOf(param1) == -1 && !_isShowing)
         {
            showGetNewQuest();
         }
         _newQuests.push(param1);
      }
      
      private static function availableForMainToolBar() : Boolean
      {
         if(StateManager.currentStateType == null || StateManager.currentStateType == StateType.LOGIN)
         {
            return false;
         }
         return true;
      }
      
      public static function clearNewQuest() : void
      {
         var _loc1_:QuestInfo = null;
         for each(_loc1_ in allAvailableQuests)
         {
         }
      }
      
      public static function showGetNewQuest() : void
      {
         if(NewHandGuideManager.Instance.progress < Step.PICK_ONE)
         {
            return;
         }
         if(mc == null)
         {
            mc = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("core.quest.GetNewQuestMovie"),false,true);
            mc.movie.buttonMode = true;
            mc.movie.addEventListener(MouseEvent.CLICK,__onclicked);
            mc.addEventListener(Event.COMPLETE,__onComplete);
            if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
            {
               CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new ShowTipAction(mc.movie));
            }
            else if(!LevelRewardManager.Instance.isShow)
            {
               LayerManager.Instance.addToLayer(mc.movie,LayerManager.GAME_TOP_LAYER,false,LayerManager.NONE_BLOCKGOUND,false);
               mc.play();
               _isShowing = true;
            }
            else
            {
               WeakGuildManager.Instance.newTask = true;
               mc = null;
            }
         }
      }
      
      private static function __onComplete(param1:Event) : void
      {
         mc.movie.removeEventListener(MouseEvent.CLICK,__onclicked);
         mc.removeEventListener(Event.COMPLETE,__onComplete);
         ObjectUtils.disposeObject(mc);
         mc = null;
         _isShowing = false;
      }
      
      private static function __onclicked(param1:MouseEvent) : void
      {
         mc.movie.removeEventListener(MouseEvent.CLICK,__onclicked);
         if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER || StateManager.currentStateType == StateType.GAME_LOADING)
         {
            return;
         }
         mc.movie.visible = false;
         //false;
         if(!_isShown)
         {
            switchVisible();
         }
      }
      
      public static function get currentNewQuest() : QuestInfo
      {
         return _currentNewQuest;
      }
      
      /*private static function __questFinish(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();

         if(_loc3_ == TaskManager.achievementQuestNo)
         {
            return;
         }

         if(_loc3_ == 319)
         {
            TrainStep.send(TrainStep.Step.FIGHT_FIRST);
         }
         if(_loc3_ == 321)
         {
            TrainStep.send(TrainStep.Step.FIGHT_TWO);
         }
         else if(_loc3_ == 537)
         {
            TrainStep.send(TrainStep.Step.WEAPONRY_AND_CLOTHING);
         }
         else if(_loc3_ == 2011)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.PvP"));
         }
         else if(_loc3_ == 2012)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.GUILD"));
         }
         else if(_loc3_ == 2015)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.GUILD.Win"));
         }
         else if(_loc3_ == 2018)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.PVP2v2"));
         }
         else if(_loc3_ == 2006)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.BaseStore.qianghua"));
         }
         else if(_loc3_ == 2007)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.BaseStore.hecheng"));
         }
         else if(_loc3_ == 2010)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.boss.mayi"));
         }
         else if(_loc3_ == 2013)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.bogu.jiandan"));
         }
         else if(_loc3_ == 2014)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.bogu.putong"));
         }
         else if(_loc3_ == 2016)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.bogu.kunnan"));
         }
         else if(_loc3_ == 2017)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.xieshen.kunnan"));
         }
         else if(_loc3_ == 2008)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.ChurchBuyRing"));
         }
         else if(_loc3_ == 2009)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.Consortion"));
         }
         else if(_loc3_ == 2000)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.level.5"));
         }
         else if(_loc3_ == 2001)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.level.6"));
         }
         else if(_loc3_ == 2002)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.level.7"));
         }
         else if(_loc3_ == 2003)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.level.8"));
         }
         else if(_loc3_ == 2004)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.level.9"));
         }
         else if(_loc3_ == 2005)
         {
            OverSeasCommunController.instance().facebookSendToFeed(LanguageMgr.GetTranslation("setFacebookParam.level.10"));
         }
      }*/
	  
	  private static function __questFinish(param1:CrazyTankSocketEvent) : void
	  {
		  var _loc3_:PackageIn = param1.pkg;
		  var _loc2_:int = _loc3_.readInt();
		  var _clickDate:Number = 0;
		  if(_loc2_ == 1000)
		  {
			  return;
		  }
		  if(new Date().time - _clickDate <= 1000)
		  {
			  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.TaskManager.questFinish.TooQuickly"));
			  return;
		  }
		  _clickDate = new Date().time;
		  onFinishQuest(_loc2_);
	  }
      
      private static function onFinishQuest(param1:int) : void
      {
         var _loc2_:QuestInfo = getQuestByID(param1);
         if(_loc2_.isAvailable || _loc2_.NextQuestID)
         {
            requestCanAcceptTask();
         }
         _dispatcher.dispatchEvent(new TaskEvent(TaskEvent.FINISH,_loc2_,_loc2_.data));
      }
      
      public static function jumpToQuest(param1:QuestInfo) : void
      {
         selectedQuest = param1;
         TaskManager.MainFrame.jumpToQuest(param1);
      }
      
      public static function onBagChanged() : void
      {
         checkHighLight();
      }
      
      public static function onGuildUpdate() : void
      {
         checkHighLight();
      }
      
      public static function onPlayerLevelUp() : void
      {
         checkHighLight();
      }
      
      public static function finshMarriage() : void
      {
         var _loc1_:QuestInfo = null;
         var _loc2_:QuestDataInfo = null;
         for each(var _loc5_:* in allQuests)
         {
            _loc1_ = _loc5_;
            _loc5_;
            _loc2_ = _loc1_.data;
            if(_loc2_)
            {
               if(!_loc2_.isAchieved)
               {
                  if(_loc1_.Condition == 21)
                  {
                     showTaskHightLight();
                  }
               }
            }
         }
         requestCanAcceptTask();
      }
      
      public static function get achievementQuest() : QuestInfo
      {
         return TaskManager.getQuestByID(achievementQuestNo);
      }
      
      public static function requestAchievementReward() : void
      {
         SocketManager.Instance.out.sendQuestFinish(achievementQuestNo,0);
      }
      
      public static function requestCanAcceptTask() : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestInfo = null;
         var _loc1_:Array = allAvailableQuests;
         if(_loc1_.length != 0)
         {
            _loc2_ = new Array();
            for each(var _loc6_:* in _loc1_)
            {
               _loc3_ = _loc6_;
               _loc6_;
               if(_loc3_.Type <= 100)
               {
                  if(!(_loc3_.data && _loc3_.data.isExist))
                  {
                     _loc2_.push(_loc3_.QuestID);
                     if(_questDataInited)
                     {
                        _loc3_.required = true;
                     }
                  }
               }
            }
            socketSendQuestAdd(_loc2_);
         }
      }
      
      public static function requestQuest(param1:QuestInfo) : void
      {
         if(StateManager.currentStateType == StateType.LOGIN)
         {
            return;
         }
         if(param1.Type > 100)
         {
            return;
         }
         var _loc2_:Array = new Array();
         _loc2_.push(param1.QuestID);
         if(_questDataInited)
         {
            param1.required = true;
            true;
         }
         socketSendQuestAdd(_loc2_);
      }
      
      public static function requestClubTask() : void
      {
         var _loc2_:QuestInfo = null;
         var _loc1_:Array = new Array();
         for each(var _loc5_:* in allAvailableQuests)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(_loc2_.otherCondition == 1)
            {
               if(isAvailableQuest(_loc2_))
               {
                  _loc1_.push(_loc2_.QuestID);
               }
            }
         }
         if(_loc1_.length > 0)
         {
            socketSendQuestAdd(_loc1_);
         }
      }
      
      public static function addItemListener(param1:int) : void
      {
         if(!_itemListenerArr)
         {
            _itemListenerArr = new Array();
         }
         _itemListenerArr.push(param1);
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         _loc2_.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,__onBagUpdate);
         _loc2_.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,__onBagUpdate);
      }
      
      private static function __onBagUpdate(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         for each(var _loc6_:* in param1.changedSlots)
         {
            _loc2_ = _loc6_;
            _loc6_;
            for each(var _loc8_:* in _itemListenerArr)
            {
               _loc3_ = _loc8_;
               _loc8_;
               if(_loc3_ == _loc2_.TemplateID)
               {
                  checkHighLight();
               }
            }
         }
      }
      
      public static function addGradeListener() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onPlayerPropertyChange);
      }
      
      private static function __onPlayerPropertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"])
         {
            checkHighLight();
         }
      }
      
      public static function onMarriaged() : void
      {
         checkHighLight();
      }
      
      public static function addGuildMemberListener() : void
      {
      }
      
      public static function addAnnexListener(param1:QuestCondition) : void
      {
         if(!_annexListenerArr)
         {
            _annexListenerArr = new Array();
         }
         _annexListenerArr.push(param1);
      }
      
      public static function addDesktopListener(param1:QuestCondition) : void
      {
         _desktopCond = param1;
         if(DesktopManager.Instance.isDesktop)
         {
            checkQuest(_desktopCond.questID,_desktopCond.ConID,0);
         }
      }
      
      public static function onDesktopApp() : void
      {
         if(_desktopCond)
         {
            checkQuest(_desktopCond.questID,_desktopCond.ConID,0);
         }
      }
      
      public static function onSendAnnex(param1:Array) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:QuestCondition = null;
         for each(var _loc6_:* in param1)
         {
            _loc2_ = _loc6_;
            _loc6_;
            for each(var _loc8_:* in _annexListenerArr)
            {
               _loc3_ = _loc8_;
               _loc8_;
               if(_loc3_.param2 == _loc2_.TemplateID)
               {
                  if(isAvailableQuest(getQuestByID(_loc3_.questID),true))
                  {
                     checkQuest(_loc3_.questID,_loc3_.ConID,0);
                  }
               }
            }
         }
      }
      
      public static function addFriendListener(param1:QuestCondition) : void
      {
         if(!_friendListenerArr)
         {
            _friendListenerArr = new Array();
         }
         _friendListenerArr.push(param1);
         PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE,__onFriendListComplete);
         addEventListener(TaskEvent.CHANGED,__onQuestChange);
      }
      
      private static function __onQuestChange(param1:TaskEvent) : void
      {
         var _loc2_:QuestCondition = null;
         for each(var _loc5_:* in _friendListenerArr)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(param1.info.Id == _loc2_.questID)
            {
               checkQuest(_loc2_.questID,_loc2_.ConID,_loc2_.param2 - PlayerManager.Instance.friendList.length);
            }
         }
      }
      
      private static function __onFriendListComplete(param1:Event) : void
      {
         var _loc2_:QuestCondition = null;
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD,__onFriendListUpdated);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,__onFriendListUpdated);
         for each(var _loc5_:* in _friendListenerArr)
         {
            _loc2_ = _loc5_;
            _loc5_;
            checkQuest(_loc2_.questID,_loc2_.ConID,_loc2_.param2 - PlayerManager.Instance.friendList.length);
         }
      }
      
      private static function __onFriendListUpdated(param1:DictionaryEvent) : void
      {
         var _loc2_:QuestCondition = null;
         for each(var _loc5_:* in _friendListenerArr)
         {
            _loc2_ = _loc5_;
            _loc5_;
            checkQuest(_loc2_.questID,_loc2_.ConID,_loc2_.param2 - PlayerManager.Instance.friendList.length);
         }
      }
      
      public static function hasConsortiaSayTask() : Boolean
      {
         var _loc2_:QuestInfo = null;
         var _loc3_:QuestCondition = null;
         var _loc1_:Array = getAvailableQuests(-1,true).list;
         for each(var _loc6_:* in _loc1_)
         {
            _loc2_ = _loc6_;
            _loc6_;
            if(!_loc2_.isAchieved)
            {
               for each(var _loc8_:* in _loc2_._conditions)
               {
                  _loc3_ = _loc8_;
                  _loc8_;
                  if(_loc3_.type == 20 && _loc3_.param == 4)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public static function addConsortaChatCondition(param1:QuestCondition) : void
      {
         if(_consortChatConditions == null)
         {
            _consortChatConditions = [];
         }
         _consortChatConditions.push(param1);
         ChatManager.Instance.addEventListener(ChatEvent.SEND_CONSORTIA,__onConsortiaChat);
      }
      
      private static function __onConsortiaChat(param1:ChatEvent) : void
      {
         var _loc2_:QuestCondition = null;
         if(!hasConsortiaSayTask())
         {
            return;
         }
         for each(var _loc5_:* in _consortChatConditions)
         {
            _loc2_ = _loc5_;
            _loc5_;
            checkQuest(_loc2_.questID,_loc2_.ConID,0);
         }
      }
      
      public static function sendQuestFinish(param1:uint) : void
      {
         SocketManager.Instance.out.sendQuestFinish(param1,itemAwardSelected);
         questFinishHook(param1);
      }
      
      private static function questFinishHook(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:URLVariables = null;
         var _loc4_:BaseLoader = null;
         switch(param1)
         {
            case COLLECT_INFO_EMAIL:
               _loc2_ = PlayerManager.Instance.Self.ID;
               _loc3_ = RequestVairableCreater.creatWidthKey(true);
               _loc3_["selfid"] = _loc2_;
               _loc3_["url"] = PathManager.solveLogin();
               _loc3_["nickname"] = PlayerManager.Instance.Self.NickName;
               _loc3_["rnd"] = Math.random();
               _loc4_ = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SendMailGameUrl.ashx"),BaseLoader.REQUEST_LOADER,_loc3_);
               LoaderManager.Instance.startLoad(_loc4_);
			   break;
         }
      }
      
      public static function sendQuestData(param1:int, param2:int) : void
      {
         if(!getQuestByID(param1).data)
         {
            return;
         }
         var _loc3_:int = getQuestByID(param1).data.progress[param2];
         _loc3_--;
         checkQuest(param1,param2,_loc3_);
      }
      
      public static function HighLightChecked(param1:QuestInfo) : void
      {
         if(param1.isCompleted)
         {
            param1.hadChecked = true;
            true;
         }
      }
      
      public static function checkQuest(param1:int, param2:int, param3:int) : void
      {
         SocketManager.Instance.out.sendQuestCheck(param1,param2,param3);
      }
      
      private static function socketSendQuestAdd(param1:Array) : void
      {
         SocketManager.Instance.out.sendQuestAdd(param1);
      }
      
      public static function checkHighLight() : void
      {
         var _loc2_:QuestInfo = null;
         ExitPromptManager.Instance.changeJSQuestVar();
         var _loc1_:int = 0;
         for each(var _loc5_:* in allCurrentQuest)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(!_loc2_.isAchieved || _loc2_.CanRepeat)
            {
               if(_loc2_.isCompleted)
               {
                  if(!_loc2_.hadChecked)
                  {
                     _loc1_++;
                  }
               }
            }
         }
         if(_loc1_ > 0)
         {
            showTaskHightLight();
         }
         else
         {
            MainToolBar.Instance.hideTaskHightLight();
         }
      }
      
      private static function showTaskHightLight() : void
      {
         if(availableForMainToolBar())
         {
            if(!_isShown)
            {
               MainToolBar.Instance.showTaskHightLight();
            }
         }
      }
      
      public function isAvailable(param1:QuestInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return isAvailableQuest(param1) && !param1.isCompleted;
      }
   }
}
