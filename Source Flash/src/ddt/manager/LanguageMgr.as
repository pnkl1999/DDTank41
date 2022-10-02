package ddt.manager
{
   import ddt.data.analyze.LanguageAnalyzer;
   import flash.utils.Dictionary;
   
   public class LanguageMgr
   {
      
      private static var _dic:Dictionary;
      
      private static var _reg:RegExp = /\{(\d+)\}/;
       
      
      public function LanguageMgr()
      {
         super();
      }
      
      public static function setup(param1:LanguageAnalyzer) : void
      {
         _dic = param1.languages;
      }
      
      public static function GetTranslation(param1:String, ... rest) : String
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc3_:String = !!Boolean(_dic[param1]) ? _dic[param1] : "";
         var _loc4_:Object = _reg.exec(_loc3_);
         while(_loc4_ && rest.length > 0)
         {
            _loc5_ = int(_loc4_[1]);
            _loc6_ = String(rest[_loc5_]);
            if(_loc5_ >= 0 && _loc5_ < rest.length)
            {
               _loc7_ = _loc6_.indexOf("$");
               if(_loc7_ > -1)
               {
                  _loc6_ = _loc6_.slice(0,_loc7_) + "$" + _loc6_.slice(_loc7_);
               }
               _loc3_ = _loc3_.replace(_reg,_loc6_);
            }
            else
            {
               _loc3_ = _loc3_.replace(_reg,"{}");
            }
            _loc4_ = _reg.exec(_loc3_);
         }
         return _loc3_;
      }
   }
}
