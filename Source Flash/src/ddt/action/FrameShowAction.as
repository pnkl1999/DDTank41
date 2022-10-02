package ddt.action
{
   import com.pickgliss.action.BaseAction;
   
   public class FrameShowAction extends BaseAction
   {
       
      
      private var _frame:Object;
      
      private var _showFun:Function;
      
      public function FrameShowAction(param1:Object, param2:Function = null, param3:uint = 0)
      {
         this._frame = param1;
         this._showFun = param2;
         super(param3);
      }
      
      override public function act() : void
      {
         if(this._showFun is Function)
         {
            this._showFun();
         }
         else
         {
            this._frame.show();
         }
         super.act();
      }
   }
}
