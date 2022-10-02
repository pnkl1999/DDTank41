package luckStar
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.net.URLVariables;
   import luckStar.manager.LuckStarManager;
   import luckStar.model.LuckStarRankAnalyzer;
   
   public class LoadingLuckStarUI
   {
      
      private static var _instance:LoadingLuckStarUI;
       
      
      public function LoadingLuckStarUI()
      {
         super();
      }
      
      public static function get Instance() : LoadingLuckStarUI
      {
         if(_instance == null)
         {
            _instance = new LoadingLuckStarUI();
         }
         return _instance;
      }
      
      public function startLoad() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this._onLoadingCloseHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LUCKSTAR);
      }
      
      private function __onLoadComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LUCKSTAR)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._onLoadingCloseHandle);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            this.loadingLuckStarAction();
            LuckStarManager.Instance.openLuckyStarFrame();
         }
      }
      
      private function __onProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LUCKSTAR)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadingLuckStarAction() : void
      {
         if(!ModuleLoader.hasDefinition("luckyStar.view.maxAwardAction"))
         {
            LoaderManager.Instance.creatAndStartLoad(PathManager.getUIPath() + "/swf/luckstaraction.swf",BaseLoader.MODULE_LOADER);
         }
      }
      
      private function _onLoadingCloseHandle(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._onLoadingCloseHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleSmallLoading.Instance.hide();
      }
      
      public function RequestActivityRank() : void
      {
         LoaderManager.Instance.startLoad(this.createRequestLuckyStarActivityRank());
      }
      
      private function createRequestLuckyStarActivityRank() : BaseLoader
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LuckStarActivityRank.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = "请求幸运星模版失败!";
         _loc2_.analyzer = new LuckStarRankAnalyzer(LuckStarManager.Instance.updateLuckyStarRank);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return _loc2_;
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
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,"确定");
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
   }
}
