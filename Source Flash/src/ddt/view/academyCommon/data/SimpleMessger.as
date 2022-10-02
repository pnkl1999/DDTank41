package ddt.view.academyCommon.data
{
   public class SimpleMessger
   {
      
      public static const ANSWER_MASTER:int = 0;
      
      public static const ANSWER_APPRENTICE:int = 1;
       
      
      public var id:int;
      
      public var name:String;
      
      public var messger:String;
      
      public var type:int;
      
      public function SimpleMessger(param1:int, param2:String, param3:String, param4:int)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.messger = param3;
         this.type = param4;
      }
   }
}
