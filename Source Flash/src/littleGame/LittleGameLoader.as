package littleGame
{
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.interfaces.IProcessObject;
   import ddt.manager.ProcessManager;
   import flash.events.EventDispatcher;
   import littleGame.data.Grid;
   import littleGame.model.Scenario;
   
   [Event(name="progress",type="com.pickgliss.loader.LoaderEvent")]
   [Event(name="complete",type="com.pickgliss.loader.LoaderEvent")]
   [Event(name="loadError",type="com.pickgliss.loader.LoaderEvent")]
   public class LittleGameLoader extends EventDispatcher implements IProcessObject
   {
       
      
      private var _game:Scenario;
      
      private var _loaded:int = 0;
      
      private var _total:int = 2;
      
      private var _scenarioLoader:ScenarioLoader;
      
      private var _monsterLoader:MonsterLoader;
      
      private var _onProcess:Boolean;
      
      public function LittleGameLoader(game:Scenario)
      {
         this._game = game;
         super();
      }
      
      public function dispose() : void
      {
         ProcessManager.Instance.removeObject(this);
         ObjectUtils.disposeObject(this._scenarioLoader);
         this._scenarioLoader = null;
         ObjectUtils.disposeObject(this._monsterLoader);
         this._monsterLoader = null;
      }
      
      public function shutdown() : void
      {
         ProcessManager.Instance.removeObject(this);
         this._scenarioLoader.shutdown();
         this._monsterLoader.shutdown();
      }
      
      public function startup() : void
      {
         this._scenarioLoader = new ScenarioLoader(this._game);
         this._scenarioLoader.addEventListener(LoaderEvent.COMPLETE,this.__scenarioComplete);
         this._scenarioLoader.startup();
         this._monsterLoader = new MonsterLoader(this._game.monsters.split(","));
         this._monsterLoader.addEventListener(LoaderEvent.COMPLETE,this.__monsterComplete);
         this._monsterLoader.startup();
         ProcessManager.Instance.addObject(this);
      }
      
      private function __monsterComplete(event:LoaderEvent) : void
      {
         this._monsterLoader.removeEventListener(LoaderEvent.COMPLETE,this.__monsterComplete);
         ++this._loaded;
         this.complete();
      }
      
      private function __scenarioComplete(event:LoaderEvent) : void
      {
         this._scenarioLoader.removeEventListener(LoaderEvent.COMPLETE,this.__scenarioComplete);
         ++this._loaded;
         this.complete();
      }
      
      public function get grid() : Grid
      {
         return this._scenarioLoader.grid;
      }
      
      public function get progress() : int
      {
         return this._scenarioLoader.progress / this._total + this._monsterLoader.progress / this._total;
      }
      
      private function complete() : void
      {
         if(this._loaded >= this._total)
         {
            this.shutdown();
            dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE,null));
         }
      }
      
      public function get onProcess() : Boolean
      {
         return this._onProcess;
      }
      
      public function set onProcess(val:Boolean) : void
      {
         this._onProcess = val;
      }
      
      public function process(rate:Number) : void
      {
         dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS,null));
      }
      
      public function unload() : void
      {
         this._monsterLoader.unload();
         this._scenarioLoader.unload();
      }
   }
}
