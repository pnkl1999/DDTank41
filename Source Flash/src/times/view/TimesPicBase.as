package times.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.utils.getDefinitionByName;
   import times.TimesController;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   import times.utils.TimesUtils;
   
   public class TimesPicBase extends Sprite implements Disposeable
   {
      
      public static const SMALL_PIC:uint = 0;
      
      public static const BIG_PIC:uint = 1;
      
      public static const CONTENT_PIC:uint = 2;
      
      public static const JPG:String = ".jpg";
      
      public static const PNG:String = ".png";
      
      public static const SWF:String = ".swf";
       
      
      protected var _info:TimesPicInfo;
      
      protected var _whiteShape:Shape;
      
      protected var _loadingMc:MovieClip;
      
      protected var _loader:Loader;
      
      protected var _glowFilter:GlowFilter;
      
      protected var _glowFilter2:GlowFilter;
      
      protected var _isSuccess:Boolean;
      
      public function TimesPicBase(param1:TimesPicInfo)
      {
         super();
         this._info = param1;
         this.init();
         this.initEvents();
      }
      
      protected function init() : void
      {
         this._loader = new Loader();
         this.configMouseInteractive();
         this.createLoadingMc();
      }
      
      public function load() : void
      {
         if(this.isSuccess)
         {
            return;
         }
         if(this._loader == null)
         {
            this._loader = new Loader();
         }
         var _loc1_:Object = getDefinitionByName("ddt.manager.PathManager");
         if(_loc1_)
         {
            this._loader.load(new URLRequest(_loc1_.SITE_WEEKLY + "weekly/" + this._info.path));
         }
         else
         {
            this._loader.load(new URLRequest(this._info.path));
         }
      }
      
      protected function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.__picClick);
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__onLoadCompleted);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.__onLoadError);
      }
      
      public function get pic() : DisplayObject
      {
         return this._loader;
      }
      
      protected function __onLoadCompleted(param1:Event) : void
      {
         if(this._loader)
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.__onLoadCompleted);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.__onLoadError);
            if(this._loadingMc && this._loadingMc.parent)
            {
               this._loadingMc.parent.removeChild(this._loadingMc);
            }
            this._isSuccess = true;
            addChild(this._loader);
            this.createFilters();
            if(this._info.fileType == SWF)
            {
               TimesUtils.createCell(this._loader,this._info);
               if(this._info.category == 0 && this._info.page == 0)
               {
                  TimesController.Instance.tryShowTipDisplay(this._info.category,this._info.page);
               }
            }
         }
      }
      
      public function get isSuccess() : Boolean
      {
         return this._isSuccess;
      }
      
      protected function __onLoadError(param1:IOErrorEvent) : void
      {
      }
      
      protected function __picClick(param1:MouseEvent) : void
      {
         TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.PLAY_SOUND));
         switch(this._info.type)
         {
            case TimesPicInfo.SMALL:
            case TimesPicInfo.BIG:
               TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.GOTO_CONTENT,this._info));
         }
      }
      
      protected function createFilters() : void
      {
         if(this._info.type == TimesPicInfo.SMALL)
         {
            this._glowFilter = new GlowFilter(16777011,1,0,0,1,1,true);
            this._glowFilter2 = new GlowFilter(16764006,1,0,0,1,1,true);
         }
      }
      
      protected function createLoadingMc() : void
      {
         this._loadingMc = ComponentFactory.Instance.creatCustomObject("times.PicLoading");
         switch(this.picMode)
         {
            case SMALL_PIC:
               TimesUtils.setPos(this._loadingMc,"times.SmallPicLoadingMcPos");
               break;
            case BIG_PIC:
               TimesUtils.setPos(this._loadingMc,"times.BigPicLoadingMcPos");
               break;
            case CONTENT_PIC:
               TimesUtils.setPos(this._loadingMc,"times.ContentPicLoadingMcPos");
         }
         addChild(this._loadingMc);
      }
      
      protected function createWhiteBg() : void
      {
         if(this._whiteShape == null)
         {
            this._whiteShape = new Shape();
         }
         this._whiteShape.graphics.clear();
         switch(this.picMode)
         {
            case SMALL_PIC:
               this._whiteShape.graphics.beginFill(16777215,1);
               this._whiteShape.graphics.drawRect(0,0,256,146);
               this._whiteShape.graphics.endFill();
               break;
            case BIG_PIC:
               break;
            case CONTENT_PIC:
               this._whiteShape.graphics.beginFill(16777215,1);
               this._whiteShape.graphics.drawRect(0,0,256,146);
               this._whiteShape.graphics.endFill();
         }
         addChildAt(this._whiteShape,0);
      }
      
      protected function get picMode() : uint
      {
         if(this._info == null)
         {
            return SMALL_PIC;
         }
         switch(this._info.type)
         {
            case "small":
               return SMALL_PIC;
            case "big":
               return BIG_PIC;
            default:
               return CONTENT_PIC;
         }
      }
      
      protected function configMouseInteractive() : void
      {
         switch(this.picMode)
         {
            case SMALL_PIC:
            case BIG_PIC:
               buttonMode = true;
               mouseChildren = false;
               break;
            case CONTENT_PIC:
               buttonMode = false;
               if(this._info != null && this._info.fileType == SWF)
               {
                  mouseChildren = true;
               }
               else
               {
                  mouseChildren = false;
               }
         }
      }
      
      public function set playEffect(param1:Boolean) : void
      {
         var updateFilter:Function = null;
         updateFilter = null;
         var value:Boolean = param1;
         updateFilter = function():void
         {
            filters = [_glowFilter2,_glowFilter];
         };
         if(value && this._glowFilter && this._glowFilter2)
         {
            y -= 5;
            TweenMax.to(this._glowFilter,0.45,{
               "startAt":{
                  "blurX":0,
                  "blurY":0,
                  "strength":1
               },
               "blurX":8,
               "blurY":8,
               "strength":2.5,
               "yoyo":true,
               "repeat":-1,
               "ease":Sine.easeOut,
               "onUpdate":updateFilter
            });
            TweenMax.to(this._glowFilter2,0.45,{
               "startAt":{
                  "blurX":0,
                  "blurY":0,
                  "strength":1
               },
               "blurX":15,
               "blurY":15,
               "strength":2.5,
               "yoyo":true,
               "repeat":-1,
               "ease":Sine.easeOut,
               "onUpdate":updateFilter
            });
            return;
         }
         if(this._glowFilter && this._glowFilter2)
         {
            y += 5;
            TweenMax.killTweensOf(this._glowFilter);
            TweenMax.killTweensOf(this._glowFilter2);
            filters = null;
            return;
         }
      }
      
      public function dispose() : void
      {
         if(this._glowFilter)
         {
            TweenMax.killTweensOf(this._glowFilter);
         }
         if(this._glowFilter2)
         {
            TweenMax.killTweensOf(this._glowFilter2);
         }
         removeEventListener(MouseEvent.CLICK,this.__picClick);
         if(this._whiteShape)
         {
            if(this._whiteShape.parent)
            {
               this._whiteShape.parent.removeChild(this._whiteShape);
            }
            this._whiteShape.graphics.clear();
            this._whiteShape = null;
         }
         if(this._loader)
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.__onLoadCompleted);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.__onLoadError);
            if(this._loader.parent)
            {
               this._loader.parent.removeChild(this._loader);
            }
            this._loader.contentLoaderInfo.loader.unloadAndStop();
            this._loader = null;
         }
         filters = null;
         this._glowFilter = null;
         this._glowFilter2 = null;
         if(this._loadingMc && this._loadingMc.parent)
         {
            if(this._loadingMc.parent)
            {
               this._loadingMc.parent.removeChild(this._loadingMc);
            }
            this._loadingMc = null;
         }
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
