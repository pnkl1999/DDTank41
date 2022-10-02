package ddt.utils
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.geom.Point;
   
   public class PositionUtils
   {
       
      
      public function PositionUtils()
      {
         super();
      }
      
      public static function setPos(param1:*, param2:*) : *
      {
         var _loc3_:Point = null;
         if(param2 is String)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject(param2);
            param1.x = _loc3_.x;
            param1.y = _loc3_.y;
         }
         else if(param2 is Object)
         {
            param1.x = param2.x;
            param1.y = param2.y;
         }
         return param1;
      }
      
      public static function creatPoint(param1:String) : Point
      {
         return ComponentFactory.Instance.creatCustomObject(param1);
      }
   }
}
