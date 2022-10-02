package eliteGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.CloneImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import eliteGame.EliteGameController;
   import eliteGame.EliteGameEvent;
   import eliteGame.info.EliteGameAllScoreRankInfo;
   import eliteGame.info.EliteGameScroeRankInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EliteGameScoreRankView extends Sprite implements Disposeable
   {
      
      private static var type30_40:int = 0;
      
      private static var type41_50:int = 1;
       
      
      private var _between30_40:SelectedCheckButton;
      
      private var _between41_50:SelectedCheckButton;
      
      private var _betweenBtnGroup:SelectedButtonGroup;
      
      private var _bg1:ScaleBitmapImage;
      
      private var _bg2:ScaleBitmapImage;
      
      private var _bg3:ScaleBitmapImage;
      
      private var _bg4:ScaleBitmapImage;
      
      private var _rankBmp:Bitmap;
      
      private var _nameBmp:Bitmap;
      
      private var _scoreBmp:Bitmap;
      
      private var _myRank:Bitmap;
      
      private var _myScore:Bitmap;
      
      private var _mySRBG1:Bitmap;
      
      private var _mySRBG2:Bitmap;
      
      private var _myRankText:FilterFrameText;
      
      private var _myScoreText:FilterFrameText;
      
      private var _nextPage:SimpleBitmapButton;
      
      private var _prePage:SimpleBitmapButton;
      
      private var _pageTextBG:ScaleBitmapImage;
      
      private var _pageText:FilterFrameText;
      
      private var _updateTimeText:FilterFrameText;
      
      private var _gridBG:CloneImage;
      
      private var _vbox:VBox;
      
      private var _items:Vector.<EliteGameScoreRankItem>;
      
      private var _allInfo:EliteGameAllScoreRankInfo;
      
      private var _list:Vector.<EliteGameScroeRankInfo>;
      
      private var _totalPage:int = 1;
      
      private var _currentPage:int;
      
      public function EliteGameScoreRankView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function set currentPage(param1:int) : void
      {
         this._currentPage = param1;
         this._pageText.text = this._currentPage.toString();
         if(this._currentPage == 1)
         {
            this._prePage.enable = false;
         }
         else
         {
            this._prePage.enable = true;
         }
         if(this._currentPage == this._totalPage)
         {
            this._nextPage.enable = false;
         }
         else
         {
            this._nextPage.enable = true;
         }
      }
      
      private function initView() : void
      {
         this._between30_40 = ComponentFactory.Instance.creatComponentByStylename("eliteGame.between30_40Btn");
         this._between41_50 = ComponentFactory.Instance.creatComponentByStylename("eliteGame.between41_50Btn");
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.bg1");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.bg2");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.bg3");
         this._bg4 = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.bg4");
         this._rankBmp = ComponentFactory.Instance.creatBitmap("EliteGame.scoreRank.rankBmp");
         this._nameBmp = ComponentFactory.Instance.creatBitmap("EliteGame.scoreRank.nameBmp");
         this._scoreBmp = ComponentFactory.Instance.creatBitmap("EliteGame.scoreRank.scorebmp");
         this._myRank = ComponentFactory.Instance.creatBitmap("EliteGame.scoreRank.myRank");
         this._myScore = ComponentFactory.Instance.creatBitmap("EliteGame.scoreRank.scoretitle");
         this._mySRBG1 = ComponentFactory.Instance.creatBitmap("EliteGame.scoreRank.mySRBG");
         this._mySRBG2 = ComponentFactory.Instance.creatBitmap("EliteGame.scoreRank.mySRBG");
         this._myRankText = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.rankAndScoreTxt");
         this._myScoreText = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.rankAndScoreTxt");
         this._nextPage = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.nextBtn");
         this._prePage = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.preBtn");
         this._pageTextBG = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.pageTextBG");
         this._pageText = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.pageText");
         this._updateTimeText = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.updateTimeTxt");
         this._gridBG = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreRankView.GridBG");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("eliteGame.scoreItem.vbox");
         addChild(this._between30_40);
         addChild(this._between41_50);
         addChild(this._bg1);
         addChild(this._bg2);
         addChild(this._bg3);
         addChild(this._bg4);
         addChild(this._rankBmp);
         addChild(this._nameBmp);
         addChild(this._scoreBmp);
         addChild(this._myRank);
         addChild(this._myScore);
         addChild(this._mySRBG1);
         addChild(this._mySRBG2);
         addChild(this._myRankText);
         addChild(this._myScoreText);
         addChild(this._nextPage);
         addChild(this._prePage);
         addChild(this._pageTextBG);
         addChild(this._pageText);
         addChild(this._updateTimeText);
         addChild(this._gridBG);
         addChild(this._vbox);
         this._betweenBtnGroup = new SelectedButtonGroup();
         this._betweenBtnGroup.addSelectItem(this._between30_40);
         this._betweenBtnGroup.addSelectItem(this._between41_50);
         if(PlayerManager.Instance.Self.Grade >= 41 && PlayerManager.Instance.Self.Grade <= 50)
         {
            this._betweenBtnGroup.selectIndex = 1;
         }
         else
         {
            this._betweenBtnGroup.selectIndex = 0;
         }
         PositionUtils.setPos(this._mySRBG1,"eliteGame.scoreRank.myRankbg.pos");
         PositionUtils.setPos(this._mySRBG2,"eliteGame.scoreRank.myscroebg.pos");
         PositionUtils.setPos(this._myRankText,"eliteGame.scoreRank.myRankText.pos");
         PositionUtils.setPos(this._myScoreText,"eliteGame.scoreRank.myScoreText.pos");
         this._myRankText.text = EliteGameController.Instance.Model.selfRank.toString();
         this._myScoreText.text = EliteGameController.Instance.Model.selfScore.toString();
         this._allInfo = EliteGameController.Instance.Model.scoreRankInfo;
         this.currentPage = 1;
         if(this._allInfo)
         {
            this._updateTimeText.text = LanguageMgr.GetTranslation("tank.tofflist.view.lastUpdateTime") + this._allInfo.lassUpdateTime;
         }
         this.showType(this._betweenBtnGroup.selectIndex);
      }
      
      private function initEvent() : void
      {
         this._prePage.addEventListener(MouseEvent.CLICK,this.__prePageHandler);
         this._nextPage.addEventListener(MouseEvent.CLICK,this.__nextPagehandler);
         this._betweenBtnGroup.addEventListener(Event.CHANGE,this.__betweenChangeHandler);
         EliteGameController.Instance.Model.addEventListener(EliteGameEvent.SCORERANK_DATAREADY,this.__dataReady);
         EliteGameController.Instance.Model.addEventListener(EliteGameEvent.SELF_RANK_SCORE_READY,this.__selfRankReady);
      }
      
      private function removeEvent() : void
      {
         this._prePage.removeEventListener(MouseEvent.CLICK,this.__prePageHandler);
         this._nextPage.removeEventListener(MouseEvent.CLICK,this.__nextPagehandler);
         this._betweenBtnGroup.removeEventListener(Event.CHANGE,this.__betweenChangeHandler);
         EliteGameController.Instance.Model.removeEventListener(EliteGameEvent.SCORERANK_DATAREADY,this.__dataReady);
         EliteGameController.Instance.Model.removeEventListener(EliteGameEvent.SELF_RANK_SCORE_READY,this.__selfRankReady);
      }
      
      private function __selfRankReady(param1:EliteGameEvent) : void
      {
         this._myRankText.text = EliteGameController.Instance.Model.selfRank.toString();
         this._myScoreText.text = EliteGameController.Instance.Model.selfScore.toString();
      }
      
      private function __prePageHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setPage(this.currentPage - 1);
      }
      
      private function __nextPagehandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setPage(this.currentPage + 1);
      }
      
      protected function __dataReady(param1:Event) : void
      {
         this._allInfo = EliteGameController.Instance.Model.scoreRankInfo;
         this._updateTimeText.text = LanguageMgr.GetTranslation("tank.tofflist.view.lastUpdateTime") + this._allInfo.lassUpdateTime;
         this.showType(this._betweenBtnGroup.selectIndex);
      }
      
      protected function __betweenChangeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.showType(this._betweenBtnGroup.selectIndex);
      }
      
      private function showType(param1:int) : void
      {
         switch(param1)
         {
            case type30_40:
               if(this._allInfo)
               {
                  this.setTypeData(this._allInfo.rank30_40);
               }
               break;
            case type41_50:
               if(this._allInfo)
               {
                  this.setTypeData(this._allInfo.rank41_50);
               }
         }
         this.setPage(1);
      }
      
      private function setTypeData(param1:Vector.<EliteGameScroeRankInfo>) : void
      {
         this._list = param1;
         this._totalPage = Math.ceil(this._list.length / 8) == 0 ? int(int(1)) : int(int(Math.ceil(this._list.length / 8)));
      }
      
      private function setPage(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.currentPage = param1;
         if(this._list)
         {
            _loc2_ = (param1 - 1) * 8;
            _loc3_ = param1 * 8 > this._list.length ? int(int(this._list.length)) : int(int(param1 * 8));
            this.setPageData(this._list.slice(_loc2_,_loc3_));
         }
      }
      
      private function setPageData(param1:Vector.<EliteGameScroeRankInfo>) : void
      {
         var _loc3_:EliteGameScoreRankItem = null;
         this.clearItems();
         this._items = new Vector.<EliteGameScoreRankItem>();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new EliteGameScoreRankItem();
            _loc3_.info = param1[_loc2_];
            this._vbox.addChild(_loc3_);
            this._items.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function clearItems() : void
      {
         var _loc1_:int = 0;
         if(this._items && this._items.length != 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               ObjectUtils.disposeObject(this._items[_loc1_]);
               this._items[_loc1_] = null;
               _loc1_++;
            }
         }
         this._items = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._between30_40)
         {
            ObjectUtils.disposeObject(this._between30_40);
         }
         this._between30_40 = null;
         if(this._between41_50)
         {
            ObjectUtils.disposeObject(this._between41_50);
         }
         this._between41_50 = null;
         if(this._bg1)
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(this._bg2)
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         this._bg2 = null;
         if(this._bg3)
         {
            ObjectUtils.disposeObject(this._bg3);
         }
         this._bg3 = null;
         if(this._bg4)
         {
            ObjectUtils.disposeObject(this._bg4);
         }
         this._bg4 = null;
         if(this._rankBmp)
         {
            ObjectUtils.disposeObject(this._rankBmp);
         }
         this._rankBmp = null;
         if(this._nameBmp)
         {
            ObjectUtils.disposeObject(this._nameBmp);
         }
         this._nameBmp = null;
         if(this._scoreBmp)
         {
            ObjectUtils.disposeObject(this._scoreBmp);
         }
         this._scoreBmp = null;
         if(this._myRank)
         {
            ObjectUtils.disposeObject(this._myRank);
         }
         this._myRank = null;
         if(this._myScore)
         {
            ObjectUtils.disposeObject(this._myScore);
         }
         this._myScore = null;
         if(this._mySRBG1)
         {
            ObjectUtils.disposeObject(this._mySRBG1);
         }
         this._mySRBG1 = null;
         if(this._mySRBG2)
         {
            ObjectUtils.disposeObject(this._mySRBG2);
         }
         this._mySRBG2 = null;
         if(this._myRankText)
         {
            ObjectUtils.disposeObject(this._myRankText);
         }
         this._myRankText = null;
         if(this._myScoreText)
         {
            ObjectUtils.disposeObject(this._myScoreText);
         }
         this._myScoreText = null;
         if(this._nextPage)
         {
            ObjectUtils.disposeObject(this._nextPage);
         }
         this._nextPage = null;
         if(this._prePage)
         {
            ObjectUtils.disposeObject(this._prePage);
         }
         this._prePage = null;
         if(this._pageTextBG)
         {
            ObjectUtils.disposeObject(this._pageTextBG);
         }
         this._pageTextBG = null;
         if(this._pageText)
         {
            ObjectUtils.disposeObject(this._pageText);
         }
         this._pageText = null;
         if(this._updateTimeText)
         {
            ObjectUtils.disposeObject(this._updateTimeText);
         }
         this._updateTimeText = null;
         if(this._gridBG)
         {
            ObjectUtils.disposeObject(this._gridBG);
         }
         this._gridBG = null;
         this.clearItems();
         if(this._vbox)
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         this._allInfo = null;
         this._list = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
