package consortion.data
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   
   public class ConsortionSkillInfo
   {
       
      
      public var id:int;
      
      public var type:int;
      
      public var descript:String;
      
      public var value:int;
      
      public var level:int;
      
      public var riches:int;
      
      public var name:String;
      
      public var pic:int;
      
      public var group:int;
      
      public var metal:int;
      
      public var isOpen:Boolean;
      
      public var beginDate:Date;
      
      public var validDate:int;
      
      public function ConsortionSkillInfo()
      {
         super();
      }
      
      public function get validity() : String
      {
         var _loc1_:int = TimeManager.Instance.TotalDaysToNow(this.beginDate);
         var _loc2_:int = this.validDate - _loc1_;
         if(_loc2_ <= 1)
         {
            _loc2_ = this.validDate * 24 - TimeManager.Instance.TotalHoursToNow(this.beginDate);
            if(_loc2_ < 1)
            {
               return int(this.validDate * 24 * 60 - TimeManager.Instance.TotalMinuteToNow(this.beginDate)) + LanguageMgr.GetTranslation("minute");
            }
            return int(this.validDate * 24 - TimeManager.Instance.TotalHoursToNow(this.beginDate)) + LanguageMgr.GetTranslation("hours");
         }
         return _loc2_ + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
      }
   }
}
