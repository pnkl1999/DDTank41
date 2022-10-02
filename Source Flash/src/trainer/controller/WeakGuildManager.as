package trainer.controller
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PreviewFrameManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import road7th.utils.MovieClipWrapper;
   import trainer.data.Step;
   
   public class WeakGuildManager
   {
      
      private static var _instance:WeakGuildManager;
       
      
      private const LV:int = 15;
      
      private var _type:String;
      
      private var _title:String;
      
      private var _newTask:Boolean;
      
      private var _bmpLoader:BitmapLoader;
      
      public function WeakGuildManager()
      {
         super();
      }
      
      public static function get Instance() : WeakGuildManager
      {
         if(_instance == null)
         {
            _instance = new WeakGuildManager();
         }
         return _instance;
      }
      
      public function get switchUserGuide() : Boolean
      {
         return (PlayerManager.Instance.Self.Grade <= this.LV ? Boolean(Boolean(true)) : Boolean(Boolean(false))) && PathManager.solveUserGuildEnable();
      }
      
      public function get newTask() : Boolean
      {
         return this._newTask;
      }
      
      public function set newTask(param1:Boolean) : void
      {
         this._newTask = param1;
      }
      
      public function setup() : void
      {
         if(this.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onChange);
         }
      }
      
      private function __onChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpGrade)
         {
            switch(PlayerManager.Instance.Self.Grade)
            {
               case 2:
                  SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_OPEN);
                  break;
               case 3:
                  SocketManager.Instance.out.syncWeakStep(Step.BAG_OPEN);
                  break;
               case 4:
                  SocketManager.Instance.out.syncWeakStep(Step.HP_PROP_OPEN);
                  break;
               case 5:
                  SocketManager.Instance.out.syncWeakStep(Step.CIVIL_OPEN);
                  SocketManager.Instance.out.syncWeakStep(Step.IM_OPEN);
                  SocketManager.Instance.out.syncWeakStep(Step.GUILD_PROP_OPEN);
                  break;
               case 6:
                  SocketManager.Instance.out.syncWeakStep(Step.MASTER_ROOM_OPEN);
                  SocketManager.Instance.out.syncWeakStep(Step.POWER_PROP_OPEN);
                  SocketManager.Instance.out.syncWeakStep(Step.CAN_OPEN_MUTI);
                  break;
               case 7:
                  SocketManager.Instance.out.syncWeakStep(Step.CONSORTIA_OPEN);
                  SocketManager.Instance.out.syncWeakStep(Step.HIDE_PROP_OPEN);
                  SocketManager.Instance.out.syncWeakStep(Step.PLANE_PROP_OPEN);
                  break;
               case 8:
                  SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_OPEN);
                  SocketManager.Instance.out.syncWeakStep(Step.FROZE_PROP_OPEN);
                  break;
               case 9:
                  SocketManager.Instance.out.syncWeakStep(Step.SHOP_OPEN);
                  SocketManager.Instance.out.syncWeakStep(Step.VANE_OPEN);
                  break;
               case 12:
                  SocketManager.Instance.out.syncWeakStep(Step.TOFF_LIST_OPEN);
                  break;
               case 13:
                  SocketManager.Instance.out.syncWeakStep(Step.HOT_WELL_OPEN);
                  break;
               case 14:
                  SocketManager.Instance.out.syncWeakStep(Step.AUCTION_OPEN);
                  break;
               case 15:
                  SocketManager.Instance.out.syncWeakStep(Step.CAMPAIGN_LAB_OPEN);
            }
         }
      }
      
      public function timeStatistics(param1:int, param2:Number) : void
      {
         var _loc3_:Number = new Date().getTime() - param2;
         if(param1 == 0)
         {
            if(_loc3_ <= 60 * 1000)
            {
               return;
            }
         }
         else if(param1 == 1)
         {
            if(_loc3_ <= 30 * 1000)
            {
               return;
            }
         }
         var _loc4_:URLVariables = new URLVariables();
         _loc4_.id = PlayerManager.Instance.Self.ID;
         _loc4_.type = param1;
         _loc4_.time = _loc3_;
         _loc4_.grade = PlayerManager.Instance.Self.Grade;
         _loc4_.serverID = PlayerManager.Instance.Self.ZoneID;
         var _loc5_:URLRequest = new URLRequest(PathManager.solveRequestPath("LogTime.ashx"));
         _loc5_.method = URLRequestMethod.POST;
         _loc5_.data = _loc4_;
         var _loc6_:URLLoader = new URLLoader();
         _loc6_.load(_loc5_);
      }
      
      public function statistics(param1:int, param2:Number) : void
      {
         var _loc3_:Number = new Date().getTime() - param2;
         var _loc4_:URLVariables = new URLVariables();
         _loc4_.id = PlayerManager.Instance.Self.ID;
         _loc4_.type = param1;
         _loc4_.time = _loc3_;
         _loc4_.grade = PlayerManager.Instance.Self.Grade;
         _loc4_.serverID = PlayerManager.Instance.Self.ZoneID;
         var _loc5_:URLRequest = new URLRequest(PathManager.solveRequestPath("LogTime.ashx"));
         _loc5_.method = URLRequestMethod.POST;
         _loc5_.data = _loc4_;
         var _loc6_:URLLoader = new URLLoader();
         _loc6_.load(_loc5_);
      }
      
      public function setStepFinish(param1:int) : void
      {
         param1--;
         var _loc2_:int = param1 / 8;
         var _loc3_:int = param1 % 8;
         var _loc4_:ByteArray = PlayerManager.Instance.Self.weaklessGuildProgress;
         if(_loc4_)
         {
            _loc4_[_loc2_] |= 1 << _loc3_;
            PlayerManager.Instance.Self.weaklessGuildProgress = _loc4_;
         }
      }
      
      public function showMainToolBarBtnOpen(param1:int, param2:String) : void
      {
         var _loc4_:MovieClipWrapper = null;
         var _loc3_:Point = null;
         _loc4_ = null;
         _loc3_ = ComponentFactory.Instance.creatCustomObject(param2);
         _loc4_ = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer.openMainToolBtn"),true,true);
         _loc4_.movie.x = _loc3_.x;
         _loc4_.movie.y = _loc3_.y;
         LayerManager.Instance.addToLayer(_loc4_.movie,LayerManager.GAME_DYNAMIC_LAYER,false);
         SocketManager.Instance.out.syncWeakStep(param1);
      }
      
      public function checkFunction() : void
      {
         this.checkLevelFunction();
      }
      
      public function checkOpen(param1:int, param2:int) : Boolean
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return true;
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(param1))
         {
            return false;
         }
         return true;
      }
      
      public function openBuildTip(param1:String) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.hall.ChooseHallView.openBuildTip",LanguageMgr.GetTranslation(param1)));
      }
      
      public function showBuildPreview(param1:String, param2:String) : void
      {
         this._type = param1;
         this._title = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         this._bmpLoader = LoaderManager.Instance.creatLoader(PathManager.solveNewHandBuild(this._type),BaseLoader.BITMAP_LOADER);
         this._bmpLoader.addEventListener(LoaderEvent.PROGRESS,this.__loadProgress);
         this._bmpLoader.addEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
         LoaderManager.Instance.startLoad(this._bmpLoader);
      }
      
      private function __loadProgress(param1:LoaderEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __loadComplete(param1:LoaderEvent) : void
      {
         this.disposeBmpLoader();
         if(param1.loader.isSuccess)
         {
            PreviewFrameManager.Instance.createBuildPreviewFrame(this._title,param1.loader.content);
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         this.disposeBmpLoader();
      }
      
      private function disposeBmpLoader() : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleSmallLoading.Instance.hide();
         if(this._bmpLoader)
         {
            this._bmpLoader.removeEventListener(LoaderEvent.PROGRESS,this.__loadProgress);
            this._bmpLoader.removeEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
            this._bmpLoader = null;
         }
      }
      
      private function checkLevelFunction() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.Grade;
         if(_loc1_ > 1)
         {
            this.openFunction(Step.GAME_ROOM_OPEN);
            this.openFunction(Step.CHANNEL_OPEN);
         }
         if(_loc1_ > 2)
         {
            this.openFunction(Step.SHOP_OPEN);
            this.openFunction(Step.STORE_OPEN);
            this.openFunction(Step.BAG_OPEN);
            this.openFunction(Step.MAIL_OPEN);
         }
         if(_loc1_ > 3)
         {
            this.openFunction(Step.HP_PROP_OPEN);
         }
         if(_loc1_ > 4)
         {
            this.openFunction(Step.GAME_ROOM_SHOW_OPEN);
            this.openFunction(Step.CIVIL_OPEN);
            this.openFunction(Step.IM_OPEN);
            this.openFunction(Step.GUILD_PROP_OPEN);
         }
         if(_loc1_ > 5)
         {
            this.openFunction(Step.CIVIL_SHOW);
            this.openFunction(Step.MASTER_ROOM_OPEN);
            this.openFunction(Step.POWER_PROP_OPEN);
         }
         if(_loc1_ > 6)
         {
            this.openFunction(Step.MASTER_ROOM_SHOW);
            this.openFunction(Step.CONSORTIA_OPEN);
            this.openFunction(Step.HIDE_PROP_OPEN);
            this.openFunction(Step.PLANE_PROP_OPEN);
         }
         if(_loc1_ > 7)
         {
            this.openFunction(Step.CONSORTIA_SHOW);
            this.openFunction(Step.DUNGEON_OPEN);
            this.openFunction(Step.SIGN_OPEN);
            this.openFunction(Step.FROZE_PROP_OPEN);
         }
         if(_loc1_ > 8)
         {
            this.openFunction(Step.DUNGEON_SHOW);
            this.openFunction(Step.VANE_OPEN);
         }
         if(_loc1_ > 9)
         {
            this.openFunction(Step.CHURCH_OPEN);
         }
         if(_loc1_ > 11)
         {
            this.openFunction(Step.CHURCH_SHOW);
            this.openFunction(Step.TOFF_LIST_OPEN);
         }
         if(_loc1_ > 12)
         {
            this.openFunction(Step.TOFF_LIST_SHOW);
            this.openFunction(Step.HOT_WELL_OPEN);
         }
         if(_loc1_ > 13)
         {
            this.openFunction(Step.HOT_WELL_SHOW);
            this.openFunction(Step.AUCTION_OPEN);
         }
         if(_loc1_ > 14)
         {
            this.openFunction(Step.AUCTION_SHOW);
            this.openFunction(Step.CAMPAIGN_LAB_OPEN);
         }
      }
      
      private function openFunction(param1:int) : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(param1))
         {
            SocketManager.Instance.out.syncWeakStep(param1);
         }
      }
   }
}
