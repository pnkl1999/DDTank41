package ddt.view.character
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BaseCharacter extends Sprite implements ICharacter, Disposeable
   {
      
      public static const BASE_WIDTH:int = 120;
      
      public static const BASE_HEIGHT:int = 165;
       
      
      protected var _info:PlayerInfo;
      
      protected var _frames:Array;
      
      protected var _loader:ICharacterLoader;
      
      protected var _characterWidth:Number;
      
      protected var _characterHeight:Number;
      
      protected var _factory:ICharacterLoaderFactory;
      
      protected var _dir:int;
      
      protected var _container:Sprite;
      
      protected var _body:Bitmap;
      
      protected var _currentframe:int;
      
      protected var _loadCompleted:Boolean;
      
      protected var _picLines:int;
      
      protected var _picsPerLine:int;
      
      private var _autoClearLoader:Boolean;
      
      protected var _characterBitmapdata:BitmapData;
      
      protected var _bitmapChanged:Boolean;
      
      private var _lifeUpdate:Boolean;
      
      private var _disposed:Boolean;
      
      public function BaseCharacter(param1:PlayerInfo, param2:Boolean)
      {
         this._info = param1;
         this._lifeUpdate = param2;
         super();
         this.init();
         this.initEvent();
      }
      
      public function get characterWidth() : Number
      {
         return this._characterWidth;
      }
      
      public function get characterHeight() : Number
      {
         return this._characterHeight;
      }
      
      protected function init() : void
      {
         this._currentframe = -1;
         this.initSizeAndPics();
         this.createFrames();
         this._container = new Sprite();
         addChild(this._container);
         this._body = new Bitmap(new BitmapData(this._characterWidth + 1,this._characterHeight,true,0),PixelSnapping.NEVER,true);
         this._container.addChild(this._body);
         mouseEnabled = false;
         mouseChildren = false;
         this._loadCompleted = false;
      }
      
      protected function initSizeAndPics() : void
      {
         this.setCharacterSize(BASE_WIDTH,BASE_HEIGHT);
         this.setPicNum(1,3);
      }
      
      protected function initEvent() : void
      {
         this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeFromStage);
      }
      
      private function __addToStage(param1:Event) : void
      {
         if(this._lifeUpdate)
         {
            addEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
      }
      
      private function __removeFromStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function __enterFrame(param1:Event) : void
      {
         this.update();
      }
      
      public function update() : void
      {
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.STYLE] || param1.changedProperties[PlayerInfo.COLORS])
         {
            if(this._loader == null)
            {
               this.initLoader();
               this._loader.load(this.__loadComplete);
            }
            else
            {
               this._loader.update();
            }
         }
      }
      
      protected function setCharacterSize(param1:Number, param2:Number) : void
      {
         this._characterWidth = param1;
         this._characterHeight = param2;
      }
      
      protected function setPicNum(param1:int, param2:int) : void
      {
         this._picLines = param1;
         this._picsPerLine = param2;
      }
      
      public function setColor(param1:*) : Boolean
      {
         return false;
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      public function get currentFrame() : int
      {
         return this._currentframe;
      }
      
      public function set characterBitmapdata(param1:BitmapData) : void
      {
         if(param1 == this._characterBitmapdata)
         {
            return;
         }
         this._characterBitmapdata = param1;
         this._bitmapChanged = true;
      }
      
      public function get characterBitmapdata() : BitmapData
      {
         return this._characterBitmapdata;
      }
      
      public function get completed() : Boolean
      {
         return this._loadCompleted;
      }
      
      public function getCharacterLoadLog() : String
      {
         if(this._loader is ShowCharacterLoader)
         {
            return (this._loader as ShowCharacterLoader).getUnCompleteLog();
         }
         return "not ShowCharacterLoader";
      }
      
      public function doAction(param1:*) : void
      {
      }
      
      public function setDefaultAction(param1:*) : void
      {
      }
      
      public function show(param1:Boolean = true, param2:int = 1, param3:Boolean = true) : void
      {
         this._dir = param2 > 0 ? int(int(1)) : int(int(-1));
         scaleX = this._dir;
         this._autoClearLoader = param1;
         if(!this._loadCompleted)
         {
            if(this._loader == null)
            {
               this.initLoader();
            }
            this._loader.load(this.__loadComplete);
         }
      }
      
      protected function __loadComplete(param1:ICharacterLoader) : void
      {
         this._loadCompleted = true;
         this.setContent();
         if(this._autoClearLoader && this._loader != null)
         {
            this._loader.dispose();
            this._loader = null;
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function setContent() : void
      {
         if(this._loader != null)
         {
            if(this._characterBitmapdata && this._characterBitmapdata != this._loader.getContent()[0])
            {
               this._characterBitmapdata.dispose();
            }
            this.characterBitmapdata = this._loader.getContent()[0];
         }
         this.drawFrame(this._currentframe);
      }
      
      public function setFactory(param1:ICharacterLoaderFactory) : void
      {
         this._factory = param1;
      }
      
      protected function initLoader() : void
      {
         this._loader = this._factory.createLoader(this._info,CharacterLoaderFactory.SHOW);
      }
      
      public function drawFrame(param1:int, param2:int = 0, param3:Boolean = true) : void
      {
         if(this._characterBitmapdata != null)
         {
            if(param1 < 0 || param1 >= this._frames.length)
            {
               param1 = 0;
            }
            if(param1 != this._currentframe || this._bitmapChanged)
            {
               this._bitmapChanged = false;
               this._currentframe = param1;
               this._body.bitmapData.copyPixels(this._characterBitmapdata,this._frames[this._currentframe],new Point(0,0));
            }
         }
      }
      
      protected function createFrames() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Rectangle = null;
         this._frames = [];
         var _loc1_:int = 0;
         while(_loc1_ < this._picLines)
         {
            _loc2_ = 0;
            while(_loc2_ < this._picsPerLine)
            {
               _loc3_ = new Rectangle(_loc2_ * this._characterWidth,_loc1_ * this._characterHeight,this._characterWidth,this._characterHeight);
               this._frames.push(_loc3_);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         this._body.smoothing = param1;
      }
      
      public function set showGun(param1:Boolean) : void
      {
      }
      
      public function setShowLight(param1:Boolean, param2:Point = null) : void
      {
      }
      
      public function get currentAction() : *
      {
         return "";
      }
      
      public function actionPlaying() : Boolean
      {
         return false;
      }
      
      public function dispose() : void
      {
         this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._disposed = true;
         this._info = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.__removeFromStage);
         if(this._loader)
         {
            this._loader.dispose();
            this._loader = null;
         }
         this._factory = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._body && this._body.bitmapData)
         {
            this._body.bitmapData.dispose();
         }
         this._body = null;
         if(this._characterBitmapdata)
         {
            this._characterBitmapdata.dispose();
         }
         this._characterBitmapdata = null;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
