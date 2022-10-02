package guildMemberWeek.manager
{
   import com.pickgliss.action.AlertAction;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;  
   import ddt.constants.CacheConsts;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import guildMemberWeek.controller.GuildMemberWeekController;
   import guildMemberWeek.data.GuildMemberWeekPackageType;
   import guildMemberWeek.loader.LoaderGuildMemberWeekUIModule;
   import guildMemberWeek.model.GuildMemberWeekModel;
   import guildMemberWeek.view.GuildMemberWeekFrame;
   import guildMemberWeek.view.ShowRankingFrame.GuildMemberWeekShowRankingFrame;
   import guildMemberWeek.view.addRankingFrame.GuildMemberWeekAddRankingFrame;
   import guildMemberWeek.view.mainFrame.GuildMemberWeekPromptFrame;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class GuildMemberWeekManager extends EventDispatcher
   {
      
      private static var _instance:GuildMemberWeekManager;
       
      
      private var _model:GuildMemberWeekModel;
      
      private var _Controller:GuildMemberWeekController;
      
      private var _isShowIcon:Boolean = false;
      
      private var _AddRankingFrame:GuildMemberWeekAddRankingFrame;
      
      private var _FinishActivityFrame:GuildMemberWeekShowRankingFrame;
      
      private var _WorkFrame:GuildMemberWeekFrame;
      
      private var _Top10PromptFrame:GuildMemberWeekPromptFrame;
      
      public function GuildMemberWeekManager(param1:PrivateClass)
      {
         super();
         if(param1 == null)
         {
            throw new Error("错误:GuildMemberWeekManager为单例，请使用instance获取实例!");
         }
      }
      
      public static function get instance() : GuildMemberWeekManager
      {
         if(_instance == null)
         {
            _instance = new GuildMemberWeekManager(new PrivateClass());
         }
         return _instance;
      }
      
      public function get MainFrame() : GuildMemberWeekFrame
      {
         return this._WorkFrame;
      }
      
      public function get Controller() : GuildMemberWeekController
      {
         return this._Controller;
      }
      
      public function setup() : void
      {
         if(this._model == null)
         {
            this._model = new GuildMemberWeekModel();
         }
         this._Controller = GuildMemberWeekController.instance;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GUILDMEMBERWEEK_SYSTEM,this.pkgHandler);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         var _loc4_:CrazyTankSocketEvent = null;
         switch(_loc3_)
         {
            case GuildMemberWeekPackageType.OPEN:
               this.openOrclose(_loc2_);
               break;
            case GuildMemberWeekPackageType.PLAYERTOP10:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_PLAYERTOP10,_loc2_);
               break;
            case GuildMemberWeekPackageType.ADDPOINTBOOK10:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_POINTBOOK,_loc2_);
               break;
            case GuildMemberWeekPackageType.ADDPOINTBOOKRECORD:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_ADDPOINTBOOKRECORD,_loc2_);
               break;
            case GuildMemberWeekPackageType.GET_MYRUNKING:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_MYRUNKING,_loc2_);
               break;
            case GuildMemberWeekPackageType.UPADDPOINTBOOK:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_UPADDPOINTBOOK,_loc2_);
               break;
            case GuildMemberWeekPackageType.SHOWACTIVITYEND:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_GET_SHOWACTIVITYEND,_loc2_);
         }
         if(_loc4_)
         {
            dispatchEvent(_loc4_);
         }
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         if(param1 != null)
         {
            this._model.isOpen = param1.readBoolean();
            this._isShowIcon = this._model.isOpen;
            if(this._model.isOpen)
            {
               this._model.ActivityStartTime = param1.readUTF();
               this._model.ActivityEndTime = param1.readUTF();
            }
         }
         if(this._model.isOpen)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
         }
      }
      
      public function showEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.GUILDMEMBERWEEK,true);
      }
      
      public function hideEnterIcon() : void
      {
         this._isShowIcon = false;
         HallIconManager.instance.updateSwitchHandler(HallIconType.GUILDMEMBERWEEK,false);
         this.disposeEnterIcon();
      }
      
      private function disposeEnterIcon() : void
      {
         if(this._WorkFrame)
         {
            this._WorkFrame.dispose();
            this._WorkFrame = null;
         }
         if(this._AddRankingFrame)
         {
            this._AddRankingFrame.dispose();
            this._AddRankingFrame = null;
         }
         if(this._FinishActivityFrame)
         {
            this._FinishActivityFrame.dispose();
            this._FinishActivityFrame = null;
         }
      }
      
      public function onClickguildMemberWeekIcon(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            if(PlayerManager.Instance.Self.Grade < 7)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.player.Level.CannotInActivity"));
               return;
            }
            StateManager.setState(StateType.CONSORTIA);
            return;
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            LoaderGuildMemberWeekUIModule.Instance.loadUIModule(this.doOpenGuildMemberWeekFrame);
         }
      }
      
      public function doOpenGuildMemberWeekFrame() : void
      {
         if(PlayerManager.Instance.Self.DutyLevel <= 3)
         {
            this._model.CanAddPointBook = true;
         }
         else
         {
            this._model.CanAddPointBook = false;
         }
         if(this._isShowIcon)
         {
            if(this._AddRankingFrame)
            {
               this._AddRankingFrame.dispose();
               this._AddRankingFrame = null;
            }
            this._WorkFrame = ComponentFactory.Instance.creatComponentByStylename("Window.guildmemberweek.GuildMemberWeekFrame");
            LayerManager.Instance.addToLayer(this._WorkFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            SocketManager.Instance.out.sendGuildMemberWeekStarEnter();
         }
      }
      
      public function LoadAndOpenGuildMemberWeekFinishActivity() : void
      {
         LoaderGuildMemberWeekUIModule.Instance.loadUIModule(this.doOpenGuildMemberWeekFinishActivity);
      }
      
      public function get FinishActivityFrame() : GuildMemberWeekShowRankingFrame
      {
         return this._FinishActivityFrame;
      }
      
      public function doOpenGuildMemberWeekFinishActivity() : void
      {
         var _loc1_:AlertAction = null;
         if(this._WorkFrame)
         {
            this._WorkFrame.dispose();
            this._WorkFrame = null;
         }
         this._FinishActivityFrame = ComponentFactory.Instance.creatComponentByStylename("Window.guildmemberweek.GuildMemberWeekShowRankingFrame");
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            _loc1_ = new AlertAction(this._FinishActivityFrame,LayerManager.GAME_UI_LAYER,LayerManager.BLCAK_BLOCKGOUND);
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,_loc1_);
            return;
         }
         LayerManager.Instance.addToLayer(this._FinishActivityFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function get AddRankingFrame() : GuildMemberWeekAddRankingFrame
      {
         return this._AddRankingFrame;
      }
      
      public function doOpenaddRankingFrame() : void
      {
         if(PlayerManager.Instance.Self.DutyLevel > 3 || !this._model.CanAddPointBook)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.CantNotAddPointBook"));
            return;
         }
         this._AddRankingFrame = ComponentFactory.Instance.creatComponentByStylename("Window.guildmemberweek.GuildMemberWeekAddRankingFrame");
         LayerManager.Instance.addToLayer(this._AddRankingFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function CloseAddRankingFrame() : void
      {
         if(this._AddRankingFrame == null)
         {
            return;
         }
         this._AddRankingFrame.dispose();
         this._AddRankingFrame = null;
      }
      
      public function get model() : GuildMemberWeekModel
      {
         if(this._model == null)
         {
            this._model = new GuildMemberWeekModel();
         }
         return this._model;
      }
      
      public function returnComponentBnt(param1:Sprite, param2:Boolean = true) : BaseButton
      {
         var _loc3_:BaseButton = new BaseButton();
         if(param2)
         {
            _loc3_.tipDirctions = "0,5";
            _loc3_.tipStyle = "ddt.view.tips.OneLineTip";
         }
         _loc3_.filterString = "null,lightFilter,lightFilter,grayFilter";
         _loc3_.backgound = param1;
         _loc3_.tipGapV = 20;
         _loc3_.addChild(param1);
         return _loc3_;
      }
      
      public function LoadAndOpenShowTop10PromptFrame() : void
      {
         LoaderGuildMemberWeekUIModule.Instance.loadUIModule(this.doOpenGuildMemberWeekTop10PromptFrame);
      }
      
      public function doOpenGuildMemberWeekTop10PromptFrame() : void
      {
         var _loc2_:AlertAction = null;
         var _loc1_:String = "";
         this._Top10PromptFrame = ComponentFactory.Instance.creatComponentByStylename("guildMemberWeek.view.GuildMemberWeekPromptFrame");
         _loc1_ = LanguageMgr.GetTranslation("guildMemberWeek.AddRankingFrame.PromptFrameF");
         this._Top10PromptFrame.setPromptFrameTxt(_loc1_);
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            _loc2_ = new AlertAction(this._Top10PromptFrame,LayerManager.GAME_UI_LAYER,LayerManager.BLCAK_BLOCKGOUND);
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,_loc2_);
            return;
         }
         LayerManager.Instance.addToLayer(this._Top10PromptFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function CloseShowTop10PromptFrame() : void
      {
         this._Top10PromptFrame.dispose();
         this._Top10PromptFrame = null;
         var _loc1_:CrazyTankSocketEvent = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_SHOWRUNKING);
         dispatchEvent(_loc1_);
      }
      
      public function get getGiftType() : int
      {
         return 15;
      }
      
      public function templateDataSetup(param1:Array) : void
      {
         this.model.TopTenGiftData = [];
         var _loc2_:String = "";
         var _loc3_:Array = param1;
         var _loc4_:int = 0;
         var _loc5_:int = _loc3_.length;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = _loc3_[_loc4_].length;
            _loc2_ = "";
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               if(_loc6_ < 3)
               {
                  _loc2_ += _loc3_[_loc4_][_loc6_].TemplateID + "," + _loc3_[_loc4_][_loc6_].Count + ",";
               }
               else if(_loc6_ == 3)
               {
                  _loc2_ += _loc3_[_loc4_][_loc6_].TemplateID + "," + _loc3_[_loc4_][_loc6_].Count;
                  break;
               }
               _loc6_++;
            }
            this.model.TopTenGiftData.push(_loc2_);
            _loc4_++;
         }
         while(this.model.TopTenGiftData.length < 10)
         {
            this.model.TopTenGiftData.push("");
         }
         this.model.items = param1;
      }
      
      public function CheckShowEndFrame(param1:Boolean) : void
      {
         if(param1)
         {
            this.LoadAndOpenShowTop10PromptFrame();
         }
         else
         {
            this.LoadAndOpenGuildMemberWeekFinishActivity();
         }
      }
      
      public function disposeAllFrame(param1:Boolean = false) : void
      {
         if(this._WorkFrame)
         {
            this._WorkFrame.dispose();
            this._WorkFrame = null;
         }
         if(this._AddRankingFrame)
         {
            this._AddRankingFrame.dispose();
            this._AddRankingFrame = null;
         }
         if(this._FinishActivityFrame)
         {
            this._FinishActivityFrame.dispose();
            this._FinishActivityFrame = null;
         }
         this._model.AddRanking.splice(0);
         this._model.TopTenMemberData.splice(0);
         this._model.TopTenAddPointBook = [0,0,0,0,0,0,0,0,0,0];
         this._model.PlayerAddPointBook = [0,0,0,0,0,0,0,0,0,0];
         this._model.PlayerAddPointBookBefor = [0,0,0,0,0,0,0,0,0,0];
         SocketManager.Instance.out.sendGuildMemberWeekStarClose();
         if(param1)
         {
            if(this._Controller)
            {
               this._Controller.dispose();
            }
         }
      }
   }
}

class PrivateClass
{
    
   
   function PrivateClass()
   {
      super();
   }
}
