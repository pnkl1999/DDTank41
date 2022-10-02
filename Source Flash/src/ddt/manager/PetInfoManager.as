package ddt.manager
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetInfoAnalyzer;
   import flash.utils.Dictionary;
   import pet.date.PetInfo;
   import pet.date.PetTemplateInfo;
   
   public class PetInfoManager
   {
      
      private static var _list:Dictionary;
       
      
      public function PetInfoManager()
      {
         super();
      }
      
      public static function setup(param1:PetInfoAnalyzer) : void
      {
         _list = param1.list;
      }
      
      public static function getPetByTemplateID(param1:int) : PetTemplateInfo
      {
         return _list[param1];
      }
      
      public static function fillPetInfo(param1:PetInfo) : void
      {
         var _loc2_:PetTemplateInfo = _list[param1.TemplateID];
         ObjectUtils.copyProperties(param1,_loc2_);
      }
   }
}
