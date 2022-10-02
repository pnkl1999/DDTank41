package fightLib.script.MeasureScree
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.manager.LanguageMgr;
   import fightLib.command.BaseFightLibCommand;
   import fightLib.command.CreateMonsterCommand;
   import fightLib.command.ImmediateCommand;
   import fightLib.command.PopUpFrameWaitCommand;
   import fightLib.command.PopupFrameCommand;
   import fightLib.command.TimeCommand;
   import fightLib.script.BaseScript;
   import flash.display.MovieClip;
   
   public class EasyMeasureScreenScript extends BaseScript
   {
       
      
      private var _arrow:MovieClip;
      
      public function EasyMeasureScreenScript(param1:Object)
      {
         super(param1);
      }
      
      override protected function initializeScript() : void
      {
         var _loc1_:BaseFightLibCommand = new PopUpFrameWaitCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command2"),this.clearMaskAndArrow,null,null,null,null,false,false);
         _loc1_.excuteFunArr.push(this.drawMaskAndWait);
         var _loc2_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command2"));
         var _loc3_:BaseFightLibCommand = new ImmediateCommand();
         _loc3_.excuteFunArr.push(_host.splitSmallMapDrager as Function);
         var _loc4_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command5"));
         var _loc5_:BaseFightLibCommand = new TimeCommand(11000);
         _loc5_.excuteFunArr.push(_host.shineText as Function);
         var _loc6_:CreateMonsterCommand = new CreateMonsterCommand();
         _loc6_.excuteFunArr.push(_host.blockSmallMap as Function);
         var _loc7_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command7"));
         var _loc8_:BaseFightLibCommand = new TimeCommand(7500);
         _loc8_.excuteFunArr.push(_host.shineText2 as Function);
         var _loc9_:BaseFightLibCommand = new PopupFrameCommand(LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.EasyMeasureScreenScript.command9"),LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.understood"),null,LanguageMgr.GetTranslation("tank.command.fightLibCommands.script.MeasureScree.watchAgain"),restart,true,true);
         _loc9_.completeFunArr.push(_host.activeSmallMap as Function);
         _loc9_.undoFunArr.push(_host.restoreText as Function);
         _loc9_.undoFunArr.push(_host.hideSmallMapSplit as Function);
         _loc9_.undoFunArr.push(_host.activeSmallMap as Function);
         _commonds.push(_loc1_);
         _commonds.push(_loc2_);
         _commonds.push(_loc3_);
         _commonds.push(_loc6_);
         _commonds.push(_loc4_);
         _commonds.push(_loc5_);
         _commonds.push(_loc7_);
         _commonds.push(_loc8_);
         _commonds.push(_loc9_);
         super.initializeScript();
      }
      
      override public function start() : void
      {
         _host.sendClientScriptStart();
         super.start();
      }
      
      public function drawMaskAndWait() : void
      {
         _host.drawMasks();
         this._arrow = ComponentFactory.Instance.creatCustomObject("fightLib.GreenArrow");
         _host.screanAddEvent();
         LayerManager.Instance.addToLayer(this._arrow,LayerManager.STAGE_DYANMIC_LAYER);
      }
      
      public function clearMaskAndArrow() : void
      {
         _host.clearMask();
         this._arrow.stop();
         if(this._arrow.parent)
         {
            this._arrow.parent.removeChild(this._arrow);
         }
      }
      
      public function splitSmallMapDrager() : void
      {
         _host.splitSmallMapDrager();
      }
      
      override public function finish() : void
      {
         super.finish();
         _host.sendClientScriptEnd();
         _host.enableExist();
      }
   }
}
