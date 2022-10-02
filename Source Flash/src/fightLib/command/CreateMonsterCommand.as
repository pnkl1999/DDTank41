package fightLib.command
{
   import ddt.manager.SocketManager;
   
   public class CreateMonsterCommand extends BaseFightLibCommand
   {
       
      
      public function CreateMonsterCommand()
      {
         super();
      }
      
      override public function excute() : void
      {
         SocketManager.Instance.out.createMonster();
         super.excute();
         finish();
      }
      
      override public function undo() : void
      {
         SocketManager.Instance.out.deleteMonster();
         super.undo();
      }
   }
}
