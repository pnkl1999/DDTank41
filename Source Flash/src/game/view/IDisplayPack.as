package game.view
{
   import flash.display.DisplayObject;
   
   public interface IDisplayPack
   {
       
      
      function get content() : Vector.<DisplayObject>;
      
      function removeFromParent() : void;
      
      function dispose() : void;
   }
}
