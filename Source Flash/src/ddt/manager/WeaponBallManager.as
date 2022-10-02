package ddt.manager
{
   import ddt.data.analyze.WeaponBallInfoAnalyze;
   import flash.utils.Dictionary;
   
   public class WeaponBallManager
   {
      
      private static var bobms:Dictionary;
       
      
      public function WeaponBallManager()
      {
         super();
      }
      
      public static function setup(param1:WeaponBallInfoAnalyze) : void
      {
         bobms = param1.bombs;
      }
      
      public static function getWeaponBallInfo(param1:int) : Array
      {
         return bobms[param1];
      }
   }
}
