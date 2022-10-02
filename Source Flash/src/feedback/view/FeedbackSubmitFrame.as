package feedback.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import feedback.FeedbackManager;
   import feedback.data.FeedbackInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import road7th.utils.DateUtils;
   
   public class FeedbackSubmitFrame extends Frame
   {
       
      
      private var _box:Sprite;
      
      private var _dayCombox:ComboBox;
      
      private var _dayTextImg:Bitmap;
      
      private var _feedbackSp:Disposeable;
      
      private var _monthCombox:ComboBox;
      
      private var _monthTextImg:Bitmap;
      
      private var _occurrenceTimeTextImg:Bitmap;
      
      private var _problemCombox:ComboBox;
      
      private var _problemTitleAsterisk:Bitmap;
      
      private var _problemTitleInput:TextInput;
      
      private var _problemTitleTextImg:Bitmap;
      
      private var _problemTypesAsterisk:Bitmap;
      
      private var _problemTypesTextImg:Bitmap;
      
      private var _yearCombox:ComboBox;
      
      private var _yearTextImg:Bitmap;
      
      public function FeedbackSubmitFrame()
      {
         super();
         this._init();
      }
      
      public function get problemCombox() : ComboBox
      {
         return this._problemCombox;
      }
      
      public function get problemTitleInput() : TextInput
      {
         return this._problemTitleInput;
      }
      
      override public function dispose() : void
      {
         this.remvoeEvent();
         if(this._feedbackSp)
         {
            this._feedbackSp.dispose();
         }
         ObjectUtils.disposeAllChildren(this._box);
         ObjectUtils.disposeObject(this._box);
         this._box = null;
         ObjectUtils.disposeAllChildren(this._feedbackSp as Sprite);
         this._feedbackSp = null;
         ObjectUtils.disposeAllChildren(this);
         this._problemTypesTextImg = null;
         this._problemCombox = null;
         this._problemTitleTextImg = null;
         this._problemTypesAsterisk = null;
         this._problemTitleInput = null;
         this._problemTitleAsterisk = null;
         this._occurrenceTimeTextImg = null;
         this._yearCombox = null;
         this._yearTextImg = null;
         this._monthCombox = null;
         this._monthTextImg = null;
         this._dayCombox = null;
         this._dayTextImg = null;
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get feedbackInfo() : FeedbackInfo
      {
         FeedbackManager.instance.feedbackInfo.user_id = PlayerManager.Instance.Self.ID;
         FeedbackManager.instance.feedbackInfo.user_name = PlayerManager.Instance.Self.LoginName;
         FeedbackManager.instance.feedbackInfo.user_nick_name = PlayerManager.Instance.Self.NickName;
         if(this._problemCombox)
         {
            FeedbackManager.instance.feedbackInfo.question_type = this._problemCombox.currentSelectedIndex + 1;
            FeedbackManager.instance.feedbackInfo.question_title = this._problemTitleInput.text;
            FeedbackManager.instance.feedbackInfo.occurrence_date = this._yearCombox.textField.text + "-" + this._monthCombox.textField.text + "-" + this._dayCombox.textField.text;
         }
         return FeedbackManager.instance.feedbackInfo;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               FeedbackManager.instance.closeFrame();
         }
      }
      
      private function __problemComboxChanged(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._feedbackSp)
         {
            this._feedbackSp["setFeedbackInfo"]();
            this._feedbackSp.dispose();
         }
         this._feedbackSp = this.getFeedbackSp(this._problemCombox.currentSelectedIndex);
         if(this._feedbackSp)
         {
            addToContent(this._feedbackSp as Sprite);
            addToContent(this._box);
         }
      }
      
      private function _init() : void
      {
         var _loc1_:Rectangle = null;
         var _loc3_:uint = 0;
         titleText = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitFrame.title");
         this._feedbackSp = this.getFeedbackSp(0);
         addToContent(this._feedbackSp as Sprite);
         this._box = new Sprite();
         addToContent(this._box);
         this._problemTypesTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.problemTypesTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.problemTypesTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTypesTextImg,_loc1_);
         this._box.addChildAt(this._problemTypesTextImg,0);
         this._problemCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.comboxRec");
         ObjectUtils.copyPropertyByRectangle(this._problemCombox,_loc1_);
         this._problemCombox.beginChanges();
         this._problemCombox.selctedPropName = "text";
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text0"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text1"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text2"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text3"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text4"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text5"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text6"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text7"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text8"));
         this._problemCombox.listPanel.vectorListModel.append(LanguageMgr.GetTranslation("feedback.view.problemCombox_text9"));
         this._problemCombox.commitChanges();
         this._problemCombox.textField.text = LanguageMgr.GetTranslation("feedback.view.FeedbackSubmitSp.comBoxText");
         this._box.addChildAt(this._problemCombox,0);
         this._problemTypesAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.problemTypesAsteriskTextRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTypesAsterisk,_loc1_);
         this._box.addChildAt(this._problemTypesAsterisk,0);
         this._problemTitleTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.problemTitleTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleTextImg,_loc1_);
         this._box.addChildAt(this._problemTitleTextImg,0);
         this._problemTitleInput = ComponentFactory.Instance.creatComponentByStylename("feedback.textInput");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleInputRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleInput,_loc1_);
         this._box.addChildAt(this._problemTitleInput,0);
         this._problemTitleAsterisk = ComponentFactory.Instance.creatBitmap("asset.feedback.asteriskImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.problemTitleAsteriskTextRec");
         ObjectUtils.copyPropertyByRectangle(this._problemTitleAsterisk,_loc1_);
         this._box.addChildAt(this._problemTitleAsterisk,0);
         this._occurrenceTimeTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.occurrenceTimeTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.occurrenceTimeTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._occurrenceTimeTextImg,_loc1_);
         this._box.addChildAt(this._occurrenceTimeTextImg,0);
         this._yearCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.yearComboxRec");
         ObjectUtils.copyPropertyByRectangle(this._yearCombox,_loc1_);
         this._yearCombox.beginChanges();
         var _loc2_:Number = new Date().getFullYear();
         this._yearCombox.textField.text = String(_loc2_);
         this._yearCombox.snapItemHeight = true;
         this._yearCombox.selctedPropName = "text";
         _loc3_ = _loc2_;
         while(_loc3_ >= _loc2_ - 2)
         {
            this._yearCombox.listPanel.vectorListModel.append(_loc3_);
            _loc3_--;
         }
         this._yearCombox.commitChanges();
         this._box.addChildAt(this._yearCombox,0);
         this._yearTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.yearTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.yearTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._yearTextImg,_loc1_);
         this._box.addChildAt(this._yearTextImg,0);
         this._monthCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.monthComboxRec");
         ObjectUtils.copyPropertyByRectangle(this._monthCombox,_loc1_);
         this._monthCombox.beginChanges();
         var _loc4_:Number = new Date().getMonth() + 1;
         this._monthCombox.textField.text = String(_loc4_);
         this._monthCombox.selctedPropName = "text";
         _loc3_ = 1;
         while(_loc3_ <= 12)
         {
            this._monthCombox.listPanel.vectorListModel.append(_loc3_);
            _loc3_++;
         }
         this._monthCombox.commitChanges();
         this._box.addChildAt(this._monthCombox,0);
         this._monthTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.monthTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.monthTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._monthTextImg,_loc1_);
         this._box.addChildAt(this._monthTextImg,0);
         this._dayCombox = ComponentFactory.Instance.creatComponentByStylename("feedback.combox");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.dayComboxRec");
         ObjectUtils.copyPropertyByRectangle(this._dayCombox,_loc1_);
         this._dayCombox.beginChanges();
         var _loc5_:Number = new Date().getDate();
         this._dayCombox.textField.text = String(_loc5_);
         this._dayCombox.selctedPropName = "text";
         var _loc6_:Number = DateUtils.getDays(_loc2_,_loc4_);
         _loc3_ = 1;
         while(_loc3_ <= _loc6_)
         {
            this._dayCombox.listPanel.vectorListModel.append(_loc3_);
            _loc3_++;
         }
         this._dayCombox.commitChanges();
         this._box.addChildAt(this._dayCombox,0);
         this._dayTextImg = ComponentFactory.Instance.creatBitmap("asset.feedback.dayTextImg");
         _loc1_ = ComponentFactory.Instance.creatCustomObject("feedback.dayTextImgRec");
         ObjectUtils.copyPropertyByRectangle(this._dayTextImg,_loc1_);
         this._box.addChildAt(this._dayTextImg,0);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._problemCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this.__problemComboxChanged);
         this._yearCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this._dateChanged);
         this._monthCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this._dateChanged);
         this._dayCombox.addEventListener(InteractiveEvent.STATE_CHANGED,this.__comboxClick);
         this._problemCombox.addEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._yearCombox.addEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._monthCombox.addEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._dayCombox.addEventListener(MouseEvent.CLICK,this.__comboxClick);
      }
      
      private function __comboxClick(param1:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function _dateChanged(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         this._dayCombox.textField.text = "1";
         var _loc2_:Number = DateUtils.getDays(Number(this._yearCombox.textField.text),Number(this._monthCombox.textField.text));
         this._dayCombox.listPanel.vectorListModel.clear();
         this._dayCombox.beginChanges();
         var _loc3_:uint = 1;
         while(_loc3_ <= _loc2_)
         {
            this._dayCombox.listPanel.vectorListModel.append(_loc3_);
            _loc3_++;
         }
         this._dayCombox.commitChanges();
      }
      
      private function getFeedbackSp(param1:int) : Disposeable
      {
         var _loc2_:Disposeable = null;
         switch(param1)
         {
            case 0:
            case 5:
            case 6:
            case 9:
               _loc2_ = new FeedbackConsultingSp();
               break;
            case 1:
               _loc2_ = new FeedbackProblemsSp();
               break;
            case 2:
               _loc2_ = new FeedbackPropsDisappearSp();
               break;
            case 3:
               _loc2_ = new FeedbackStealHandSp();
               break;
            case 4:
               _loc2_ = new FeedbackPrepaidCardSp();
               break;
            case 7:
               _loc2_ = new FeedbackReportSp();
               break;
            case 8:
               _loc2_ = new FeedbackComplaintSp();
         }
         _loc2_["submitFrame"] = this;
         return _loc2_;
      }
      
      private function remvoeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._problemCombox.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__problemComboxChanged);
         this._yearCombox.removeEventListener(InteractiveEvent.STATE_CHANGED,this._dateChanged);
         this._monthCombox.removeEventListener(InteractiveEvent.STATE_CHANGED,this._dateChanged);
         this._dayCombox.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__comboxClick);
         this._problemCombox.removeEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._yearCombox.removeEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._monthCombox.removeEventListener(MouseEvent.CLICK,this.__comboxClick);
         this._dayCombox.removeEventListener(MouseEvent.CLICK,this.__comboxClick);
      }
   }
}
