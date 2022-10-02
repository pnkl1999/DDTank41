package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import pet.date.PetConfigInfo;
   
   public class PetconfigAnalyzer extends DataAnalyzer
   {
      
      public static var PetCofnig:PetConfigInfo = new PetConfigInfo();
       
      
      public function PetconfigAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc2_:XML = XML(param1);
         var _loc3_:XMLList = _loc2_..item;
         for each(_loc4_ in _loc3_)
         {
            ObjectUtils.copyPorpertiesByXML(PetCofnig,_loc4_);
         }
         onAnalyzeComplete();
      }
   }
}
