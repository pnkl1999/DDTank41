package game.actions
{
   import game.objects.GamePlayer;
   import game.objects.SimpleBox;
   import phy.object.PhysicalObj;
   
   public class PickBoxAction
   {
       
      
      public var executed:Boolean = false;
      
      private var _time:int;
      
      private var _boxid:int;
      
      public function PickBoxAction(param1:int, param2:int)
      {
         super();
         this._time = param2;
         this._boxid = param1;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function execute(param1:GamePlayer) : void
      {
         this.executed = true;
         var _loc2_:PhysicalObj = param1.map.getPhysical(this._boxid);
         if(_loc2_ is SimpleBox)
         {
            SimpleBox(_loc2_).pickByLiving(param1.info);
         }
      }
   }
}
