package ddt.view
{
   import com.pickgliss.utils.ClassUtils;
   import flash.display.MovieClip;
   
   public class FaceSource
   {
       
      
      public function FaceSource()
      {
         super();
      }
      
      public static function getFaceById(param1:int) : MovieClip
      {
         if(param1 < 75 && param1 > 0)
         {
            return ClassUtils.CreatInstance("asset.core.expression.Expresion0" + (param1 < 10 ? "0" + String(param1) : String(param1))) as MovieClip;
         }
         return null;
      }
      
      public static function getSFaceById(param1:int) : MovieClip
      {
         if(param1 < 49 && param1 > 0)
         {
            return ClassUtils.CreatInstance("sFace_0" + (param1 < 10 ? "0" + String(param1) : String(param1))) as MovieClip;
         }
         return null;
      }
      
      public static function stringIsFace(param1:String) : int
      {
         if(param1.length != 3 && param1.length != 2 || param1.slice(0,1) != "/")
         {
            return -1;
         }
         var _loc2_:Number = Number(param1.slice(1));
         if(_loc2_ < 49 && _loc2_ > 0)
         {
            return _loc2_;
         }
         return -1;
      }
   }
}
