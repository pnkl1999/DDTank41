package ddt.manager
{
   import consortion.data.BadgeInfo;
   import ddt.data.analyze.BadgeInfoAnalyzer;
   import flash.utils.Dictionary;
   
   public class BadgeInfoManager
   {
      
      private static var _instance:BadgeInfoManager;
       
      
      private var _badgeList:Dictionary;
      
      public function BadgeInfoManager()
      {
         super();
         this._badgeList = new Dictionary();
      }
      
      public static function get instance() : BadgeInfoManager
      {
         if(_instance == null)
         {
            _instance = new BadgeInfoManager();
         }
         return _instance;
      }
      
      public function setup(param1:BadgeInfoAnalyzer) : void
      {
         this._badgeList = param1.list;
      }
      
      public function getBadgeInfoByID(param1:int) : BadgeInfo
      {
         return this._badgeList[param1];
      }
      
      public function getBadgeInfoByLevel(param1:int, param2:int) : Array
      {
         var _loc4_:BadgeInfo = null;
         var _loc3_:Array = [];
         for each(_loc4_ in this._badgeList)
         {
            if(_loc4_.LimitLevel >= param1 && _loc4_.LimitLevel <= param2)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
   }
}
