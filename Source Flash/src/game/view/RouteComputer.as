package game.view
{
   import flash.geom.Point;
   import game.GameManager;
   import phy.maps.Map;
   import phy.object.PhysicalObj;
   
   public class RouteComputer
   {
      
      private static var DELAY_TIME:Number = 0.04;
       
      
      private var _map:Map;
      
      public function RouteComputer(param1:Map)
      {
         super();
         this._map = param1;
      }
      
      public function getPath(param1:int, param2:int) : Array
      {
         var _loc3_:PhysicalObj = null;
         _loc3_ = new PhysicalObj(0,1,10,70,240,1);
         _loc3_.x = GameManager.Instance.Current.selfGamePlayer.pos.x;
         _loc3_.y = GameManager.Instance.Current.selfGamePlayer.pos.y;
         _loc3_.setSpeedXY(new Point(this.getVx(param1,param2),this.getVy(param1,param2)));
         _loc3_.setCollideRect(-3,-3,6,6);
         this._map.addPhysical(_loc3_);
         _loc3_.startMoving();
         var _loc4_:Array = [];
         while(_loc3_.isMoving())
         {
            _loc4_.push(new Point(_loc3_.x,_loc3_.y));
            _loc3_.update(DELAY_TIME);
         }
         return _loc4_;
      }
      
      private function getVx(param1:int, param2:int) : Number
      {
         return Number(param2 * Math.cos(param1 / 180 * Math.PI));
      }
      
      private function getVy(param1:int, param2:int) : Number
      {
         return Number(param2 * Math.sin(param1 / 180 * Math.PI));
      }
   }
}
