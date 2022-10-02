package times
{
   import activeEvents.ActiveController;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   import shop.manager.ShopBuyManager;
   import times.data.TimesAnalyzer;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   import times.data.TimesStatistics;
   import times.view.TimesView;
   
   public class TimesManager
   {
      
      private static var _instance:TimesManager;
       
      
      public var isDefaultStarUpShow:Boolean = true;
      
      private var _timesBtn:MovieClip;
      
      private var _timesView:TimesView;
      
      private var _isReturn:Boolean;
      
      private var _isUIComplete:Boolean;
      
      private var _isThumbnailComplete:Boolean;
      
      private var _controller:TimesController;
      
      private var _statistics:TimesStatistics;
      
      private var _isQQshow:Boolean = false;
      
      private var _page:int = 0;
      
      public function TimesManager()
      {
         super();
         this.createTimesInfo();
         this._controller = TimesController.Instance;
         this._controller.model.webPath = PathManager.SITE_WEEKLY + "weekly/";
         this._controller.addEventListener(TimesEvent.THUMBNAIL_LOAD_COMPLETE,this.__onThumbnailComplete);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WEEKLY_CLICK_CNT,this.__canGenerateEgg);
         this._statistics = new TimesStatistics();
      }
      
      public static function get Instance() : TimesManager
      {
         if(!_instance)
         {
            _instance = new TimesManager();
         }
         return _instance;
      }
      
      public function showButton() : void
      {
         if(this._isThumbnailComplete)
         {
            if(this._timesBtn && this._timesBtn.parent)
            {
               return;
            }
            this._timesBtn = ComponentFactory.Instance.creat("asset.weekly.WeeklyBtnMc");
            this._timesBtn.buttonMode = true;
            this._timesBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
            this._timesBtn.addEventListener(Event.ADDED_TO_STAGE,this.onWeeklyAdded);
            LayerManager.Instance.addToLayer(this._timesBtn,LayerManager.GAME_DYNAMIC_LAYER,false,0,false);
            this._timesBtn.parent.setChildIndex(this._timesBtn,0);
         }
      }
      
      private function onWeeklyAdded(param1:Event) : void
      {
         var event:Event = param1;
         if(PlayerManager.Instance.Self.IsFirst > 1)
         {
            setTimeout(function():void
            {
               if(TimesManager.Instance.isDefaultStarUpShow)
               {
                  TimesManager.Instance.isDefaultStarUpShow = false;
                  __onBtnClick(null);
               }
            },1000);
         }
      }
      
      private function __onThumbnailComplete(param1:TimesEvent) : void
      {
         this._isThumbnailComplete = true;
         if(StateManager.currentStateType == StateType.MAIN)
         {
            this.showButton();
         }
      }
      
      public function hideButton() : void
      {
         if(this._timesBtn)
         {
            if(this._timesBtn.parent)
            {
               this._timesBtn.parent.removeChild(this._timesBtn);
            }
            this._timesBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
            this._timesBtn = null;
         }
      }
      
      public function show() : void
      {
         if(!this._isReturn || !this._isUIComplete)
         {
            return;
         }
         SoundManager.instance.playMusic("140");
         this._timesView = new TimesView();
         this._controller.addEventListener(TimesEvent.CLOSE_VIEW,this.__timesEventHandler);
         this._controller.addEventListener(TimesEvent.PLAY_SOUND,this.__timesEventHandler);
         this._controller.addEventListener(TimesEvent.GOT_EGG,this.__timesEventHandler);
         this._controller.addEventListener(TimesEvent.PURCHASE,this.__timesEventHandler);
         this._controller.initEvent();
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyBoardEventHandler);
         LayerManager.Instance.addToLayer(this._timesView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(this._isQQshow)
         {
            this._isQQshow = false;
            this._QQshowComplete();
         }
      }
      
      public function showByQQtips(param1:int) : void
      {
         this._isQQshow = true;
         this._page = param1;
         this.__onBtnClick(null);
      }
      
      private function _QQshowComplete() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Array = this._controller.model.contentInfos;
         var _loc3_:TimesPicInfo = new TimesPicInfo();
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_[_loc4_].length)
            {
               _loc1_++;
               if(_loc1_ == this._page)
               {
                  _loc3_.targetCategory = _loc4_;
                  _loc3_.targetPage = _loc5_;
               }
               _loc5_++;
            }
            _loc4_++;
         }
         this._controller.dispatchEvent(new TimesEvent(TimesEvent.GOTO_CONTENT,_loc3_));
      }
      
      private function __keyBoardEventHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this.hide();
         }
      }
      
      public function hide() : void
      {
         if(ShopBuyManager.Instance.isShow)
         {
            ShopBuyManager.Instance.dispose();
            return;
         }
         if(ActiveController.instance.isShowing)
         {
            return;
         }
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyBoardEventHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WEEKLY_CLICK_CNT,this.__canGenerateEgg);
         SoundManager.instance.playMusic("062");
         this.sendStatistics();
         DisplayUtils.removeDisplay(this._timesView);
         this._controller.clearExtraObjects();
         this._controller.removeEvent();
         ObjectUtils.disposeObject(this._timesView);
         this._timesView = null;
      }
      
      public function get statistics() : TimesStatistics
      {
         return this._statistics;
      }
      
      private function sendStatistics() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Vector.<int> = this._statistics.stayTime;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_ += _loc1_[_loc3_];
            _loc3_++;
         }
         if(_loc2_ == 0)
         {
            this._statistics.stopTick();
            return;
         }
         var _loc4_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc4_["Versions"] = this._controller.model.edition;
         _loc4_["Forum1"] = _loc1_[0];
         _loc4_["Forum2"] = _loc1_[1];
         _loc4_["Forum3"] = _loc1_[2];
         _loc4_["Forum4"] = _loc1_[3];
         _loc4_["Forum5"] = _loc1_[4];
         var _loc5_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("CommitWeeklyUserRecord.ashx"),BaseLoader.REQUEST_LOADER,_loc4_);
         LoaderManager.Instance.startLoad(_loc5_);
         this._statistics.stopTick();
      }
      
      private function __timesEventHandler(param1:TimesEvent) : void
      {
         switch(param1.type)
         {
            case TimesEvent.CLOSE_VIEW:
               SoundManager.instance.play("008");
               this.hide();
               break;
            case TimesEvent.PLAY_SOUND:
               SoundManager.instance.play("008");
               break;
            case TimesEvent.GOT_EGG:
               SoundManager.instance.play("008");
               SocketManager.Instance.out.sendDailyAward(2);
               this._controller.model.isShowEgg = !this._controller.model.isShowEgg;
               break;
            case TimesEvent.PURCHASE:
               SoundManager.instance.play("008");
               ShopBuyManager.Instance.buy(int(param1.info.templateID));
         }
      }
      
      private function __onBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ComponentSetting.SEND_USELOG_ID(24);
         this.show();
         if(!this._isReturn)
         {
            SocketManager.Instance.out.sendWeeklyClick();
         }
         if(!this._isUIComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TIMES);
         }
      }
      
      private function __canGenerateEgg(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._controller.model.isShowEgg = _loc2_.readBoolean();
         this._isReturn = true;
         this.show();
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TIMES)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      private function __onUIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TIMES)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            this._isUIComplete = true;
            this.show();
         }
      }
      
      private function createTimesInfo() : void
      {
         var _loc1_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.SITE_WEEKLY + "weekly/weeklyInfo.xml",BaseLoader.TEXT_LOADER);
         _loc1_.loadErrorMessage = "Error occur when loading times pic! Please refer to webmaster!";
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc1_.analyzer = new TimesAnalyzer(TimesController.Instance.setup);
         LoaderManager.Instance.startLoad(_loc1_,true);
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
      }
   }
}
