package character
{
   import flash.geom.Point;
   
   public class CharacterUtils
   {
       
      
      public function CharacterUtils()
      {
         super();
      }
      
      public static function creatFrames(frames:String) : Vector.<int>
      {
         var n:String = null;
         var start:int = 0;
         var end:int = 0;
         var j:int = 0;
         var result:Vector.<int> = new Vector.<int>();
         var fs:Array = frames.split(",");
         for(var i:int = 0; i < fs.length; i++)
         {
            n = fs[i];
            if(n.indexOf("-") > -1)
            {
               start = n.split("-")[0];
               end = n.split("-")[1];
               for(j = start; j <= end; j++)
               {
                  result.push(j);
               }
            }
            else
            {
               result.push(int(n));
            }
         }
         return result;
      }
      
      public static function creatPoints(points:String) : Vector.<Point>
      {
         var n:String = null;
         var p:Point = null;
         var result:Vector.<Point> = new Vector.<Point>();
         var ps:Array = points.split("|");
         for(var i:int = 0; i < ps.length; i++)
         {
            n = ps[i];
            p = new Point(Number(n.split(",")[0]),Number(n.split(",")[1]));
            result.push(p);
         }
         return result;
      }
   }
}
