package civil
{
   import cityWide.CityWideManager;
   import civil.view.CivilRegisterFrame;
   import civil.view.CivilView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.CivilMemberListAnalyze;
   import ddt.data.player.CivilPlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import flash.net.URLVariables;
   
   public class CivilController extends BaseStateView
   {
       
      
      private var _model:CivilModel;
      
      private var _view:CivilView;
      
      private var _register:CivilRegisterFrame;
      
      public function CivilController()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         SocketManager.Instance.out.sendCurrentState(1);
         this.init(param2);
         MainToolBar.Instance.show();
      }
      
      private function init(param1:Boolean = true) : void
      {
         this._model = new CivilModel(param1);
         this.loadCivilMemberList(1,!PlayerManager.Instance.Self.Sex);
         this._model.sex = !PlayerManager.Instance.Self.Sex;
         this._view = new CivilView(this,this._model);
         addChild(this._view);
         CityWideManager.Instance.toSendOpenCityWide();
      }
      
      override public function dispose() : void
      {
         this._model.dispose();
         this._model = null;
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         if(this._register)
         {
            this._register.removeEventListener(Event.COMPLETE,this.__onRegisterComplete);
            this._register.dispose();
            this._register = null;
         }
      }
      
      public function Register() : void
      {
         this._register = ComponentFactory.Instance.creatComponentByStylename("civil.register.CivilRegisterFrame");
         this._register.model = this._model;
         this._register.addEventListener(Event.COMPLETE,this.__onRegisterComplete);
         LayerManager.Instance.addToLayer(this._register,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onRegisterComplete(param1:Event) : void
      {
         this._register.removeEventListener(Event.COMPLETE,this.__onRegisterComplete);
         ObjectUtils.disposeObject(this._register);
         this._register = null;
      }
      
      public function get currentcivilInfo() : CivilPlayerInfo
      {
         if(this._model)
         {
            return this._model.currentcivilItemInfo;
         }
         return null;
      }
      
      public function set currentcivilInfo(param1:CivilPlayerInfo) : void
      {
         if(this._model)
         {
            this._model.currentcivilItemInfo = param1;
         }
      }
      
      public function upLeftView(param1:CivilPlayerInfo) : void
      {
         if(this._model)
         {
            this._model.currentcivilItemInfo = param1;
         }
      }
      
      public function loadCivilMemberList(param1:int = 0, param2:Boolean = true, param3:String = "") : void
      {
         var _loc4_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc4_["page"] = param1;
         _loc4_["name"] = param3;
         _loc4_["sex"] = param2;
         var _loc5_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("MarryInfoPageList.ashx"),BaseLoader.REQUEST_LOADER,_loc4_);
         _loc5_.loadErrorMessage = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.infoError");
         _loc5_.analyzer = new CivilMemberListAnalyze(this.__loadCivilMemberList);
         _loc5_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc5_);
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("aler"),param1.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      private function __loadCivilMemberList(param1:CivilMemberListAnalyze) : void
      {
         if(this._model)
         {
            if(this._model.TotalPage != param1._totalPage)
            {
               this._model.TotalPage = param1._totalPage;
            }
            this._model.civilPlayers = param1.civilMemberList;
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         MainToolBar.Instance.hide();
         super.leaving(param1);
         this.dispose();
      }
      
      override public function getType() : String
      {
         return StateType.CIVIL;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
   }
}
