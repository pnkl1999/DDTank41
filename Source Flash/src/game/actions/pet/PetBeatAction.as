package game.actions.pet
{
   import flash.geom.Point;
   import game.actions.BaseAction;
   import game.model.Living;
   import game.model.Player;
   import game.objects.GamePet;
   import game.objects.GamePlayer;
   
   public class PetBeatAction extends BaseAction
   {
       
      
      private var _pet:GamePet;
      
      private var _act:String;
      
      private var _pt:Point;
      
      private var _targets:Array;
      
      private var _master:GamePlayer;
      
      private var _updated:Boolean = false;
      
      public function PetBeatAction(param1:GamePet, param2:GamePlayer, param3:String, param4:Point, param5:Array)
      {
         this._pet = param1;
         this._act = param3;
         this._pt = param4;
         this._targets = param5;
         this._master = param2;
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
         if(this._pet == null || this._pet.info == null)
         {
            this.finish();
            return;
         }
         this._pet.show();
         this._pet.info.pos = this._pt;
         this._pet.map.setCenter(this._pt.x,this._pt.y,true);
         this._pet.map.bringToFront(this._pet.info);
         this._pet.actionMovie.doAction(this._act,this.updateHp);
      }
      
      private function updateHp() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Living = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._pet == null || this._pet.info == null || this._master == null || this._master.info == null)
         {
            this.finish();
            return;
         }
         if(!this._updated)
         {
            for each(_loc1_ in this._targets)
            {
               _loc2_ = _loc1_.target;
               _loc3_ = _loc1_.hp;
               _loc4_ = _loc1_.dam;
               _loc5_ = _loc1_.dander;
               _loc2_.updateBlood(_loc3_,3,_loc4_);
               if(_loc2_ is Player)
               {
                  Player(_loc2_).dander = _loc5_;
               }
            }
            this._updated = true;
            _isFinished = true;
            if(this._pet)
            {
               this._pet.hide();
            }
         }
      }
      
      override public function cancel() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Living = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._pet == null || this._pet.info == null || this._master == null || this._master.info == null)
         {
            this.finish();
            return;
         }
         if(!this._updated)
         {
            for each(_loc1_ in this._targets)
            {
               _loc2_ = _loc1_.target;
               _loc3_ = _loc1_.hp;
               _loc4_ = _loc1_.dam;
               _loc5_ = _loc1_.dander;
               _loc2_.updateBlood(_loc3_,3,_loc4_);
               if(_loc2_ is Player)
               {
                  Player(_loc2_).dander = _loc5_;
               }
            }
            this._pet.info.pos = this._master.info.pos;
            this._updated = true;
         }
      }
      
      private function finish() : void
      {
         this._pet = null;
         this._targets = null;
         this._master = null;
         _isFinished = true;
      }
      
      override public function executeAtOnce() : void
      {
         this.cancel();
      }
      
      override public function execute() : void
      {
         if(this._pet == null || this._pet.info == null || this._master == null || this._master.info == null)
         {
            this.finish();
            return;
         }
         if(this._updated && Point.distance(this._pet.info.pos,this._master.info.pos) < 1)
         {
            this.finish();
         }
      }
   }
}
