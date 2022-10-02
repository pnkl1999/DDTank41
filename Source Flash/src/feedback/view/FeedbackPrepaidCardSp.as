package feedback.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import feedback.FeedbackManager;
   import feedback.data.FeedbackInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import road7th.utils.StringHelper;
   
   public class FeedbackPrepaidCardSp extends Sprite implements Disposeable
   {
       
      
      private var _closeBtn:TextButton;
      
      private var _detailTextArea:TextArea;
      
      private var _csTelText:FilterFrameText;
      
      private var _detailTextImg:Bitmap;
      
      private var _infoText:FilterFrameText;
      
      private var _orderNumberValueAsterisk:Bitmap;
      
      private var _orderNumberValueTextImg:Bitmap;
      
      private var _orderNumberValueTextInput:TextInput;
      
      private var _prepaidAmountAsterisk:Bitmap;
      
      private var _prepaidAmountTextImg:Bitmap;
      
      private var _prepaidAmountTextInput:TextInput;
      
      private var _prepaidModeAsterisk:Bitmap;
      
      private var _prepaidModeTextImg:Bitmap;
      
      private var _prepaidModeTextInput:TextInput;
      
      private var _submitBtn:TextButton;
      
      private var _submitFrame:FeedbackSubmitFrame;
      
      public function FeedbackPrepaidCardSp()
      {
         super();
         this._init();
      }
      
      public function get check() : Boolean
      {
         if(this._submitFrame.feedbackInfo.question_type < 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_type"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.question_title)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_title"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.charge_order_id)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.charge_order_id"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.charge_method)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.charge_method"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.charge_moneys)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.charge_moneys"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.question_content)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_content"));
            return false;
         }
         if(this._submitFrame.feedbackInfo.question_content.length < 8)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.question_LessThanEight"));
            return false;
         }
         return true;
      }
      
      public function dispose() : void
      {
         this.remvoeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._orderNumberValueTextImg = null;
         this._orderNumberValueTextInput = null;
         this._orderNumberValueAsterisk = null;
         this._prepaidModeTextImg = null;
         this._prepaidModeTextInput = null;
         this._prepaidModeAsterisk = null;
         this._prepaidAmountTextImg = null;
         this._prepaidAmountTextInput = null;
         this._prepaidAmountAsterisk = null;
         this._detailTextImg = null;
         this._csTelText = null;
         this._infoText = null;
         this._detailTextArea = null;
         this._submitBtn = null;
         this._closeBtn = null;
         this._submitFrame = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function setFeedbackInfo() : void
      {
         this._submitFrame.feedbackInfo.question_content = this._detailTextArea.text;
         this._submitFrame.feedbackInfo.charge_order_id = this._orderNumberValueTextInput.text;
         this._submitFrame.feedbackInfo.charge_method = this._prepaidModeTextInput.text;
         this._submitFrame.feedbackInfo.charge_moneys = Number(this._prepaidAmountTextInput.text);
      }
      
      public function set submitFrame(param1:FeedbackSubmitFrame) : void
      {
         this._submitFrame = param1;
         if(this._submitFrame.feedbackInfo.question_content)
         {
            this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
         }
         if(this._submitFrame.feedbackInfo.charge_order_id)
         {
            this._orderNumberValueTextInput.text = this._submitFrame.feedbackInfo.charge_order_id;
         }
         if(this._submitFrame.feedbackInfo.charge_method)
         {
            this._prepaidModeTextInput.text = this._submitFrame.feedbackInfo.charge_method;
         }
         if(this._submitFrame.feedbackInfo.charge_moneys)
         {
            this._prepaidAmountTextInput.text = String(this._submitFrame.feedbackInfo.charge_moneys);
         }
         this.__texeInput(null);
      }
      
      private function __closeBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FeedbackManager.instance.closeFrame();
      }
      
      private function __submitBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:FeedbackInfo = null;
         SoundManager.instance.play("008");
         this.setFeedbackInfo();
         if(this.check)
         {
            _loc2_ = new FeedbackInfo();
            _loc2_.question_type = this._submitFrame.feedbackInfo.question_type;
            _loc2_.question_title = this._submitFrame.feedbackInfo.question_title;
            _loc2_.occurrence_date = this._submitFrame.feedbackInfo.occurrence_date;
            _loc2_.question_content = this._submitFrame.feedbackInfo.question_content;
            _loc2_.charge_order_id = this._submitFrame.feedbackInfo.charge_order_id;
            _loc2_.charge_method = this._submitFrame.feedbackInfo.charge_method;
            _loc2_.charge_moneys = this._submitFrame.feedbackInfo.charge_moneys;
            FeedbackManager.instance.submitFeedbackInfo(_loc2_);
         }
      }
      
      private function __texeInput(param1:Event) : void
      {
         this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText",this._detailTextArea.maxChars - this._detailTextArea.textField.length);
      }
      
      private function _init() : void
      {
         var _loc1_:Rectangle = null;
         this._orderNumberValueTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.orderNumberValueTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardOrderNumberValueTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._orderNumberValueTextImg,_loc1_);
         addChildAt(this._orderNumberValueTextImg,0);
         this._orderNumberValueTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardOrderNumberValueInputRec");
         ObjectUtils.copyPropertyByRectangle(this._orderNumberValueTextInput,_loc1_);
         this._orderNumberValueTextInput.textField.restrict = "a-zA-Z0-9";
         addChildAt(this._orderNumberValueTextInput,0);
         this._orderNumberValueAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardOrderNumberValueAsteriskRec");
         ObjectUtils.copyPropertyByRectangle(this._orderNumberValueAsterisk,_loc1_);
         addChildAt(this._orderNumberValueAsterisk,0);
         this._prepaidModeTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.prepaidModeTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidModeTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._prepaidModeTextImg,_loc1_);
         addChildAt(this._prepaidModeTextImg,0);
         this._prepaidModeTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidModeInputRec");
         ObjectUtils.copyPropertyByRectangle(this._prepaidModeTextInput,_loc1_);
         addChildAt(this._prepaidModeTextInput,0);
         this._prepaidModeAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidModeAsteriskRec");
         ObjectUtils.copyPropertyByRectangle(this._prepaidModeAsterisk,_loc1_);
         addChildAt(this._prepaidModeAsterisk,0);
         this._prepaidAmountTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.prepaidAmountTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidAmountTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._prepaidAmountTextImg,_loc1_);
         addChildAt(this._prepaidAmountTextImg,0);
         this._prepaidAmountTextInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidAmountInputRec");
         ObjectUtils.copyPropertyByRectangle(this._prepaidAmountTextInput,_loc1_);
         addChildAt(this._prepaidAmountTextInput,0);
         this._prepaidAmountAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardPrepaidAmountAsteriskRec");
         ObjectUtils.copyPropertyByRectangle(this._prepaidAmountAsterisk,_loc1_);
         addChildAt(this._prepaidAmountAsterisk,0);
         this._detailTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.detailTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardDetailTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextImg,_loc1_);
         addChildAt(this._detailTextImg,0);
         this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
         this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber",PathManager.solveFeedbackTelNumber());
         if(!StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))
         {
            addChild(this._csTelText);
         }
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardDisappearInfoTextRec");
         ObjectUtils.copyPropertyByRectangle(this._infoText,_loc1_);
         this._csTelText.y = this._infoText.y;
         addChildAt(this._infoText,0);
         this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.prepaidCardDetailTextAreaRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextArea,_loc1_);
         addChildAt(this._detailTextArea,0);
         this._infoText.text = LanguageMgr.GetTranslation("feedback.view.infoText",this._detailTextArea.maxChars);
         this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.submitBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._submitBtn,_loc1_);
         this._submitBtn.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.submitBtnText");
         addChildAt(this._submitBtn,0);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("feedback.btn");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.closeBtnRec");
         ObjectUtils.copyPropertyByRectangle(this._closeBtn,_loc1_);
         this._closeBtn.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
         addChildAt(this._closeBtn,0);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._submitBtn.addEventListener(MouseEvent.CLICK,this.__submitBtnClick);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeBtnClick);
         this._detailTextArea.textField.addEventListener(Event.CHANGE,this.__texeInput);
      }
      
      private function remvoeEvent() : void
      {
         this._submitBtn.removeEventListener(MouseEvent.CLICK,this.__submitBtnClick);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeBtnClick);
         this._detailTextArea.textField.removeEventListener(Event.CHANGE,this.__texeInput);
      }
   }
}
