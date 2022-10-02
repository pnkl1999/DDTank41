package giftSystem
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.RequestVairableCreater;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.URLVariables;
   import giftSystem.analyze.RecordAnalyzer;
   import giftSystem.data.RecordInfo;
   import giftSystem.view.ClearingInterface;
   
   public class GiftController extends EventDispatcher
   {
      
      public static const RECEIVEDPATH:String = "GiftRecieveLog.ashx";
      
      public static const SENDEDPATH:String = "GiftSendLog.ashx";
      
      private static var _instance:GiftController;
       
      
      private var _recordInfo:RecordInfo;
      
      private var _rebackName:String = "";
      
      private var _alertFrame:BaseAlerFrame;
      
      private var _canActive:Boolean;
      
      private var _path:String;
      
      private var _inChurch:Boolean;
      
      private var _CI:ClearingInterface;
      
      public function GiftController(param1:IEventDispatcher = null)
      {
         super(param1);
         this.initEvent();
      }
      
      public static function get Instance() : GiftController
      {
         if(_instance == null)
         {
            _instance = new GiftController();
         }
         return _instance;
      }
      
      public function get canActive() : Boolean
      {
         return this._canActive;
      }
      
      public function set canActive(param1:Boolean) : void
      {
         this._canActive = param1;
      }
      
      public function get inChurch() : Boolean
      {
         return this._inChurch;
      }
      
      public function set inChurch(param1:Boolean) : void
      {
         this._inChurch = param1;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_SEND_GIFTS,this.__sendStatus);
         BagAndInfoManager.Instance.addEventListener(Event.CLOSE,this.__bagCloseHandler);
      }
      
      private function __sendStatus(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            this.loadRecord(SENDEDPATH,PlayerManager.Instance.Self.ID);
         }
         dispatchEvent(new GiftEvent(GiftEvent.SEND_GIFT_RETURN,_loc2_.toString()));
      }
      
      public function loadRecord(param1:String, param2:int) : void
      {
         this._path = param1;
         var _loc3_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc3_["userID"] = param2;
         var _loc4_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath(param1),BaseLoader.COMPRESS_REQUEST_LOADER,_loc3_);
         _loc4_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.giftSystem.loadRecord.error");
         _loc4_.analyzer = new RecordAnalyzer(this.__setupRecord);
         _loc4_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(_loc4_);
      }
      
      public function get recordInfo() : RecordInfo
      {
         return this._recordInfo;
      }
      
      private function __setupRecord(param1:RecordAnalyzer) : void
      {
         this._recordInfo = param1.info;
         dispatchEvent(new GiftEvent(GiftEvent.LOAD_RECORD_COMPLETE,this._path));
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
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function get rebackName() : String
      {
         return this._rebackName;
      }
      
      public function set rebackName(param1:String) : void
      {
         if(this._rebackName == param1)
         {
            return;
         }
         this._rebackName = param1;
      }
      
      public function RebackClick(param1:String) : void
      {
         this.rebackName = param1;
         this._alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.giftSystem.RebackMenu.alert",this.rebackName),LanguageMgr.GetTranslation("ok"),"",false,true,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alertFrame.addEventListener(FrameEvent.RESPONSE,this.__responsehandler);
      }
      
      private function __responsehandler(param1:FrameEvent) : void
      {
         if(this._alertFrame)
         {
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__responsehandler);
            this._alertFrame.dispose();
            this._alertFrame = null;
            dispatchEvent(new GiftEvent(GiftEvent.REBACK_GIFT));
         }
      }
      
      public function openClearingInterface(param1:ShopItemInfo) : void
      {
         this._CI = null;
         this._CI = ComponentFactory.Instance.creatComponentByStylename("ClearingInterface");
         this._CI.setName(this._rebackName);
         this._CI.info = param1;
         LayerManager.Instance.addToLayer(this._CI,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __bagCloseHandler(param1:Event) : void
      {
         if(this._alertFrame)
         {
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__responsehandler);
            this._alertFrame.dispose();
            this._alertFrame = null;
         }
      }
   }
}
