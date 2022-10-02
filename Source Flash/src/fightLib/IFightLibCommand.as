package fightLib
{
   import flash.events.IEventDispatcher;
   
   public interface IFightLibCommand extends IEventDispatcher
   {
       
      
      function excute() : void;
      
      function finish() : void;
      
      function undo() : void;
      
      function dispose() : void;
   }
}
