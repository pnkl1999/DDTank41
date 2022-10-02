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
   
   public class FeedbackReportSp extends Sprite implements Disposeable
   {
       
      
      private var _closeBtn:TextButton;
      
      private var _detailTextArea:TextArea;
      
      private var _csTelText:FilterFrameText;
      
      private var _detailTextImg:Bitmap;
      
      private var _infoText:FilterFrameText;
      
      private var _reportTitleOrUrlAsterisk:Bitmap;
      
      private var _reportTitleOrUrlInput:TextInput;
      
      private var _reportTitleOrUrlTextImg:Bitmap;
      
      private var _reportUserNameAsterisk:Bitmap;
      
      private var _reportUserNameInput:TextInput;
      
      private var _reportUserNameTextImg:Bitmap;
      
      private var _submitBtn:TextButton;
      
      private var _submitFrame:FeedbackSubmitFrame;
      
      public function FeedbackReportSp()
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
         if(!this._submitFrame.feedbackInfo.report_url)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.report_url"));
            return false;
         }
         if(!this._submitFrame.feedbackInfo.report_user_name)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.report_user_name"));
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
         this._reportTitleOrUrlTextImg = null;
         this._reportTitleOrUrlInput = null;
         this._reportTitleOrUrlAsterisk = null;
         this._reportUserNameTextImg = null;
         this._reportUserNameInput = null;
         this._reportUserNameAsterisk = null;
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
         this._submitFrame.feedbackInfo.report_url = this._reportTitleOrUrlInput.text;
         this._submitFrame.feedbackInfo.report_user_name = this._reportUserNameInput.text;
      }
      
      public function set submitFrame(param1:FeedbackSubmitFrame) : void
      {
         this._submitFrame = param1;
         if(this._submitFrame.feedbackInfo.question_content)
         {
            this._detailTextArea.text = this._submitFrame.feedbackInfo.question_content;
         }
         if(this._submitFrame.feedbackInfo.report_url)
         {
            this._reportTitleOrUrlInput.text = this._submitFrame.feedbackInfo.report_url;
         }
         if(this._submitFrame.feedbackInfo.report_user_name)
         {
            this._reportUserNameInput.text = this._submitFrame.feedbackInfo.report_user_name;
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
            _loc2_.report_url = this._submitFrame.feedbackInfo.report_url;
            _loc2_.report_user_name = this._submitFrame.feedbackInfo.report_user_name;
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
         this._reportTitleOrUrlTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.reportTitleOrUrlTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.reportTitleOrUrlTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._reportTitleOrUrlTextImg,_loc1_);
         addChildAt(this._reportTitleOrUrlTextImg,0);
         this._reportTitleOrUrlInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.reportTitleOrUrlInputRec");
         ObjectUtils.copyPropertyByRectangle(this._reportTitleOrUrlInput,_loc1_);
         addChildAt(this._reportTitleOrUrlInput,0);
         this._reportTitleOrUrlAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.reportTitleOrUrlAsteriskRec");
         ObjectUtils.copyPropertyByRectangle(this._reportTitleOrUrlAsterisk,_loc1_);
         addChildAt(this._reportTitleOrUrlAsterisk,0);
         this._reportUserNameTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.reportUserNameTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.reportUserNameTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._reportUserNameTextImg,_loc1_);
         addChildAt(this._reportUserNameTextImg,0);
         this._reportUserNameInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.reportUserNameInputRec");
         ObjectUtils.copyPropertyByRectangle(this._reportUserNameInput,_loc1_);
         addChildAt(this._reportUserNameInput,0);
         this._reportUserNameAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.reportUserNameAsteriskRec");
         ObjectUtils.copyPropertyByRectangle(this._reportUserNameAsterisk,_loc1_);
         addChildAt(this._reportUserNameAsterisk,0);
         this._detailTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.detailTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.reportDetailTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextImg,_loc1_);
         addChildAt(this._detailTextImg,0);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("feedback.infoText");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.reportDisappearInfoTextRec");
         ObjectUtils.copyPropertyByRectangle(this._infoText,_loc1_);
         addChildAt(this._infoText,0);
         this._csTelText = ComponentFactory.Instance.creatComponentByStylename("feedback.csTelText");
         this._csTelText.text = LanguageMgr.GetTranslation("feedback.view.csTelNumber",PathManager.solveFeedbackTelNumber());
         if(!StringHelper.isNullOrEmpty(PathManager.solveFeedbackTelNumber()))
         {
            addChild(this._csTelText);
         }
         this._csTelText.y = this._infoText.y;
         this._detailTextArea = ComponentFactory.Instance.creatComponentByStylename("feedback.simpleTextArea");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.reportDetailTextAreaRec");
         ObjectUtils.copyPropertyByRectangle(this._detailTextArea,_loc1_);
         addChildAt(this._detailTextArea,0);
         this._detailTextArea.text = "";
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
