package lottery
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.utils.RequestVairableCreater;
   import flash.net.URLVariables;
   import lottery.data.LotteryWorldWagerAnalyzer;
   
   public class LotteryManger
   {
       
      
      public function LotteryManger()
      {
         super();
      }
      
      public function setup() : void
      {
      }
      
      public function refreshTotalAmount() : void
      {
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("Casdfsdf.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
         _loc2_.analyzer = new LotteryWorldWagerAnalyzer(this.onLoadCardLotteryInfoComplete);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      private function onLoadCardLotteryInfoComplete(param1:LotteryWorldWagerAnalyzer) : void
      {
         param1.worldWager;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
      }
   }
}
