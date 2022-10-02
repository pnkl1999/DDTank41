package game.gametrainer.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.manager.PlayerManager;
   import flash.display.MovieClip;
   import phy.object.PhysicalObj;
   
   public class TrainerEquip extends PhysicalObj
   {
       
      
      private var _equip:MovieClip;
      
      public function TrainerEquip(param1:int, param2:int = 1, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 1)
      {
         super(param1,param2,param3,param4,param5,param6);
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:String = !!PlayerManager.Instance.Self.Sex ? "asset.trainer.TrainerManEquipAsset" : "asset.trainer.TrainerWomanEquipAsset";
         this._equip = ComponentFactory.Instance.creat(_loc1_);
         addChild(this._equip);
      }
      
      override public function dispose() : void
      {
         if(this._equip && this._equip.parent)
         {
            this._equip.parent.removeChild(this._equip);
         }
         this._equip = null;
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
