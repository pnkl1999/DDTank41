package fightLib
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.EffortMovieClipManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import fightLib.script.FightLibGuideScripit;
   import fightLib.view.FightLibView;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.GameManager;
   import par.ParticleManager;
   import room.RoomManager;
   import roomLoading.view.RoomLoadingView;
   import trainer.data.Step;
   
   public class FightLibState extends BaseStateView
   {
      
      public static const LibLevelMin:int = 15;
      
      public static const GuildOne:int = 1;
      
      public static const GuildTwo:int = 2;
       
      
      private var _container:Sprite;
      
      private var _fightLibView:FightLibView;
      
      private var _roomLoading:RoomLoadingView;
      
      public function FightLibState()
      {
         super();
      }
      
      override public function dispose() : void
      {
         if(this._fightLibView)
         {
            ObjectUtils.disposeObject(this._fightLibView);
            this._fightLibView = null;
         }
         if(this._roomLoading)
         {
            ObjectUtils.disposeObject(this._roomLoading);
            this._roomLoading = null;
         }
         super.dispose();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:FightLibInfo = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:BoxGoodsTempInfo = null;
         super.enter(param1,param2);
         SoundManager.instance.playMusic("065");
         FightLibManager.Instance.reset();
         ParticleManager.initPartical(PathManager.FLASHSITE);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         this._fightLibView = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibView");
         addChild(this._fightLibView);
         this._fightLibView.startup();
         ChatManager.Instance.state = ChatManager.CHAT_FIGHT_LIB;
         addChild(ChatManager.Instance.view);
         MainToolBar.Instance.show();
         EffortMovieClipManager.Instance.show();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_FIGHT);
         var _loc3_:String = this.hasNeedGetAward();
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.split("_");
            _loc5_ = FightLibManager.Instance.getFightLibInfoByID(int(_loc4_[0]) + 1000);
            if(_loc5_ != null)
            {
               _loc6_ = [];
               _loc5_.difficulty = int(_loc4_[1]);
               for each(_loc7_ in _loc5_.getAwardItems())
               {
                  _loc8_ = new BoxGoodsTempInfo();
                  _loc8_.IsBind = true;
                  _loc8_.ItemCount = _loc7_.count;
                  _loc8_.TemplateId = _loc7_.id;
                  _loc6_.push(_loc8_);
               }
               BossBoxManager.instance.showFightLibAwardBox(int(_loc4_[0]) + 1000,int(_loc4_[1]),_loc6_);
            }
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VISIT_CAMPAIGN_LAB) && TaskManager.getQuestDataByID(469))
         {
            SocketManager.Instance.out.sendQuestCheck(469,1,0);
            SocketManager.Instance.out.syncWeakStep(Step.VISIT_CAMPAIGN_LAB);
         }
         AcademyManager.Instance.showAlert();
         PlayerManager.Instance.Self.sendOverTimeListByBody();
      }
      
      private function hasNeedGetAward() : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:String = PlayerManager.Instance.Self.fightLibMission;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = _loc1_.substr(_loc2_ + 20,1);
            _loc4_ = _loc1_.substr(_loc2_ * 2 + 1,1);
            if(int(_loc4_) < int(_loc3_))
            {
               return _loc2_ + "_" + _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      override public function fadingComplete() : void
      {
         super.fadingComplete();
         this.checkIfFirtEnter();
         RoomManager.Instance.reset();
         GameInSocketOut.sendCreateRoom("",5);
      }
      
      public function showGuide1() : void
      {
         this._fightLibView.showGuild(GuildOne);
      }
      
      public function showGuide2() : void
      {
         this._fightLibView.showGuild(GuildTwo);
      }
      
      public function hideGuide() : void
      {
         this._fightLibView.hideGuide();
      }
      
      private function checkIfFirtEnter() : void
      {
         var _loc1_:FightLibInfo = FightLibManager.Instance.getFightLibInfoByID(LessonType.Measure);
         if(!_loc1_.InfoCanPlay)
         {
            this.startScript();
         }
         SharedManager.Instance.save();
      }
      
      private function startScript() : void
      {
         FightLibManager.Instance.script = new FightLibGuideScripit(this);
         FightLibManager.Instance.script.start();
      }
      
      private function __startLoading(param1:Event) : void
      {
         ChatManager.Instance.input.faceEnabled = false;
         ChatManager.Instance.state = ChatManager.CHAT_GAME_LOADING;
         LayerManager.Instance.clearnGameDynamic();
         RoomManager.Instance.current.selfRoomPlayer.resetCharacter();
         this._roomLoading = new RoomLoadingView(GameManager.Instance.Current);
         if(this._fightLibView)
         {
            if(this._fightLibView.parent)
            {
               this._fightLibView.parent.removeChild(this._fightLibView);
            }
         }
         addChild(this._roomLoading);
         addChild(ChatManager.Instance.view);
         MainToolBar.Instance.hide();
         FightLibManager.Instance.lastInfo = null;
         FightLibManager.Instance.lastFightLibMission = null;
         FightLibManager.Instance.lastWin = false;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.FIGHT_LIB;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         PlayerManager.Instance.Self.isUpGradeInGame = false;
         ObjectUtils.disposeObject(this._fightLibView);
         FightLibManager.Instance.lastInfo = null;
         FightLibManager.Instance.lastWin = false;
         this._fightLibView = null;
         if(this._roomLoading)
         {
            ObjectUtils.disposeObject(this._roomLoading);
            this._roomLoading = null;
         }
         if(param1.getType() != StateType.FIGHT_LIB_GAMEVIEW)
         {
            GameInSocketOut.sendGamePlayerExit();
            RoomManager.Instance.reset();
         }
         PlayerManager.Instance.Self.sendOverTimeListByBody();
      }
   }
}
