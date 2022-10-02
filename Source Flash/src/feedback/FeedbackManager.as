package feedback
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.MD5;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.DailyButtunBar;
   import feedback.analyze.LoadFeedbackReplyAnalyzer;
   import feedback.data.FeedbackInfo;
   import feedback.data.FeedbackReplyInfo;
   import feedback.view.FeedbackReplyFrame;
   import feedback.view.FeedbackSubmitFrame;
   import flash.events.EventDispatcher;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.DateUtils;
   
   public class FeedbackManager extends EventDispatcher
   {
      
      private static var _instance:FeedbackManager;
       
      
      private var _feedbackInfo:FeedbackInfo;
      
      private var _feedbackTime:Date;
      
      private var _currentTime:Date;
      
      private var _currentOpenInt:int;
      
      private var _feedbackReplyData:DictionaryData;
      
      private var _isReply:Boolean;
      
      private var _feedbackSubmitFrame:FeedbackSubmitFrame;
      
      private var _feedbackReplyFrame:FeedbackReplyFrame;
      
      private var _isSubmitTime:Boolean;
      
      private var _removeFeedbackInfoId:String;
      
      public function FeedbackManager()
      {
         super();
      }
      
      public static function get instance() : FeedbackManager
      {
         if(_instance == null)
         {
            _instance = new FeedbackManager();
         }
         return _instance;
      }
      
      public function get feedbackInfo() : FeedbackInfo
      {
         if(!this._feedbackInfo)
         {
            this._feedbackInfo = new FeedbackInfo();
         }
         return this._feedbackInfo;
      }
      
      public function get feedbackReplyData() : DictionaryData
      {
         return this._feedbackReplyData;
      }
      
      public function set feedbackReplyData(param1:DictionaryData) : void
      {
         if(this._feedbackReplyData)
         {
            this._feedbackReplyData.removeEventListener(DictionaryEvent.ADD,this.feedbackReplyDataAdd);
            this._feedbackReplyData.removeEventListener(DictionaryEvent.REMOVE,this.feedbackReplyDataRemove);
         }
         this._feedbackReplyData = param1;
         this._feedbackReplyData.addEventListener(DictionaryEvent.ADD,this.feedbackReplyDataAdd);
         this._feedbackReplyData.addEventListener(DictionaryEvent.REMOVE,this.feedbackReplyDataRemove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FEEDBACK_REPLY,this.feedbackReplyBySocket);
         this.checkFeedbackReplyData();
      }
      
      public function setupFeedbackData(param1:LoadFeedbackReplyAnalyzer) : void
      {
         if(PathManager.solveFeedbackEnable())
         {
            this.feedbackReplyData = param1.listData;
         }
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc2_["userid"] = PlayerManager.Instance.Self.ID;
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("AdvanceQuestTime.ashx"),BaseLoader.REQUEST_LOADER,_loc2_);
         _loc3_.addEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
         LoaderManager.Instance.startLoad(_loc3_);
      }
      
      private function __loaderComplete(param1:LoaderEvent) : void
      {
         param1.currentTarget.removeEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
         if(param1.loader.content == 0)
         {
            return;
         }
         var _loc2_:Array = String(param1.loader.content).split(",");
         if(_loc2_[0])
         {
            if(_loc2_[0] == 0)
            {
               this._feedbackTime = null;
            }
            else
            {
               this._feedbackTime = DateUtils.getDateByStr(_loc2_[0]);
            }
         }
         if(_loc2_[1])
         {
            this._currentTime = DateUtils.getDateByStr(_loc2_[1]);
         }
         if(_loc2_[2])
         {
            this._currentOpenInt = Number(_loc2_[2]);
         }
      }
      
      private function feedbackReplyBySocket(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:FeedbackReplyInfo = new FeedbackReplyInfo();
         _loc3_.questionId = _loc2_.readUTF();
         _loc3_.replyId = _loc2_.readInt();
         _loc3_.occurrenceDate = _loc2_.readUTF();
         _loc3_.questionTitle = _loc2_.readUTF();
         _loc3_.questionContent = _loc2_.readUTF();
         _loc3_.replyContent = _loc2_.readUTF();
         _loc3_.stopReply = _loc2_.readUTF();
         this._feedbackReplyData.add(_loc3_.questionId + "_" + _loc3_.replyId,_loc3_);
         this.stopReplyEvt(_loc3_.stopReply);
      }
      
      private function stopReplyEvt(param1:String) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.stopReply = param1;
         var _loc3_:FeedbackEvent = new FeedbackEvent(FeedbackEvent.FEEDBACK_StopReply,_loc2_);
         dispatchEvent(_loc3_);
      }
      
      private function feedbackReplyDataAdd(param1:DictionaryEvent) : void
      {
         this.checkFeedbackReplyData();
      }
      
      private function feedbackReplyDataRemove(param1:DictionaryEvent) : void
      {
         this.checkFeedbackReplyData();
      }
      
      private function checkFeedbackReplyData() : void
      {
         if(this._feedbackReplyData.length <= 0)
         {
            this._isReply = false;
            DailyButtunBar.Insance.setComplainGlow(false);
         }
         else
         {
            this._isReply = true;
            DailyButtunBar.Insance.setComplainGlow(true);
         }
      }
      
      public function examineTime() : Boolean
      {
         var _loc1_:Date = TimeManager.Instance.Now();
         if(!this._feedbackTime)
         {
            return true;
         }
         if(_loc1_.time - this._feedbackTime.time >= 1000 * 60 * 35)
         {
            return true;
         }
         return false;
      }
      
      public function show() : void
      {
         if(!this._isReply)
         {
            if(this._currentOpenInt >= 5)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.MaxReferTimes"));
               return;
            }
            if(!this._currentTime && !this._feedbackTime)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseStateCreator.LoadingTip"));
               return;
            }
            if(this.examineTime())
            {
               this.openFeedbackSubmitView();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.SystemsAnalysis"));
            }
         }
         else
         {
            this.openFeedbackReplyView();
         }
      }
      
      private function openFeedbackSubmitView() : void
      {
         if(!this._feedbackSubmitFrame)
         {
            this._feedbackSubmitFrame = ComponentFactory.Instance.creatComponentByStylename("feedback.feedbackSubmitFrame");
            this._feedbackSubmitFrame.show();
            return;
         }
         this.closeFrame();
      }
      
      private function openFeedbackReplyView() : void
      {
         if(!this._feedbackReplyFrame)
         {
            this._feedbackReplyFrame = ComponentFactory.Instance.creatComponentByStylename("feedback.feedbackReplyFrame");
            this._feedbackReplyFrame.show();
            this._feedbackReplyFrame.setup(this._feedbackReplyData.list[0] as FeedbackReplyInfo);
            return;
         }
         this.closeFrame();
      }
      
      public function closeFrame() : void
      {
         this._feedbackInfo = null;
         if(this._feedbackSubmitFrame)
         {
            this._feedbackSubmitFrame.dispose();
            this._feedbackSubmitFrame = null;
         }
         if(this._feedbackReplyFrame)
         {
            this._feedbackReplyFrame.dispose();
            this._feedbackReplyFrame = null;
         }
      }
      
      public function submitFeedbackInfo(param1:FeedbackInfo) : void
      {
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc2_.user_id = PlayerManager.Instance.Self.ID.toString();
         _loc2_.user_name = PlayerManager.Instance.Self.LoginName;
         _loc2_.user_nick_name = PlayerManager.Instance.Self.NickName;
         _loc2_.question_title = param1.question_title;
         _loc2_.question_content = param1.question_content;
         _loc2_.occurrence_date = param1.occurrence_date;
         _loc2_.question_type = param1.question_type.toString();
         _loc2_.goods_get_method = param1.goods_get_method;
         _loc2_.goods_get_date = param1.goods_get_date;
         _loc2_.charge_order_id = param1.charge_order_id;
         _loc2_.charge_method = param1.charge_method;
         _loc2_.charge_moneys = param1.charge_moneys.toString();
         _loc2_.activity_is_error = param1.activity_is_error.toString();
         _loc2_.activity_name = param1.activity_name;
         _loc2_.report_user_name = param1.report_user_name;
         _loc2_.report_url = param1.report_url;
         _loc2_.user_full_name = param1.user_full_name;
         _loc2_.user_phone = param1.user_phone;
         _loc2_.complaints_title = param1.complaints_title;
         _loc2_.complaints_source = param1.complaints_source;
         var _loc3_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("AdvanceQuestion.ashx"),BaseLoader.REQUEST_LOADER,_loc2_,URLRequestMethod.POST);
         _loc3_.addEventListener(LoaderEvent.COMPLETE,this.__onLoadFreeBackComplete);
         LoaderManager.Instance.startLoad(_loc3_);
         this.closeFrame();
         this._isSubmitTime = true;
      }
      
      public function continueSubmit(param1:String, param2:int, param3:String) : void
      {
         this._removeFeedbackInfoId = param1 + "_" + param2;
         var _loc4_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc4_.pass = MD5.hash(PlayerManager.Instance.Self.ID + "3kjf2jfwj93pj22jfsl11jjoe12oij");
         _loc4_.userid = PlayerManager.Instance.Self.ID;
         _loc4_.nick_name = PlayerManager.Instance.Self.NickName;
         _loc4_.question_id = param1;
         _loc4_.reply_id = param2;
         _loc4_.reply_content = param3;
         var _loc5_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("AdvanceReply.ashx"),BaseLoader.REQUEST_LOADER,_loc4_,URLRequestMethod.POST);
         _loc5_.addEventListener(LoaderEvent.COMPLETE,this.__onLoadFreeBackComplete);
         LoaderManager.Instance.startLoad(_loc5_);
         this.closeFrame();
      }
      
      public function delPosts(param1:String, param2:int, param3:int, param4:String) : void
      {
         this._removeFeedbackInfoId = param1 + "_" + param2;
         var _loc5_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc5_.pass = MD5.hash(PlayerManager.Instance.Self.ID + "3kjf2jfwj93pj22jfsl11jjoe12oij");
         _loc5_.userid = PlayerManager.Instance.Self.ID;
         _loc5_.nick_name = PlayerManager.Instance.Self.NickName;
         _loc5_.question_id = param1;
         _loc5_.reply_id = param2;
         _loc5_.appraisal_grade = param3;
         _loc5_.appraisal_content = param4;
         var _loc6_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("AdvanceQuestionAppraisal.ashx"),BaseLoader.REQUEST_LOADER,_loc5_,URLRequestMethod.POST);
         _loc6_.addEventListener(LoaderEvent.COMPLETE,this.__onLoadFreeBackComplete);
         LoaderManager.Instance.startLoad(_loc6_);
         this.closeFrame();
      }
      
      private function __onLoadFreeBackComplete(param1:LoaderEvent) : void
      {
         if(param1.loader.content == 1)
         {
            if(this._isSubmitTime)
            {
               this._feedbackTime = TimeManager.Instance.Now();
               ++this._currentOpenInt;
            }
            if(this._removeFeedbackInfoId)
            {
               this._feedbackReplyData.remove(this._removeFeedbackInfoId);
               this._removeFeedbackInfoId = null;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.ThankReferQuestion"));
         }
         else if(param1.loader.content == -1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.MaxReferTimes"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.SystemBusy"));
         }
         this._isSubmitTime = false;
      }
   }
}
