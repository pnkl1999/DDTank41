package ddt.data
{
   import ddt.data.analyze.ExpericenceAnalyze;
   import ddt.manager.PlayerManager;
   
   public class Experience
   {
      
      public static var expericence:Array;
      
      public static var HP:Array;
      
      public static var MAX_LEVEL:int;
       
      
      public function Experience()
      {
         super();
      }
      
      public static function getExpPercent(param1:int, param2:int) : Number
      {
         if(param1 == MAX_LEVEL)
         {
            return 0;
         }
         if(param1 == 1)
         {
            param2--;
         }
         return (param2 - expericence[param1 - 1]) / (expericence[param1] - expericence[param1 - 1]);
      }
      
      public static function getGrade(param1:Number) : int
      {
         var _loc2_:int = PlayerManager.Instance.Self.Grade;
         var _loc3_:int = 0;
         while(_loc3_ < expericence.length)
         {
            if(param1 >= expericence[MAX_LEVEL - 1])
            {
               _loc2_ = MAX_LEVEL;
               break;
            }
            if(param1 < expericence[_loc3_])
            {
               _loc2_ = _loc3_;
               break;
            }
            if(param1 <= 0)
            {
               _loc2_ = 0;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getBasicHP(param1:int) : int
      {
         if(param1 == MAX_LEVEL)
         {
            return 0;
         }
         return HP[param1 - 1];
      }
      
      public static function setup(param1:ExpericenceAnalyze) : void
      {
         expericence = param1.expericence;
         HP = param1.HP;
         MAX_LEVEL = param1.expericence.length + 1;
      }
   }
}
