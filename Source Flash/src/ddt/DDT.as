package ddt
{
   import accumulativeLogin.AccumulativeManager;
   import bagAndInfo.BagAndInfoManager;
   import calendar.CalendarManager;
   import cityWide.CityWideManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.StringUtils;
   import ddt.data.AccountInfo;
   import ddt.data.ColorEnum;
   import ddt.data.ConfigParaser;
   import ddt.data.PathInfo;
   import ddt.events.StartupEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.DesktopManager;
   import ddt.manager.DynamicManager;
   import ddt.manager.EdictumManager;
   import ddt.manager.EnthrallManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.GradeExaltClewManager;
   import ddt.manager.HotSpringManager;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerStateManager;
   import ddt.manager.QQtipsManager;
   import ddt.manager.QueueManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StageFocusManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.manager.VipLevelUpManager;
   import ddt.states.StateCreater;
   import ddt.states.StateType;
   import ddt.utils.CrytoUtils;
   import ddt.view.BackgoundView;
   import ddt.view.chat.ChatBugleView;
   import eliteGame.EliteGameController;
   import exitPrompt.ExitPromptManager;
   import farm.FarmModelController;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import game.GameManager;
   import game.view.WindPowerManager;
   import hallIcon.HallIconManager;
   import im.IMController;
   import inviteFriends.InviteFriendsManager;
   import littleGame.LittleGameManager;
   import littleGame.character.LittleGameCharacter;
   import newChickenBox.controller.NewChickenBoxManager;
   import newTitle.NewTitleControl;
   import newTitle.NewTitleManager;
   import org.aswing.KeyboardManager;
   import petsBag.controller.PetBagController;
   import room.RoomManager;
   import roulette.LeftGunRouletteManager;
   import trainer.controller.LevelRewardManager;
   import trainer.controller.WeakGuildManager;
   import worldboss.WorldBossManager;
   import chickActivation.ChickActivationManager;
   import luckStar.manager.LuckStarManager;
   import latentEnergy.LatentEnergyManager;
   import gemstone.GemstoneManager;
   import AvatarCollection.AvatarCollectionManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import league.manager.LeagueManager;
   
   public class DDT
   {
      
      public static var SERVER_ID:int = -1;
      
      public static var IsFBLoader:Boolean = false;
       
      
      private var _alerLayer:Sprite;
      
      private var _allowMulti:Boolean;
      
      private var _gameLayer:Sprite;
      
      private var _musicList:Array;
      
      private var _pass:String;
      
      private var _user:String;
      
      private var _rid:String;
      
      private var numCh:Number;
      
      private var _loaded:Boolean = false;
      
      public function DDT()
      {
         super();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:DisplayObject = null;
         _loc3_ = null;
         this.numCh = 0;
         var _loc2_:int = 0;
         while(_loc2_ < StageReferance.stage.numChildren)
         {
            _loc3_ = StageReferance.stage.getChildAt(_loc2_);
            _loc3_.visible = true;
            ++this.numCh;
            if(_loc3_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc3_));
            }
            _loc2_++;
         }
      }
      
      private function show(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         _loc3_ = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            _loc3_.visible = true;
            ++this.numCh;
            if(_loc3_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc3_));
            }
            _loc2_++;
         }
      }
      
      public function lunch(param1:XML, param2:String, param3:String, param4:int, param5:String = "", param6:String = "", param7:String = "") : void
      {
         DesktopManager.Instance.checkIsDesktop();
         PlayerManager.Instance.Self.baiduEnterCode = param6;
         if(!this._loaded)
         {
            if(param7 == "4")
            {
               DesktopManager.Instance.SetIsDesktop();
            }
            else if(param7 == "3")
            {
               IsFBLoader = true;
            }
            else
            {
               IsFBLoader = false;
            }
            this._user = param2;
            this._pass = param3;
            this._rid = param5;
            PlayerManager.Instance.Self.rid = this._rid;
            ConfigParaser.paras(param1,StageReferance.stage.loaderInfo,this._user);
            this.setup();
            StartupResourceLoader.Instance.addEventListener(StartupEvent.CORE_SETUP_COMPLETE,this.__onCoreSetupLoadComplete);
            StartupResourceLoader.Instance.start(param4);
         }
         else if(StartupResourceLoader.Instance._queueIsComplete)
         {
            this.__onCoreSetupLoadComplete(null);
         }
         else
         {
            StartupResourceLoader.Instance.addEventListener(StartupEvent.CORE_SETUP_COMPLETE,this.__onCoreSetupLoadComplete);
         }
      }
      
      public function startLoad(param1:XML, param2:String, param3:String, param4:int, param5:String = "") : void
      {
         this._loaded = true;
         this._user = param2;
         this._pass = param3;
         this._rid = param5;
         PlayerManager.Instance.Self.rid = this._rid;
         ConfigParaser.paras(param1,StageReferance.stage.loaderInfo,this._user);
         this.setup();
         StartupResourceLoader.Instance.start(param4);
      }
      
      private function __onCoreSetupLoadComplete(param1:StartupEvent) : void
      {
         StartupResourceLoader.Instance.removeEventListener(StartupEvent.CORE_SETUP_COMPLETE,this.__onCoreSetupLoadComplete);
         ChatManager.Instance.setup();
         ChatBugleView.instance.setup();
         StageFocusManager.getInstance().setup(StageReferance.stage);
         BackgoundView.Instance.show();
         StateManager.setState(StateType.LOGIN);
         FightLibManager.Instance.setup();
         PlayerStateManager.Instance.setup();
         WeakGuildManager.Instance.setup();
         AccumulativeManager.instance.setup();
      }
      
      private function setup() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:AccountInfo = null;
         if(StringUtils.isEmpty(this._user))
         {
            LeavePageManager.leaveToLoginPath();
         }
         else
         {
            this.setupComponent();
            _loc1_ = "zRSdzFcnZjOCxDMkWUbuRgiOZIQlk7frZMhElQ0a7VqZI9VgU3+lwo0ghZLU3Gg63kOY2UyJ5vFpQdwJUQydsF337ZAUJz4rwGRt/MNL70wm71nGfmdPv4ING+DyJ3ZxFawwE1zSMjMOqQtY4IV8his/HlgXuUfIHVDK87nMNLc=";
            _loc2_ = "AQAB";
            _loc3_ = new AccountInfo();
            _loc3_.Account = this._user;
            _loc3_.Password = this._pass;
            _loc3_.Key = CrytoUtils.generateRsaKey(_loc1_,_loc2_);
            PlayerManager.Instance.setup(_loc3_);
            ShowTipManager.Instance.setup();
            QueueManager.setup(StageReferance.stage);
            TimeManager.Instance.setup();
            SoundManager.instance.setup(PathInfo.MUSIC_LIST,PathManager.SITE_MAIN);
            IMController.Instance.setup();
            SharedManager.Instance.setup();
            LittleGameManager.Instance.initialize();
            CalendarManager.getInstance().initialize();
            RoomManager.Instance.setup();
            EliteGameController.Instance.setup();
            GameManager.Instance.setup();
            KeyboardManager.getInstance().init(StageReferance.stage);
            ChurchManager.instance.setup();
            GradeExaltClewManager.getInstance().setup();
            HotSpringManager.instance.setup();
            VipLevelUpManager.instance.initVIPLevelUpEvent();
            RouletteManager.instance.setup();
            AcademyManager.Instance.setup();
            ColorEnum.initColor();
            StateManager.setup(LayerManager.Instance.getLayerByType(LayerManager.GAME_BASE_LAYER),new StateCreater());
            EnthrallManager.getInstance().setup();
            ExitPromptManager.Instance.init();
            CityWideManager.Instance.init();
            WindPowerManager.Instance.init();
            LevelRewardManager.Instance.setup();
            QQtipsManager.instance.setup();
            LittleGameCharacter.setup();
            EdictumManager.Instance.setup();
            LeftGunRouletteManager.instance.init();
            FarmModelController.instance.setup();
            PetBagController.instance().setup();
            if(PathManager.CommunityExist())
            {
               DynamicManager.Instance.initialize();
            }
            InviteFriendsManager.Instance.setup();
            BagAndInfoManager.Instance.setup();
            HallIconManager.instance.setup();
            NewChickenBoxManager.instance.setup();
            NewTitleManager.instance.setup();
            NewTitleControl.instance.setup();
			WorldBossManager.Instance.setup();
			ChickActivationManager.instance.setup();
			LuckStarManager.Instance.setup();
			LatentEnergyManager.instance.setup();
			GemstoneManager.Instance.initEvent();
			GemstoneManager.Instance.loaderData();
			AvatarCollectionManager.instance.setup();
			GuildMemberWeekManager.instance.setup();
			LeagueManager.instance.initLeagueStartNoticeEvent();
         }
      }
      
      private function setupComponent() : void
      {
         ComponentSetting.COMBOX_LIST_LAYER = LayerManager.Instance.getLayerByType(LayerManager.STAGE_DYANMIC_LAYER);
         ComponentSetting.PLAY_SOUND_FUNC = SoundManager.instance.play;
         ComponentSetting.SEND_USELOG_ID = SocketManager.Instance.out.sendUseLog;
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.mutiline = true;
         _loc1_.buttonGape = 15;
         _loc1_.autoDispose = true;
         _loc1_.sound = "008";
         AlertManager.Instance.setup(LayerManager.STAGE_DYANMIC_LAYER,_loc1_);
      }
      
      private function soundPlay() : void
      {
         SoundManager.instance.play("008");
      }
   }
}
