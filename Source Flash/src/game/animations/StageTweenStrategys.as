package game.animations
{
   public class StageTweenStrategys
   {
       
      
      public function StageTweenStrategys()
      {
         super();
      }
      
      public static function getTweenClassNameByShortName(param1:String) : String
      {
         switch(param1)
         {
            case "default":
               return "game.animations.StrDefaultTween";
            case "directly":
               return "game.animations.StrDirectlyTween";
            case "lowSpeedLinear":
               return "game.animations.StrLinearTween";
            case "highSpeedLinear":
               return "game.animations.StrHighSpeedLinearTween";
            case "shockingLinear":
               return "game.animations.StrShockingLinearTween";
            case "stay":
               return "game.animations.StrStayTween";
            default:
               return "game.animations.StrDefaultTween";
         }
      }
   }
}
