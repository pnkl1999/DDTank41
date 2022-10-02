package ddt.view.common.church
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.utils.StringHelper;
   
   public class ChurchProposeResponseFrame extends BaseAlerFrame
   {
       
      
      private var _spouseID:int;
      
      private var _spouseName:String;
      
      private var _love:String;
      
      private var _bg:Bitmap;
      
      private var _loveTxt:TextArea;
      
      private var _answerId:int;
      
      private var _name_txt:FilterFrameText;
      
      private var _btnLookEquip:BaseButton;
      
      private var _alertInfo:AlertInfo;
      
      public function ChurchProposeResponseFrame()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.titleText");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("accept");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("refuse");
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.ProposeResponseAsset");
         addToContent(this._bg);
         this._name_txt = ComponentFactory.Instance.creat("common.church.txtChurchProposeResponseAsset");
         addToContent(this._name_txt);
         this._btnLookEquip = ComponentFactory.Instance.creat("common.church.btnLookEquipAsset");
         this._btnLookEquip.addEventListener(MouseEvent.CLICK,this.__lookEquip);
         addToContent(this._btnLookEquip);
         this._loveTxt = ComponentFactory.Instance.creat("common.church.txtChurchProposeResponseMsgAsset");
         addToContent(this._loveTxt);
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.__cancel();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               this.confirmSubmit();
         }
      }
      
      public function get answerId() : int
      {
         return this._answerId;
      }
      
      public function set answerId(param1:int) : void
      {
         this._answerId = param1;
      }
      
      public function get love() : String
      {
         return this._love;
      }
      
      public function set love(param1:String) : void
      {
         this._love = param1;
         this._loveTxt.text = !!Boolean(this._love) ? this._love : "";
      }
      
      public function get spouseName() : String
      {
         return this._spouseName;
      }
      
      public function set spouseName(param1:String) : void
      {
         this._spouseName = param1;
         this._name_txt.text = this._spouseName + LanguageMgr.GetTranslation("ddt.view.common.church.ProposeResponse");
      }
      
      public function get spouseID() : int
      {
         return this._spouseID;
      }
      
      public function set spouseID(param1:int) : void
      {
         this._spouseID = param1;
      }
      
      private function __lookEquip(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerInfoViewControl.viewByID(this.spouseID);
      }
      
      private function confirmSubmit() : void
      {
         SocketManager.Instance.out.sendProposeRespose(true,this.spouseID,this.answerId);
         this.dispose();
      }
      
      private function __cancel() : void
      {
         SocketManager.Instance.out.sendProposeRespose(false,this.spouseID,this.answerId);
         var _loc1_:String = StringHelper.rePlaceHtmlTextField(LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.msg",this.spouseName));
         ChatManager.Instance.sysChatRed(_loc1_);
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._loveTxt = null;
         ObjectUtils.disposeObject(this._name_txt);
         this._name_txt = null;
         ObjectUtils.disposeObject(this._btnLookEquip);
         this._btnLookEquip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}
