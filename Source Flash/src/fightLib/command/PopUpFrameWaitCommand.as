package fightLib.command
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import fightLib.view.FightLibAlertView;
   
   public class PopUpFrameWaitCommand extends WaittingCommand
   {
       
      
      private var _frame:FightLibAlertView;
      
      public function PopUpFrameWaitCommand(param1:String, param2:Function, param3:String = "", param4:Function = null, param5:String = "", param6:Function = null, param7:Boolean = true, param8:Boolean = false)
      {
         super(param2);
         this._frame = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibAlertView",[param1,param3,this.finish,param5,param6,param7,param8]);
      }
      
      override public function excute() : void
      {
         this._frame.show();
         super.excute();
      }
      
      override public function undo() : void
      {
         this._frame.hide();
         super.undo();
      }
      
      override public function finish() : void
      {
         super.finish();
         this._frame.hide();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
         super.dispose();
      }
   }
}
