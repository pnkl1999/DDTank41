package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import pet.date.PetSkillTemplateInfo;
   
   public class PetSkillAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Dictionary;
      
      public function PetSkillAnalyzer(param1:Function)
      {
         this.list = new Dictionary();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc5_:PetSkillTemplateInfo = null;
         var _loc2_:XML = XML(param1);
         var _loc3_:XMLList = _loc2_..item;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new PetSkillTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(_loc5_,_loc4_);
            this.list[_loc5_.ID] = _loc5_;
         }
         onAnalyzeComplete();
      }
   }
}
