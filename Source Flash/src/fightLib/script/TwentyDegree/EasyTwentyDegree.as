package fightLib.script.TwentyDegree
{
   import ddt.manager.LanguageMgr;
   import fightLib.WeaponId;
   import fightLib.command.BaseFightLibCommand;
   import fightLib.command.CreateMonsterCommand;
   import fightLib.command.ImmediateCommand;
   import fightLib.command.PopupFrameCommand;
   import fightLib.command.WaittingCommand;
   import fightLib.script.BaseScript;
   
   public class EasyTwentyDegree extends BaseScript
   {
       
      
      private var _arr:Array;
      
      public function EasyTwentyDegree(param1:Object)
      {
         this._arr = new Array(WeaponId.WeaponA,WeaponId.WeaponB,WeaponId.WeaponC,WeaponId.WeaponD,WeaponId.WeaponE,WeaponId.WeaponF);
         super(param1);
      }
      
      override protected function initializeScript() : void
      {
         var _loc1_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command1"),"",null,"",null,true,false,this._arr);
         var _loc2_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command2"));
         var _loc3_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command4"));
         _loc3_.excuteFunArr.push(_host.showPowerTable1 as Function);
         _loc3_.undoFunArr.push(_host.hidePowerTable as Function);
         var _loc4_:PopupFrameCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command6"),null);
         var _loc5_:ImmediateCommand = new ImmediateCommand();
         _loc5_.excuteFunArr.push(_host.splitSmallMapDrager as Function);
         _loc5_.completeFunArr.push(_host.openShowTurn as Function);
         _loc5_.completeFunArr.push(_host.skip as Function);
         var _loc6_:CreateMonsterCommand = new CreateMonsterCommand();
         _loc6_.excuteFunArr.push(_host.waitAttack as Function);
         var _loc7_:WaittingCommand = new WaittingCommand(null);
         var _loc8_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyTwentyDegree.command7"),LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.startTrain"),this.startTrain,LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
         _loc8_.excuteFunArr.push(_host.closeShowTurn as Function);
         _loc8_.undoFunArr.push(_host.hideSmallMapSplit as Function);
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
      
      override public function next() : void
      {
         var _loc1_:BaseFightLibCommand = null;
         if(_index < _commonds.length)
         {
            _loc1_ = _commonds[_index++];
            _loc1_.excute();
         }
         else
         {
            this.finish();
         }
      }
   }
}
