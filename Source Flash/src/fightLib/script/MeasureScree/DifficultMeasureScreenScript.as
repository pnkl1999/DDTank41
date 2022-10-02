package fightLib.script.MeasureScree
{
   import ddt.manager.LanguageMgr;
   import fightLib.command.BaseFightLibCommand;
   import fightLib.command.CreateMonsterCommand;
   import fightLib.command.PopupFrameCommand;
   import fightLib.command.TimeCommand;
   import fightLib.script.BaseScript;
   
   public class DifficultMeasureScreenScript extends BaseScript
   {
       
      
      public function DifficultMeasureScreenScript(param1:Object)
      {
         super(param1);
      }
      
      override protected function initializeScript() : void
      {
         var _loc1_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.DifficultMeasureScreenScript.command2"));
         var _loc2_:CreateMonsterCommand = new CreateMonsterCommand();
         var _loc3_:TimeCommand = new TimeCommand(2000);
         _loc3_.completeFunArr.push(_host.leftJustifyWithPlayer);
         var _loc4_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.DifficultMeasureScreenScript.command4"),LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.understood"),null,LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
         _loc4_.excuteFunArr.push(_host.leftJustifyWithPlayer as Function);
         _commonds.push(_loc1_);
         _commonds.push(_loc2_);
         _commonds.push(_loc3_);
         _commonds.push(_loc4_);
         super.initializeScript();
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
