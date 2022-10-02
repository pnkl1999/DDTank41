package com.pickgliss.loader
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import deng.fzip.FZip;
   import deng.fzip.FZipFile;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.utils.ByteArray;
   
   [Event(name="uiModuleComplete",type="com.pickgliss.events.UIModuleEvent")]
   [Event(name="uiModuleError",type="com.pickgliss.events.UIModuleEvent")]
   [Event(name="uiMoudleProgress",type="com.pickgliss.events.UIModuleEvent")]
   public class UIModuleLoader extends EventDispatcher
   {
      
      public static const XMLPNG:String = "xml.png";
      
      public static const CONFIG_ZIP:String = "configZip";
      
      public static const CONFIG_XML:String = "configXml";
      
      private static var _baseUrl:String = "";
      
      private static var _instance:UIModuleLoader;
       
      
      private var _uiModuleLoadMode:String = "configXml";
      
      private var _loadingLoaders:Vector.<BaseLoader>;
      
      private var _queue:Vector.<String>;
      
      private var _backupUrl:String = "";
      
      private var _zipPath:String = "";
      
      private var _zipLoadComplete:Boolean = true;
      
      private var _zipLoader:BaseLoader;
      
      private var _isSecondLoad:Boolean = false;
      
      public function UIModuleLoader()
      {
         super();
         this._queue = new Vector.<String>();
         this._loadingLoaders = new Vector.<BaseLoader>();
      }
      
      public static function get Instance() : UIModuleLoader
      {
         if(_instance == null)
         {
            _instance = new UIModuleLoader();
         }
         return _instance;
      }
      
      public function addUIModlue(module:String) : void
      {
         if(this._queue.indexOf(module) != -1)
         {
            return;
         }
         this._queue.push(module);
         if(!this.isLoading && this._zipLoadComplete)
         {
            this.loadNextModule();
         }
      }
      
      public function addUIModuleImp(module:String, state:String = null) : void
      {
         var index:int = this._queue.indexOf(module);
         if(index != -1)
         {
            this._queue.splice(index,1);
         }
         if(this._zipLoadComplete)
         {
            this.loadModuleConfig(module,state);
         }
         else
         {
            this._queue.unshift(module);
         }
      }
      
      public function setup(baseUrl:String = "", backupUrl:String = "") : void
      {
         _baseUrl = baseUrl;
         this._backupUrl = backupUrl;
         ComponentSetting.FLASHSITE = _baseUrl;
         ComponentSetting.BACKUP_FLASHSITE = this._backupUrl;
         this._zipPath = _baseUrl + ComponentSetting.getUIConfigZIPPath();
         this._uiModuleLoadMode = CONFIG_ZIP;
         this._zipLoadComplete = false;
         this.loadZipConfig();
      }
      
      public function get baseUrl() : String
      {
         return _baseUrl;
      }
      
      private function loadZipConfig() : void
      {
         if(this._uiModuleLoadMode == CONFIG_XML)
         {
            return;
         }
         this._zipLoader = LoaderManager.Instance.creatLoader(this._zipPath,BaseLoader.BYTE_LOADER);
         this._zipLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadZipComplete);
         LoaderManager.Instance.startLoad(this._zipLoader);
      }
      
      private function __onLoadZipComplete(event:LoaderEvent) : void
      {
         var temp:ByteArray = this._zipLoader.content;
         this.analyMd5(temp);
      }
      
      public function analyMd5(content:ByteArray) : void
      {
         var temp:ByteArray = null;
         if(ComponentSetting.md5Dic[XMLPNG] || this.hasHead(content))
         {
            if(this.compareMD5(content))
            {
               temp = new ByteArray();
               content.position = 37;
               content.readBytes(temp);
               this.zipLoad(temp);
            }
            else
            {
               if(this._isSecondLoad)
               {
                  if(ExternalInterface.available)
                  {
                     ExternalInterface.call("alert",this._zipPath + ":is old");
                  }
               }
               else
               {
                  this._zipPath = this._zipPath.replace(ComponentSetting.FLASHSITE,ComponentSetting.BACKUP_FLASHSITE);
                  this._zipLoader.url = this._zipPath + "?rnd=" + Math.random();
                  this._zipLoader.isLoading = false;
                  this._zipLoader.loadFromWeb();
               }
               this._isSecondLoad = true;
            }
         }
         else
         {
            this.zipLoad(content);
         }
      }
      
      private function compareMD5(temp:ByteArray) : Boolean
      {
         var source:int = 0;
         var target:int = 0;
         var md5Bytes:ByteArray = new ByteArray();
         md5Bytes.writeUTFBytes(ComponentSetting.md5Dic[XMLPNG]);
         md5Bytes.position = 0;
         temp.position = 5;
         while(md5Bytes.bytesAvailable > 0)
         {
            source = md5Bytes.readByte();
            target = temp.readByte();
            if(source != target)
            {
               return false;
            }
         }
         return true;
      }
      
      private function hasHead(temp:ByteArray) : Boolean
      {
         var source:int = 0;
         var target:int = 0;
         var road7Byte:ByteArray = new ByteArray();
         road7Byte.writeUTFBytes(ComponentSetting.swf_head);
         road7Byte.position = 0;
         temp.position = 0;
         while(road7Byte.bytesAvailable > 0)
         {
            source = road7Byte.readByte();
            target = temp.readByte();
            if(source != target)
            {
               return false;
            }
         }
         return true;
      }
      
      private function zipLoad(content:ByteArray) : void
      {
         var zip:FZip = new FZip();
         zip.addEventListener(Event.COMPLETE,this.__onZipParaComplete);
         zip.loadBytes(content);
      }
      
      private function __onZipParaComplete(event:Event) : void
      {
         var file:FZipFile = null;
         var xml:XML = null;
         this._zipLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadZipComplete);
         var zip:FZip = event.currentTarget as FZip;
         zip.removeEventListener(Event.COMPLETE,this.__onZipParaComplete);
         var count:int = zip.getFileCount();
         for(var i:int = 0; i < count; i++)
         {
            file = zip.getFileAt(i);
            xml = new XML(file.content.toString());
            ComponentFactory.Instance.setup(xml);
         }
         this._zipLoadComplete = true;
         this.loadNextModule();
      }
      
      public function get isLoading() : Boolean
      {
         return this._loadingLoaders.length > 0;
      }
      
      private function __onConfigLoadComplete(event:LoaderEvent) : void
      {
         var config:XML = null;
         var resourcePath:String = null;
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onConfigLoadComplete);
         event.loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         this._loadingLoaders.splice(this._loadingLoaders.indexOf(event.loader),1);
         if(event.loader.isSuccess)
         {
            config = new XML(event.loader.content);
            resourcePath = config.@source;
            ComponentFactory.Instance.setup(config);
            this.loadModuleUI(resourcePath,event.loader.loadProgressMessage,event.loader.loadCompleteMessage);
         }
         else
         {
            this.removeLastLoader(event.loader);
            dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_COMPLETE,event.loader));
            this.loadNextModule();
         }
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_ERROR,event.loader));
      }
      
      private function __onResourceComplete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         event.loader.removeEventListener(LoaderEvent.PROGRESS,this.__onResourceProgress);
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onResourceComplete);
         this.removeLastLoader(event.loader);
         dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_COMPLETE,event.loader));
         this.loadNextModule();
      }
      
      private function removeLastLoader(loader:BaseLoader) : void
      {
         this._loadingLoaders.splice(this._loadingLoaders.indexOf(loader),1);
         this._queue.splice(this._queue.indexOf(loader.loadProgressMessage),1);
      }
      
      private function __onResourceProgress(event:LoaderEvent) : void
      {
         dispatchEvent(new UIModuleEvent(UIModuleEvent.UI_MODULE_PROGRESS,event.loader));
      }
      
      private function loadNextModule() : void
      {
         if(this._queue.length <= 0)
         {
            return;
         }
         var loadingModule:String = this._queue[0];
         if(!this.isLoadingModule(loadingModule))
         {
            this.loadModuleConfig(loadingModule);
         }
      }
      
      private function isLoadingModule(module:String) : Boolean
      {
         for(var i:int = 0; i < this._loadingLoaders.length; i++)
         {
            if(this._loadingLoaders[i].loadProgressMessage == module)
            {
               return true;
            }
         }
         return false;
      }
      
      private function loadModuleConfig(module:String, state:String = "") : void
      {
         var textLoader:BaseLoader = null;
         if(this._uiModuleLoadMode == CONFIG_XML)
         {
            textLoader = LoaderManager.Instance.creatLoader(_baseUrl + ComponentSetting.getUIConfigXMLPath(module),BaseLoader.TEXT_LOADER);
            textLoader.loadProgressMessage = module;
            textLoader.loadCompleteMessage = state;
            textLoader.addEventListener(LoaderEvent.COMPLETE,this.__onConfigLoadComplete);
            textLoader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            textLoader.loadErrorMessage = "加载UI配置文件" + textLoader.url + "出现错误";
            this._loadingLoaders.push(textLoader);
            LoaderManager.Instance.startLoad(textLoader,true);
         }
         else
         {
            this.loadModuleUI(_baseUrl + ComponentSetting.getUISourcePath(module),module,state);
         }
      }
      
      private function loadModuleUI(uipath:String, module:String = "", state:String = "") : void
      {
         var uiResourceLoader:BaseLoader = LoaderManager.Instance.creatLoader(uipath,BaseLoader.MODULE_LOADER);
         uiResourceLoader.loadProgressMessage = module;
         uiResourceLoader.loadCompleteMessage = state;
         uiResourceLoader.loadErrorMessage = "加载ui资源：" + uiResourceLoader.url + "出现错误";
         uiResourceLoader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         uiResourceLoader.addEventListener(LoaderEvent.PROGRESS,this.__onResourceProgress);
         uiResourceLoader.addEventListener(LoaderEvent.COMPLETE,this.__onResourceComplete);
         this._loadingLoaders.push(uiResourceLoader);
         LoaderManager.Instance.startLoad(uiResourceLoader,true);
      }
   }
}
