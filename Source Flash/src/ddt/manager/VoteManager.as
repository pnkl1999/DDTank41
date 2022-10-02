package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.analyze.VoteInfoAnalyzer;
   import ddt.data.analyze.VoteSubmitResultAnalyzer;
   import ddt.data.vote.VoteQuestionInfo;
   import ddt.view.vote.VoteView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   
   public class VoteManager extends EventDispatcher
   {
      
      public static var LOAD_COMPLETED:String = "loadCompleted";
      
      private static var vote:VoteManager;
       
      
      public var loadOver:Boolean = false;
      
      public var showVote:Boolean = true;
      
      public var count:int = 0;
      
      public var questionLength:int = 0;
      
      public var awardArr:Array;
      
      private var voteView:VoteView;
      
      private var list:Dictionary;
      
      private var firstQuestionID:String;
      
      private var completeMessage:String;
      
      private var voteId:String;
      
      private var allAnswer:String = "";
      
      private var nowVoteQuestionInfo:VoteQuestionInfo;
      
      public function VoteManager()
      {
         super();
      }
      
      public static function get Instance() : VoteManager
      {
         if(vote == null)
         {
            vote = new VoteManager();
         }
         return vote;
      }
      
      public function loadCompleted(param1:VoteInfoAnalyzer) : void
      {
         this.loadOver = true;
         this.list = param1.list;
         this.voteId = param1.voteId;
         this.firstQuestionID = param1.firstQuestionID;
         this.completeMessage = param1.completeMessage;
         this.questionLength = param1.questionLength;
         this.awardArr = param1.awardArr;
         dispatchEvent(new Event(LOAD_COMPLETED));
      }
      
      public function openVote() : void
      {
         this.voteView = ComponentFactory.Instance.creatComponentByStylename("vote.VoteView");
         this.voteView.addEventListener(VoteView.OK_CLICK,this.__chosed);
         this.voteView.addEventListener(VoteView.VOTEVIEW_CLOSE,this.__voteViewCLose);
         if(SharedManager.Instance.voteData["userId"] == PlayerManager.Instance.Self.ID)
         {
            this.count = SharedManager.Instance.voteData["voteProgress"] - 1;
            this.nextQuetion(SharedManager.Instance.voteData["voteQuestionID"]);
            this.allAnswer = SharedManager.Instance.voteData["voteAnswer"];
         }
         else
         {
            this.nextQuetion(this.firstQuestionID);
         }
      }
      
      private function __chosed(param1:Event) : void
      {
         this.allAnswer += this.voteView.selectAnswer;
         this.nextQuetion(this.nowVoteQuestionInfo.nextQuestionID);
      }
      
      private function nextQuetion(param1:String) : void
      {
         ++this.count;
         if(param1 != "0")
         {
            this.voteView.visible = false;
            this.nowVoteQuestionInfo = this.list[param1];
            this.voteView.info = this.nowVoteQuestionInfo;
            this.voteView.visible = true;
            LayerManager.Instance.addToLayer(this.voteView,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            this.closeVote();
         }
      }
      
      public function closeVote() : void
      {
         this.loadOver = false;
         this.showVote = false;
         this.voteView.removeEventListener(VoteView.OK_CLICK,this.__chosed);
         this.voteView.dispose();
         this.sendToServer();
      }
      
      private function sendToServer() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["userId"] = PlayerManager.Instance.Self.ID;
         _loc1_["voteId"] = this.voteId;
         _loc1_["answerContent"] = this.allAnswer;
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("VoteSubmitResult.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.analyzer = new VoteSubmitResultAnalyzer(this.getResult);
         LoaderManager.Instance.startLoad(_loc2_);
      }
      
      private function getResult(param1:VoteSubmitResultAnalyzer) : void
      {
         if(param1.result == 1)
         {
            MessageTipManager.getInstance().show(this.completeMessage);
         }
         else
         {
            MessageTipManager.getInstance().show("投票失败!");
         }
      }
      
      private function __voteViewCLose(param1:Event) : void
      {
         this.loadOver = false;
         this.showVote = false;
         SharedManager.Instance.voteData["voteAnswer"] = this.allAnswer;
         SharedManager.Instance.voteData["voteProgress"] = this.count;
         SharedManager.Instance.voteData["voteQuestionID"] = this.nowVoteQuestionInfo.questionID;
         SharedManager.Instance.voteData["userId"] = PlayerManager.Instance.Self.ID;
         SharedManager.Instance.save();
      }
   }
}
