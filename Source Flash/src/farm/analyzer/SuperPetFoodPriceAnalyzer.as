package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.modelx.SuperPetFoodPriceInfo;
   
   public class SuperPetFoodPriceAnalyzer extends DataAnalyzer
   {
      
      public static const Path:String = "PetExpItemPrice.xml";
       
      
      public var list:Vector.<SuperPetFoodPriceInfo>;
      
      public function SuperPetFoodPriceAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc5_:XML = null;
         var _loc6_:SuperPetFoodPriceInfo = null;
         var _loc2_:XML = XML(param1);
         var _loc3_:XMLList = _loc2_..Item;
         this.list = new Vector.<SuperPetFoodPriceInfo>();
         for each(_loc5_ in _loc3_)
         {
            _loc6_ = new SuperPetFoodPriceInfo();
            ObjectUtils.copyPorpertiesByXML(_loc6_,_loc5_);
            this.list.push(_loc6_);
         }
         onAnalyzeComplete();
      }
   }
}
