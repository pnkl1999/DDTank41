package ddt.manager
{
   import com.pickgliss.toplevel.StageReferance;
   import ddt.data.DebugCommand;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   
   public class DebugManager
   {
      
      private static const USER:String = "admin";
      
      private static const PWD:String = "ddt";
      
      private static var _ins:DebugManager;
       
      
      private var _user:String;
      
      private var _pwd:String;
      
      private var _address:String = "127.0.0.1";
      
      private var _port:String = "5800";
      
      private var _started:Boolean = false;
      
      private var _loadedMonster:Boolean = false;
      
      private var _loader:Loader;
      
      public function DebugManager()
      {
         super();
      }
      
      public static function getInstance() : DebugManager
      {
         if(_ins == null)
         {
            _ins = new DebugManager();
         }
         return _ins;
      }
      
      public function get enabled() : Boolean
      {
         return this._started && this._loadedMonster;
      }
      
      private function loadMonster() : void
      {
         if(!this._loadedMonster)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__monsterComplete);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.__progress);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
            this._loader.load(new URLRequest(PathManager.getMonsterPath()),new LoaderContext(false,ApplicationDomain.currentDomain));
         }
      }
      
      private function __progress(param1:ProgressEvent) : void
      {
         var _loc2_:int = param1.bytesLoaded / param1.bytesTotal * 100;
         ChatManager.Instance.sysChatYellow("Monster 已载入 " + _loc2_ + "%");
      }
      
      private function __ioError(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = param1.currentTarget as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.__monsterComplete);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.__progress);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
         ChatManager.Instance.sysChatYellow("Monster io error: " + param1.text);
      }
      
      protected function __monsterComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = param1.currentTarget as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.__monsterComplete);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.__progress);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
         this._loadedMonster = true;
         ChatManager.Instance.sysChatYellow("Monster载入完成。");
      }
      
      public function startup(param1:String) : void
      {
         var arr:Array = null;
         var s:String = null;
         var param:Array = null;
         var monsterRef:Class = null;
         var str:String = param1;
         if(!this._started)
         {
            arr = str.split(" -");
            for each(s in arr)
            {
               param = s.split(" ");
               switch(param[0])
               {
                  case "u":
                     this._user = param[1];
                     break;
                  case "p":
                     this._pwd = param[1];
                     break;
                  case "host":
                     this._address = param[1];
                     break;
                  case "P":
                     this._port = param[1];
                     break;
               }
            }
            try
            {
               if(this._user != USER || this._pwd != PWD)
               {
                  return;
               }
               monsterRef = getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class;
               if(!monsterRef["initialized"])
               {
                  monsterRef["initialize"](StageReferance.stage);
               }
               monsterRef["startup"](this._address,this._port,this.onDebuggerConnect);
               return;
            }
            catch(e:Error)
            {
               ChatManager.Instance.sysChatYellow(e.toString());
               return;
            }
         }
         else
         {
            return;
         }
      }
      
      private function onDebuggerConnect() : void
      {
         ChatManager.Instance.sysChatYellow("Monster 已经启动。");
         this._started = true;
      }
      
      public function shutdown() : void
      {
         var monsterRef:Class = null;
         if(this._started)
         {
            try
            {
               monsterRef = getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class;
               monsterRef["shutdown"]();
               ChatManager.Instance.sysChatYellow("Monster 已经关闭。");
               this._started = false;
               return;
            }
            catch(e:Error)
            {
               ChatManager.Instance.sysChatYellow(e.toString());
               return;
            }
         }
         else
         {
            return;
         }
      }
      
      public function handle(param1:String) : void
      {
         var _loc2_:String = null;
         if(!this._started)
         {
            if(param1.split(" ")[0] == "#loadmonster")
            {
               this.loadMonster();
            }
            else if(param1.split(" ")[0] == "#debug-startup" && this._loadedMonster)
            {
               this.startup(param1);
            }
            else if(param1.split(" ")[0] == "#info")
            {
               this.info();
            }
         }
         else if(this._loadedMonster)
         {
            _loc2_ = String(param1.split(" ")[0]).replace("#","");
            switch(_loc2_)
            {
               case DebugCommand.Shutdown:
                  this.shutdown();
            }
         }
      }
      
      private function info() : void
      {
         var _loc1_:String = "info:\n";
         var _loc2_:String = Capabilities.playerType;
         var _loc3_:String = Capabilities.version;
         var _loc4_:Boolean = Capabilities.isDebugger;
         _loc1_ += "PlayerType:" + _loc2_;
         _loc1_ += "\nPlayerVersion:" + _loc3_;
         _loc1_ += "\nisDebugger:" + _loc4_;
         if(_loc2_ == "Desktop")
         {
            _loc1_ += "\ncpuArchitecture:" + Capabilities.cpuArchitecture;
         }
         _loc1_ += "\nhasIME:" + Capabilities.hasIME;
         _loc1_ += "\nlanguage:" + Capabilities.language;
         _loc1_ += "\nos:" + Capabilities.os;
         _loc1_ += "\nscreenResolutionX:" + Capabilities.screenResolutionX;
         _loc1_ += "\nscreenResolutionY:" + Capabilities.screenResolutionY;
         ChatManager.Instance.sysChatYellow(_loc1_);
      }
   }
}
