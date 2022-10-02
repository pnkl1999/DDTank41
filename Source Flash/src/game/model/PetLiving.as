package game.model
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.utils.StringUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.PetSkillManager;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   
   public class PetLiving extends Living
   {
       
      
      private var _petinfo:PetInfo;
      
      private var _master:Player;
      
      private var _usedSkill:Array;
      
      private var _mp:int;
      
      private var _maxMp:int;
      
      public function PetLiving(param1:PetInfo, param2:Player, param3:int, param4:int, param5:int)
      {
         super(-1,param4,param5);
         this._petinfo = param1;
         this._master = param2;
         this._mp = 0;
         this._maxMp = param1.MP;
         this._usedSkill = [];
      }
      
      public function get skills() : Array
      {
         return this._petinfo.skills;
      }
      
      public function get equipedSkillIDs() : Array
      {
         return this._petinfo.equipdSkills.list;
      }
      
      public function get master() : Player
      {
         return this._master;
      }
      
      override public function get name() : String
      {
         return this._petinfo.Name;
      }
      
      override public function get actionMovieName() : String
      {
         return "pet.asset.game." + StringUtils.trim(this._petinfo.GameAssetUrl);
      }
      
      public function get assetUrl() : String
      {
         return StringUtils.trim(this._petinfo.GameAssetUrl);
      }
      
      public function get assetReady() : Boolean
      {
         return ModuleLoader.hasDefinition(this.actionMovieName);
      }
      
      public function get MP() : int
      {
         return this._mp;
      }
      
      public function set MP(param1:int) : void
      {
         if(this._mp == param1)
         {
            return;
         }
         this._mp = param1;
         dispatchEvent(new LivingEvent(LivingEvent.PET_MP_CHANGE));
      }
      
      public function set MaxMP(param1:int) : void
      {
         this._maxMp = param1;
      }
      
      public function get MaxMP() : int
      {
         return this._maxMp;
      }
      
      public function get livingPetInfo() : PetInfo
      {
         return this._petinfo;
      }
      
      public function useSkill(param1:int, param2:Boolean) : void
      {
         var _loc3_:PetSkillTemplateInfo = PetSkillManager.getSkillByID(param1);
         if(_loc3_ && param2)
         {
            this.MP -= _loc3_.CostMP;
         }
         dispatchEvent(new LivingEvent(LivingEvent.USE_PET_SKILL,param1,0,param2));
      }
   }
}
