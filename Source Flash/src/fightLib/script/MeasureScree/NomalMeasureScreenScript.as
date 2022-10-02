package fightLib.script.MeasureScree
{
   import ddt.manager.LanguageMgr;
   import fightLib.command.BaseFightLibCommand;
   import fightLib.command.CreateMonsterCommand;
   import fightLib.command.PopupFrameCommand;
   import fightLib.command.TimeCommand;
   import fightLib.script.BaseScript;
   
   public class NomalMeasureScreenScript extends BaseScript
   {
       
      
      public function NomalMeasureScreenScript(param1:Object)
      {
         super(param1);
      }
      
      override protected function initializeScript() : void
      {
         var _loc1_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.NomalMeasureScreenScript.command2"));
         _loc1_.excuteFunArr.push(_host.blockSmallMap as Function);
         var _loc2_:CreateMonsterCommand = new CreateMonsterCommand();
         var _loc3_:TimeCommand = new TimeCommand(2000);
         _loc3_.completeFunArr.push(_host.leftJustifyWithPlayer);
         _loc3_.completeFunArr.push(_host.addRedPointInSmallMap as Function);
         _loc3_.undoFunArr.push(_host.removeRedPointInSmallMap as Function);
         var _loc4_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.NomalMeasureScreenScript.command4"));
         var _loc5_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.NomalMeasureScreenScript.command5"),LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.understood"),null,LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
         _loc5_.excuteFunArr.push(_host.leftJustifyWithRedPoint as Function);
         _loc5_.completeFunArr.push(_host.removeRedPointInSmallMap as Function);
         _loc5_.completeFunArr.push(_host.activeSmallMap as Function);
         _commonds.push(_loc1_);
         _commonds.push(_loc2_);
         _commonds.push(_loc3_);
         _commonds.push(_loc4_);
         _commonds.push(_loc5_);
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
