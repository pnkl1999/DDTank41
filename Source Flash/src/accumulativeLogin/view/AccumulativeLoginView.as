package accumulativeLogin.view
{
   import accumulativeLogin.AccumulativeManager;
   import accumulativeLogin.data.AccumulativeLoginRewardData;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Dictionary;
   import wonderfulActivity.views.IRightView;
   
   public class AccumulativeLoginView extends Sprite implements IRightView
   {
       
      
      private var _back:Bitmap;
      
      private var _progressBarBack:Bitmap;
      
      private var _progressBar:Bitmap;
      
      private var _progressBarItemArr:Array;
      
      private var _clickSpriteArr:Array;
      
      private var _progressCompleteItem:MovieClip;
      
      private var _dayTxtArr:Array;
      
      private var _loginDayTxt:FilterFrameText;
      
      private var _loginDayNum:int;
      
      private var _awardDayNum:int;
      
      private var _hBox:HBox;
      
      private var _dataDic:Dictionary;
      
      private var _selectedDay:int;
      
      private var _selectedFiveWeaponId:int;
      
      private var _dayGiftPackDic:Dictionary;
      
      private var _fiveWeaponArr:Array;
      
      private var _bagCellBgArr:Array;
      
      private var _filter:ColorMatrixFilter;
      
      private var _movieStringArr:Array;
      
      private var _movieVector:Vector.<AccumulativeMovieSprite>;
      
      private var _getButton:SimpleBitmapButton;
      
      public function AccumulativeLoginView()
      {
         this._movieStringArr = ["wonderfulactivity.login.gun","wonderfulactivity.login.axe","wonderfulactivity.login.chick","wonderfulactivity.login.boomerang","wonderfulactivity.login.cannon"];
         super();
         this._movieVector = new Vector.<AccumulativeMovieSprite>();
         this._progressBarItemArr = new Array();
         this._clickSpriteArr = new Array();
         this._dayTxtArr = new Array();
         this._dayGiftPackDic = new Dictionary();
         this._bagCellBgArr = new Array();
         this._fiveWeaponArr = new Array();
      }
      
      public function setState(param1:int, param2:int) : void
      {
      }
      
      public function init() : void
      {
         this.createFilter();
         this.initEvent();
         this.initView();
         this.initData();
         this.initViewWithData();
         this.selectedDay = this._loginDayNum;
      }
      
      private function createFilter() : void
      {
         var _loc1_:Array = new Array();
         _loc1_ = _loc1_.concat([0.3086,0.6094,0.082,0,0]);
         _loc1_ = _loc1_.concat([0.3086,0.6094,0.082,0,0]);
         _loc1_ = _loc1_.concat([0.3086,0.6094,0.082,0,0]);
         _loc1_ = _loc1_.concat([0,0,0,1,0]);
         this._filter = new ColorMatrixFilter(_loc1_);
      }
      
      public function initEvent() : void
      {
         AccumulativeManager.instance.addEventListener(AccumulativeManager.ACCUMULATIVE_AWARD_REFRESH,this.__refreshAward);
      }
      
      protected function __refreshAward(param1:Event) : void
      {
         this._loginDayNum = PlayerManager.Instance.Self.accumulativeLoginDays > 7 ? int(int(7)) : int(int(PlayerManager.Instance.Self.accumulativeLoginDays));
         this._awardDayNum = PlayerManager.Instance.Self.accumulativeAwardDays;
         this.checkMovieCanClick();
         if(this._awardDayNum >= this._loginDayNum)
         {
            this._getButton.enable = false;
         }
         else
         {
            this._getButton.enable = true;
         }
         this.selectedDay = this._selectedDay;
      }
      
      private function initView() : void
      {
         var _loc5_:FilterFrameText = null;
         var _loc6_:Bitmap = null;
         _loc5_ = null;
         _loc6_ = null;
         var _loc7_:Sprite = null;
         var _loc8_:AccumulativeMovieSprite = null;
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.login.back");
         addChild(this._back);
         this._loginDayTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.accumulativeLogin.dayTxt");
         addChild(this._loginDayTxt);
         var _loc1_:int = 1;
         while(_loc1_ < 8)
         {
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.accumulativeLogin.dayTxt");
            addChild(_loc5_);
            _loc5_.text = "" + _loc1_;
            _loc5_.x = _loc1_ == 7 ? Number(Number(700)) : Number(Number(334 + 62 * (_loc1_ - 1)));
            _loc5_.y = 150;
            this._dayTxtArr.push(_loc5_);
            _loc1_++;
         }
         this._progressBarBack = ComponentFactory.Instance.creat("wonderfulactivity.login.barback");
         addChild(this._progressBarBack);
         this._progressBar = ComponentFactory.Instance.creat("wonderfulactivity.login.bar");
         addChild(this._progressBar);
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            _loc6_ = ComponentFactory.Instance.creat("wonderfulactivity.login.barItem");
            _loc6_.x = 334 + 62 * _loc2_;
            _loc6_.y = 170;
            addChild(_loc6_);
            this._progressBarItemArr.push(_loc6_);
            _loc2_++;
         }
         this._progressCompleteItem = ComponentFactory.Instance.creat("wonderfulactivity.login.barCompleteItem");
         addChild(this._progressCompleteItem);
         this._progressCompleteItem.y = 170;
         var _loc3_:int = 0;
         while(_loc3_ < 7)
         {
            _loc7_ = new Sprite();
            _loc7_.buttonMode = true;
            _loc7_.graphics.beginFill(0,0);
            if(_loc3_ != 6)
            {
               _loc7_.graphics.drawRect(this._progressBarItemArr[_loc3_].x,170,this._progressBarItemArr[_loc3_].width,this._progressBarItemArr[_loc3_].height);
            }
            else
            {
               _loc7_.graphics.drawRect(this._progressBarItemArr[5].x + 58,170,this._progressBarItemArr[5].width + 8,this._progressBarItemArr[5].height);
            }
            _loc7_.graphics.endFill();
            _loc7_.addEventListener(MouseEvent.CLICK,this.__showAwardHandler);
            addChild(_loc7_);
            this._clickSpriteArr.push(_loc7_);
            _loc3_++;
         }
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("wonderful.accumulativeLogin.Hbox");
         addChild(this._hBox);
         var _loc4_:int = 0;
         while(_loc4_ < this._movieStringArr.length)
         {
            _loc8_ = new AccumulativeMovieSprite(this._movieStringArr[_loc4_]);
            _loc8_.addEventListener(MouseEvent.CLICK,this.__onClickHandler);
            addChild(_loc8_);
            PositionUtils.setPos(_loc8_,"wonderful.accumulativeLogin.moviePos" + (_loc4_ + 1));
            this._movieVector.push(_loc8_);
            _loc4_++;
         }
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("wonderful.ActivityState.GetButton");
         addChild(this._getButton);
         this._getButton.enable = false;
      }
      
      protected function __showAwardHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = this._clickSpriteArr.indexOf(param1.target);
         if(_loc2_ != -1 && _loc2_ + 1 != this.selectedDay)
         {
            this.selectedDay = _loc2_ + 1;
         }
      }
      
      protected function __onClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:AccumulativeMovieSprite = null;
         if(this._loginDayNum < 7)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulactivity.accumulativelogin.txt"));
            return;
         }
         if(param1.currentTarget.state == 3)
         {
            return;
         }
         for each(_loc2_ in this._movieVector)
         {
            if(_loc2_ == param1.currentTarget)
            {
               _loc2_.state = 3;
               this._selectedFiveWeaponId = _loc2_.data.ID;
            }
            else
            {
               _loc2_.state = 1;
            }
         }
      }
      
      protected function __onOverHandler(param1:MouseEvent) : void
      {
         (param1.target as MovieClip).gotoAndPlay(2);
      }
      
      private function checkMovieCanClick() : void
      {
         var _loc1_:AccumulativeMovieSprite = null;
         var _loc2_:AccumulativeMovieSprite = null;
         if(this._loginDayNum >= 7 && this._awardDayNum >= 7)
         {
            for each(_loc1_ in this._movieVector)
            {
               _loc1_.removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
               _loc1_.state = 1;
            }
         }
         if(this._loginDayNum >= 7 && this._awardDayNum < 7)
         {
            for each(_loc2_ in this._movieVector)
            {
               _loc2_.state = 2;
            }
         }
      }
      
      private function initData() : void
      {
         this._loginDayNum = PlayerManager.Instance.Self.accumulativeLoginDays > 7 ? int(int(7)) : int(int(PlayerManager.Instance.Self.accumulativeLoginDays));
         this._awardDayNum = PlayerManager.Instance.Self.accumulativeAwardDays;
         if(this._awardDayNum < this._loginDayNum && this._awardDayNum < 7)
         {
            this._getButton.enable = true;
            this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         }
         else
         {
            this._getButton.enable = false;
         }
         this._dataDic = AccumulativeManager.instance.dataDic;
      }
      
      private function initViewWithData() : void
      {
         var _loc3_:Array = null;
         var _loc4_:AccumulativeLoginRewardData = null;
         var _loc5_:Sprite = null;
         this.checkMovieCanClick();
         this._loginDayTxt.text = "" + this._loginDayNum;
         if(this._loginDayNum < 7)
         {
            this._progressBar.width = !!Boolean(this._progressBarItemArr[this._loginDayNum - 1]) ? Number(Number(this._progressBarItemArr[this._loginDayNum - 1].x - 265)) : Number(Number(0));
            this._progressCompleteItem.x = this._progressBar.width + 256;
         }
         else if(this._loginDayNum >= 7)
         {
            this._progressBar.width = this._progressBarItemArr[5].x - 265 + 55;
            this._progressCompleteItem.x = this._progressBar.width + 258;
         }
         if(!this._dataDic)
         {
            return;
         }
         var _loc1_:int = 1;
         while(_loc1_ < 8)
         {
            _loc3_ = new Array();
            for each(_loc4_ in this._dataDic[_loc1_])
            {
               _loc5_ = this.createBagCellSp(_loc4_,_loc1_);
               _loc3_.push(_loc5_);
            }
            this._dayGiftPackDic[_loc1_] = _loc3_;
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._movieVector.length)
         {
            this._movieVector[_loc2_].tipData = this._fiveWeaponArr[_loc2_].tipData;
            this._movieVector[_loc2_].data = this._dataDic[7][_loc2_];
            _loc2_++;
         }
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         if(this._loginDayNum >= 7 && this._selectedFiveWeaponId == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulactivity.accumulativelogin.txt2"));
            return;
         }
         SocketManager.Instance.out.sendAccumulativeLoginAward(this._selectedFiveWeaponId);
      }
      
      private function set selectedDay(param1:int) : void
      {
         var _loc2_:Sprite = null;
         this._selectedDay = param1;
         if(this._selectedDay > 7)
         {
            this._selectedDay = 7;
         }
         this._hBox.removeAllChild();
         for each(_loc2_ in this._dayGiftPackDic[this._selectedDay])
         {
            if(this._selectedDay <= this._awardDayNum)
            {
               this.graySp(_loc2_);
            }
            else
            {
               _loc2_.filters = null;
            }
            this._hBox.addChild(_loc2_);
         }
      }
      
      private function graySp(param1:Sprite) : void
      {
         param1.filters = [this._filter];
      }
      
      private function get selectedDay() : int
      {
         return this._selectedDay;
      }
      
      private function createBagCellSp(param1:AccumulativeLoginRewardData, param2:int) : Sprite
      {
         var _loc4_:Bitmap = null;
         var _loc3_:Sprite = new Sprite();
         _loc4_ = ComponentFactory.Instance.creat("wonderfulactivity.login.bagCellBg");
         _loc4_.scaleX = _loc4_.scaleY = 0.7;
         _loc3_.addChild(_loc4_);
         var _loc5_:InventoryItemInfo = new InventoryItemInfo();
         _loc5_.TemplateID = param1.RewardItemID;
         _loc5_ = ItemManager.fill(_loc5_);
         _loc5_.IsBinds = param1.IsBind;
         _loc5_.ValidDate = param1.RewardItemValid;
         _loc5_._StrengthenLevel = param1.StrengthenLevel;
         _loc5_.AttackCompose = param1.AttackCompose;
         _loc5_.DefendCompose = param1.DefendCompose;
         _loc5_.AgilityCompose = param1.AgilityCompose;
         _loc5_.LuckCompose = param1.LuckCompose;
         var _loc6_:BagCell = new BagCell(0);
         _loc6_.info = _loc5_;
         _loc6_.setCount(param1.RewardItemCount);
         _loc6_.setBgVisible(false);
         _loc6_.x = _loc6_.y = 4;
         _loc3_.addChild(_loc6_);
         if(param2 == 7)
         {
            this._fiveWeaponArr.push(_loc6_);
         }
         return _loc3_;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         var _loc1_:Array = null;
         var _loc2_:BagCell = null;
         var _loc3_:int = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:Sprite = null;
         var _loc6_:FilterFrameText = null;
         var _loc7_:int = 0;
         var _loc8_:Sprite = null;
         AccumulativeManager.instance.removeEventListener(AccumulativeManager.ACCUMULATIVE_AWARD_REFRESH,this.__refreshAward);
         for each(_loc1_ in this._dayGiftPackDic)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc1_.length)
            {
               _loc8_ = _loc1_[_loc7_];
               ObjectUtils.disposeAllChildren(_loc8_);
               ObjectUtils.disposeObject(_loc8_);
               _loc7_++;
            }
         }
         this._dayGiftPackDic = null;
         for each(_loc2_ in this._fiveWeaponArr)
         {
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
         }
         this._fiveWeaponArr = null;
         _loc3_ = 0;
         while(_loc3_ < this._movieVector.length)
         {
            this._movieVector[_loc3_].removeEventListener(MouseEvent.CLICK,this.__onClickHandler);
            this._movieVector[_loc3_].dispose();
            this._movieVector[_loc3_] = null;
            _loc3_++;
         }
         this._movieVector = null;
         for each(_loc4_ in this._progressBarItemArr)
         {
            if(_loc4_)
            {
               ObjectUtils.disposeObject(_loc4_);
            }
            _loc4_ = null;
         }
         this._progressBarItemArr = null;
         for each(_loc5_ in this._clickSpriteArr)
         {
            if(_loc5_)
            {
               _loc5_.graphics.clear();
            }
            _loc5_.removeEventListener(MouseEvent.CLICK,this.__showAwardHandler);
            _loc5_ = null;
         }
         this._clickSpriteArr = null;
         for each(_loc6_ in this._dayTxtArr)
         {
            if(_loc6_)
            {
               ObjectUtils.disposeObject(_loc6_);
            }
            _loc6_ = null;
         }
         this._dayTxtArr = null;
         if(this._back)
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(this._hBox)
         {
            ObjectUtils.disposeObject(this._hBox);
         }
         this._hBox = null;
         if(this._progressCompleteItem)
         {
            ObjectUtils.disposeObject(this._progressCompleteItem);
         }
         this._progressCompleteItem = null;
         if(this._loginDayTxt)
         {
            ObjectUtils.disposeObject(this._loginDayTxt);
         }
         this._loginDayTxt = null;
         if(this._progressBarBack)
         {
            ObjectUtils.disposeObject(this._progressBarBack);
         }
         this._progressBarBack = null;
         if(this._progressBar)
         {
            ObjectUtils.disposeObject(this._progressBar);
         }
         this._progressBar = null;
         if(this._getButton)
         {
            this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         }
         ObjectUtils.disposeObject(this._getButton);
         this._getButton = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
