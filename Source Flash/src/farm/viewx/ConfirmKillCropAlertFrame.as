package farm.viewx
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.view.compose.event.SelectComposeItemEvent;
   import flash.display.DisplayObject;
   
   public class ConfirmKillCropAlertFrame extends BaseAlerFrame
   {
       
      
      private var _addBtn:BaseButton;
      
      private var _removeBtn:BaseButton;
      
      private var _msgTxt:FilterFrameText;
      
      private var _bgTitle:DisplayObject;
      
      private var _cropName:String;
      
      private var _fieldId:int = -1;
      
      public function ConfirmKillCropAlertFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("ddt.farms.killCropComfirmNumPnlTitle");
         _loc1_.bottomGap = 37;
         _loc1_.buttonGape = 65;
         _loc1_.customPos = ComponentFactory.Instance.creat("farm.confirmComposeAlertBtnPos");
         this.info = _loc1_;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bgTitle = ComponentFactory.Instance.creat("assets.farm.titleSmall");
         addChild(this._bgTitle);
         PositionUtils.setPos(this._bgTitle,PositionUtils.creatPoint("farm.confirmComposeAlertTitlePos"));
         this._msgTxt = ComponentFactory.Instance.creat("farm.killCrop.msgtext");
         addToContent(this._msgTxt);
      }
      
      public function cropName(param1:String, param2:Boolean = false) : void
      {
         this._cropName = param1;
         if(param2)
         {
            this._msgTxt.text = LanguageMgr.GetTranslation("ddt.farms.comfirmKillCropMsg2",this._cropName);
         }
         else
         {
            this._msgTxt.text = LanguageMgr.GetTranslation("ddt.farms.comfirmKillCropMsg",this._cropName);
         }
      }
      
      public function set fieldId(param1:int) : void
      {
         this._fieldId = param1;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.KILLCROP_CLICK,this._fieldId));
               break;
            case FrameEvent.CLOSE_CLICK:
               break;
            case FrameEvent.CANCEL_CLICK:
         }
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._msgTxt)
         {
            ObjectUtils.disposeObject(this._msgTxt);
            this._msgTxt = null;
         }
         super.dispose();
      }
   }
}
