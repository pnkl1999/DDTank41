package game.animations
{
   import game.objects.GameLiving;
   import game.objects.SimpleBomb;
   import game.view.map.MapView;
   import phy.object.PhysicalObj;
   
   public class BombFocusAnimation extends PhysicalObjFocusAnimation
   {
       
      
      protected var _phy:SimpleBomb;
      
      protected var _owner:GameLiving;
      
      public function BombFocusAnimation(param1:SimpleBomb, param2:int = 100, param3:int = 0, param4:PhysicalObj = null)
      {
         super(param1,param2,param3);
         this._phy = param1;
         _level = AnimationLevel.MIDDLE;
         this._owner = param4 as GameLiving;
      }
      
      override public function update(param1:MapView) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         return super.update(param1);
      }
      
      private function smoothDown(param1:Number, param2:Number, param3:Number) : Number
      {
         param3 = Math.sqrt(param3);
         var _loc4_:Number = (param2 - param1) * param3;
         return param1 + _loc4_;
      }
      
      private function smoothUp(param1:Number, param2:Number, param3:Number) : Number
      {
         param3 *= param3;
         var _loc4_:Number = (param2 - param1) * param3;
         return param1 + _loc4_;
      }
   }
}
