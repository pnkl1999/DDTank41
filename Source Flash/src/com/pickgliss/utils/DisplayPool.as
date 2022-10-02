package com.pickgliss.utils
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class DisplayPool
   {
      
      private static var _instance:DisplayPool;
       
      
      private var _objects:Dictionary;
      
      public function DisplayPool()
      {
         super();
         this._objects = new Dictionary();
      }
      
      public static function get Instance() : DisplayPool
      {
         if(_instance == null)
         {
            _instance = new DisplayPool();
         }
         return _instance;
      }
      
      public function clearAll() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this._objects)
         {
            if(this._objects[_loc1_])
            {
               while(this._objects[_loc1_].length > 0)
               {
                  ObjectUtils.disposeObject(this._objects[_loc1_].shift());
               }
            }
            delete this._objects[_loc1_];
         }
      }
      
      public function creat(param1:*) : DisplayObject
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
         if(this._objects[_loc2_] == null)
         {
            this._objects[_loc2_] = new Vector.<DisplayObject>();
         }
         var _loc3_:Vector.<DisplayObject> = this._objects[_loc2_];
         return this.getFreeObject(_loc3_,_loc2_);
      }
      
      private function getFreeObject(param1:Vector.<DisplayObject>, param2:String) : DisplayObject
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
         var _loc5_:Class = getDefinitionByName(param2) as Class;
         var _loc6_:* = new _loc5_();
         param1.push(_loc6_);
         return _loc6_;
      }
   }
}
