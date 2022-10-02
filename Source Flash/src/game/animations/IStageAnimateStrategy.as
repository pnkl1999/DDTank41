package game.animations
{
   import flash.geom.Point;
   
   public interface IStageAnimateStrategy
   {
       
      
      function get currentOffset() : Point;
      
      function get life() : uint;
   }
}
