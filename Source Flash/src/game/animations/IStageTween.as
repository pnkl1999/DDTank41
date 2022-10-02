package game.animations
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public interface IStageTween
   {
       
      
      function initData(param1:TweenObject) : void;
      
      function update(param1:DisplayObject) : Point;
   }
}
