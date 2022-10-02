package room.model
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.WeaponBallManager;
   
   public class WeaponInfo
   {
      
      public static var ROTATITON_SPEED:Number = 1;
       
      
      private var _info:ItemTemplateInfo;
      
      public var armMaxAngle:Number = 90;
      
      public var armMinAngle:Number = 50;
      
      public var commonBall:int;
      
      public var skillBall:int;
      
      public var skill:int = -1;
      
      public var actionType:int;
      
      public var specialSkillMovie:int;
      
      public var refineryLevel:int;
      
      public var bombs:Array;
      
      public function WeaponInfo(param1:ItemTemplateInfo)
      {
         super();
         this._info = param1;
         this.armMinAngle = Number(param1.Property5);
         this.armMaxAngle = Number(param1.Property6);
         this.commonBall = Number(param1.Property1);
         this.skillBall = Number(param1.Property2);
         this.actionType = Number(param1.Property3);
         this.skill = int(param1.Property4);
         this.bombs = WeaponBallManager.getWeaponBallInfo(param1.TemplateID);
         if(this.bombs && this.bombs[0])
         {
            this.commonBall = this.bombs[0];
         }
         this.refineryLevel = int(param1.RefineryLevel);
      }
      
      public function get TemplateID() : int
      {
         return this._info.TemplateID;
      }
      
      public function dispose() : void
      {
         this._info = null;
      }
   }
}
