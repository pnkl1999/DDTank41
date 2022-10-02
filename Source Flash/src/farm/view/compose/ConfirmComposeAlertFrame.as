package farm.view.compose
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
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import trainer.data.ArrowType;
   
   public class ConfirmComposeAlertFrame extends BaseAlerFrame
   {
      
      private static const MaxNum:int = 999;
       
      
      private var _minBtn:BaseButton;
      
      private var _maxBtn:BaseButton;
      
      private var _addBtn:BaseButton;
      
      private var _removeBtn:BaseButton;
      
      private var _inputNumBg:DisplayObject;
      
      private var _inputTxt:FilterFrameText;
      
      private var _inputNum:int = 1;
      
      private var _bgTitle:DisplayObject;
      
      public function ConfirmComposeAlertFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("ddt.farms.composeComfirmNumPnlTitle");
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
         this._inputNumBg = ComponentFactory.Instance.creat("farmHouse.confimCompose.inputBG");
         addToContent(this._inputNumBg);
         this._inputTxt = ComponentFactory.Instance.creat("farmHouse.text.composeNum");
         addToContent(this._inputTxt);
         this._inputTxt.restrict = "0-9";
         this._inputTxt.text = this._inputNum.toString();
         this._minBtn = ComponentFactory.Instance.creat("farmHouse.houseCompose.minBtn");
         addToContent(this._minBtn);
         this._maxBtn = ComponentFactory.Instance.creat("farmHouse.houseCompose.maxBtn");
         addToContent(this._maxBtn);
         this._addBtn = ComponentFactory.Instance.creat("farmHouse.houseCompose.addBtn");
         addToContent(this._addBtn);
         this._removeBtn = ComponentFactory.Instance.creat("farmHouse.houseCompose.removeBtn");
         addToContent(this._removeBtn);
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CLICK_COOK_BTN);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._inputTxt.addEventListener(Event.CHANGE,this.__inputCheck);
         this._minBtn.addEventListener(MouseEvent.CLICK,this.__changeInputNumber);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.__changeInputNumber);
         this._addBtn.addEventListener(MouseEvent.CLICK,this.__changeInputNumber);
         this._removeBtn.addEventListener(MouseEvent.CLICK,this.__changeInputNumber);
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.COMPOSE_COUNT,this._inputTxt.text));
         }
         this.dispose();
      }
      
      private function __inputCheck(param1:Event) : void
      {
         this._inputNum = int(this._inputTxt.text);
         if(this._inputNum > MaxNum)
         {
            this._inputNum = MaxNum;
         }
         else if(this._inputNum < 1)
         {
            this._inputNum = 1;
         }
         this._inputTxt.text = String(this._inputNum);
      }
      
      private function checkInput() : void
      {
         if(this._inputNum > MaxNum)
         {
            this._inputNum = MaxNum;
         }
         else if(this._inputNum < 1)
         {
            this._inputNum = 1;
         }
         this._inputTxt.text = this._inputNum.toString();
      }
      
      private function __changeInputNumber(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this._maxBtn:
               this._inputNum = MaxNum;
               break;
            case this._minBtn:
               this._inputNum = 1;
               break;
            case this._addBtn:
               ++this._inputNum;
               break;
            case this._removeBtn:
               --this._inputNum;
         }
         this.checkInput();
      }
      
      public function set maxCount(param1:int) : void
      {
         this._inputNum = param1;
         this._inputTxt.text = this._inputNum.toString();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         this._inputTxt.removeEventListener(Event.CHANGE,this.__inputCheck);
         this._minBtn.removeEventListener(MouseEvent.CLICK,this.__changeInputNumber);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.__changeInputNumber);
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.__changeInputNumber);
         this._removeBtn.removeEventListener(MouseEvent.CLICK,this.__changeInputNumber);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._inputNum = 1;
         if(this._minBtn)
         {
            ObjectUtils.disposeObject(this._minBtn);
            this._minBtn = null;
         }
         if(this._inputTxt)
         {
            ObjectUtils.disposeObject(this._inputTxt);
            this._inputTxt = null;
         }
         if(this._inputNumBg)
         {
            ObjectUtils.disposeObject(this._inputNumBg);
            this._inputNumBg = null;
         }
         if(this._removeBtn)
         {
            ObjectUtils.disposeObject(this._removeBtn);
            this._removeBtn = null;
         }
         if(this._addBtn)
         {
            ObjectUtils.disposeObject(this._addBtn);
            this._addBtn = null;
         }
         if(this._maxBtn)
         {
            ObjectUtils.disposeObject(this._maxBtn);
            this._maxBtn = null;
         }
         super.dispose();
      }
   }
}
