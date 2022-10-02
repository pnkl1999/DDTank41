package ddt.view.common.church
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class ChurchDialogueAgreePropose extends BaseAlerFrame
   {
       
      
      private var _bg:Bitmap;
      
      public var isShowed:Boolean = true;
      
      private var _alertInfo:AlertInfo;
      
      private var _msgInfo:String;
      
      private var _name_txt:FilterFrameText;
      
      public function ChurchDialogueAgreePropose()
      {
         super();
         this.initialize();
      }
      
      public function get msgInfo() : String
      {
         return this._msgInfo;
      }
      
      public function set msgInfo(param1:String) : void
      {
         this._msgInfo = param1;
         this._name_txt.text = this._msgInfo;
         this.isShowed = false;
      }
      
      private function initialize() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.titleText");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("tank.view.common.church.DialogueAgreePropose.okLabel");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("tank.view.common.church.DialogueAgreePropose.cancelLabel");
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.AgreeProposeAsset");
         addToContent(this._bg);
         this._name_txt = ComponentFactory.Instance.creat("common.church.churchDialogueAgreeProposeUserNameAsset");
         this._name_txt.width = 120;
         addToContent(this._name_txt);
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
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               this.confirmSubmit();
         }
      }
      
      private function confirmSubmit() : void
      {
         SoundManager.instance.play("008");
         StateManager.setState(StateType.CHURCH_ROOM_LIST);
         this.dispose();
      }
      
      public function show() : void
      {
         SoundManager.instance.play("018");
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.isShowed = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._alertInfo = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._name_txt);
         this._name_txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}
