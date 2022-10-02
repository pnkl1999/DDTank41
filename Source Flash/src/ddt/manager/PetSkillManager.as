package ddt.manager
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetSkillAnalyzer;
   import flash.utils.Dictionary;
   import pet.date.PetSkill;
   import pet.date.PetSkillTemplateInfo;
   
   public class PetSkillManager
   {
      
      private static var _skills:Dictionary;
       
      
      public function PetSkillManager()
      {
         super();
      }
      
      public static function setup(param1:PetSkillAnalyzer) : void
      {
         _skills = param1.list;
      }
      
      public static function getSkillByID(param1:int) : PetSkillTemplateInfo
      {
         return _skills[param1];
      }
      
      public static function fillPetSkill(param1:PetSkill) : void
      {
         var _loc2_:PetSkillTemplateInfo = getSkillByID(param1.ID);
         if(_loc2_)
         {
            ObjectUtils.copyProperties(param1,_loc2_);
         }
      }
   }
}
