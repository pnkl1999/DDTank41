package ddt.data
{
   import com.pickgliss.loader.ModuleLoader;
   import ddt.manager.LanguageMgr;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Living;
   
   public class FightBuffInfo
   {
      
      public static const DEFUALT_EFFECT:String = "asset.game.AttackEffect2";
       
      
      public var id:int;
      
      public var displayid:int = 0;
      
      public var type:int;
      
      private var _sigh:int = -1;
      
      public var buffPic:String = "";
      
      public var buffEffect:String = "";
      
      public var buffName:String = "FightBuffInfo";
      
      public var name:String = "FightBuffInfo";
      
      public var description:String = "unkown buff";
      
      public var priority:Number = 0.0;
      
      private var _data:int;
      
      private var _level:int;
      
      public var Count:int = 1;
      
      public var isSelf:Boolean;
      
      public function FightBuffInfo(param1:int)
      {
         super();
         this.id = param1;
         this.name = LanguageMgr.GetTranslation("tank.game.BuffName" + this.id);
      }
      
      public function get data() : int
      {
         return this._data;
      }
      
      public function set data(param1:int) : void
      {
         var _loc2_:GameInfo = null;
         this._data = param1;
         this.description = LanguageMgr.GetTranslation("tank.game.BuffTip" + this.id,this._data);
         if(this.id == 243 || this.id == 244 || this.id == 245 || this.id == 246)
         {
            _loc2_ = GameManager.Instance.Current;
            if(_loc2_.mapIndex == 1214 || _loc2_.mapIndex == 1215 || _loc2_.mapIndex == 1216 || _loc2_.mapIndex == 1217)
            {
               this.description = LanguageMgr.GetTranslation("tank.game.BuffTip" + this.id + "1",this._data);
            }
         }
      }
      
      public function execute(param1:Living) : void
      {
         if(this.type == BuffType.PET_BUFF)
         {
            if(this.buffEffect)
            {
               if(ModuleLoader.hasDefinition("asset.game.skill.effect." + this.buffEffect))
               {
                  param1.showBuffEffect("asset.game.skill.effect." + this.buffEffect,this.id);
               }
               else
               {
                  param1.showBuffEffect(DEFUALT_EFFECT,this.id);
               }
            }
         }
         else
         {
            switch(this.id)
            {
               case BuffType.LockAngel:
                  param1.isLockAngle = true;
            }
         }
      }
      
      public function unExecute(param1:Living) : void
      {
         if(this.type == BuffType.PET_BUFF)
         {
            if(this.buffEffect)
            {
               param1.removeBuffEffect(this.id);
            }
         }
         else
         {
            switch(this.id)
            {
               case BuffType.LockAngel:
                  param1.isLockAngle = false;
            }
         }
      }
   }
}
