package farm.modelx
{
   import ddt.manager.ItemManager;
   import ddt.manager.TimeManager;
   
   public class SimpleLandStateInfo
   {
       
      
      public var id:int;
      
      public var seedId:int;
      
      public var AccelerateDate:int;
      
      public var plantTime:Date;
      
      public var isStolen:Boolean = false;
      
      public function SimpleLandStateInfo()
      {
         super();
      }
      
      public function get hasPlantGrown() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.seedId == 0)
         {
            return false;
         }
         _loc1_ = parseInt(ItemManager.Instance.getTemplateById(this.seedId).Property3);
         _loc2_ = _loc1_ - this.AccelerateDate;
         _loc3_ = (TimeManager.Instance.Now().time - this.plantTime.time) / 60000;
         return _loc3_ >= _loc2_;
      }
   }
}
