package petsBag.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.utils.StringHelper;
   
   public class RePetNameFrame extends BaseAlerFrame
   {
      
      public static const RENAME_NEED_MONEY:int = 1900;
       
      
      protected var _inputBackground:DisplayObject;
      
      private var _alertInfo:AlertInfo;
      
      private var _inputText:FilterFrameText;
      
      private var _inputLbl:FilterFrameText;
      
      private var _alertTxt:FilterFrameText;
      
      private var _alertTxt2:FilterFrameText;
      
      private var _petName:String = "";
      
      public function RePetNameFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get petName() : String
      {
         return this._petName;
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.pets.rePetNameTitle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._inputBackground = ComponentFactory.Instance.creat("petsBag.repetName.inputBG");
         this._inputText = ComponentFactory.Instance.creat("petsBag.text.inputPetName");
         this._alertTxt = ComponentFactory.Instance.creat("petsBag.text.rePetNameAlert");
         this._alertTxt2 = ComponentFactory.Instance.creat("petsBag.text.rePetNameAlert2");
         this._inputLbl = ComponentFactory.Instance.creat("petsBag.text.inputPetNameLbl");
         addToContent(this._inputLbl);
         addToContent(this._inputBackground);
         addToContent(this._inputText);
         addToContent(this._alertTxt);
         addToContent(this._alertTxt2);
         this._inputLbl.text = LanguageMgr.GetTranslation("ddt.pets.reInputPetName");
         this._alertTxt.text = LanguageMgr.GetTranslation("ddt.pets.rePetNameAlertContonet");
         this._alertTxt2.text = RENAME_NEED_MONEY.toString();
      }
      
      private function initEvent() : void
      {
         this._inputText.addEventListener(Event.CHANGE,this.__inputChange);
         addEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
      }
      
      private function removeEvent() : void
      {
         this._inputText.removeEventListener(Event.CHANGE,this.__inputChange);
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
      }
      
      private function __getFocus(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         this._inputText.setFocus();
      }
      
      override protected function __onSubmitClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.nameInputCheck())
         {
            this._petName = this._inputText.text;
            super.__onSubmitClick(param1);
            return;
         }
      }
      
      override protected function __onCancelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         super.__onCancelClick(param1);
         this.dispose();
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         super.__onCloseClick(param1);
         this.dispose();
      }
      
      private function __inputChange(param1:Event) : void
      {
         StringHelper.checkTextFieldLength(this._inputText,14);
      }
      
      private function getStrActualLen(param1:String) : int
      {
         return param1.replace(/[^\x00-\xff]/g,"xx").length;
      }
      
      private function nameInputCheck() : Boolean
      {
         var _loc1_:BaseAlerFrame = null;
         if(this._inputText.text != "")
         {
            if(FilterWordManager.isGotForbiddenWords(this._inputText.text,"name"))
            {
               _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.name"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
               return false;
            }
            if(FilterWordManager.IsNullorEmpty(this._inputText.text))
            {
               _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.space"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
               return false;
            }
            if(FilterWordManager.containUnableChar(this._inputText.text))
            {
               _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.string"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
               return false;
            }
            return true;
         }
         _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("choosecharacter.ChooseCharacterView.input"),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         return false;
      }
      
      protected function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               _loc2_.dispose();
         }
         StageReferance.stage.focus = this._inputText;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._alertTxt)
         {
            ObjectUtils.disposeObject(this._alertTxt);
            this._alertTxt = null;
         }
         if(this._alertTxt2)
         {
            ObjectUtils.disposeObject(this._alertTxt2);
            this._alertTxt2 = null;
         }
         if(this._inputLbl)
         {
            ObjectUtils.disposeObject(this._inputLbl);
            this._inputLbl = null;
         }
         if(this._inputText)
         {
            ObjectUtils.disposeObject(this._inputText);
            this._inputText = null;
         }
         if(this._inputBackground)
         {
            ObjectUtils.disposeObject(this._inputBackground);
            this._inputBackground = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._petName = "";
         super.dispose();
      }
   }
}
