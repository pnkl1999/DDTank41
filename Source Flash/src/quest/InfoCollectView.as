package quest
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   
   public class InfoCollectView extends Sprite implements Disposeable
   {
       
      
      public var Type:int = 2;
      
      protected var _dataLabel:FilterFrameText;
      
      protected var _validateLabel:FilterFrameText;
      
      protected var _inputData:FilterFrameText;
      
      protected var _inputValidate:FilterFrameText;
      
      protected var _dataAlert:FilterFrameText;
      
      protected var _valiAlert:FilterFrameText;
      
      private var _submitBtn:IconButton;
      
      private var _sendBtn:IconButton;
      
      public function InfoCollectView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.addLabel();
         this._inputData = ComponentFactory.Instance.creat("core.quest.infoCollect.InputData");
         this._sendBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.infoCollect.SubmitBtn");
         this._sendBtn.y = this._dataLabel.y = this._inputData.y;
         this._dataAlert = ComponentFactory.Instance.creat("core.quest.infoCollect.Alert");
         this._inputValidate = ComponentFactory.Instance.creat("core.quest.infoCollect.InputValidate");
         this._validateLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
         this._validateLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.validate");
         this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.infoCollect.CheckBtn");
         this._submitBtn.y = this._validateLabel.y = this._inputValidate.y;
         this._valiAlert = ComponentFactory.Instance.creat("core.quest.infoCollect.Result");
         addChild(this._inputData);
         addChild(this._dataLabel);
         addChild(this._inputValidate);
         addChild(this._dataAlert);
         addChild(this._validateLabel);
         addChild(this._sendBtn);
         addChild(this._submitBtn);
         addChild(this._valiAlert);
         this._inputData.addEventListener(FocusEvent.FOCUS_OUT,this.__onDataFocusOut);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.__onSendBtn);
         this._submitBtn.addEventListener(MouseEvent.CLICK,this._onSubmitBtn);
         this.modifyView();
      }
      
      protected function modifyView() : void
      {
         this._inputData.restrict = "0-9";
      }
      
      protected function addLabel() : void
      {
         this._dataLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
         this._dataLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.phone");
      }
      
      protected function validate() : void
      {
         this.alert("ddt.quest.collectInfo.validateSend");
      }
      
      protected function __onSendBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._inputData.text.length < 1)
         {
            this.alert("ddt.quest.collectInfo.noPhone");
            return;
         }
         if(this._inputData.text.length > 11)
         {
            this.alert("ddt.quest.collectInfo.phoneNumberError");
            return;
         }
         this.sendData();
      }
      
      protected function _onSubmitBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.sendValidate();
      }
      
      protected function sendData() : void
      {
         var _loc1_:Number = PlayerManager.Instance.Self.ID;
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc2_["selfid"] = _loc1_;
         _loc2_["input"] = this._inputData.text;
         _loc2_["rnd"] = Math.random();
         this.fillArgs(_loc2_);
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("SendActiveKeySystem.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.addEventListener(LoaderEvent.COMPLETE,this.__onDataLoad);
         LoaderManager.Instance.startLoad(_loc3_);
      }
      
      protected function fillArgs(param1:URLVariables) : URLVariables
      {
         param1["phone"] = param1["input"];
         return param1;
      }
      
      private function __onDataLoad(param1:LoaderEvent) : void
      {
         var _loc2_:XML = XML(param1.loader.content);
         var _loc3_:String = _loc2_.@value;
         if(_loc3_ == "true")
         {
         }
         this.dalert(_loc2_.@message);
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
      }
      
      private function __onDataFocusOut(param1:Event) : void
      {
         this.alert(this.updateHelper(this._inputData.text));
      }
      
      protected function updateHelper(param1:String) : String
      {
         if(param1.length > 11)
         {
            return "ddt.quest.collectInfo.phoneNumberError";
         }
         return "";
      }
      
      protected function dalert(param1:String) : void
      {
         this._dataAlert.text = param1;
      }
      
      protected function alert(param1:String) : void
      {
         this._dataAlert.text = LanguageMgr.GetTranslation(param1);
      }
      
      protected function dalertVali(param1:String) : void
      {
         this._valiAlert.text = param1;
      }
      
      protected function alertVali(param1:String) : void
      {
         this._valiAlert.text = LanguageMgr.GetTranslation(param1);
      }
      
      private function sendValidate() : void
      {
         if(this._inputValidate.text.length < 1)
         {
            this.alertVali("ddt.quest.collectInfo.noValidate");
            return;
         }
         if(this._inputValidate.text.length < 6)
         {
            this.alertVali("ddt.quest.collectInfo.validateError");
            return;
         }
         if(this._inputValidate.text.length > 6)
         {
            this.alertVali("ddt.quest.collectInfo.validateError");
            return;
         }
         SocketManager.Instance.out.sendCollectInfoValidate(this.Type,this._inputValidate.text);
      }
      
      public function dispose() : void
      {
         this._inputData.removeEventListener(FocusEvent.FOCUS_OUT,this.__onDataFocusOut);
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.__onSendBtn);
         this._submitBtn.removeEventListener(MouseEvent.CLICK,this._onSubmitBtn);
         ObjectUtils.disposeObject(this._dataLabel);
         this._dataLabel = null;
         ObjectUtils.disposeObject(this._validateLabel);
         this._validateLabel = null;
         ObjectUtils.disposeObject(this._inputData);
         this._inputData = null;
         ObjectUtils.disposeObject(this._inputValidate);
         this._inputValidate = null;
         ObjectUtils.disposeObject(this._valiAlert);
         this._valiAlert = null;
         ObjectUtils.disposeObject(this._submitBtn);
         this._submitBtn = null;
         ObjectUtils.disposeObject(this._sendBtn);
         this._sendBtn = null;
      }
   }
}
