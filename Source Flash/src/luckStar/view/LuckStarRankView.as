package luckStar.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import luckStar.LoadingLuckStarUI;
   import luckStar.manager.LuckStarManager;
   import luckStar.model.LuckStarPlayerInfo;
   
   public class LuckStarRankView extends Sprite implements Disposeable
   {
      
      private static const MAX_RANK_VIEW:int = 5;
      
      private static const MAX_PAGE:int = 2;
      
      private static const MAX_AWARD:int = 3;
      
      private static const REQUEST_TIME:int = 300000;
       
      
      private var _rankBG:Bitmap;
      
      private var _awardListBG:Bitmap;
      
      private var _awardBtn:BaseButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _pageBG:Scale9CornerImage;
      
      private var _pageText:FilterFrameText;
      
      private var _updateTimeText:FilterFrameText;
      
      private var _timeText:FilterFrameText;
      
      private var _myRankText:FilterFrameText;
      
      private var _luckyStarNumText:FilterFrameText;
      
      private var _rankInfo:Vector.<LuckStarRankItem>;
      
      private var _currentPage:int = 1;
      
      private var _maxPage:int = 1;
      
      private var _newAward:Sprite;
      
      private var _newAwardList:Vector.<LuckStarNewAwardItem>;
      
      private var _list:Vector.<Array>;
      
      private var _isMove:Boolean = false;
      
      private var _textHeight:int;
      
      private var _awardView:LuckStarAwardView;
      
      private var _index:int;
      
      private var _rankTitle:FilterFrameText;
      
      private var _rankName:FilterFrameText;
      
      private var _rankNum:FilterFrameText;
      
      private var _awardNmae:FilterFrameText;
      
      private var _awardListText:FilterFrameText;
      
      private var _time:Timer;
      
      private var _helpText:FilterFrameText;
      
      public function LuckStarRankView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:LuckStarRankItem = null;
         var _loc6_:LuckStarNewAwardItem = null;
         this._rankBG = ComponentFactory.Instance.creat("luckyStar.view.RankBG");
         this._awardListBG = ComponentFactory.Instance.creat("luckyStar.view.NewAwardListBG");
         this._awardBtn = ComponentFactory.Instance.creat("luckyStar.view.AwardBtn");
         this._preBtn = ComponentFactory.Instance.creat("luckyStar.view.preBtn");
         this._nextBtn = ComponentFactory.Instance.creat("luckyStar.view.nextBtn");
         this._pageBG = ComponentFactory.Instance.creat("luckyStar.view.pageLastBg");
         this._pageText = ComponentFactory.Instance.creat("luckyStar.view.pageText");
         this._updateTimeText = ComponentFactory.Instance.creat("luckyStar.view.updateTimeText");
         this._myRankText = ComponentFactory.Instance.creat("luckyStar.view.myRankText");
         this._luckyStarNumText = ComponentFactory.Instance.creat("luckyStar.view.luckyStarNumText");
         this._timeText = ComponentFactory.Instance.creat("luckyStar.view.timeText");
         this._rankTitle = ComponentFactory.Instance.creat("luckyStar.view.rankTitle");
         this._rankTitle.text = LanguageMgr.GetTranslation("repute");
         this._rankName = ComponentFactory.Instance.creat("luckyStar.view.rankName");
         this._rankName.text = LanguageMgr.GetTranslation("civil.rightview.listname");
         this._rankNum = ComponentFactory.Instance.creat("luckyStar.view.rankNum");
         this._rankNum.text = LanguageMgr.GetTranslation("ddt.luckStar.useStarNum");
         this._awardNmae = ComponentFactory.Instance.creat("luckyStar.view.awardNum");
         this._awardNmae.text = LanguageMgr.GetTranslation("itemview.listname");
         this._awardListText = ComponentFactory.Instance.creat("luckyStar.view.awardListText");
         this._awardListText.text = LanguageMgr.GetTranslation("ddt.luckStar.awardList");
         this._helpText = ComponentFactory.Instance.creat("luckyStar.view.helpTextText");
         this._newAward = new Sprite();
         this._newAward.scrollRect = ComponentFactory.Instance.creat("luckyStar.view.newAwardViewRec");
         PositionUtils.setPos(this._newAward,"luckyStar.view.newAwardPos");
         addChild(this._rankBG);
         addChild(this._awardListBG);
         addChild(this._awardBtn);
         addChild(this._preBtn);
         addChild(this._nextBtn);
         addChild(this._pageBG);
         addChild(this._pageText);
         addChild(this._updateTimeText);
         addChild(this._myRankText);
         addChild(this._luckyStarNumText);
         addChild(this._timeText);
         addChild(this._newAward);
         addChild(this._rankTitle);
         addChild(this._rankName);
         addChild(this._rankNum);
         addChild(this._awardNmae);
         addChild(this._awardListText);
         addChild(this._helpText);
         _loc1_ = 87;
         _loc2_ = 35;
         var _loc3_:int = 24;
         this._rankInfo = new Vector.<LuckStarRankItem>();
         _loc4_ = 0;
         while(_loc4_ < MAX_RANK_VIEW)
         {
            _loc5_ = new LuckStarRankItem();
            _loc5_.x = _loc3_;
            _loc5_.y = _loc1_;
            _loc1_ += _loc2_;
            addChild(_loc5_);
            this._rankInfo.push(_loc5_);
            _loc4_++;
         }
         this._newAwardList = new Vector.<LuckStarNewAwardItem>();
         _loc4_ = 0;
         while(_loc4_ < MAX_AWARD)
         {
            _loc6_ = new LuckStarNewAwardItem();
            this._textHeight = _loc6_.height;
            _loc6_.y = this._textHeight * _loc4_;
            this._newAward.addChild(_loc6_);
            this._newAwardList.push(_loc6_);
            _loc4_++;
         }
         this._awardBtn.addEventListener(MouseEvent.CLICK,this.__onAwardClick);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__onPreClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__onNextClick);
         this._time = new Timer(REQUEST_TIME,1);
         this._time.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimer);
         this._time.start();
         this.currentPage = 1;
         this.updateActivityDate();
         this.updateNewAwardList();
         this.updateHelpText();
      }
      
      public function updateNewAwardList() : void
      {
         this._list = LuckStarManager.Instance.model.newRewardList;
         this.moreItemPlay();
      }
      
      public function insertNewAwardItem(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:LuckStarNewAwardItem = new LuckStarNewAwardItem();
         _loc4_.setText(param1,param2,param3);
         _loc4_.y = this._newAwardList[this._newAwardList.length - 1].y + this._textHeight;
         this._newAward.addChild(_loc4_);
         this._newAwardList.push(_loc4_);
         if(this._newAwardList.length > MAX_AWARD)
         {
            if(!this._isMove)
            {
               addEventListener(Event.ENTER_FRAME,this.__onMove);
            }
            this._isMove = true;
         }
      }
      
      private function __onMove(param1:Event) : void
      {
         if(!this._isMove)
         {
            return;
         }
         var _loc2_:int = this._newAwardList.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._newAwardList[_loc3_].y -= 1;
            _loc3_++;
         }
         this.check();
      }
      
      private function check() : void
      {
         if(this._newAwardList.length > MAX_AWARD)
         {
            if(Math.abs(this._newAwardList[0].y) > this._textHeight)
            {
               ObjectUtils.disposeObject(this._newAwardList.shift());
               if(this._newAwardList.length == MAX_AWARD)
               {
                  this._isMove = false;
                  this._newAwardList[0].y = 0;
                  this._newAwardList[1].y = this._textHeight;
                  this._newAwardList[2].y = this._textHeight * 2;
                  removeEventListener(Event.ENTER_FRAME,this.__onMove);
                  this.moreItemPlay();
               }
               ++this._index;
            }
         }
      }
      
      private function moreItemPlay() : void
      {
         if(this._list != null && this._list.length > 0)
         {
            if(this._index >= this._list.length)
            {
               this._index = 0;
            }
            this.insertNewAwardItem(this._list[this._index][2],int(this._list[this._index][0]),int(this._list[this._index][1]));
         }
      }
      
      private function __onPreClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = this._currentPage - 1;
         if(_loc2_ < 1)
         {
            _loc2_ = this._maxPage;
         }
         this.currentPage = _loc2_;
      }
      
      private function __onNextClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = this._currentPage + 1;
         if(_loc2_ > this._maxPage)
         {
            _loc2_ = 1;
         }
         this.currentPage = _loc2_;
      }
      
      private function __onAwardClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._awardView == null)
         {
            this._awardView = new LuckStarAwardView();
         }
         if(this._awardView.parent == null)
         {
            addChild(this._awardView);
         }
      }
      
      private function set currentPage(param1:int) : void
      {
         if(this._currentPage == param1)
         {
            return;
         }
         this._currentPage = param1;
         this.updateRankInfo();
      }
      
      public function updateRankInfo() : void
      {
         if(LuckStarManager.Instance.model.rank == null || LuckStarManager.Instance.model.rank.length == 0)
         {
            return;
         }
         this._maxPage = LuckStarManager.Instance.model.rank.length;
         this._pageText.text = this._currentPage.toString() + "/" + this._maxPage.toString();
         var _loc1_:Vector.<LuckStarPlayerInfo> = LuckStarManager.Instance.model.rank[this._currentPage - 1] as Vector.<LuckStarPlayerInfo>;
         var _loc2_:int = 0;
         while(_loc2_ < MAX_RANK_VIEW)
         {
            this._rankInfo[_loc2_].resetItem();
            if(_loc2_ < _loc1_.length && _loc1_[_loc2_] != null)
            {
               this._rankInfo[_loc2_].info = _loc1_[_loc2_];
            }
            _loc2_++;
         }
      }
      
      public function lastUpdateTime() : void
      {
         this._updateTimeText.text = LanguageMgr.GetTranslation("ddt.luckStar.updateTime",LuckStarManager.Instance.model.lastDate);
      }
      
      public function updateSelfInfo() : void
      {
         var _loc1_:LuckStarPlayerInfo = LuckStarManager.Instance.model.selfInfo;
         if(_loc1_)
         {
            this._myRankText.text = _loc1_.rank.toString();
            this._luckyStarNumText.text = _loc1_.starNum.toString();
         }
      }
      
      public function updateHelpText() : void
      {
         this._helpText.text = LanguageMgr.GetTranslation("ddt.luckStar.useLuckStarHelp",LuckStarManager.Instance.model.minUseNum);
      }
      
      public function updateActivityDate() : void
      {
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:Array = LuckStarManager.Instance.model.activityDate;
         if(_loc1_)
         {
            _loc2_ = _loc1_[0] as Date;
            _loc3_ = _loc1_[1] as Date;
            _loc4_ = LanguageMgr.GetTranslation("ddt.luckStar.fullDate",_loc2_.getFullYear(),_loc2_.getMonth() + 1,_loc2_.getDate());
            _loc5_ = LanguageMgr.GetTranslation("ddt.luckStar.fullDate",_loc3_.getFullYear(),_loc3_.getMonth() + 1,_loc3_.getDate());
            this._timeText.text = LanguageMgr.GetTranslation("ddt.luckStar.activityTime",_loc4_,_loc5_);
         }
      }
      
      private function __onTimer(param1:TimerEvent) : void
      {
         LoadingLuckStarUI.Instance.RequestActivityRank();
         this._time.reset();
         this._time.start();
      }
      
      public function dispose() : void
      {
         this._time.stop();
         this._time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onTimer);
         this._time = null;
         this._awardBtn.removeEventListener(MouseEvent.CLICK,this.__onAwardClick);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__onPreClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__onNextClick);
         if(this._isMove)
         {
            this._isMove = false;
            removeEventListener(Event.ENTER_FRAME,this.__onMove);
         }
         ObjectUtils.disposeObject(this._rankBG);
         this._rankBG = null;
         ObjectUtils.disposeObject(this._awardListBG);
         this._awardListBG = null;
         ObjectUtils.disposeObject(this._awardBtn);
         this._awardBtn = null;
         ObjectUtils.disposeObject(this._preBtn);
         this._preBtn = null;
         ObjectUtils.disposeObject(this._nextBtn);
         this._nextBtn = null;
         ObjectUtils.disposeObject(this._pageBG);
         this._pageBG = null;
         ObjectUtils.disposeObject(this._pageText);
         this._pageText = null;
         ObjectUtils.disposeObject(this._updateTimeText);
         this._updateTimeText = null;
         ObjectUtils.disposeObject(this._myRankText);
         this._myRankText = null;
         ObjectUtils.disposeObject(this._luckyStarNumText);
         this._luckyStarNumText = null;
         ObjectUtils.disposeObject(this._timeText);
         this._timeText = null;
         ObjectUtils.disposeObject(this._awardView);
         this._awardView = null;
         ObjectUtils.disposeObject(this._rankTitle);
         this._rankTitle = null;
         ObjectUtils.disposeObject(this._rankName);
         this._rankName = null;
         ObjectUtils.disposeObject(this._rankNum);
         this._rankNum = null;
         ObjectUtils.disposeObject(this._awardNmae);
         this._awardNmae = null;
         ObjectUtils.disposeObject(this._awardListText);
         this._awardListText = null;
         ObjectUtils.disposeObject(this._helpText);
         this._helpText = null;
         while(this._rankInfo.length)
         {
            ObjectUtils.disposeObject(this._rankInfo.pop());
         }
         this._rankInfo = null;
         while(this._newAwardList.length)
         {
            ObjectUtils.disposeObject(this._newAwardList.pop());
         }
         this._newAwardList = null;
         this._newAward = null;
      }
   }
}
