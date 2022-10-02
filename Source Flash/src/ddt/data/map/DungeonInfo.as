package ddt.data.map
{
   public class DungeonInfo
   {
      
      public static const EASY:int = 0;
      
      public static const NORMAL:int = 1;
      
      public static const HARD:int = 2;
      
      public static const HERO:int = 3;
       
      
      public var ID:int;
      
      public var Description:String;
      
      public var SimpleTemplateIds:String;
      
      public var NormalTemplateIds:String;
      
      public var HardTemplateIds:String;
      
      public var TerrorTemplateIds:String;
      
      public var Pic:String;
      
      public var Name:String;
      
      public var AdviceTips:String;
      
      public var LevelLimits:int;
      
      public var isOpen:Boolean = true;
      
      public var BossFightNeedMoney:String;
      
      public var Ordering:int;
      
      public var Type:int;
      
      public function DungeonInfo()
      {
         super();
      }
   }
}
