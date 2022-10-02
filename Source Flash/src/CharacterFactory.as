package
{
   import character.CharacterType;
   import character.ComplexBitmapCharacter;
   import character.ICharacter;
   import character.MovieClipCharacter;
   import character.SimpleBitmapCharacter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class CharacterFactory
   {
      
      private static var _instance:CharacterFactory;
       
      
      private var _filse:Dictionary;
      
      private var _loadedResource:Array;
      
      private var _bitmapdatas:Dictionary;
      
      private var _characterDefines:Dictionary;
      
      private var _movieClips:Dictionary;
      
      private var _loader:URLLoader;
      
      public function CharacterFactory()
      {
         this._filse = new Dictionary();
         super();
         this._loadedResource = [];
         this._bitmapdatas = new Dictionary();
         this._characterDefines = new Dictionary();
         this._movieClips = new Dictionary();
         this._loader = new URLLoader();
         this._loader.dataFormat = URLLoaderDataFormat.BINARY;
      }
      
      public static function get Instance() : CharacterFactory
      {
         if(_instance == null)
         {
            _instance = new CharacterFactory();
         }
         return _instance;
      }
      
      public function addResource(url:String) : URLLoader
      {
         var onComplete:Function = null;
         onComplete = null;
         onComplete = function(event:Event):void
         {
            _loader.removeEventListener(Event.COMPLETE,onComplete);
            var data:ByteArray = _loader.data;
            readFile(data);
            _loadedResource.push(url);
         };
         var request:URLRequest = new URLRequest(url);
         this._loader.addEventListener(Event.COMPLETE,onComplete,false,99);
         this._loader.load(request);
         return this._loader;
      }
      
      public function hasResource(url:String) : Boolean
      {
         return this._loadedResource.indexOf(url) > -1;
      }
      
      public function hasChactater(label:String) : Boolean
      {
         return this._characterDefines[label] != null;
      }
      
      public function creatChacrater(label:String) : ICharacter
      {
         var define:XML = null;
         var fileName:* = null;
         var result:ICharacter = null;
         for(fileName in this._characterDefines)
         {
            if(this._characterDefines[fileName][label])
            {
               define = this._characterDefines[fileName][label];
               break;
            }
         }
         if(define)
         {
            if(int(define.@type) == CharacterType.SIMPLE_BITMAP_TYPE)
            {
               result = new SimpleBitmapCharacter(this._bitmapdatas[fileName][String(define.@resource)],define);
            }
            else if(int(define.@type) == CharacterType.COMPLEX_BITMAP_TYPE)
            {
               result = new ComplexBitmapCharacter(this._bitmapdatas[fileName],define);
            }
            else if(int(define.@type) == CharacterType.MOVIECLIP_TYPE)
            {
               result = new MovieClipCharacter(null,define,label);
            }
         }
         return result;
      }
      
      public function releaseResource() : void
      {
         var bms:Dictionary = null;
         var bm:BitmapData = null;
         for each(bms in this._bitmapdatas)
         {
            for each(bm in bms)
            {
               bm.dispose();
            }
         }
         this._bitmapdatas = new Dictionary();
         this._filse = new Dictionary();
         this._characterDefines = new Dictionary();
      }
      
      public function hasFile(name:String) : Boolean
      {
         return this._filse[name] == true;
      }
      
      public function addFile(name:String, file:ByteArray) : void
      {
         this._filse[name] = true;
         this.readFile(file);
      }
      
      public function readFile(file:ByteArray) : void
      {
         var bitmapdatas:Dictionary = null;
         var loaderComplete:Function = null;
         bitmapdatas = null;
         loaderComplete = null;
         var label:String = null;
         var content:ByteArray = null;
         var contentLen:uint = 0;
         var loader:Loader = null;
         var swfLabel:String = null;
         var swfContent:ByteArray = null;
         var swfLen:uint = 0;
         var ld:Loader = null;
         var context:LoaderContext = null;
         var description:XML = null;
         loaderComplete = function(event:Event):void
         {
            var ld:Loader = LoaderInfo(event.target).loader;
            ld.contentLoaderInfo.removeEventListener(Event.COMPLETE,loaderComplete);
            bitmapdatas[ld.name] = Bitmap(ld.content).bitmapData;
         };
         if(file.position == 0)
         {
            file.uncompress();
         }
         else
         {
            file.position = 0;
         }
         var assetNum:int = 0;
         var assetInitNum:int = 0;
         var swfNum:int = 0;
         var swfInitNum:int = 0;
         var monstNum:int = 0;
         assetNum = file.readByte();
         for(var i:int = 0; i < assetNum; i++)
         {
            label = file.readUTF();
            content = new ByteArray();
            contentLen = file.readUnsignedInt();
            file.readBytes(content,0,contentLen);
            loader = new Loader();
            loader.name = label;
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderComplete);
            loader.loadBytes(content);
         }
         swfNum = file.readByte();
         for(var j:int = 0; j < swfNum; j++)
         {
            swfLabel = file.readUTF();
            swfContent = new ByteArray();
            swfLen = file.readUnsignedInt();
            file.readBytes(swfContent,0,swfLen);
            ld = new Loader();
            context = new LoaderContext(false,ApplicationDomain.currentDomain);
            ld.loadBytes(swfContent,context);
         }
         var fileDescription:XML = new XML(file.readUTF());
         var characters:XMLList = fileDescription..character;
         var fileName:String = fileDescription.@fileName;
         bitmapdatas = new Dictionary();
         var characterDefines:Dictionary = new Dictionary();
         monstNum = characters.length();
         for(var k:int = 0; k < monstNum; k++)
         {
            description = characters[k];
            characterDefines[String(description.@label)] = description;
         }
         this._characterDefines[fileName] = characterDefines;
         this._bitmapdatas[fileName] = bitmapdatas;
      }
   }
}
