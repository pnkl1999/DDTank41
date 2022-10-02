package fightLib.script.HighThrow
{
   import ddt.manager.LanguageMgr;
   import fightLib.WeaponId;
   import fightLib.command.BaseFightLibCommand;
   import fightLib.command.CreateMonsterCommand;
   import fightLib.command.PopupFrameCommand;
   import fightLib.command.TimeCommand;
   import fightLib.command.WaittingCommand;
   import fightLib.script.BaseScript;
   
   public class EasyHighThrow extends BaseScript
   {
       
      
      private var _arr:Array;
      
      public function EasyHighThrow(param1:Object)
      {
         this._arr = new Array(WeaponId.WeaponD,WeaponId.WeaponH,WeaponId.WeaponI);
         super(param1);
      }
      
      override protected function initializeScript() : void
      {
         var _loc1_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.HighThrow.EasyHighThrow.command1"),"",null,"",null,true,false,this._arr);
         var _loc2_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.HighThrow.EasyHighThrow.command2"));
         var _loc3_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.HighThrow.EasyHighThrow.command3"),null);
         var _loc4_:CreateMonsterCommand = new CreateMonsterCommand();
         _loc4_.excuteFunArr.push(_host.waitAttack as Function);
         var _loc5_:TimeCommand = new TimeCommand(2000);
         var _loc6_:PopupFrameCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.HighThrow.EasyHighThrow.command5"),null);
         _loc6_.completeFunArr.push(_host.openShowTurn as Function);
         _loc6_.completeFunArr.push(_host.skip as Function);
         var _loc7_:WaittingCommand = new WaittingCommand(null);
         var _loc8_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.HighThrow.EasyHighThrow.command6"),LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.startTrain"),this.startTrain,LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
         _loc8_.excuteFunArr.push(_host.closeShowTurn as Function);
         _commonds.push(_loc1_);
         _commonds.push(_loc2_);
         _commonds.push(_loc3_);
         _commonds.push(_loc4_);
         _commonds.push(_loc5_);
         _commonds.push(_loc6_);
         _commonds.push(_loc7_);
         _commonds.push(_loc8_);
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
