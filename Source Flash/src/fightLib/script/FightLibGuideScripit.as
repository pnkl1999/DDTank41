package fightLib.script
{
   import ddt.manager.FightLibManager;
   import ddt.manager.LanguageMgr;
   import fightLib.command.ImmediateCommand;
   import fightLib.command.PopupHFrameCommand;
   import fightLib.command.WaittingCommand;
   
   public class FightLibGuideScripit extends BaseScript
   {
       
      
      public function FightLibGuideScripit(param1:Object)
      {
         super(param1);
      }
      
      private function firstEnterFrameClose() : void
      {
         if(FightLibManager.Instance.script && FightLibManager.Instance.script is FightLibGuideScripit)
         {
            FightLibManager.Instance.script.next();
         }
      }
      
      override protected function initializeScript() : void
      {
         var _loc1_:PopupHFrameCommand = new PopupHFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.FightLibGuideScripit.welcome"),LanguageMgr.GetTranslation("ok"),this.firstEnterFrameClose);
         _commonds.push(_loc1_);
         var _loc2_:WaittingCommand = new WaittingCommand(null);
         _loc2_.excuteFunArr.push(_host.showGuide1 as Function);
         var _loc3_:WaittingCommand = new WaittingCommand(null);
         _loc3_.excuteFunArr.push(_host.showGuide2 as Function);
         var _loc4_:ImmediateCommand = new ImmediateCommand();
         _loc4_.excuteFunArr.push(_host.hideGuide as Function);
         _commonds.push(_loc2_);
         _commonds.push(_loc3_);
         _commonds.push(_loc4_);
         super.initializeScript();
      }
   }
}
