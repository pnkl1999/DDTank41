package par
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class ShapeManager
   {
      
      public static var list:Array = [];
      
      private static var _ready:Boolean;
      
      private static var objects:Dictionary = new Dictionary();
       
      
      public function ShapeManager()
      {
         super();
      }
      
      public static function get ready() : Boolean
      {
         return _ready;
      }
      
      public static function clear() : void
      {
         list = [];
         _ready = false;
         objects = new Dictionary();
      }
      
      public static function setup() : void
      {
         var cls:Object = null;
         try
         {
            cls = ParticleManager.Domain.getDefinition("ParticalShapLib");
            if(cls["data"])
            {
               list = cls["data"];
               _ready = true;
            }
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      public static function create(param1:uint) : DisplayObject
      {
         var _loc2_:Sprite = null;
         var _loc3_:Class = null;
         if(param1 < 0 || param1 >= list.length)
         {
            _loc2_ = new Sprite();
            _loc2_.graphics.beginFill(0);
            _loc2_.graphics.drawCircle(0,0,10);
            _loc2_.graphics.endFill();
            return _loc2_;
         }
         _loc3_ = list[param1]["data"];
         return creatShape(_loc3_);
      }
      
      private static function creatShape(param1:*) : DisplayObject
      {
         var _loc2_:String = null;
         if(param1 is String)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = getQualifiedClassName(param1);
         }
         if(objects[_loc2_] == null)
         {
            objects[_loc2_] = new Vector.<DisplayObject>();
         }
         var _loc3_:Vector.<DisplayObject> = objects[_loc2_];
         return getFreeObject(_loc3_,_loc2_);
      }
      
      private static function getFreeObject(param1:Vector.<DisplayObject>, param2:String) : DisplayObject
      {
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].parent == null)
            {
               return param1[_loc4_];
            }
            _loc4_++;
         }
         var _loc5_:Class = ParticleManager.Domain.getDefinition(param2) as Class;
         var _loc6_:* = new _loc5_();
         param1.push(_loc6_);
         return _loc6_;
      }
   }
}
