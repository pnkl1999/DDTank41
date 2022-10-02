package ddt.view.sceneCharacter
{
   import flash.geom.Point;
   
   public class SceneCharacterDirection
   {
      
      public static const RT:SceneCharacterDirection = new SceneCharacterDirection("RT",false);
      
      public static const LT:SceneCharacterDirection = new SceneCharacterDirection("LT",true);
      
      public static const RB:SceneCharacterDirection = new SceneCharacterDirection("RB",true);
      
      public static const LB:SceneCharacterDirection = new SceneCharacterDirection("LB",false);
       
      
      private var _isMirror:Boolean;
      
      private var _type:String;
      
      public function SceneCharacterDirection(param1:String, param2:Boolean)
      {
         super();
         this._type = param1;
         this._isMirror = param2;
      }
      
      public static function getDirection(param1:Point, param2:Point) : SceneCharacterDirection
      {
         var _loc3_:Number = getDegrees(param1,param2);
         if(_loc3_ >= 0 && _loc3_ < 90)
         {
            return SceneCharacterDirection.RT;
         }
         if(_loc3_ >= 90 && _loc3_ < 180)
         {
            return SceneCharacterDirection.LT;
         }
         if(_loc3_ >= 180 && _loc3_ < 270)
         {
            return SceneCharacterDirection.LB;
         }
         if(_loc3_ >= 270 && _loc3_ < 360)
         {
            return SceneCharacterDirection.RB;
         }
         return SceneCharacterDirection.RB;
      }
      
      private static function getDegrees(param1:Point, param2:Point) : Number
      {
         var _loc3_:Number = Math.atan2(param1.y - param2.y,param2.x - param1.x) * 180 / Math.PI;
         if(_loc3_ < 0)
         {
            _loc3_ += 360;
         }
         return _loc3_;
      }
      
      public function get isMirror() : Boolean
      {
         return this._isMirror;
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}
