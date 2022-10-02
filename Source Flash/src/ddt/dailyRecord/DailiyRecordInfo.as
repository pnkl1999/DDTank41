package ddt.dailyRecord
{
   public class DailiyRecordInfo
   {
       
      
      public var index:int;
      
      public var type:int;
      
      public var value:String;
      
      public function DailiyRecordInfo()
      {
         super();
      }
      
      public function get valueList() : Array
      {
         return this.value.split(",");
      }
   }
}
