package game.model
{
   import ddt.events.LivingEvent;
   
   [Event(name="modelChanged",type="tank.events.LivingEvent")]
   public class SmallEnemy extends Living
   {
       
      
      private var _modelID:int;
      
      public function SmallEnemy(param1:int, param2:int, param3:int)
      {
         super(param1,param2,param3);
      }
      
      public function set modelID(param1:int) : void
      {
         var _loc2_:int = this._modelID;
         this._modelID = param1;
         dispatchEvent(new LivingEvent(LivingEvent.MODEL_CHANGED,this._modelID,_loc2_));
      }
      
      public function get modelID() : int
      {
         return this._modelID;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
