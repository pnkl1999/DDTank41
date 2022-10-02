package littleGame
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import ddt.interfaces.IProcessObject;
   import ddt.manager.PathManager;
   import ddt.manager.ProcessManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import littleGame.data.Grid;
   import littleGame.model.Scenario;
   
   [Event(name="complete",type="com.pickgliss.loader.LoaderEvent")]
   public class ScenarioLoader extends EventDispatcher implements IProcessObject
   {
      
      private static const GridProcessCount:int = 5000;
      
      private static const ConfigReady:int = 1;
      
      private static const ConfigStartProcess:int = 2;
      
      private static const ConfigEndProcess:int = 3;
      
      private static const ConfigComplete:int = 4;
       
      
      private var _onProcess:Boolean = false;
      
      private var _loaded:int = 0;
      
      private var _total:int = 2;
      
      private var _w:int;
      
      private var _h:int;
      
      private var _localW:int;
      
      private var _localH:int;
      
      private var _configBytes:ByteArray;
      
      private var _grid:Grid;
      
      private var _resLoader:BaseLoader;
      
      private var _configLoader:BaseLoader;
      
      private var _scene:Scenario;
      
      private var _objectLoaders:Vector.<BaseLoader>;
      
      private var _objectLoaded:int = 0;
      
      private var _configLoaded:int = 0;
      
      private var _configProcessState:int = 0;
      
      private var _configReady:Boolean = false;
      
      public function ScenarioLoader(scene:Scenario)
      {
         this._scene = scene;
         super();
      }
      
      public function startup() : void
      {
         this.loadObjects();
         this.loadConfig();
         this.loadResource();
      }
      
      private function loadObjects() : void
      {
         var loader:BaseLoader = null;
         var objects:Array = this._scene.objects.split(",");
         this._total = objects.length + 2;
         this._objectLoaders = new Vector.<BaseLoader>();
         var len:int = objects.length;
         for(var i:int = 0; i < len; i++)
         {
            loader = LoaderManager.Instance.creatLoader(PathManager.solveLittleGameObjectPath(objects[i]),BaseLoader.MODULE_LOADER);
            loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__loaderError);
            loader.addEventListener(LoaderEvent.COMPLETE,this.__objectComplete);
            LoaderManager.Instance.startLoad(loader);
            this._objectLoaders.push(loader);
         }
      }
      
      private function __loaderError(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__scenarioConfigComplete);
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__objectComplete);
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__scenarioResComplete);
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__loaderError);
      }
      
      private function __objectComplete(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__objectComplete);
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__loaderError);
         ++this._objectLoaded;
         ++this._loaded;
         this.complete();
      }
      
      public function get progress() : int
      {
         return (this._resLoader.progress / this._total + this._configLoader.progress / this._total + this._objectLoaded / this._total + this._configLoaded / this._total) * 100;
      }
      
      public function shutdown() : void
      {
         this._resLoader.removeEventListener(LoaderEvent.COMPLETE,this.__scenarioResComplete);
         this._configLoader.removeEventListener(LoaderEvent.COMPLETE,this.__scenarioConfigComplete);
      }
      
      private function loadResource() : void
      {
         this._resLoader = LoaderManager.Instance.creatLoader(PathManager.solveLittleGameResPath(this._scene.id),BaseLoader.MODULE_LOADER);
         this._resLoader.addEventListener(LoaderEvent.LOAD_ERROR,this.__loaderError);
         this._resLoader.addEventListener(LoaderEvent.COMPLETE,this.__scenarioResComplete);
         LoaderManager.Instance.startLoad(this._resLoader);
      }
      
      private function __scenarioResComplete(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__scenarioResComplete);
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__loaderError);
         ++this._loaded;
         this.complete();
      }
      
      private function loadConfig() : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["rnd"] = Math.random();
         this._configLoader = LoaderManager.Instance.creatLoader(PathManager.solveLittleGameConfigPath(this._scene.id),BaseLoader.BYTE_LOADER,args);
         this._configLoader.addEventListener(LoaderEvent.LOAD_ERROR,this.__loaderError);
         this._configLoader.addEventListener(LoaderEvent.COMPLETE,this.__scenarioConfigComplete);
         LoaderManager.Instance.startLoad(this._configLoader);
      }
      
      private function __scenarioConfigComplete(event:LoaderEvent) : void
      {
         ++this._loaded;
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__scenarioConfigComplete);
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__loaderError);
         this._configBytes = loader.content as ByteArray;
         this._configBytes.uncompress();
         this._configBytes.endian = Endian.LITTLE_ENDIAN;
         this._w = this._configBytes.readInt();
         this._h = this._configBytes.readInt();
         this._grid = new Grid(this._h,this._w);
         this._total += this._w * this._h / GridProcessCount;
         this._configReady = true;
         this.processConfig();
      }
      
      private function processConfig() : void
      {
         ProcessManager.Instance.addObject(this);
         this._configProcessState = ConfigEndProcess;
      }
      
      private function configProcessComplete() : void
      {
         this._configProcessState = ConfigComplete;
         ProcessManager.Instance.removeObject(this);
      }
      
      private function loadConfigData() : void
      {
         var j:int = 0;
         this._configProcessState = ConfigStartProcess;
         var w:int = this._localW + GridProcessCount / this._h;
         w = w > this._w ? int(int(this._w)) : int(int(w));
         for(var i:int = this._localW; i < w; i++)
         {
            for(j = 0; j < this._h; j++)
            {
               this._grid.setNodeWalkAble(i,j,this._configBytes.readByte() == 1 ? Boolean(Boolean(true)) : Boolean(Boolean(false)));
               this._configBytes.readByte();
            }
         }
         this._localW = w;
         if(this._localW < this._w)
         {
            ++this._loaded;
            ++this._configLoaded;
            this._configProcessState = ConfigEndProcess;
         }
         else
         {
            this.configProcessComplete();
            this.complete();
         }
      }
      
      private function __resDataComplete(event:Event) : void
      {
         var dataLoader:URLLoader = event.currentTarget as URLLoader;
         dataLoader.removeEventListener(Event.COMPLETE,this.__resDataComplete);
         var bytes:ByteArray = dataLoader.data as ByteArray;
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__resComplete);
         loader.loadBytes(bytes,new LoaderContext(false,ApplicationDomain.currentDomain));
      }
      
      private function __resComplete(event:Event) : void
      {
         event.currentTarget.removeEventListener(Event.COMPLETE,this.__resComplete);
         ++this._loaded;
         this.complete();
      }
      
      private function complete() : void
      {
         if(this._loaded >= this._total)
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,null));
         }
      }
      
      public function get grid() : Grid
      {
         return this._grid;
      }
      
      public function dispose() : void
      {
         this._grid = null;
         this._objectLoaders = null;
         this._resLoader = null;
         this._configLoader = null;
         this._scene = null;
         this._configBytes = null;
         this._configLoader = null;
      }
      
      public function unload() : void
      {
      }
      
      public function get onProcess() : Boolean
      {
         return this._onProcess;
      }
      
      public function set onProcess(val:Boolean) : void
      {
         this._onProcess = false;
      }
      
      public function process(rate:Number) : void
      {
         if(this._configReady && this._configProcessState == ConfigEndProcess)
         {
            this.loadConfigData();
         }
      }
   }
}
