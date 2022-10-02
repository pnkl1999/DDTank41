package fightLib.command
{
   import flash.utils.setTimeout;
   
   public class TimeCommand extends BaseFightLibCommand
   {
       
      
      private var _delay:int;
      
      public function TimeCommand(param1:int)
      {
         this._delay = param1;
         super();
      }
      
      override public function excute() : void
      {
         super.excute();
         setTimeout(finish,this._delay);
      }
   }
}
