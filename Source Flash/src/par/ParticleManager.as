package par
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.utils.ObjectUtils;
   import flash.system.ApplicationDomain;
   import flash.utils.describeType;
   import par.emitters.Emitter;
   import par.emitters.EmitterInfo;
   import par.lifeeasing.AbstractLifeEasing;
   import par.particals.ParticleInfo;
   import road7th.math.ColorLine;
   import road7th.math.XLine;
   
   public class ParticleManager
   {
      
      public static var list:Array = new Array();
      
      private static var _ready:Boolean;
      
      public static const PARTICAL_XML_PATH:String = "partical.xml";
      
      public static const SHAPE_PATH:String = "shape.swf";
      
      public static const PARTICAL_LITE:String = "particallite.xml";
      
      public static const SHAPE_LITE:String = "shapelite.swf";
      
	  internal static var Domain:ApplicationDomain;
       
      
      public function ParticleManager()
      {
         super();
      }
      
      public static function get ready() : Boolean
      {
         return _ready;
      }
      
      public static function addEmitterInfo(param1:EmitterInfo) : void
      {
         list.push(param1);
      }
      
      public static function removeEmitterInfo(param1:EmitterInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < list.length)
         {
            if(list[_loc2_] == param1)
            {
               list.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public static function creatEmitter(param1:Number) : Emitter
      {
         var _loc2_:EmitterInfo = null;
         var _loc3_:Emitter = null;
         for each(_loc2_ in list)
         {
            if(_loc2_.id == param1)
            {
               _loc3_ = new Emitter();
               _loc3_.info = _loc2_;
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function clear() : void
      {
         list = new Array();
         _ready = false;
      }
      
      private static function load(param1:XML) : void
      {
         var _loc5_:XML = null;
         var _loc6_:EmitterInfo = null;
         var _loc7_:XMLList = null;
         var _loc8_:XML = null;
         var _loc9_:ParticleInfo = null;
         var _loc10_:XMLList = null;
         var _loc11_:AbstractLifeEasing = null;
         var _loc12_:XML = null;
         var _loc2_:XMLList = param1..emitter;
         var _loc3_:XML = describeType(new ParticleInfo());
         var _loc4_:XML = describeType(new EmitterInfo());
         for each(_loc5_ in _loc2_)
         {
            _loc6_ = new EmitterInfo();
            ObjectUtils.copyPorpertiesByXML(_loc6_,_loc5_);
            _loc7_ = _loc5_.particle;
            for each(_loc8_ in _loc7_)
            {
               _loc9_ = new ParticleInfo();
               ObjectUtils.copyPorpertiesByXML(_loc9_,_loc8_);
               _loc10_ = _loc8_.easing;
               _loc11_ = new AbstractLifeEasing();
               for each(_loc12_ in _loc10_)
               {
                  if(_loc12_.@name != "colorLine")
                  {
                     _loc11_[_loc12_.@name].line = XLine.parse(_loc12_.@value);
                  }
                  else
                  {
                     _loc11_.colorLine = new ColorLine();
                     _loc11_.colorLine.line = XLine.parse(_loc12_.@value);
                  }
               }
               _loc9_.lifeEasing = _loc11_;
               _loc6_.particales.push(_loc9_);
            }
            list.push(_loc6_);
         }
         _ready = true;
      }
      
      public static function initPartical(param1:String, param2:String = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:BaseLoader = null;
         var _loc6_:ModuleLoader = null;
         if(!_ready && param1 != null)
         {
            Domain = new ApplicationDomain();
            _loc3_ = param1 + (param2 == "lite" ? PARTICAL_LITE : PARTICAL_XML_PATH);
            _loc4_ = param1 + (param2 == "lite" ? SHAPE_LITE : SHAPE_PATH);
            _loc5_ = LoaderManager.Instance.creatLoader(_loc3_,BaseLoader.TEXT_LOADER);
            _loc5_.addEventListener(LoaderEvent.COMPLETE,__loadComplete);
            LoaderManager.Instance.startLoad(_loc5_);
            _loc6_ = LoaderManager.Instance.creatLoader(_loc4_,BaseLoader.MODULE_LOADER,null,"GET",Domain);
            _loc6_.addEventListener(LoaderEvent.COMPLETE,__onShapeLoadComplete);
            LoaderManager.Instance.startLoad(_loc6_);
         }
      }
      
      private static function __onShapeLoadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,__onShapeLoadComplete);
         ShapeManager.setup();
      }
      
      private static function __loadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,__loadComplete);
         try
         {
            load(new XML(param1.loader.content));
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      private static function save() : XML
      {
         var _loc2_:EmitterInfo = null;
         var _loc3_:XML = null;
         var _loc4_:ParticleInfo = null;
         var _loc5_:XML = null;
         var _loc1_:XML = <list></list>;
         for each(_loc2_ in list)
         {
            _loc3_ = ObjectUtils.encode("emitter",_loc2_);
            for each(_loc4_ in _loc2_.particales)
            {
               _loc5_ = ObjectUtils.encode("particle",_loc4_);
               _loc5_.appendChild(encodeXLine("vLine",_loc4_.lifeEasing.vLine));
               _loc5_.appendChild(encodeXLine("rvLine",_loc4_.lifeEasing.rvLine));
               _loc5_.appendChild(encodeXLine("spLine",_loc4_.lifeEasing.spLine));
               _loc5_.appendChild(encodeXLine("sizeLine",_loc4_.lifeEasing.sizeLine));
               _loc5_.appendChild(encodeXLine("weightLine",_loc4_.lifeEasing.weightLine));
               _loc5_.appendChild(encodeXLine("alphaLine",_loc4_.lifeEasing.alphaLine));
               if(_loc4_.lifeEasing.colorLine)
               {
                  _loc5_.appendChild(encodeXLine("colorLine",_loc4_.lifeEasing.colorLine));
               }
               _loc3_.appendChild(_loc5_);
            }
            _loc1_.appendChild(_loc3_);
         }
         return _loc1_;
      }
      
      private static function encodeXLine(param1:String, param2:XLine) : XML
      {
         return new XML("<easing name=\"" + param1 + "\" value=\"" + XLine.ToString(param2.line) + "\" />");
      }
   }
}
