package ddt.events
{
   import road7th.comm.PackageIn;
   
   public class PkgEvent extends CrazyTankSocketEvent
   {
       
      
      public function PkgEvent(param1:String, param2:PackageIn)
      {
         super(param1,param2);
      }
      
      public static function format(... rest) : String
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < rest.length)
         {
            _loc3_.push(rest[_loc2_].toString(16));
            _loc2_++;
         }
         return _loc3_.join("+");
      }
   }
}
