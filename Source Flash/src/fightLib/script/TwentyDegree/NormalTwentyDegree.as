package fightLib.script.TwentyDegree
{
   import ddt.manager.LanguageMgr;
   import fightLib.command.BaseFightLibCommand;
   import fightLib.command.PopupFrameCommand;
   import fightLib.script.BaseScript;
   
   public class NormalTwentyDegree extends BaseScript
   {
       
      
      public function NormalTwentyDegree(param1:Object)
      {
         super(param1);
      }
      
      override protected function initializeScript() : void
      {
         var _loc1_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.NormalTwentyDegree.command2"),LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.startTrain"),this.startTrain);
         _loc1_.excuteFunArr.push(_host.showPowerTable2 as Function);
         _loc1_.undoFunArr.push(_host.hidePowerTable as Function);
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
