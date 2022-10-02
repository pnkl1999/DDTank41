package ddt.manager
{
   public class DataRecordManager
   {
      
      private static var instance:DataRecordManager;
       
      
      public function DataRecordManager()
      {
         super();
      }
      
      public static function getInstance() : DataRecordManager
      {
         if(instance == null)
         {
            instance = new DataRecordManager();
         }
         return instance;
      }
      
      public function recordClick(param1:int) : void
      {
      }
   }
}
