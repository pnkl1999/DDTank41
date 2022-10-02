package store
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import store.analyze.StrengthenDataAnalyzer;
   import store.events.StoreIIEvent;
   
   public class StrengthDataManager extends EventDispatcher
   {
      
      private static var _instance:StrengthDataManager;
      
      public static const FUSIONFINISH:String = "fusionFinish";
       
      
      public var _strengthData:Vector.<Dictionary>;
      
      public var autoFusion:Boolean;
      
      public function StrengthDataManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this.loadStrengthenLevel();
      }
      
      public static function get instance() : StrengthDataManager
      {
         if(_instance == null)
         {
            _instance = new StrengthDataManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
      }
      
      private function loadStrengthenLevel() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ItemStrengthenData.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("store.view.fusion.LoadStrengthenListError");
         _loc1_.analyzer = new StrengthenDataAnalyzer(this.__searchResult);
         LoaderManager.Instance.startLoad(_loc1_);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
      }
      
      private function __searchResult(param1:StrengthenDataAnalyzer) : void
      {
         this._strengthData = param1._strengthData;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),param1.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function getRecoverDongAddition(param1:int, param2:int) : Number
      {
         return this._strengthData[param2][param1];
      }
      
      public function fusionFinish() : void
      {
         dispatchEvent(new Event(FUSIONFINISH));
      }
      
      public function exaltFinish() : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.EXALT_FINISH));
      }
      
      public function exaltFail(param1:int = 0) : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.EXALT_FAIL,param1));
      }
   }
}
