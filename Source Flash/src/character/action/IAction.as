package character.action
{
   import flash.display.DisplayObject;
   
   public interface IAction
   {
       
      
      function reset() : void;
      
      function get isEnd() : Boolean;
      
      function get asset() : DisplayObject;
      
      function get priority() : uint;
      
      function get nextAction() : String;
      
      function get name() : String;
      
      function dispose() : void;
      
      function get len() : int;
   }
}
