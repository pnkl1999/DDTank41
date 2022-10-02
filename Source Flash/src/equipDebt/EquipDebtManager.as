package equipDebt
{
   import com.pickgliss.ui.ComponentFactory;
   import equipDebt.view.EquipAddMoneyFrame;
   import equipDebt.view.EquipDebtFrame;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class EquipDebtManager extends EventDispatcher
   {
      
      private static var _instance:EquipDebtManager;
       
      
      private var _viewPrompt:EquipDebtFrame;
      
      private var _viewDebt:EquipAddMoneyFrame;
      
      private var _equipTimeOutArr:Array;
      
      private var _isOpen:Boolean = false;
      
      public function EquipDebtManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get Instance() : EquipDebtManager
      {
         if(_instance == null)
         {
            _instance = new EquipDebtManager();
         }
         return _instance;
      }
      
      public function start() : void
      {
         if(this._isOpen == true)
         {
            return;
         }
         this._equipTimeOutArr = new Array();
         this._viewPrompt = null;
         this.checkEquipTime();
         this._isOpen = true;
      }
      
      private function checkEquipTime() : void
      {
      }
      
      public function openEquipDebt() : void
      {
         if(this._equipTimeOutArr.length > 0)
         {
            this._viewDebt = ComponentFactory.Instance.creatComponentByStylename("EquipAddMoneyFrame");
            this._viewDebt.Equiplist = this._equipTimeOutArr;
            this._viewDebt.show();
         }
      }
      
      public function dispose() : void
      {
         this._equipTimeOutArr = null;
         if(this._viewPrompt)
         {
            this._viewPrompt.dispose();
         }
         if(this._viewDebt)
         {
            this._viewDebt.dispose();
         }
         this._viewDebt = null;
         this._viewPrompt = null;
      }
   }
}
