package petsBag.view
{
   import com.pickgliss.ui.controls.NumberSelecter;
   import flash.geom.Point;
   
   public class PetNumberSelecter extends NumberSelecter
   {
       
      
      public function PetNumberSelecter()
      {
         super();
      }
      
      override public function set valueLimit(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         _valueLimit = new Point(_loc2_[0],_loc2_[1]);
         currentValue = _valueLimit.y;
      }
   }
}
