package pet.date
{
   import ddt.manager.PetSkillManager;
   
   public class PetSkill extends PetSkillTemplateInfo
   {
       
      
      private var _equiped:Boolean;
      
      public function PetSkill(param1:int)
      {
         super();
         ID = param1;
         PetSkillManager.fillPetSkill(this);
      }
      
      public function get Equiped() : Boolean
      {
         return this._equiped;
      }
      
      public function set Equiped(param1:Boolean) : void
      {
         this._equiped = param1;
      }
   }
}
