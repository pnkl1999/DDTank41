package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.QuestionInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.QuestionInfoMannager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import trainer.view.QuestionItemView;
   
   public class QuestionGoogsView extends Frame
   {
       
      
      private var _choiceBg:ScaleBitmapImage;
      
      private var _questionText:FilterFrameText;
      
      private var _answersText:FilterFrameText;
      
      private var _explanationText:FilterFrameText;
      
      private var _txtAward:FilterFrameText;
      
      private var _imgBg:ScaleBitmapImage;
      
      private var _progressText:FilterFrameText;
      
      private var _list:VBox;
      
      private var _currentQuestion:QuestionInfo;
      
      private var _questionTotal:int;
      
      private var _questionCurrentNum:int;
      
      private var _correctQuestionNum:int;
      
      private var _questionCatalogID:int;
      
      private var _questionID:int;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _itemArray:Array;
      
      private var _perKey:int;
      
      public function QuestionGoogsView()
      {
         super();
         this.initContent();
      }
      
      private function initContent() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.view.common.QuestionGoogsView.title");
         this._imgBg = ComponentFactory.Instance.creatComponentByStylename("common.QuestionGoogsFrame.bg");
         addToContent(this._imgBg);
         this._choiceBg = ComponentFactory.Instance.creatComponentByStylename("common.QuestionGoogsFrame.choiceBg");
         addToContent(this._choiceBg);
         this._explanationText = ComponentFactory.Instance.creatComponentByStylename("common.QuestionGoogsFrame.explanationText");
         this._explanationText.text = LanguageMgr.GetTranslation("ddt.view.common.QuestionGoogsView.questionDescription");
         addToContent(this._explanationText);
         this._questionText = ComponentFactory.Instance.creatComponentByStylename("common.QuestionGoogsFrame.questionText");
         addToContent(this._questionText);
         this._progressText = ComponentFactory.Instance.creat("common.QuestionGoogsFrame.progressText");
         addToContent(this._progressText);
         this._list = ComponentFactory.Instance.creatComponentByStylename("trainer.question.ItemList");
         addToContent(this._list);
         this.initItem();
      }
      
      private function initItem() : void
      {
         var _loc2_:QuestionItemView = null;
         _loc2_ = null;
         this._itemArray = [];
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new QuestionItemView();
            _loc2_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc2_.visible = false;
            this._list.addChild(_loc2_);
            this._itemArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         QuestionInfoMannager.Instance.sendRespond((param1.target as QuestionItemView).index);
      }
      
      private function update() : void
      {
         this._questionText.text = this._currentQuestion.QuestionContent;
         this._progressText.text = LanguageMgr.GetTranslation("ddt.view.common.QuestionGoogsView.questionCorrect") + String(this._correctQuestionNum) + "/" + String(this._questionTotal);
         this.updateItem();
      }
      
      private function updateItem() : void
      {
         if(this._currentQuestion.Option1 != "")
         {
            this._itemArray[0].visible = true;
            this._itemArray[0].setData(1,this._currentQuestion.Option1);
         }
         else
         {
            this._itemArray[0].visible = false;
         }
         if(this._currentQuestion.Option2 != "")
         {
            this._itemArray[1].visible = true;
            this._itemArray[1].setData(2,this._currentQuestion.Option2);
         }
         else
         {
            this._itemArray[1].visible = false;
         }
         if(this._currentQuestion.Option3 != "")
         {
            this._itemArray[2].visible = true;
            this._itemArray[2].setData(3,this._currentQuestion.Option3);
         }
         else
         {
            this._itemArray[2].visible = false;
         }
         if(this._currentQuestion.Option4 != "")
         {
            this._itemArray[3].visible = true;
            this._itemArray[3].setData(4,this._currentQuestion.Option4);
         }
         else
         {
            this._itemArray[3].visible = false;
         }
      }
      
      public function setQuestionInfo(param1:QuestionInfo, param2:int, param3:int, param4:int) : void
      {
         this._currentQuestion = param1;
         this._questionTotal = param2;
         this._questionCurrentNum = param3;
         this._correctQuestionNum = param4;
         this.update();
      }
      
      private function getPerKeyStr(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return "A";
            case 2:
               return "B";
            case 3:
               return "C";
            case 4:
               return "D";
            default:
               return "";
         }
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArray.length)
         {
            (this._itemArray[_loc1_] as QuestionItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[_loc1_] as QuestionItemView).dispose();
            _loc1_++;
         }
         this._list.disposeAllChildren();
         this._itemArray = [];
      }
      
      override public function dispose() : void
      {
         this.cleanItem();
         if(this._choiceBg && this._choiceBg.parent)
         {
            this._choiceBg.parent.removeChild(this._choiceBg);
            this._choiceBg.dispose();
            this._choiceBg = null;
         }
         if(this._questionText && this._questionText.parent)
         {
            this._questionText.parent.removeChild(this._questionText);
            this._questionText.dispose();
            this._questionText = null;
         }
         if(this._answersText && this._answersText.parent)
         {
            this._answersText.parent.removeChild(this._answersText);
            this._answersText.dispose();
            this._answersText = null;
         }
         if(this._explanationText && this._explanationText.parent)
         {
            this._explanationText.parent.removeChild(this._explanationText);
            this._explanationText.dispose();
            this._explanationText = null;
         }
         if(this._imgBg && this._imgBg.parent)
         {
            this._imgBg.parent.removeChild(this._imgBg);
            this._imgBg.dispose();
            this._imgBg = null;
         }
         if(this._progressText && this._progressText.parent)
         {
            this._progressText.parent.removeChild(this._progressText);
            this._progressText.dispose();
            this._progressText = null;
         }
         if(this._list && this._list.parent)
         {
            this._list.parent.removeChild(this._list);
            this._list.dispose();
            this._list = null;
         }
         super.dispose();
      }
   }
}
