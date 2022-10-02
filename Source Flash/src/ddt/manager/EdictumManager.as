package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.analyze.LoadEdictumAnalyze;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.edictum.EdictumFrame;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class EdictumManager extends EventDispatcher
   {
      
      private static var _instance:EdictumManager;
       
      
      private var unShowArr:Array;
      
      private var edictumDataList:DictionaryData;
      
      public function EdictumManager(param1:IEventDispatcher = null)
      {
         this.unShowArr = new Array();
         super();
      }
      
      public static function get Instance() : EdictumManager
      {
         if(_instance == null)
         {
            _instance = new EdictumManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EDICTUM_GET_VERSION,this.__getEdictumVersion);
      }
      
      private function __getEdictumVersion(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_.push(_loc2_.readInt());
            _loc5_++;
         }
         this.__checkVersion(_loc4_);
      }
      
      private function __checkVersion(param1:Array) : void
      {
         var _loc2_:String = SharedManager.Instance.edictumVersion;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(_loc2_.indexOf(param1[_loc4_].toString()) != -1)
            {
               _loc3_.push(param1[_loc4_]);
            }
            else
            {
               this.unShowArr.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         SharedManager.Instance.edictumVersion = _loc3_.join("|");
         if(this.unShowArr.length > 0)
         {
            this.__loadEdictumData();
         }
      }
      
      private function __loadEdictumData() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoaderOriginal(this.__getURL(),BaseLoader.REQUEST_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         _loc1_.analyzer = new LoadEdictumAnalyze(this.__returnWebSiteInfoHandler);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      private function __returnWebSiteInfoHandler(param1:LoadEdictumAnalyze) : void
      {
         this.edictumDataList = param1.edictumDataList;
         this.showEdictum();
      }
      
      private function __getURL() : String
      {
         return PathManager.solveRequestPath("GMTipAllByIDs.ashx?ids=" + this.unShowArr.join(","));
      }
      
      public function showEdictum() : void
      {
         if(this.unShowArr.length == 0 || this.edictumDataList == null || this.edictumDataList[this.unShowArr[0]] == null || StateManager.currentStateType != StateType.MAIN)
         {
            return;
         }
         var _loc1_:EdictumFrame = ComponentFactory.Instance.creatComponentByStylename("edictum.EdictumFrame");
         var _loc2_:int = this.unShowArr.shift();
         _loc1_.data = this.edictumDataList[_loc2_];
         SharedManager.Instance.edictumVersion = SharedManager.Instance.edictumVersion + "," + _loc2_;
         _loc1_.show();
      }
   }
}
