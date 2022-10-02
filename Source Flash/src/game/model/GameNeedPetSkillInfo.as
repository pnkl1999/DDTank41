package game.model
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import ddt.manager.PathManager;
   
   public class GameNeedPetSkillInfo
   {
       
      
      private var _pic:String;
      
      private var _effect:String;
      
      public function GameNeedPetSkillInfo()
      {
         super();
      }
      
      public function get pic() : String
      {
         return this._pic;
      }
      
      public function set pic(param1:String) : void
      {
         this._pic = param1;
      }
      
      public function get effect() : String
      {
         return this._effect;
      }
      
      public function set effect(param1:String) : void
      {
         this._effect = param1;
      }
      
      public function get effectClassLink() : String
      {
         return "asset.game.skill.effect." + this.effect;
      }
      
      public function startLoad() : void
      {
         if(!this.effect)
         {
            return;
         }
         LoaderManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(this.effect),BaseLoader.MODULE_LOADER);
      }
   }
}
