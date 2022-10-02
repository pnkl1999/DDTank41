package ddt.view.character
{
   public class Direction
   {
      
      private static const TOP_PATH:String = "5";
      
      private static const TOP_RIGHT_PATH:String = "8";
      
      private static const RIGHT_PATH:String = "7";
      
      private static const RIGHT_BUTTOM_PATH:String = "6";
      
      private static const BUTTOM_PATH:String = "1";
      
      private static const BUTTOM_LEFT_PATH:String = "2";
      
      private static const LEFT_PATH:String = "3";
      
      private static const LEFT_TOP_PATH:String = "4";
      
      public static const TOP:Direction = new Direction(5,"Direction:TOP");
      
      public static const TOP_RIGHT:Direction = new Direction(8,"Direction:TOP_RIGHT");
      
      public static const RIGHT:Direction = new Direction(7,"Direction:RIGHT");
      
      public static const RIGHT_BUTTOM:Direction = new Direction(6,"Direction:RIGHT_BUTTOM");
      
      public static const BUTTOM:Direction = new Direction(1,"Direction:BUTTOM");
      
      public static const BUTTOM_LEFT:Direction = new Direction(2,"Direction:BUTTOM_LEFT");
      
      public static const LEFT:Direction = new Direction(3,"Direction:LEFT");
      
      public static const LEFT_TOP:Direction = new Direction(4,"Direction:LEFT_TOP");
       
      
      private var num:int;
      
      private var comment:String;
      
      public function Direction(param1:int, param2:String)
      {
         super();
         this.num = param1;
         this.comment = param2;
      }
      
      public static function getDirection(param1:String) : Direction
      {
         if(param1.indexOf(TOP_PATH) > -1)
         {
            return TOP;
         }
         if(param1.indexOf(TOP_RIGHT_PATH) > -1)
         {
            return TOP_RIGHT;
         }
         if(param1.indexOf(RIGHT_PATH) > -1)
         {
            return RIGHT;
         }
         if(param1.indexOf(RIGHT_BUTTOM_PATH) > -1)
         {
            return RIGHT_BUTTOM;
         }
         if(param1.indexOf(BUTTOM_PATH) > -1)
         {
            return BUTTOM;
         }
         if(param1.indexOf(BUTTOM_LEFT_PATH) > -1)
         {
            return BUTTOM_LEFT;
         }
         if(param1.indexOf(LEFT_PATH) > -1)
         {
            return LEFT;
         }
         if(param1.indexOf(LEFT_TOP_PATH) > -1)
         {
            return LEFT_TOP;
         }
         return null;
      }
      
      public static function getDirectionFromAngle(param1:Number) : Direction
      {
         if(param1 < 0)
         {
            param1 += Math.PI * 2;
         }
         var _loc2_:Number = param1 / Math.PI * 180;
         if(_loc2_ >= 359 || _loc2_ < 1)
         {
            return RIGHT;
         }
         if(_loc2_ >= 1 && _loc2_ < 89)
         {
            return RIGHT_BUTTOM;
         }
         if(_loc2_ >= 89 && _loc2_ < 91)
         {
            return BUTTOM;
         }
         if(_loc2_ >= 91 && _loc2_ < 179)
         {
            return BUTTOM_LEFT;
         }
         if(_loc2_ >= 179 && _loc2_ < 181)
         {
            return LEFT;
         }
         if(_loc2_ >= 181 && _loc2_ < 269)
         {
            return LEFT_TOP;
         }
         if(_loc2_ >= 269 && _loc2_ < 271)
         {
            return TOP;
         }
         return TOP_RIGHT;
      }
      
      public static function getDirectionByNumber(param1:Number) : Direction
      {
         switch(param1)
         {
            case 1:
               return BUTTOM;
            case 2:
               return BUTTOM_LEFT;
            case 3:
               return LEFT;
            case 4:
               return LEFT_TOP;
            case 5:
               return TOP;
            case 6:
               return RIGHT_BUTTOM;
            case 7:
               return RIGHT;
            default:
               return TOP_RIGHT;
         }
      }
      
      public function getNum() : int
      {
         return this.num;
      }
      
      public function toString() : String
      {
         return this.comment;
      }
      
      public function getHeading() : Number
      {
         switch(this.num)
         {
            case 1:
               return Math.PI / 2;
            case 2:
               return Math.PI * 3 / 4;
            case 3:
               return Math.PI;
            case 4:
               return Math.PI * 5 / 4;
            case 5:
               return Math.PI * 3 / 2;
            case 8:
               return Math.PI * 7 / 4;
            case 7:
               return 0;
            case 6:
               return Math.PI * 1 / 4;
            default:
               return 0;
         }
      }
   }
}
