package tofflist
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.net.URLVariables;
   import tofflist.analyze.TofflistListAnalyzer;
   import tofflist.analyze.TofflistListTwoAnalyzer;
   import tofflist.view.TofflistView;
   import trainer.data.Step;
   
   public class TofflistController extends BaseStateView
   {
       
      
      private var _container:Sprite;
      
      private var _view:TofflistView;
      
      private var _temporaryTofflistListData:String;
      
      public function TofflistController()
      {
         super();
      }
      
      private function init() : void
      {
         this._container = new Sprite();
         this._view = new TofflistView(this);
         this._container.addChild(this._view);
         this.loadFormData("personalBattleAccumulate","CelebByDayFightPowerList.xml","personal");
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this.init();
         this._view.addEvent();
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VISIT_TOFF_LIST) && TaskManager.getQuestDataByID(358))
         {
            SocketManager.Instance.out.sendQuestCheck(358,1,0);
            SocketManager.Instance.out.syncWeakStep(Step.VISIT_TOFF_LIST);
         }
         if(TofflistModel.Instance.rankInfo == null)
         {
            TofflistModel.Instance.loadRankInfo();
         }
      }
      
      override public function getView() : DisplayObject
      {
         return this._container;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         super.leaving(param1);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.TOFFLIST;
      }
      
      public function loadFormData(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:DataAnalyzer = null;
         this._temporaryTofflistListData = param1;
         if(!TofflistModel.Instance[this._temporaryTofflistListData])
         {
            if(param3 == "personal")
            {
               _loc4_ = new TofflistListTwoAnalyzer(this.__personalResult);
            }
            else if(param3 == "sociaty")
            {
               _loc4_ = new TofflistListAnalyzer(this.__sociatyResult);
            }
            this._loadXml(param2,_loc4_,BaseLoader.COMPRESS_TEXT_LOADER);
         }
         else
         {
            TofflistModel.Instance[this._temporaryTofflistListData] = TofflistModel.Instance[this._temporaryTofflistListData];
         }
      }
      
      private function __personalResult(param1:TofflistListTwoAnalyzer) : void
      {
         TofflistModel.Instance[this._temporaryTofflistListData] = param1.data;
      }
      
      private function __sociatyResult(param1:TofflistListAnalyzer) : void
      {
         TofflistModel.Instance[this._temporaryTofflistListData] = param1.data;
      }
      
      public function clearDisplayContent() : void
      {
         this._view.clearDisplayContent();
      }
      
      public function loadList(param1:int) : void
      {
      }
      
      private function _loadXml(param1:String, param2:DataAnalyzer, param3:int, param4:String = "") : void
      {
         this._view.rightView.gridBox.orderList.clearList();
         var _loc5_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loc6_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath(param1),param3,_loc5_);
         _loc6_.loadErrorMessage = param4;
         _loc6_.analyzer = param2;
         LoaderManager.Instance.startLoad(_loc6_);
      }
   }
}
