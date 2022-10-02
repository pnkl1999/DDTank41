package com.pickgliss.utils
{
   import flash.errors.IllegalOperationError;
   import flash.system.ApplicationDomain;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedSuperclassName;
   
   public final class ClassUtils
   {
      
      public static const INNERRECTANGLE:String = "com.pickgliss.geom.InnerRectangle";
      
      public static const OUTTERRECPOS:String = "com.pickgliss.geom.OuterRectPos";
      
      public static const RECTANGLE:String = "flash.geom.Rectangle";
      
      public static const COLOR_MATIX_FILTER:String = "flash.filters.ColorMatrixFilter";
      
      private static var _appDomain:ApplicationDomain;
       
      
      public function ClassUtils()
      {
         super();
      }
      
      public static function CreatInstance(param1:String, param2:Array = null) : *
      {
         var _loc4_:Object = null;
         var _loc3_:Object = getDefinitionByName(param1);
         if(_loc3_ == null)
         {
            throw new IllegalOperationError("can\'t find the class of\"" + param1 + "\"in current domain");
         }
         if(param2 == null || param2.length == 0)
         {
            _loc4_ = new _loc3_();
         }
         else if(param2.length == 1)
         {
            _loc4_ = new _loc3_(param2[0]);
         }
         else if(param2.length == 2)
         {
            _loc4_ = new _loc3_(param2[0],param2[1]);
         }
         else if(param2.length == 3)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2]);
         }
         else if(param2.length == 4)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3]);
         }
         else if(param2.length == 5)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3],param2[4]);
         }
         else if(param2.length == 6)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5]);
         }
         else if(param2.length == 7)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6]);
         }
         else if(param2.length == 8)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7]);
         }
         else if(param2.length == 9)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8]);
         }
         else if(param2.length == 10)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9]);
         }
         else if(param2.length == 11)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10]);
         }
         else if(param2.length == 12)
         {
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10],param2[11]);
         }
         else
         {
            if(param2.length != 13)
            {
               throw new IllegalOperationError("arguments too long");
            }
            _loc4_ = new _loc3_(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10],param2[11],param2[12]);
         }
         return _loc4_;
      }
      
      public static function get uiSourceDomain() : ApplicationDomain
      {
         return _appDomain;
      }
      
      public static function set uiSourceDomain(param1:ApplicationDomain) : void
      {
         _appDomain = param1;
      }
      
      public static function getDefinition(param1:String) : Object
      {
         return getDefinitionByName(param1);
      }
      
      public static function classIsBitmapData(param1:String) : Boolean
      {
         if(!_appDomain.hasDefinition(param1))
         {
            return false;
         }
         var _loc2_:* = getDefinitionByName(param1);
         var _loc3_:String = getQualifiedSuperclassName(_loc2_);
         return _loc3_ == "flash.display::BitmapData";
      }
      
      public static function classIsComponent(param1:String) : Boolean
      {
         if(param1 == "com.pickgliss.ui.text.FilterFrameText" || param1 == "com.pickgliss.ui.controls.SimpleDropListTarget" || param1 == "ddt.view.FriendDropListTarget" || param1 == "com.pickgliss.ui.text.FilterFrameTextWithTips" || param1 == "eliteGame.view.EliteGamePaarungText")
         {
            return false;
         }
         return true;
      }
   }
}
