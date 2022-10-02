package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.LoaderQueue;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import ddt.utils.BitmapUtils;
   import flash.display.Bitmap;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import road7th.utils.StringHelper;
   
   public class BaseLayer extends Sprite implements ILayer
   {
      
      public static const ICON:String = "icon";
      
      public static const SHOW:String = "show";
      
      public static const GAME:String = "game";
      
      public static const CONSORTIA:String = "consortia";
      
      public static const STATE:String = "state";
       
      
      protected var _queueLoader:LoaderQueue;
      
      protected var _info:ItemTemplateInfo;
      
      protected var _colors:Array;
      
      protected var _gunBack:Boolean;
      
      protected var _hairType:String;
      
      protected var _currentEdit:uint;
      
      private var _callBack:Function;
      
      protected var _color:String;
      
      protected var _defaultLayer:uint;
      
      protected var _bitmaps:Vector.<Bitmap>;
      
      private var _isAllLoadSucceed:Boolean = true;
      
      protected var _pic:String;
      
      private var _isComplete:Boolean;
      
      public function BaseLayer(param1:ItemTemplateInfo, param2:String = "", param3:Boolean = false, param4:int = 1, param5:String = null)
      {
         this._info = param1;
         this._color = param2 == null ? "" : param2;
         this._gunBack = param3;
         this._hairType = param4 == 1 ? "B" : "A";
         this._pic = param5 == null || String(param5) == "undefined" ? this._info.Pic : param5;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._queueLoader = new LoaderQueue();
         this._bitmaps = new Vector.<Bitmap>();
         this._colors = [];
         this.initLoaders();
      }
      
      protected function initLoaders() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:BitmapLoader = null;
         if(this._info != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this._info.Property8.length)
            {
               _loc2_ = this.getUrl(int(this._info.Property8.charAt(_loc1_)));
               _loc3_ = LoaderManager.Instance.creatLoader(_loc2_,BaseLoader.BITMAP_LOADER);
               this._queueLoader.addLoader(_loc3_);
               _loc1_++;
            }
            this._defaultLayer = 0;
            this._currentEdit = this._queueLoader.length;
         }
      }
      
      protected function initColors(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ColorTransform = null;
         var _loc5_:Bitmap = null;
         this._colors = param1.split("|");
         if(this._bitmaps.length == 0)
         {
            return;
         }
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._bitmaps.length)
         {
            if(this._bitmaps[_loc2_])
            {
               addChild(this._bitmaps[_loc2_]);
               this._bitmaps[_loc2_].visible = false;
            }
            _loc2_++;
         }
         if(this._bitmaps[this._defaultLayer])
         {
            this._bitmaps[this._defaultLayer].visible = true;
         }
         if(this._colors.length == this._bitmaps.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this._colors.length)
            {
               if(!StringHelper.isNullOrEmpty(this._colors[_loc3_]) && this._colors[_loc3_].toString() != "undefined" && this._colors[_loc3_].toString() != "null")
               {
                  if(this._bitmaps[_loc3_] != null)
                  {
                     this._bitmaps[_loc3_].visible = true;
                     this._bitmaps[_loc3_].transform.colorTransform = BitmapUtils.getColorTransfromByColor(this._colors[_loc3_]);
                     _loc4_ = BitmapUtils.getHightlightColorTransfrom(this._colors[_loc3_]);
                     _loc5_ = new Bitmap(this._bitmaps[_loc3_].bitmapData,"auto",true);
                     if(_loc4_)
                     {
                        _loc5_.transform.colorTransform = _loc4_;
                     }
                     _loc5_.blendMode = BlendMode.HARDLIGHT;
                     addChild(_loc5_);
                  }
               }
               else if(this._bitmaps[_loc3_] != null)
               {
                  this._bitmaps[_loc3_].transform.colorTransform = new ColorTransform();
               }
               _loc3_++;
            }
         }
      }
      
      public function getContent() : DisplayObject
      {
         return this;
      }
      
      public function setColor(param1:*) : Boolean
      {
         if(this._info == null || param1 == null)
         {
            return false;
         }
         this._color = String(param1);
         this.initColors(param1);
         return true;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._info;
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         if(this.info == param1)
         {
            return;
         }
         this.clear();
         this._info = param1;
         if(this._info)
         {
            this.initLoaders();
            this.load(this._callBack);
         }
      }
      
      public function set currentEdit(param1:int) : void
      {
         this._currentEdit = param1;
         if(this._currentEdit > this._bitmaps.length)
         {
            this._currentEdit = this._bitmaps.length;
         }
         else if(this._currentEdit < 1)
         {
            this._currentEdit = 1;
         }
      }
      
      public function get currentEdit() : int
      {
         return this._currentEdit;
      }
      
      public function dispose() : void
      {
         this.clear();
         this._info = null;
         this._callBack = null;
         this._bitmaps = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      protected function clearBitmap() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bitmaps = new Vector.<Bitmap>();
      }
      
      protected function clear() : void
      {
         if(this._queueLoader)
         {
            this._queueLoader.removeEventListener(Event.COMPLETE,this.__loadComplete);
            this._queueLoader.dispose();
            this._queueLoader = null;
         }
         this.clearBitmap();
         this._colors = [];
      }
      
      public final function load(param1:Function) : void
      {
         this._callBack = param1;
         if(this._info == null)
         {
            this.loadCompleteCallBack();
            return;
         }
         this._queueLoader.addEventListener(Event.COMPLETE,this.__loadComplete);
         this._queueLoader.start();
      }
      
      protected function getUrl(param1:int) : String
      {
         return PathManager.solveGoodsPath(this._info.CategoryID,this._pic,this._info.NeedSex == 1,SHOW,this._hairType,String(param1),this._info.Level,this._gunBack,int(this._info.Property1));
      }
      
      protected function __loadComplete(param1:Event) : void
      {
         this.reSetBitmap();
         this._queueLoader.removeEventListener(Event.COMPLETE,this.__loadComplete);
         this._queueLoader.removeEvent();
         this.initColors(this._color);
         this.loadCompleteCallBack();
      }
      
      public function reSetBitmap() : void
      {
         var _loc1_:int = 0;
         this.clearBitmap();
         _loc1_ = 0;
         while(_loc1_ < this._queueLoader.loaders.length)
         {
            this._bitmaps.push(this._queueLoader.loaders[_loc1_].content);
            if(this._bitmaps[_loc1_])
            {
               this._bitmaps[_loc1_].smoothing = true;
               this._bitmaps[_loc1_].visible = false;
               addChild(this._bitmaps[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      protected function loadCompleteCallBack() : void
      {
         this._isComplete = true;
         if(this._callBack != null)
         {
            this._callBack(this);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function __onBitmapError(param1:LoaderEvent) : void
      {
         this._isAllLoadSucceed = false;
      }
      
      public function get isAllLoadSucceed() : Boolean
      {
         return this._isAllLoadSucceed;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
   }
}
