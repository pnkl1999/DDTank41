package fightLib.script.SixtyDegree
{
   import ddt.manager.LanguageMgr;
   import fightLib.command.BaseFightLibCommand;
   import fightLib.command.PopupFrameCommand;
   import fightLib.script.BaseScript;
   
   public class DifficultSixtyDegreeScript extends BaseScript
   {
       
      
      public function DifficultSixtyDegreeScript(param1:Object)
      {
         super(param1);
      }
      
      override protected function initializeScript() : void
      {
         var _loc1_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.SixtyDegree.DifficultSixtyDegreeScript.command2"),LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.startTrain"));
         _loc1_.completeFunArr.push(this.startTrain);
         _commonds.push(_loc1_);
         super.initializeScript();
      }
      
      private function startTrain() : void
      {
         _host.continueGame();
      }
      
      override public function start() : void
      {
         _host.sendClientScriptStart();
         super.start();
      }
      
      override public function finish() : void
      {
         super.finish();
         _host.sendClientScriptEnd();
         _host.enableExist();
      }
   }
}
