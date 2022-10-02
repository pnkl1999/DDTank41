package ddt.manager
{
   import ddt.command.SoundEffect;
   import ddt.events.SoundEffectEvent;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class SoundEffectManager extends EventDispatcher
   {
      
      private static var _instance:SoundEffectManager;
       
      
      private var _loader:Loader;
      
      private var _soundDomain:ApplicationDomain;
      
      private var _context:LoaderContext;
      
      private var _lib:Dictionary;
      
      private var _delay:Dictionary;
      
      private var _maxCounts:Dictionary;
      
      private var _progress:Dictionary;
      
      private var _movieClips:Dictionary;
      
      private var _currentLib:String;
      
      public function SoundEffectManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get Instance() : SoundEffectManager
      {
         if(_instance == null)
         {
            _instance = new SoundEffectManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._loader = new Loader();
         this._soundDomain = new ApplicationDomain();
         this._context = new LoaderContext(false,this._soundDomain);
         this._lib = new Dictionary();
         this._delay = new Dictionary();
         this._maxCounts = new Dictionary();
         this._progress = new Dictionary();
         this._movieClips = new Dictionary(true);
         this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.__onProgress);
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__onLoadComplete);
      }
      
      public function loadSound(param1:String) : void
      {
         this._currentLib = param1;
         if(this._progress[this._currentLib] == 1)
         {
            return;
         }
         this._progress[this._currentLib] = 0;
         this._loader.load(new URLRequest(this._currentLib),this._context);
      }
      
      public function definition(param1:String) : *
      {
         return this._soundDomain.getDefinition(param1);
      }
      
      public function get progress() : int
      {
         return this._progress[this._currentLib];
      }
      
      public function controlMovie(param1:MovieClip) : void
      {
         param1.addEventListener("play",this.__onPlay);
         this._movieClips[param1] = param1;
      }
      
      public function releaseMovie(param1:MovieClip) : void
      {
         param1.removeEventListener("play",this.__onPlay);
         delete this._movieClips[param1];
         this._movieClips[param1] = null;
      }
      
      private function play(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SoundEffect = null;
         if(this._lib[this._currentLib] == null)
         {
            this.loadSound(this._currentLib);
         }
         else
         {
            _loc2_ = getTimer();
            if(this.checkPlay(param1))
            {
               _loc3_ = new SoundEffect(param1);
               _loc3_.addEventListener(Event.SOUND_COMPLETE,this.__onSoundComplete);
               _loc3_.play();
            }
         }
      }
      
      private function checkPlay(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         if(this._delay[param1])
         {
            if(this._delay[param1].length > 0)
            {
               _loc2_ = getTimer();
               if(_loc2_ - this._delay[param1][0] > 200)
               {
                  if(this._delay[param1].length >= this._maxCounts[param1])
                  {
                     this._delay[param1].shift();
                  }
                  this._delay[param1].push(_loc2_);
                  return true;
               }
               return false;
            }
            return true;
         }
         this._delay[param1] = [getTimer()];
         return true;
      }
      
      private function __onPlay(param1:SoundEffectEvent) : void
      {
         this._maxCounts[param1.soundInfo.soundId] = param1.soundInfo.maxCount;
         this.play(param1.soundInfo.soundId);
      }
      
      private function __onProgress(param1:ProgressEvent) : void
      {
         this._progress[this._currentLib] = Math.floor(param1.bytesLoaded / param1.bytesTotal);
      }
      
      private function __onLoadComplete(param1:Event) : void
      {
         this._lib[this._currentLib] = true;
         this._progress[this._currentLib] = 1;
      }
      
      private function __onSoundComplete(param1:Event) : void
      {
         var _loc2_:SoundEffect = param1.currentTarget as SoundEffect;
         this._delay[_loc2_.id].shift();
         _loc2_.dispose();
         _loc2_ = null;
      }
   }
}
