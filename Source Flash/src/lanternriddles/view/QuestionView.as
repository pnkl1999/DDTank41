package lanternriddles.view
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import lanternriddles.LanternRiddlesManager;
   import lanternriddles.data.LanternInfo;
   import road7th.comm.PackageIn;
   
   public class QuestionView extends Sprite
   {
      
      private static var SELECT_NUM:int = 4;
       
      
      private var _questionTitle:FilterFrameText;
      
      private var _questionCount:FilterFrameText;
      
      private var _cdTime:FilterFrameText;
      
      private var _question:FilterFrameText;
      
      private var _question2:FilterFrameText;
      
      private var _selectVec:Vector.<MovieImage>;
      
      private var _grayFilters:Array;
      
      private var _countDownTime:Number;
      
      private var _timer:Timer;
      
      private var _count:int;
      
      private var _info:LanternInfo;
      
      private var _resultMovie:MovieImage;
      
      public function QuestionView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._selectVec = new Vector.<MovieImage>();
         this._grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
      }
      
      private function initView() : void
      {
         var _loc1_:MovieImage = null;
         var _loc2_:int = 0;
         this._questionTitle = ComponentFactory.Instance.creatComponentByStylename("lantern.view.questionTitle");
         this._questionTitle.text = LanguageMgr.GetTranslation("lanternRiddles.view.questionTitleText");
         addChild(this._questionTitle);
         this._questionCount = ComponentFactory.Instance.creatComponentByStylename("lantern.view.questionCount");
         addChild(this._questionCount);
         this._cdTime = ComponentFactory.Instance.creatComponentByStylename("lantern.view.questionCDTime");
         this._cdTime.text = LanguageMgr.GetTranslation("lanternRiddles.view.cdTime",9);
         addChild(this._cdTime);
         this._question = ComponentFactory.Instance.creatComponentByStylename("lantern.view.question");
         addChild(this._question);
         this._question2 = ComponentFactory.Instance.creatComponentByStylename("lantern.view.question2");
         addChild(this._question2);
         _loc2_ = 0;
         while(_loc2_ < SELECT_NUM)
         {
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("lantern.view.selectMovie");
            _loc1_.buttonMode = true;
            _loc1_.movie.gotoAndStop(1);
            _loc1_.addEventListener(MouseEvent.CLICK,this.__onSelectClick);
            PositionUtils.setPos(_loc1_,"lantern.view.selectPos" + _loc2_);
            addChild(_loc1_);
            this._selectVec.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         LanternRiddlesManager.instance.addEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_ANSWERRESULT,this.__onAnswerResult);
      }
      
      protected function __onAnswerResult(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:Boolean = _loc2_.readBoolean();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:String = _loc2_.readUTF();
         if(_loc4_)
         {
            this.setAnswerFlag(_loc5_);
         }
         if(_loc3_)
         {
            this._resultMovie = ComponentFactory.Instance.creat("lantern.view.correctMovie");
         }
         else
         {
            this._resultMovie = ComponentFactory.Instance.creat("lantern.view.errorMovie");
         }
         LayerManager.Instance.addToLayer(this._resultMovie,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         this._resultMovie.movie["result"]["awardText"].autoSize = TextFieldAutoSize.CENTER;
         this._resultMovie.movie["result"]["awardText"].text = _loc6_;
         this._resultMovie.x = (StageReferance.stage.stageWidth - this._resultMovie.width) / 2;
         this._resultMovie.y = 290;
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      protected function __onEnterFrame(param1:Event) : void
      {
         if(this._resultMovie && this._resultMovie.parent && this._resultMovie.movie.currentFrame == 40)
         {
            this._resultMovie.parent.removeChild(this._resultMovie);
            this._resultMovie.dispose();
            this._resultMovie = null;
            removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         }
      }
      
      public function set info(param1:LanternInfo) : void
      {
         this._info = param1;
         this.setQuestionCount(this._info.QuestionIndex);
         this.setQuestionInfo(param1);
         this.setCDTime(this._info.EndDate);
         this.setAnswerFlag(this._info.Option);
      }
      
      private function setQuestionCount(param1:int) : void
      {
         this._questionCount.text = param1.toString() + "/" + this._count.toString();
      }
      
      private function setQuestionInfo(param1:LanternInfo) : void
      {
         this._question.text = param1.QuestionContent;
         this._question2.text = LanguageMgr.GetTranslation("lanternRiddles.view.questionText","\n",param1.Option1,param1.Option2,param1.Option3,param1.Option4);
      }
      
      private function setCDTime(param1:Date) : void
      {
         this._countDownTime = param1.time - TimeManager.Instance.Now().time;
         if(this._countDownTime > 0)
         {
            this._countDownTime /= 1000;
            this._cdTime.visible = true;
            this._cdTime.text = LanguageMgr.GetTranslation("lanternRiddles.view.cdTime",this.transSecond(this._countDownTime));
            if(!this._timer)
            {
               this._timer = new Timer(1000);
               this._timer.addEventListener(TimerEvent.TIMER,this.__onTimer);
            }
            this._timer.start();
         }
         else
         {
            this._cdTime.visible = false;
            if(this._timer)
            {
               this._timer.stop();
               this._timer.reset();
            }
         }
      }
      
      protected function __onTimer(param1:TimerEvent) : void
      {
         --this._countDownTime;
         if(this._countDownTime < 0)
         {
            this._timer.stop();
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer = null;
         }
         else if(this._cdTime)
         {
            this._cdTime.text = LanguageMgr.GetTranslation("lanternRiddles.view.cdTime",this.transSecond(this._countDownTime));
         }
      }
      
      private function transSecond(param1:Number) : String
      {
         return String("0" + Math.floor(param1 % 60)).substr(-2);
      }
      
      protected function __onSelectClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         SoundManager.instance.playButtonSound();
         var _loc2_:MovieImage = param1.currentTarget as MovieImage;
         _loc3_ = 0;
         while(_loc3_ < this._selectVec.length)
         {
            if(_loc2_ == this._selectVec[_loc3_])
            {
               this._selectVec[_loc3_].movie.gotoAndStop(2);
               this._info.Option = _loc3_ + 1;
               SocketManager.Instance.out.sendLanternRiddlesAnswer(this._info.QuestionID,this._info.QuestionIndex,this._info.Option);
            }
            this._selectVec[_loc3_].filters = this._grayFilters;
            this._selectVec[_loc3_].removeEventListener(MouseEvent.CLICK,this.__onSelectClick);
            _loc3_++;
         }
      }
      
      private function setAnswerFlag(param1:int) : void
      {
         if(param1 > 0)
         {
            this.setSelectBtnEnable(false);
            this._selectVec[param1 - 1].movie.gotoAndStop(2);
         }
      }
      
      public function setSelectBtnEnable(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._selectVec.length)
         {
            this._selectVec[_loc2_].movie.gotoAndStop(1);
            if(param1)
            {
               this._selectVec[_loc2_].filters = null;
               this._selectVec[_loc2_].addEventListener(MouseEvent.CLICK,this.__onSelectClick);
            }
            else
            {
               this._selectVec[_loc2_].filters = this._grayFilters;
               this._selectVec[_loc2_].removeEventListener(MouseEvent.CLICK,this.__onSelectClick);
            }
            _loc2_++;
         }
      }
      
      private function removeEvent() : void
      {
         LanternRiddlesManager.instance.removeEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_ANSWERRESULT,this.__onAnswerResult);
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvent();
         if(this._questionTitle)
         {
            this._questionTitle.dispose();
            this._questionTitle = null;
         }
         if(this._questionCount)
         {
            this._questionCount.dispose();
            this._questionCount = null;
         }
         if(this._question)
         {
            this._question.dispose();
            this._question = null;
         }
         if(this._question2)
         {
            this._question2.dispose();
            this._question2 = null;
         }
         if(this._cdTime)
         {
            this._cdTime.dispose();
            this._cdTime = null;
         }
         if(this._timer)
         {
            this._timer.stop();
            this._timer.reset();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimer);
            this._timer = null;
         }
         if(this._selectVec)
         {
            _loc1_ = 0;
            while(_loc1_ < this._selectVec.length)
            {
               this._selectVec[_loc1_].removeEventListener(MouseEvent.CLICK,this.__onSelectClick);
               this._selectVec[_loc1_].dispose();
               this._selectVec[_loc1_] = null;
               _loc1_++;
            }
            this._selectVec.length = 0;
            this._selectVec = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
      }
      
      public function get info() : LanternInfo
      {
         return this._info;
      }
      
      public function get countDownTime() : Number
      {
         return this._countDownTime;
      }
   }
}
