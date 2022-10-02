package farm.viewx.helper
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   
   public class HelperBuyAlertFrame extends BaseAlerFrame
   {
       
      
      private var _bgTilte:DisplayObject;
      
      private var _alertTip:FilterFrameText;
      
      public function HelperBuyAlertFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("ddt.farms.helper.buyTxt");
         _loc1_.bottomGap = 37;
         _loc1_.buttonGape = 65;
         _loc1_.customPos = ComponentFactory.Instance.creat("farm.refreshPetAlertBtnPos");
         this.info = _loc1_;
         moveEnable = false;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bgTilte = ComponentFactory.Instance.creat("assets.farm.titleSmall");
         addChild(this._bgTilte);
         PositionUtils.setPos(this._bgTilte,"farm.refreshPetAlertTitlePos");
         this._alertTip = ComponentFactory.Instance.creatComponentByStylename("farm.text.refreshPetAlertTips");
         addToContent(this._alertTip);
         PositionUtils.setPos(this._alertTip,"farm.helper.alertTipPos");
         this._alertTip.text = LanguageMgr.GetTranslation("ddt.farms.helper.buyTxt1");
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
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
         }
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      override public function dispose() : void
      {
         if(this._bgTilte)
         {
            ObjectUtils.disposeObject(this._bgTilte);
            this._bgTilte = null;
         }
         if(this._alertTip)
         {
            ObjectUtils.disposeObject(this._alertTip);
            this._alertTip = null;
         }
         super.dispose();
      }
   }
}
