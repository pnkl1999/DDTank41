package fightLib.command
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import fightLib.view.FightLibAlertView;
   
   public class PopupFrameCommand extends BaseFightLibCommand
   {
       
      
      private var _frame:FightLibAlertView;
      
      private var _callBack:Function;
      
      private var _okLable:String;
      
      private var _cancelLabel:String;
      
      private var _cancelFunc:Function;
      
      public function PopupFrameCommand(param1:String, param2:String = "", param3:Function = null, param4:String = "", param5:Function = null, param6:Boolean = true, param7:Boolean = false, param8:Array = null)
      {
         super();
         this._frame = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibAlertView",[param1,param2,this.finish,param4,param5,param6,param7,param8]);
         this._callBack = param3;
         this._okLable = param2;
         this._cancelLabel = param4;
         this._cancelFunc = param5;
      }
      
      override public function excute() : void
      {
         super.excute();
         this._frame.show();
      }
      
      override public function finish() : void
      {
         if(this._callBack != null)
         {
            this._callBack();
         }
         this._frame.hide();
         super.finish();
      }
      
      override public function undo() : void
      {
         this._frame.hide();
         super.undo();
      }
      
      override public function dispose() : void
      {
         if(this._frame)
         {
            this._frame.hide();
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
         this._callBack = null;
         super.dispose();
      }
   }
}
