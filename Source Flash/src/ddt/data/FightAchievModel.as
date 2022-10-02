package ddt.data
{
   import com.pickgliss.ui.ComponentFactory;
   
   public class FightAchievModel
   {
      
      public static const Achiev1:int = 1;
      
      public static const Achiev2:int = 2;
      
      public static const Achiev3:int = 3;
      
      public static const Achiev4:int = 4;
      
      public static const Achiev5:int = 5;
      
      public static const Achiev6:int = 6;
      
      public static const Achiev7:int = 7;
      
      private static var _ins:FightAchievModel;
       
      
      private var _colors:Array;
      
      public function FightAchievModel()
      {
         super();
      }
      
      public static function getInstance() : FightAchievModel
      {
         if(_ins == null)
         {
            _ins = ComponentFactory.Instance.creatCustomObject("FightAchievModel");
         }
         return _ins;
      }
      
      public function isNumAchiev(param1:int) : Boolean
      {
         switch(param1)
         {
            case Achiev1:
            case Achiev5:
               return true;
            default:
               return false;
         }
      }
      
      public function getAchievColor(param1:int) : int
      {
         if(this._colors && param1 <= this._colors.length)
         {
            return this._colors[param1 - 1];
         }
         return 16711680;
      }
      
      public function set colors(param1:String) : void
      {
         this._colors = param1.split(",");
      }
   }
}
