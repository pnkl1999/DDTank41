package fightLib.script.HighGap
{
   import ddt.manager.LanguageMgr;
   import fightLib.command.BaseFightLibCommand;
   import fightLib.command.PopupFrameCommand;
   import fightLib.script.BaseScript;
   
   public class NormalHighGap extends BaseScript
   {
       
      
      public function NormalHighGap(param1:Object)
      {
         super(param1);
      }
      
      override protected function initializeScript() : void
      {
         var _loc1_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.HighGap.NormalHighGap.command1"),LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.startTrain"),this.startTrain);
         _commonds.push(_loc1_);
         super.initializeScript();
      }
      
      private function startTrain() : void
      {
         _host.continueGame();
         _host.skip();
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
