package littleGame
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.PathManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   
   [Event(name="complete",type="com.pickgliss.loader.LoaderEvent")]
   public class MonsterLoader extends EventDispatcher implements Disposeable
   {
       
      
      private var _loaded:int;
      
      private var _total:int;
      
      private var _monsters:Array;
      
      private var _loaders:Vector.<BaseLoader>;
      
      private var _shutdown:Boolean = false;
      
      public function MonsterLoader(monsters:Array)
      {
         this._loaders = new Vector.<BaseLoader>();
         this._monsters = monsters;
         this._total = this._monsters.length;
         super();
      }
      
      public function dispose() : void
      {
         this._loaders = null;
      }
      
      public function startup() : void
      {
         var monster:String = null;
         var loader:BaseLoader = null;
         for each(monster in this._monsters)
         {
            loader = LoaderManager.Instance.creatLoader(PathManager.solveASTPath(monster),BaseLoader.BYTE_LOADER);
            if(CharacterFactory.Instance.hasFile(loader.url))
            {
               ++this._loaded;
               this.complete();
            }
            else
            {
               loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__loaderError);
               loader.addEventListener(LoaderEvent.COMPLETE,this.__dataComplete);
               LoaderManager.Instance.startLoad(loader);
               this._loaders.push(loader);
            }
         }
      }
      
      private function __loaderError(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__dataComplete);
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__loaderError);
         trace("MonsterLoader__loaderError:" + event.loader.url);
      }
      
      public function shutdown() : void
      {
         this._shutdown = true;
      }
      
      private function __dataComplete(event:Event) : void
      {
         var dataLoader:BaseLoader = event.currentTarget as BaseLoader;
         dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.__loaderError);
         dataLoader.removeEventListener(LoaderEvent.COMPLETE,this.__dataComplete);
         var bytes:ByteArray = dataLoader.content as ByteArray;
         CharacterFactory.Instance.addFile(dataLoader.url,bytes);
         var idx:int = this._loaders.indexOf(dataLoader);
         if(idx >= 0)
         {
            this._loaders.splice(idx,1);
         }
         ++this._loaded;
         this.complete();
      }
      
      private function complete() : void
      {
         if(this._loaded >= this._total && !this._shutdown)
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,null));
         }
      }
      
      public function get progress() : int
      {
         return this._loaded / this._total * 100;
      }
      
      public function unload() : void
      {
      }
   }
}
