package game.interfaces
{
   import flash.utils.Dictionary;
   
   public interface ICommandedAble
   {
       
      
      function get commandList() : Dictionary;
      
      function initCommand() : void;
      
      function command(param1:String, param2:*) : Boolean;
   }
}
