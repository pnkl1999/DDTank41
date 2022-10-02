package login
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.loader.RequestLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.LoginAnalyzer;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SelectListManager;
   import ddt.manager.ServerManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.CrytoUtils;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.character.BaseLightLayer;
   import ddt.view.character.ILayer;
   import ddt.view.character.LayerFactory;
   import ddt.view.character.ShowCharacterLoader;
   import ddt.view.character.SinpleLightLayer;
   import flash.events.Event;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import login.view.ChooseRoleFrame;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   
   public class LoginStateView extends BaseStateView
   {
      
      private static var w:String = "abcdefghijklmnopqrstuvwxyz";
       
      
      public function LoginStateView()
      {
         super();
      }
      
      public static function creatLoginLoader(param1:String, param2:Function) : RequestLoader
      {
         var _loc3_:AccountInfo = PlayerManager.Instance.Account;
         var _loc4_:Date = new Date();
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeShort(_loc4_.fullYearUTC);
         _loc5_.writeByte(_loc4_.monthUTC + 1);
         _loc5_.writeByte(_loc4_.dateUTC);
         _loc5_.writeByte(_loc4_.hoursUTC);
         _loc5_.writeByte(_loc4_.minutesUTC);
         _loc5_.writeByte(_loc4_.secondsUTC);
         var _loc6_:String = "";
         var _loc7_:int = 0;
         while(_loc7_ < 6)
         {
            _loc6_ += w.charAt(int(Math.random() * 26));
            _loc7_++;
         }
         _loc5_.writeUTFBytes(_loc3_.Account + "," + _loc3_.Password + "," + _loc6_ + "," + param1);
         var _loc8_:String = CrytoUtils.rsaEncry4(_loc3_.Key,_loc5_);
         var _loc9_:URLVariables = RequestVairableCreater.creatWidthKey(false);
         _loc9_["p"] = _loc8_;
         _loc9_["v"] = Version.Build;
         _loc9_["site"] = PathManager.solveConfigSite();
         _loc9_["rid"] = PlayerManager.Instance.Self.rid;
         var _loc10_:RequestLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("Login.ashx"),BaseLoader.REQUEST_LOADER,_loc9_);
         _loc10_.addEventListener(LoaderEvent.LOAD_ERROR,__onLoadLoginError);
         var _loc11_:LoginAnalyzer = new LoginAnalyzer(param2);
         _loc11_.tempPassword = _loc6_;
         _loc10_.analyzer = _loc11_;
         return _loc10_;
      }
      
      private static function __onLoadLoginError(param1:LoaderEvent) : void
      {
         LeavePageManager.leaveToLoginPurely();
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(param1.loader.analyzer)
         {
            _loc2_ = (param1.loader.loadErrorMessage == null ? "" : param1.loader.loadErrorMessage + "\n") + param1.loader.analyzer.message;
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert("Alerta：",_loc2_,"Đồng ý");
         _loc3_.addEventListener(FrameEvent.RESPONSE,__onAlertResponse);
      }
      
      private static function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      private static function onLoginComplete(param1:LoginAnalyzer) : void
      {
         var _loc2_:ShowCharacterLoader = new ShowCharacterLoader(PlayerManager.Instance.Self);
         _loc2_.needMultiFrames = false;
         _loc2_.setFactory(LayerFactory.instance);
         _loc2_.load(onPreLoadComplete);
         var _loc3_:BaseLightLayer = new BaseLightLayer(PlayerManager.Instance.Self.Nimbus);
         _loc3_.load(onLayerComplete);
         var _loc4_:SinpleLightLayer = new SinpleLightLayer(PlayerManager.Instance.Self.Nimbus);
         _loc4_.load(onLayerComplete);
         if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            StartupResourceLoader.Instance.addEventListener(StartupResourceLoader.USER_GUILD_RESOURCE_COMPLETE,onUserGuildResourceComplete);
            StartupResourceLoader.Instance.addUserGuildResource();
         }
         else if(ServerManager.Instance.canAutoLogin())
         {
            ServerManager.Instance.connentCurrentServer();
         }
         else
         {
            StartupResourceLoader.Instance.finishLoadingProgress();
         }
      }
      
      private static function onUserGuildResourceComplete(param1:Event) : void
      {
         StartupResourceLoader.Instance.removeEventListener(StartupResourceLoader.USER_GUILD_RESOURCE_COMPLETE,onUserGuildResourceComplete);
         if(ServerManager.Instance.canAutoLogin())
         {
            ServerManager.Instance.connentCurrentServer();
         }
         else
         {
            StartupResourceLoader.Instance.finishLoadingProgress();
         }
      }
      
      private static function onLayerComplete(param1:ILayer) : void
      {
         param1.dispose();
      }
      
      private static function onPreLoadComplete(param1:ShowCharacterLoader) : void
      {
         param1.destory();
      }
      
      override public function getType() : String
      {
         return StateType.LOGIN;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         if(SelectListManager.Instance.mustShowSelectWindow)
         {
            this.loadLoginRes();
         }
         else
         {
            this.loginCurrentRole();
         }
      }
      
      private function __onShareAlertResponse(param1:FrameEvent) : void
      {
         LoaderSavingManager.loadFilesInLocal();
         if(LoaderSavingManager.ReadShareError)
         {
            MessageTipManager.getInstance().show("请清除缓存后再重新登录");
         }
         else
         {
            LeavePageManager.leaveToLoginPath();
         }
      }
      
      private function loadLoginRes() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoginResComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onLoginResError);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LOGIN);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoginResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onLoginResError);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onLoginResComplete(param1:UIModuleEvent) : void
      {
         var _loc2_:ChooseRoleFrame = null;
         if(param1.module == UIModuleTypes.LOGIN)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoginResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onLoginResError);
            UIModuleSmallLoading.Instance.hide();
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ChooseRoleFrame");
            _loc2_.addEventListener(Event.COMPLETE,this.__onChooseRoleComplete);
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
      }
      
      private function __onLoginResError(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoginResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onLoginResError);
      }
      
      private function loginCurrentRole() : void
      {
         var _loc1_:RequestLoader = creatLoginLoader(SelectListManager.Instance.currentLoginRole.NickName,onLoginComplete);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      private function __onChooseRoleComplete(param1:Event) : void
      {
         var _loc2_:ChooseRoleFrame = param1.currentTarget as ChooseRoleFrame;
         _loc2_.removeEventListener(Event.COMPLETE,this.__onChooseRoleComplete);
         _loc2_.dispose();
         this.loginCurrentRole();
      }
   }
}
