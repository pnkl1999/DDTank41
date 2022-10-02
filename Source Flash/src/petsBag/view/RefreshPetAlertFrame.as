package petsBag.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class RefreshPetAlertFrame extends BaseAlerFrame
   {
       
      
      private var _bgTitle:DisplayObject;
      
      private var _alertTips:FilterFrameText;
      
      private var _alertTips2:FilterFrameText;
      
      private var _refreshSelBtn:SelectedCheckButton;
      
      public function RefreshPetAlertFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("ddt.farms.refreshPetsAlert");
         _loc1_.bottomGap = 37;
         _loc1_.buttonGape = 65;
         _loc1_.customPos = ComponentFactory.Instance.creat("farm.refreshPetAlertBtnPos");
         this.info = _loc1_;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bgTitle = ComponentFactory.Instance.creat("assets.farm.titleSmall");
         addChild(this._bgTitle);
         PositionUtils.setPos(this._bgTitle,PositionUtils.creatPoint("farm.refreshPetAlertTitlePos"));
         this._alertTips = ComponentFactory.Instance.creatComponentByStylename("farm.text.refreshPetAlertTips");
         addToContent(this._alertTips);
         this._alertTips2 = ComponentFactory.Instance.creatComponentByStylename("farm.text.refreshPetAlertTips2");
         addToContent(this._alertTips2);
         this._alertTips.text = LanguageMgr.GetTranslation("ddt.farms.refreshPetsAlertContonet");
         this._alertTips2.text = String(PetconfigAnalyzer.PetCofnig.AdoptRefereshCost) + LanguageMgr.GetTranslation("money");
         this._refreshSelBtn = ComponentFactory.Instance.creatComponentByStylename("farm.refreshPet.selectBtn");
         addToContent(this._refreshSelBtn);
         this._refreshSelBtn.text = LanguageMgr.GetTranslation("ddt.farms.refreshPetsNOAlert");
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._refreshSelBtn.addEventListener(Event.SELECT,this.__noAlertTip);
      }
      
      private function __noAlertTip(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.isRefreshPet = this._refreshSelBtn.selected;
         SharedManager.Instance.isRefreshBand = false;
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
               return;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      override public function dispose() : void
      {
         if(this._bgTitle)
         {
            ObjectUtils.disposeObject(this._bgTitle);
            this._bgTitle = null;
         }
         if(this._refreshSelBtn)
         {
            ObjectUtils.disposeObject(this._refreshSelBtn);
            this._refreshSelBtn = null;
         }
         if(this._alertTips2)
         {
            ObjectUtils.disposeObject(this._alertTips2);
            this._alertTips2 = null;
         }
         if(this._alertTips)
         {
            ObjectUtils.disposeObject(this._alertTips);
            this._alertTips = null;
         }
         super.dispose();
      }
   }
}
