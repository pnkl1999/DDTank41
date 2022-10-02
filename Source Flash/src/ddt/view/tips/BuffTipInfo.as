package ddt.view.tips
{
   import ddt.data.BuffInfo;
   
   public class BuffTipInfo
   {
       
      
      public var isActive:Boolean;
      
      public var isFree:Boolean;
      
      public var name:String;
      
      public var describe:String;
      
      public var day:int;
      
      public var hour:int;
      
      public var min:int;
      
      public var linkBuffs:Vector.<BuffInfo>;
      
      public function BuffTipInfo()
      {
         super();
      }
   }
}
