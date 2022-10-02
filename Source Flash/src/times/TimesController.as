package times
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.LoaderQueue;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import times.data.TimesAnalyzer;
   import times.data.TimesEvent;
   import times.data.TimesModel;
   import times.data.TimesPicInfo;
   import times.utils.TimesUtils;
   import times.view.TimesContentView;
   import times.view.TimesThumbnailView;
   import times.view.TimesView;
   
   public class TimesController extends EventDispatcher
   {
      
      private static var _instance:TimesController;
       
      
      private var _currentPointer:int;
      
      private var _model:TimesModel;
      
      private var _thumbnailLoaders:Array;
      
      private var _extraDisplays:Dictionary;
      
      private var _tipCurrentKey:String;
      
      private var _tipItemMcs:Dictionary;
      
      private var _timesView:TimesView;
      
      private var _thumbnailView:TimesThumbnailView;
      
      private var _contentViews:Vector.<TimesContentView>;
      
      private var _statisticsInstance:*;
      
      private var _egg:MovieClip;
      
      private var _eggLoc:Point;
      
      public function TimesController(param1:IEventDispatcher = null)
      {
         this._eggLoc = new Point(-1,-1);
         super(param1);
         this.init();
      }
      
      public static function get Instance() : TimesController
      {
         if(_instance == null)
         {
            _instance = new TimesController();
         }
         return _instance;
      }
      
      public function get currentPointer() : int
      {
         return this._currentPointer;
      }
      
      public function set currentPointer(param1:int) : void
      {
         this._currentPointer = param1;
      }
      
      public function setup(param1:TimesAnalyzer) : void
      {
         this._model.smallPicInfos = param1.smallPicInfos;
         this._model.bigPicInfos = param1.bigPicInfos;
         this._model.contentInfos = param1.contentInfos;
         this._model.edition = param1.edition;
         this._model.editor = param1.editor;
         this._model.nextDate = param1.nextDate;
         this.loadThumbnail();
      }
      
      public function get model() : TimesModel
      {
         return this._model;
      }
      
      private function init() : void
      {
         this._model = new TimesModel();
         this._tipItemMcs = new Dictionary();
      }
      
      public function initView(param1:TimesView, param2:TimesThumbnailView, param3:Vector.<TimesContentView>) : void
      {
         this._timesView = param1;
         this._thumbnailView = param2;
         this._contentViews = param3;
         var _loc4_:TimesPicInfo = new TimesPicInfo();
         _loc4_.type = "category0";
         _loc4_.targetCategory = 0;
         _loc4_.targetPage = 0;
         this.__gotoContent(new TimesEvent(TimesEvent.GOTO_CONTENT,_loc4_));
      }
      
      public function initEvent() : void
      {
         TimesController.Instance.addEventListener(TimesEvent.PUSH_TIP_ITEMS,this.__pushTipItems);
         TimesController.Instance.addEventListener(TimesEvent.GOTO_CONTENT,this.__gotoContent);
         TimesController.Instance.addEventListener(TimesEvent.GOTO_PRE_CONTENT,this.__gotoPreContent);
         TimesController.Instance.addEventListener(TimesEvent.GOTO_NEXT_CONTENT,this.__gotoNextContent);
         TimesController.Instance.addEventListener(TimesEvent.PUSH_TIP_CELLS,this.__pushTipCells);
      }
      
      public function removeEvent() : void
      {
         TimesController.Instance.removeEventListener(TimesEvent.PUSH_TIP_ITEMS,this.__pushTipItems);
         TimesController.Instance.removeEventListener(TimesEvent.GOTO_CONTENT,this.__gotoContent);
         TimesController.Instance.removeEventListener(TimesEvent.GOTO_PRE_CONTENT,this.__gotoPreContent);
         TimesController.Instance.removeEventListener(TimesEvent.GOTO_NEXT_CONTENT,this.__gotoNextContent);
         TimesController.Instance.removeEventListener(TimesEvent.PUSH_TIP_CELLS,this.__pushTipCells);
      }
      
      private function __pushTipCells(param1:TimesEvent) : void
      {
         this.addTip(param1.info.category,param1.info.page,param1.params);
      }
      
      private function __gotoContent(param1:TimesEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:TimesPicInfo = param1.info;
         this.currentPointer = _loc2_.targetCategory;
         this._timesView.menuSelected(this.currentPointer);
         this._contentViews[this.currentPointer].frame = _loc2_.targetPage;
         this.tryRemoveAllViews();
         this._timesView.addChild(this._contentViews[this.currentPointer]);
         this.tryShowTipDisplay(this.currentPointer,_loc2_.targetPage);
         this.tryShowEgg();
         this.updateGuildViewPoint(this.currentPointer,_loc2_.targetPage);
         if(this._statisticsInstance)
         {
            this._statisticsInstance.startTick();
         }
         else
         {
            _loc3_ = getDefinitionByName("times.TimesManager") as Class;
            if(_loc3_)
            {
               this._statisticsInstance = _loc3_.Instance.statistics;
               this._statisticsInstance.startTick();
            }
         }
      }
      
      private function __gotoNextContent(param1:TimesEvent) : void
      {
         var _loc2_:* = undefined;
         this.currentPointer = this.currentPointer < 3 ? int(int(this.currentPointer + 1)) : int(int(0));
         this._timesView.menuSelected(this.currentPointer);
         this.tryRemoveAllViews();
         this._contentViews[this.currentPointer].frame = 0;
         this._timesView.addChild(this._contentViews[this.currentPointer]);
         this.tryShowTipDisplay(this.currentPointer,0);
         this.tryShowEgg();
         this.updateGuildViewPoint(this.currentPointer,0);
         if(this._statisticsInstance)
         {
            this._statisticsInstance.startTick();
         }
         else
         {
            _loc2_ = getDefinitionByName("times.TimesManager") as Class;
            if(_loc2_)
            {
               this._statisticsInstance = _loc2_.Instance.statistics;
               this._statisticsInstance.startTick();
            }
         }
      }
      
      private function __gotoPreContent(param1:TimesEvent) : void
      {
         var _loc2_:* = undefined;
         this.currentPointer = this.currentPointer > 0 ? int(int(this.currentPointer - 1)) : int(int(this._contentViews.length - 1));
         this._timesView.menuSelected(this.currentPointer);
         this.tryRemoveAllViews();
         this._contentViews[this.currentPointer].frame = this._contentViews[this.currentPointer].maxIdx - 1;
         this._timesView.addChild(this._contentViews[this.currentPointer]);
         this.tryShowTipDisplay(this.currentPointer,this._contentViews[this.currentPointer].maxIdx - 1);
         this.tryShowEgg();
         this.updateGuildViewPoint(this.currentPointer,this._contentViews[this.currentPointer].maxIdx - 1);
         if(this._statisticsInstance)
         {
            this._statisticsInstance.startTick();
         }
         else
         {
            _loc2_ = getDefinitionByName("times.TimesManager") as Class;
            if(_loc2_)
            {
               this._statisticsInstance = _loc2_.Instance.statistics;
               this._statisticsInstance.startTick();
            }
         }
      }
      
      private function __pushTipItems(param1:TimesEvent) : void
      {
         var _loc5_:Array = null;
         var _loc2_:TimesPicInfo = param1.info as TimesPicInfo;
         var _loc3_:MovieClip = param1.params[0] as MovieClip;
         var _loc4_:String = String(_loc2_.category) + String(_loc2_.page);
         if(this._tipItemMcs[_loc4_])
         {
            _loc5_ = this._tipItemMcs[_loc4_];
         }
         else
         {
            _loc5_ = [];
         }
         _loc5_.push(_loc3_);
         this._tipItemMcs[_loc4_] = _loc5_;
      }
      
      public function updateGuildViewPoint(param1:int = -1, param2:int = -1) : void
      {
         var _loc5_:int = 0;
         var _loc6_:TimesPicInfo = null;
         var _loc3_:int = 0;
         if(param1 == -1 && param2 == -1)
         {
            this._thumbnailView.pointIdx = _loc3_;
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._model.contentInfos.length)
         {
            _loc5_ = 0;
            while(_loc5_ < this._model.contentInfos[_loc4_].length)
            {
               _loc6_ = this._model.contentInfos[_loc4_][_loc5_];
               if(param1 == _loc6_.category && param2 == _loc6_.page)
               {
                  this._thumbnailView.pointIdx = _loc3_;
                  return;
               }
               _loc3_++;
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      private function tryRemoveAllViews() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._contentViews.length)
         {
            if(this._contentViews[_loc1_] && this._timesView.contains(this._contentViews[_loc1_]))
            {
               this._timesView.removeChild(this._contentViews[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      private function addTip(param1:int, param2:int, param3:Array) : void
      {
         var _loc4_:String = String(param1) + String(param2);
         var _loc5_:Sprite = new Sprite();
         TimesUtils.setPos(_loc5_,"times.ContentBigPicPos");
         var _loc6_:int = 0;
         while(_loc6_ < param3.length)
         {
            _loc5_.addChild(param3[_loc6_]);
            param3[_loc6_].addEventListener(MouseEvent.ROLL_OVER,this.__playEffect);
            param3[_loc6_].addEventListener(MouseEvent.ROLL_OUT,this.__stopEffect);
            _loc6_++;
         }
         if(this._extraDisplays == null)
         {
            this._extraDisplays = new Dictionary();
         }
         this._extraDisplays[_loc4_] = _loc5_;
      }
      
      private function __stopEffect(param1:MouseEvent) : void
      {
         if(this._extraDisplays == null)
         {
            param1.currentTarget.removeEventListener(MouseEvent.ROLL_OVER,this.__playEffect);
            param1.currentTarget.removeEventListener(MouseEvent.ROLL_OUT,this.__stopEffect);
            return;
         }
         var _loc2_:int = this._extraDisplays[this._tipCurrentKey].getChildIndex(param1.currentTarget);
         this._tipItemMcs[this._tipCurrentKey][_loc2_].gotoAndStop(1);
      }
      
      private function __playEffect(param1:MouseEvent) : void
      {
         if(this._extraDisplays == null)
         {
            param1.currentTarget.removeEventListener(MouseEvent.ROLL_OVER,this.__playEffect);
            param1.currentTarget.removeEventListener(MouseEvent.ROLL_OUT,this.__stopEffect);
            return;
         }
         var _loc2_:int = this._extraDisplays[this._tipCurrentKey].getChildIndex(param1.currentTarget);
         this._tipItemMcs[this._tipCurrentKey][_loc2_].gotoAndStop(2);
      }
      
      public function clearExtraObjects() : void
      {
         var _loc1_:Array = null;
         var _loc2_:MovieClip = null;
         for each(_loc1_ in this._tipItemMcs)
         {
            while(_loc1_.length > 0)
            {
               _loc2_ = _loc1_.shift();
               _loc2_ = null;
            }
            _loc1_ = null;
         }
         this._tipItemMcs = new Dictionary();
         if(this._egg)
         {
            this._egg.stop();
            ObjectUtils.disposeObject(this._egg);
            this._egg = null;
         }
         this.deleteTipDisplay();
      }
      
      public function tryShowTipDisplay(param1:int, param2:int) : void
      {
         this.removeTipDisplay();
         this._tipCurrentKey = String(param1) + String(param2);
         if(this._extraDisplays && this._extraDisplays[this._tipCurrentKey])
         {
            this._timesView.addChild(this._extraDisplays[this._tipCurrentKey]);
            if(this._egg && this._timesView.contains(this._egg))
            {
               this._timesView.addChild(this._egg);
            }
         }
      }
      
      private function removeTipDisplay() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this._extraDisplays)
         {
            if(this._extraDisplays[_loc1_].parent)
            {
               this._extraDisplays[_loc1_].parent.removeChild(this._extraDisplays[_loc1_]);
            }
         }
      }
      
      private function deleteTipDisplay() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         this.removeTipDisplay();
         for(_loc1_ in this._extraDisplays)
         {
            _loc2_ = this._extraDisplays[_loc1_];
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this._extraDisplays[_loc1_].getChildAt(_loc3_);
               if(_loc4_ is InteractiveObject)
               {
                  _loc4_.addEventListener(MouseEvent.ROLL_OVER,this.__playEffect);
                  _loc4_.addEventListener(MouseEvent.ROLL_OUT,this.__stopEffect);
               }
               _loc3_++;
            }
            delete this._extraDisplays[_loc1_];
         }
         this._extraDisplays = null;
      }
      
      public function tryShowEgg() : void
      {
         var __eggClick:Function = null;
         __eggClick = null;
         var initialize:Function = function():void
         {
            _egg = ComponentFactory.Instance.creat("times.Egg");
            _egg.buttonMode = true;
            _egg.addEventListener(MouseEvent.CLICK,__eggClick);
            _eggLoc.x = _currentPointer;
            _eggLoc.y = _contentViews[_currentPointer].frame;
            _timesView.addChild(_egg);
         };
         __eggClick = function(param1:MouseEvent):void
         {
            ComponentSetting.SEND_USELOG_ID(145);
            TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.GOT_EGG));
            eggDispose();
         };
         var bingo:Function = function():Boolean
         {
            var _loc1_:Number = Math.random() * 5;
            return _loc1_ > 4;
         };
         var eggDispose:Function = function():void
         {
            if(_egg && _egg.parent)
            {
               _egg.parent.removeChild(_egg);
               _egg.removeEventListener(MouseEvent.CLICK,__eggClick);
            }
            _egg = null;
            _eggLoc = null;
         };
         if(!this._egg && this._model.isShowEgg && bingo())
         {
            initialize();
         }
         if(this._egg)
         {
            if(this._currentPointer == this._eggLoc.x && this._contentViews[this._currentPointer].frame == this._eggLoc.y)
            {
               this._timesView.addChild(this._egg);
            }
            else
            {
               DisplayUtils.removeDisplay(this._egg);
            }
         }
      }
      
      public function get thumbnailLoaders() : Array
      {
         return this._thumbnailLoaders;
      }
      
      private function loadThumbnail() : void
      {
         var _queue:LoaderQueue = null;
         _queue = null;
         var __onQueueComplete:Function = null;
         var arr:Array = null;
         var j:int = 0;
         var info:TimesPicInfo = null;
         __onQueueComplete = function(param1:Event):void
         {
            _queue.dispose();
            _queue = null;
            TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.THUMBNAIL_LOAD_COMPLETE));
         };
         this._thumbnailLoaders = new Array();
         _queue = new LoaderQueue();
         _queue.addEventListener(Event.COMPLETE,__onQueueComplete);
         var i:int = 0;
         while(i < this._model.contentInfos.length)
         {
            arr = new Array();
            j = 0;
            while(j < this._model.contentInfos[i].length)
            {
               info = this._model.contentInfos[i][j];
               if(info.thumbnailPath && info.thumbnailPath != "null" && info.thumbnailPath != "")
               {
                  arr.push(LoaderManager.Instance.creatLoader(this._model.webPath + info.thumbnailPath,BaseLoader.BITMAP_LOADER));
                  _queue.addLoader(arr[j]);
               }
               j++;
            }
            this._thumbnailLoaders.push(arr);
            i++;
         }
         _queue.start();
      }
      
      public function dispose() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._model.dispose();
         var _loc1_:int = 0;
         while(_loc1_ < this._thumbnailLoaders.length)
         {
            _loc4_ = 0;
            while(_loc4_ < this._thumbnailLoaders[_loc1_].length)
            {
               ObjectUtils.disposeObject(this._thumbnailLoaders[_loc1_][_loc4_]);
               this._thumbnailLoaders[_loc1_][_loc4_] = null;
               _loc4_++;
            }
            _loc1_++;
         }
         this._thumbnailLoaders = null;
         for each(_loc2_ in this._extraDisplays)
         {
            if(_loc2_)
            {
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
            }
         }
         this._extraDisplays = null;
         _loc3_ = 0;
         while(_loc3_ < this._tipItemMcs.length)
         {
            if(this._tipItemMcs[_loc3_])
            {
               if(this._tipItemMcs[_loc3_].parent)
               {
                  this._tipItemMcs[_loc3_].parent.removeChild(this._tipItemMcs[_loc3_]);
               }
               MovieClip(this._tipItemMcs[_loc3_]).loaderInfo.loader.unloadAndStop();
               this._tipItemMcs[_loc3_] = null;
            }
            _loc3_++;
         }
         if(this._statisticsInstance)
         {
            this._statisticsInstance.dispose();
         }
         this._tipItemMcs = null;
         this._timesView = null;
         this._contentViews = null;
      }
   }
}
