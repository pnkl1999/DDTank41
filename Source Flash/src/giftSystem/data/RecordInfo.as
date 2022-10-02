package giftSystem.data
{
   public class RecordInfo
   {
       
      
      public var giftCount:int = 0;
      
      public var recordList:Vector.<RecordItemInfo>;
      
      public function RecordInfo()
      {
         this.recordList = new Vector.<RecordItemInfo>();
         super();
      }
   }
}
