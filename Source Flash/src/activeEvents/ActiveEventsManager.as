package activeEvents
{
   import activeEvents.analyze.ActiveEventsAnalyzer;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   
   public class ActiveEventsManager
   {
      
      private static var _instance:ActiveEventsManager;
       
      
      private var _model:ActiveEventsModel;
      
      public function ActiveEventsManager()
      {
         super();
         this._model = new ActiveEventsModel();
      }
      
      public static function get Instance() : ActiveEventsManager
      {
         if(_instance == null)
         {
            _instance = new ActiveEventsManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActiveList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadingActivityInformationFailure");
         _loc1_.analyzer = new ActiveEventsAnalyzer(this.setupActiveEventsnfo);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      public function setupActiveEventsnfo(param1:ActiveEventsAnalyzer) : void
      {
         this._model.actives = param1.list;
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
      
      public function get model() : ActiveEventsModel
      {
         return this._model;
      }
   }
}
