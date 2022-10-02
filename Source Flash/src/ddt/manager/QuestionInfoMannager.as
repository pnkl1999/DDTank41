package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.QuestionInfo;
   import ddt.data.analyze.QuestionInfoAnalyze;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.view.common.QuestionGoogsView;
   import road7th.data.DictionaryData;
   
   public class QuestionInfoMannager
   {
      
      private static var _instance:QuestionInfoMannager;
       
      
      private var _questionList:DictionaryData;
      
      private var _allQuestion:Array;
      
      private var _questionTotal:int;
      
      private var _questionCurrentNum:int;
      
      private var _correctQuestionNum:int;
      
      private var _questionCatalogID:int;
      
      private var _questionID:int;
      
      private var _questionGoogsView:QuestionGoogsView;
      
      private var _perKey:int;
      
      public function QuestionInfoMannager()
      {
         super();
         this._questionList = new DictionaryData();
      }
      
      public static function get Instance() : QuestionInfoMannager
      {
         if(_instance == null)
         {
            _instance = new QuestionInfoMannager();
         }
         return _instance;
      }
      
      public function setup(param1:QuestionInfoAnalyze) : void
      {
         this._allQuestion = param1.allQuestion;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ANSWERBOX_QUESTIN,this.__AnswerBoxQuestion);
      }
      
      private function __AnswerBoxQuestion(param1:CrazyTankSocketEvent) : void
      {
         this._questionCatalogID = param1.pkg.readInt();
         this._questionID = param1.pkg.readInt();
         this._questionTotal = param1.pkg.readInt();
         this._questionCurrentNum = param1.pkg.readInt();
         this._correctQuestionNum = param1.pkg.readInt();
         if(!this._questionGoogsView)
         {
            this._questionGoogsView = ComponentFactory.Instance.creatComponentByStylename("ddt.view.common.QuestionGoogsFrame");
            LayerManager.Instance.addToLayer(this._questionGoogsView,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         }
         this._questionGoogsView.setQuestionInfo(this.getQuestionInfo(),this._questionTotal,this._questionCurrentNum,this._correctQuestionNum);
      }
      
      public function test() : void
      {
         this._questionGoogsView = ComponentFactory.Instance.creatComponentByStylename("ddt.view.common.QuestionGoogsFrame");
         LayerManager.Instance.addToLayer(this._questionGoogsView,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function getQuestionInfo() : QuestionInfo
      {
         return this._allQuestion[this._questionCatalogID][this._questionID];
      }
      
      public function sendRespond(param1:int) : void
      {
         ++this._questionCurrentNum;
         SocketManager.Instance.out.sendQuestionReply(param1);
         this.hideQuestionFrame();
      }
      
      private function hideQuestionFrame() : void
      {
         if(this._questionCurrentNum == this._questionTotal)
         {
            if(this._questionGoogsView && this._questionGoogsView.parent)
            {
               this._questionGoogsView.parent.removeChild(this._questionGoogsView);
               this._questionGoogsView.dispose();
               this._questionGoogsView = null;
            }
         }
      }
   }
}
