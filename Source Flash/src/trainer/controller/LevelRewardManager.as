package trainer.controller
{
   import com.pickgliss.action.AlertAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.analyze.LevelRewardAnalyzer;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.utils.Dictionary;
   //import trainer.TrainStep;
   import trainer.data.LevelRewardInfo;
   import trainer.data.Step;
   import trainer.view.LevelRewardFrame;
   import trainer.view.SecondOnlineView;
   
   public class LevelRewardManager
   {
      
      private static var _instance:LevelRewardManager;
       
      
      public var _isShow:Boolean;
      
      private var _reward:Dictionary;
      
      private var _fr:LevelRewardFrame;
      
      public function LevelRewardManager()
      {
         super();
      }
      
      public static function get Instance() : LevelRewardManager
      {
         if(_instance == null)
         {
            _instance = new LevelRewardManager();
         }
         return _instance;
      }
      
      public function get isShow() : Boolean
      {
         return this._isShow;
      }
      
      public function set isShow(param1:Boolean) : void
      {
         this._isShow = param1;
      }
      
      public function setup() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.getLevelRewardPath(),BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = "load levelRewards Failed";
         _loc1_.analyzer = new LevelRewardAnalyzer(this.onDataComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc1_);
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
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      private function onDataComplete(param1:LevelRewardAnalyzer) : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         this._reward = param1.list;
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onChange);
      }
      
/*      private function __onChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpGrade)
         {
            if(PlayerManager.Instance.Self.Grade == 6)
            {
               this.showSecFrame();
            }
            switch(PlayerManager.Instance.Self.Grade)
            {
               case 2:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_2);
                  break;
               case 3:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_3);
                  break;
               case 4:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_4);
                  break;
               case 5:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_5);
                  break;
               case 6:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_6);
                  break;
               case 7:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_7);
                  break;
               case 8:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_8);
                  break;
               case 9:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_9);
                  break;
               case 10:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_10);
                  break;
               case 15:
                  TrainStep.send(TrainStep.Step.PLAYER_GRAD_15);
            }
            this.showFrame(PlayerManager.Instance.Self.Grade);
         }
      }
*/
	  private function __onChange(param1:PlayerPropertyEvent) : void
	  {
		  if(param1.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpGrade)
		  {
			  if(PlayerManager.Instance.Self.Grade == 6)
			  {
				  showSecFrame();
			  }
			  showFrame(PlayerManager.Instance.Self.Grade);
		  }
	  }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.hide();
      }
      
      public function getRewardInfo(param1:int, param2:int) : LevelRewardInfo
      {
         return this._reward[param1][param2];
      }
      
      public function showSecFrame() : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         var _loc1_:SecondOnlineView = ComponentFactory.Instance.creat("trainer.second.mainFrame");
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(_loc1_,LayerManager.GAME_UI_LAYER,LayerManager.ALPHA_BLOCKGOUND));
         }
         else
         {
            _loc1_.show();
         }
      }
      
      public function showFrame(param1:int) : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.Grade == 1 || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         this._fr = ComponentFactory.Instance.creatCustomObject("trainer.welcome.levelRewardFrame");
         this._fr.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            this._fr.level = param1;
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(this._fr,LayerManager.GAME_UI_LAYER,LayerManager.ALPHA_BLOCKGOUND));
         }
         else
         {
            this._fr.level = param1;
            this._fr.show(param1);
            this.isShow = true;
         }
      }
      
      public function hide() : void
      {
         if(this._fr)
         {
            this._fr.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this._fr.hide();
            this._fr = null;
            this.isShow = false;
         }
      }
   }
}
