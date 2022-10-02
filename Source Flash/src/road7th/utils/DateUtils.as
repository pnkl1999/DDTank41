package road7th.utils
{
   public class DateUtils
   {
       
      
      public function DateUtils()
      {
         super();
      }
      
      public static function getDateByStr(param1:String) : Date
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(param1)
         {
            _loc2_ = param1.split(" ");
            if(_loc2_[0].indexOf("/") > 0)
            {
               _loc3_ = _loc2_[0].split("/");
               _loc4_ = _loc3_[2];
               _loc5_ = _loc3_[0] - 1;
               _loc6_ = _loc3_[1];
            }
            else
            {
               _loc3_ = _loc2_[0].split("-");
               _loc4_ = _loc3_[0];
               _loc5_ = _loc3_[1] - 1;
               _loc6_ = _loc3_[2];
            }
            _loc7_ = _loc2_[1].split(":");
            _loc8_ = _loc7_[0];
            _loc9_ = _loc7_[1];
            _loc10_ = _loc7_[2];
            return new Date(_loc4_,_loc5_,_loc6_,_loc8_,_loc9_,_loc10_);
         }
         return new Date(0);
      }
      
      public static function getHourDifference(param1:Number, param2:Number) : int
      {
         return Math.floor((param2 - param1) / 3600000);
      }
      
      public static function getDays(param1:int, param2:int) : int
      {
         var _loc3_:Date = new Date(param1,param2);
         return _loc3_.getUTCDate();
      }
      
      public static function decodeDated(param1:String) : Date
      {
         var _loc2_:Array = param1.split("T");
         var _loc3_:Array = _loc2_[0].split("-");
         var _loc4_:Array = _loc2_[1].split(":");
         return new Date(_loc3_[0],_loc3_[1] - 1,_loc3_[2],_loc4_[0],_loc4_[1],_loc4_[2]);
      }
      
      public static function encodeDated(param1:Date) : String
      {
         var _loc3_:String = param1.fullYear.toString();
         var _loc4_:String = param1.month + 1 < 10 ? "0" + param1.month + 1 : (param1.month + 1).toString();
         var _loc5_:String = param1.date < 10 ? "0" + param1.date : param1.date.toString();
         var _loc6_:String = param1.hours < 10 ? "0" + param1.hours : param1.hours.toString();
         var _loc7_:String = param1.minutes < 10 ? "0" + param1.minutes : param1.minutes.toString();
         var _loc8_:String = param1.seconds < 10 ? "0" + param1.seconds : param1.seconds.toString();
         return _loc3_ + "-" + _loc4_ + "-" + _loc5_ + "T" + _loc6_ + ":" + _loc7_ + ":" + _loc8_;
      }
      
      public static function isToday(param1:Date) : Boolean
      {
         var _loc2_:Date = new Date();
         return param1.getDate() == _loc2_.getDate() && param1.getMonth() == _loc2_.getMonth() && param1.getFullYear() == _loc2_.getFullYear();
      }
      
      public static function dealWithStringDate(param1:String) : Date
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1.indexOf("-") > 0)
         {
            _loc2_ = parseInt(param1.split(" ")[1].split(":")[0]);
            _loc6_ = parseInt(param1.split(" ")[1].split(":")[1]);
            _loc3_ = parseInt(param1.split(" ")[0].split("-")[2]);
            _loc4_ = parseInt(param1.split(" ")[0].split("-")[1]) - 1;
            _loc5_ = parseInt(param1.split(" ")[0].split("-")[0]);
         }
         if(param1.indexOf("/") > 0)
         {
            if(param1.indexOf("PM") > 0)
            {
               _loc2_ = parseInt(param1.split(" ")[1].split(":")[0]) + 12;
            }
            else
            {
               _loc2_ = parseInt(param1.split(" ")[1].split(":")[0]);
            }
            _loc6_ = parseInt(param1.split(" ")[1].split(":")[1]);
            _loc3_ = parseInt(param1.split(" ")[0].split("/")[1]);
            _loc4_ = parseInt(param1.split(" ")[0].split("/")[0]) - 1;
            _loc5_ = parseInt(param1.split(" ")[0].split("/")[2]);
         }
         return new Date(_loc5_,_loc4_,_loc3_,_loc2_,_loc6_);
      }
      
      public static function dateFormat(param1:Date) : String
      {
         var _loc3_:String = param1.fullYear.toString();
         var _loc4_:String = param1.month + 1 < 10 ? "0" + (param1.month + 1) : (param1.month + 1).toString();
         var _loc5_:String = param1.date < 10 ? "0" + param1.date : param1.date.toString();
         var _loc6_:String = param1.hours < 10 ? "0" + param1.hours : param1.hours.toString();
         var _loc7_:String = param1.minutes < 10 ? "0" + param1.minutes : param1.minutes.toString();
         var _loc8_:String = param1.seconds < 10 ? "0" + param1.seconds : param1.seconds.toString();
         return _loc3_ + "-" + _loc4_ + "-" + _loc5_ + " " + _loc6_ + ":" + _loc7_ + ":" + _loc8_;
      }
   }
}
