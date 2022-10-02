package littleGame
{
   import littleGame.actions.AddObjectAction;
   import littleGame.actions.InhaleAction;
   import littleGame.actions.LittleAction;
   import littleGame.actions.LittleLivingDieAction;
   import littleGame.actions.RemoveObjectAction;
   import littleGame.actions.UnInhaleAction;
   import littleGame.data.LittleActType;
   import road7th.comm.PackageIn;
   
   public class LittleActionCreator
   {
       
      
      public function LittleActionCreator()
      {
         super();
      }
      
      public static function CreatAction(type:String, pkg:PackageIn = null, ... arg) : LittleAction
      {
         var action:LittleAction = null;
         switch(type)
         {
            case LittleActType.LivingInhale:
               action = new InhaleAction();
               break;
            case LittleActType.AddObject:
               action = new AddObjectAction();
               break;
            case LittleActType.RemoveObject:
               action = new RemoveObjectAction();
               break;
            case LittleActType.LivingUnInhale:
               action = new UnInhaleAction();
               break;
            case LittleActType.LivingDie:
               action = new LittleLivingDieAction();
         }
         return action;
      }
   }
}
