package ddt.data
{
   import ddt.data.analyze.PetExpericenceAnalyze;
   
   public class PetExperience
   {
      
      public static var expericence:Array;
      
      public static var MAX_LEVEL:int = 0;
       
      
      public function PetExperience()
      {
         super();
      }
      
      public static function setup(param1:PetExpericenceAnalyze) : void
      {
         expericence = param1.expericence;
         expericence.sort(Array.NUMERIC);
         MAX_LEVEL = param1.expericence.length;
      }
      
      public static function getExpMax(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < expericence.length)
         {
            if(expericence[_loc2_] > param1)
            {
               return expericence[_loc2_];
            }
            _loc2_++;
         }
         return expericence[_loc2_];
      }
      
      public static function getLevelByGP(param1:int) : int
      {
         var _loc2_:int = MAX_LEVEL - 1;
         while(_loc2_ > -1)
         {
            if(expericence[_loc2_] <= param1)
            {
               return _loc2_ + 1;
            }
            _loc2_--;
         }
         return 1;
      }
   }
}
