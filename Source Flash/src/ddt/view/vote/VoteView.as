package ddt.view.vote
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.vote.VoteQuestionInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.manager.VoteManager;
   import ddt.view.bossbox.BoxAwardsCell;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class VoteView extends Frame
   {
      
      public static var OK_CLICK:String = "Ok_click";
      
      public static var VOTEVIEW_CLOSE:String = "voteView_close";
      
      private static var CELL_1_GOODS:int = 11904;
      
      private static var CELL_2_GOODS:int = 11032;
      
      private static var TWOLINEHEIGHT:int = 31;
      
      private static var questionBGHeight_2line:int = 188;
      
      private static var questionBGY_2line:int = 143;
      
      private static var questionContentY_2line:int = 158;
       
      
      private var _voteInfo:VoteQuestionInfo;
      
      private var _choseAnswerID:int;
      
      private var _itemArr:Array;
      
      private var _answerIDArr:Array;
      
      private var _answerGroup:SelectedButtonGroup;
      
      private var _okBtn:TextButton;
      
      private var _questionBG:Scale9CornerImage;
      
      private var _answerBG:Scale9CornerImage;
      
      private var _questionContent:FilterFrameText;
      
      private var _voteProgress:FilterFrameText;
      
      private var _awardBG:Scale9CornerImage;
      
      private var _awardWord:Bitmap;
      
      private var _cell1:BoxAwardsCell;
      
      private var _cell2:BoxAwardsCell;
      
      public function VoteView()
      {
         super();
         this.addEvent();
      }
      
      public function get choseAnswerID() : int
      {
         return this._choseAnswerID;
      }
      
      override protected function init() : void
      {
         super.init();
         this._itemArr = new Array();
         escEnable = true;
         titleText = LanguageMgr.GetTranslation("ddt.view.vote.title");
         this._questionBG = ComponentFactory.Instance.creatComponentByStylename("vote.questionBG");
         this._answerBG = ComponentFactory.Instance.creatComponentByStylename("vote.answerBG");
         this._questionContent = ComponentFactory.Instance.creat("vote.questionContent");
         this._voteProgress = ComponentFactory.Instance.creat("vote.progress");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("vote.okBtn");
         this._awardBG = ComponentFactory.Instance.creatComponentByStylename("vote.awardBG");
         this._awardWord = ComponentFactory.Instance.creatBitmap("asset.vote.awardWord");
         this._cell1 = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
         this._cell2 = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
         this._cell1.info = ItemManager.Instance.getTemplateById(parseInt(VoteManager.Instance.awardArr[0]));
         this._cell2.info = ItemManager.Instance.getTemplateById(parseInt(VoteManager.Instance.awardArr[1]));
         this._cell1.count = 1;
         this._cell2.count = 1;
         addToContent(this._questionBG);
         addToContent(this._answerBG);
         addToContent(this._questionContent);
         addToContent(this._voteProgress);
         addToContent(this._okBtn);
         addToContent(this._awardBG);
         addToContent(this._awardWord);
         this._awardBG.addChild(this._cell1);
         this._awardBG.addChild(this._cell2);
         this._cell2.y = 17;
         this._cell1.y = 17;
         this._cell1.x = 24;
         this._cell2.x = 233;
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
      }
      
      public function set info(param1:VoteQuestionInfo) : void
      {
         this._voteInfo = param1;
         this.update();
      }
      
      private function update() : void
      {
         var _loc2_:* = null;
         var _loc3_:SelectedCheckButton = null;
         this.clear();
         this._voteProgress.text = "进度" + VoteManager.Instance.count + "/" + VoteManager.Instance.questionLength;
         this._answerGroup = new SelectedButtonGroup();
         this._itemArr = new Array();
         this._answerIDArr = new Array();
         var _loc1_:int = 0;
         this._questionContent.text = "    " + this._voteInfo.question;
         for(_loc2_ in this._voteInfo.answer)
         {
            _loc1_++;
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("vote.answer.selectedBtn");
            _loc3_.text = _loc1_ + "、" + this._voteInfo.answer[_loc2_];
            this._answerBG.addChild(_loc3_);
            this._answerGroup.addSelectItem(_loc3_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.__playSound);
            _loc3_.y = (_loc3_.height + 10) * (_loc1_ - 1) + 15;
            this._itemArr.push(_loc3_);
            this._answerIDArr.push(_loc2_);
         }
         if(this._questionContent.textHeight < TWOLINEHEIGHT)
         {
            this._questionBG.height = questionBGHeight_2line - 25;
            this._questionBG.y = questionBGY_2line + 25;
            this._questionContent.y = questionContentY_2line + 20;
         }
         else
         {
            this._questionBG.height = questionBGHeight_2line;
            this._questionBG.y = questionBGY_2line;
            this._questionContent.y = questionContentY_2line;
         }
      }
      
      private function __playSound(param1:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function clear() : void
      {
         this._questionContent.text = "";
         this._voteProgress.text = "";
         if(this._answerGroup)
         {
            this._answerGroup.dispose();
         }
         this._answerGroup = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArr.length)
         {
            this._itemArr[_loc1_].removeEventListener(MouseEvent.CLICK,this.__playSound);
            this._itemArr[_loc1_].dispose();
            this._itemArr[_loc1_] = null;
            _loc1_++;
         }
         this._itemArr = null;
         this._answerIDArr = null;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < this._itemArr.length)
         {
            if((this._itemArr[_loc3_] as SelectedCheckButton).selected)
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(!_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.vote.choseOne"));
            return;
         }
         dispatchEvent(new Event(OK_CLICK));
      }
      
      public function get selectAnswer() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this._itemArr.length)
         {
            if((this._itemArr[_loc2_] as SelectedCheckButton).selected)
            {
               _loc1_ = _loc1_ + this._answerIDArr[_loc2_] + ",";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
               dispatchEvent(new Event(VOTEVIEW_CLOSE));
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clear();
         super.dispose();
         if(this._answerBG)
         {
            ObjectUtils.disposeObject(this._answerBG);
         }
         this._answerBG = null;
         if(this._answerGroup)
         {
            ObjectUtils.disposeObject(this._answerGroup);
         }
         this._answerGroup = null;
         if(this._okBtn)
         {
            ObjectUtils.disposeObject(this._okBtn);
         }
         this._okBtn = null;
         if(this._questionBG)
         {
            ObjectUtils.disposeObject(this._questionBG);
         }
         this._questionBG = null;
         if(this._questionContent)
         {
            ObjectUtils.disposeObject(this._questionContent);
         }
         this._questionContent = null;
         if(this._voteProgress)
         {
            ObjectUtils.disposeObject(this._voteProgress);
         }
         this._voteProgress = null;
         if(this._awardBG)
         {
            ObjectUtils.disposeObject(this._awardBG);
         }
         this._awardBG = null;
         if(this._awardWord)
         {
            ObjectUtils.disposeObject(this._awardWord);
         }
         this._awardWord = null;
         if(this._cell1)
         {
            this._cell1.dispose();
         }
         this._cell1 = null;
         if(this._cell2)
         {
            this._cell2.dispose();
         }
         this._cell2 = null;
         this._itemArr = null;
         this._answerIDArr = null;
         this._voteInfo = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
