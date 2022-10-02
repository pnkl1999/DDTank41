package fightLib.command
{
   public class ImmediateCommand extends BaseFightLibCommand
   {
       
      
      public function ImmediateCommand()
      {
         super();
      }
      
      override public function excute() : void
      {
         super.excute();
         finish();
      }
   }
}
