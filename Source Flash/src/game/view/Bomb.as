package game.view
{
   import ddt.data.BallInfo;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import game.objects.ActionType;
   
   public class Bomb extends EventDispatcher
   {
      
      public static const FLY_BOMB:int = 3;
      
      public static const FREEZE_BOMB:int = 1;
       
      
      public var Id:int;
      
      public var X:int;
      
      public var Y:int;
      
      public var VX:int;
      
      public var VY:int;
      
      public var Actions:Array;
      
      public var UsedActions:Array;
      
      public var Template:BallInfo;
      
      public var targetX:Number;
      
      public var targetY:Number;
      
      public var damageMod:Number;
      
      public var changedPartical:String;
      
      private var i:int = 0;
      
      public var number:int;
      
      public var shootCount:int;
      
      public var IsHole:Boolean;
      
      public function Bomb()
      {
         this.Actions = new Array();
         this.UsedActions = new Array();
         super();
      }
      
      private function checkFly(param1:Array, param2:Array) : Boolean
      {
         if(int(param1[0]) != int(param2[0]))
         {
            return true;
         }
         return false;
      }
      
      public function get target() : Point
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.Actions.length)
         {
            if(this.Actions[_loc1_].type == ActionType.BOMB)
            {
               return new Point(this.Actions[_loc1_].param1,this.Actions[_loc1_].param2);
            }
            if(this.Actions[_loc1_].type == ActionType.FLY_OUT)
            {
               return new Point(this.Actions[_loc1_].param1,this.Actions[_loc1_].param2);
            }
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.UsedActions.length)
         {
            if(this.UsedActions[_loc2_].type == ActionType.BOMB)
            {
               return new Point(this.UsedActions[_loc2_].param1,this.UsedActions[_loc2_].param2);
            }
            if(this.UsedActions[_loc2_].type == ActionType.FLY_OUT)
            {
               return new Point(this.UsedActions[_loc2_].param1,this.UsedActions[_loc2_].param2);
            }
            _loc2_++;
         }
         return null;
      }
      
      public function get isCritical() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.Actions.length)
         {
            if(this.Actions[_loc1_].type == ActionType.BOMBED)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
   }
}
